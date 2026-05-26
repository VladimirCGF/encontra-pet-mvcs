import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../model/user_model.dart';
import '../api/auth_api.dart';
import '../service/user_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends ChangeNotifier {
  final AuthApi _authApi = AuthApi();
  final UserService _userService = UserService();

  UserModel? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  UserModel? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Carrega a Sessão Offline (Cache) ao abrir o app e verifica "Manter conectado"
  Future<bool> loadSession() async {
    final session = Supabase.instance.client.auth.currentSession;
    if (session == null) {
      return false; // Sem sessão ativa, deve ir para o Login
    }

    final prefs = await SharedPreferences.getInstance();
    final keepLoggedIn = prefs.getBool('keep_logged_in') ?? false;

    if (keepLoggedIn) {
      // Usuário quer ser lembrado, carrega os dados e entra direto
      _currentUser = await _userService.getCurrentUser();
      notifyListeners();
      return true;
    } else {
      // Sessão existe mas ele NÃO marcou "Manter conectado", força o logout silencioso
      await logout();
      return false;
    }
  }

  Future<bool> _hasInternetConnection() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return !connectivityResult.contains(ConnectivityResult.none);
  }

  // Método de Cadastro (SignUp) estritamente ONLINE
  Future<bool> signUp(String email, String password, String name, String phone) async {
    if (!await _hasInternetConnection()) {
      _errorMessage = 'Sem conexão! Conecte-se para criar sua conta.';
      notifyListeners();
      return false; // Trava o fluxo
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final user = await _authApi.signUp(email, password, name, phone);
      if (user != null) {
        await _userService.saveLocalProfile(user); // Salva a cópia no SQLite
        _currentUser = user;
        _isLoading = false;
        notifyListeners();
        return true; 
      } else {
        _errorMessage = 'Falha ao criar o usuário.';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } on AuthException catch (e) {
      if (e.message.toLowerCase().contains('user already registered') || e.message.toLowerCase().contains('already exists')) {
        _errorMessage = 'Este e-mail já está em uso por outra conta.';
      } else if (e.message.toLowerCase().contains('rate limit') || e.statusCode == '429') {
        _errorMessage = 'Muitas tentativas seguidas! Por favor, aguarde alguns minutos antes de tentar novamente.';
      } else {
        _errorMessage = e.message;
      }
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'Ocorreu um erro inesperado.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Método de Login estritamente ONLINE
  Future<bool> login(String email, String password, bool keepLoggedIn) async {
    if (!await _hasInternetConnection()) {
      _errorMessage = 'Sem conexão! Conecte-se para fazer login.';
      notifyListeners();
      return false; // Trava o fluxo
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final user = await _authApi.signIn(email, password);
      if (user != null) {
        await _userService.saveLocalProfile(user);
        _currentUser = user;

        // Salva a preferência de "Manter conectado"
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('keep_logged_in', keepLoggedIn);

        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = 'E-mail ou senha inválidos.';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } on AuthException catch (e) {
      if (e.message.toLowerCase().contains('email not confirmed') || e.code == 'email_not_confirmed') {
        _errorMessage = 'Seu e-mail ainda não foi confirmado. Verifique sua caixa de entrada!';
      } else if (e.message.toLowerCase().contains('invalid login credentials')) {
        _errorMessage = 'E-mail ou senha inválidos.';
      } else {
        _errorMessage = e.message;
      }
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'Ocorreu um erro inesperado.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      // 1. Limpa o Supabase (Sessão remota) E o SQLite (Cache local do usuário)
      await _userService.logout();

      // 2. Limpa a flag "Manter conectado" do SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('keep_logged_in'); // Ou .setBool('keep_logged_in', false);

      // 3. Limpa o estado da memória do Controller
      _currentUser = null;
      _errorMessage = null;

      debugPrint('Sucesso: Logout completo realizado.');
    } catch (e) {
      _errorMessage = 'Erro ao realizar logout: $e';
      debugPrint('Erro no AuthController.logout: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Atualiza o perfil (nome e telefone) do usuário atual em modo Offline-First
  Future<void> updateProfile(String name, String phone) async {
    if (_currentUser == null) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // O UserService atualiza o SQLite local em 0ms e dispara sincronização em segundo plano
      final updatedUser = await _userService.updateProfile(
        _currentUser!.id!,
        _currentUser!.email,
        name,
        phone,
      );
      _currentUser = updatedUser; // Atualiza a variável de sessão em memória
    } catch (e) {
      _errorMessage = 'Ocorreu um erro ao atualizar o perfil: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
