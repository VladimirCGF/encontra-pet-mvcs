import '../database/user_dao.dart';
import '../model/user_model.dart';
import '../api/auth_api.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class UserService {
  final UserDao _userDao = UserDao();
  final AuthApi _authApi = AuthApi();

  /// Salva ou atualiza os dados do perfil do usuário no SQLite (Cache Local)
  Future<void> saveLocalProfile(UserModel user) async {
    await _userDao.insertUser(user);
  }

  /// Recupera o perfil do usuário do SQLite para carregamento instantâneo offline
  Future<UserModel?> getLocalProfile(String userId) async {
    return await _userDao.getUser(userId);
  }

  /// Atualiza o perfil localmente (0ms) e tenta sincronizar imediatamente na nuvem
  Future<UserModel> updateProfile(String userId, String email, String name, String phone) async {
    // 1. Cria modelo com pendência de sincronização
    final updatedUser = UserModel(
      id: userId,
      email: email,
      name: name,
      phone: phone,
      syncStatus: 'pending_update',
    );

    // 2. Salva localmente imediatamente
    await _userDao.insertUser(updatedUser);

    // 3. Tenta sincronizar online se houver internet
    final connectivityResult = await Connectivity().checkConnectivity();
    final hasInternet = !connectivityResult.contains(ConnectivityResult.none);

    if (hasInternet) {
      try {
        await _authApi.updateProfile(name, phone);
        // Sucesso! Marca como sincronizado localmente
        final syncedUser = UserModel(
          id: userId,
          email: email,
          name: name,
          phone: phone,
          syncStatus: 'synced',
        );
        await _userDao.insertUser(syncedUser);
        return syncedUser;
      } catch (e) {
        // Silencia erro para manter robustez offline-first. O SyncService tratará depois.
      }
    }

    return updatedUser;
  }

  /// Verifica se há um usuário ativo no cache do Supabase (Offline-First Session)
  Future<UserModel?> getCurrentUser() async {
    final session = Supabase.instance.client.auth.currentSession;
    if (session != null) {
      // Se tiver sessão em cache, busca os detalhes do SQLite para renderização rápida
      final localUser = await getLocalProfile(session.user.id);
      if (localUser != null) {
        return localUser;
      } else {
        // Se não estiver no SQLite (ex: primeiro login na instalação), cria um modelo básico
        return UserModel(
          id: session.user.id,
          name: session.user.userMetadata?['name'] ?? 'Usuário',
          email: session.user.email ?? '',
          phone: session.user.userMetadata?['phone'] as String?,
        );
      }
    }
    return null;
  }
}
