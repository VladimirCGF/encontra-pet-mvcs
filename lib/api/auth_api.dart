import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';
import '../model/user_model.dart';

class AuthApi {
  final SupabaseClient _client = Supabase.instance.client;

  Future<UserModel?> signUp(String email, String password, String name, String phone) async {
    try {
      debugPrint('➡️ [Supabase Auth] Iniciando signUp para: $email');

      final response = await _client.auth.signUp(
        email: email,
        password: password,
        data: {
          'name': name,
          'phone': phone,
        },
      );

      if (response.user != null) {
        debugPrint('✅ [Supabase Auth] signUp concluído! UID: ${response.user!.id}');
        return UserModel(
          id: response.user!.id,
          name: name,
          email: email,
          phone: phone,
        );
      }
      return null;
    } catch (e) {
      // Captura o erro real para você ver no console do VS Code / Android Studio
      debugPrint('❌ [Supabase Auth] Erro no signUp: $e');
      return null;
    }
  }

  Future<UserModel?> signIn(String email, String password) async {
    debugPrint('➡️ [Supabase Auth] Iniciando signIn para: $email');
    final response = await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );

    if (response.user != null) {
      debugPrint('✅ [Supabase Auth] signIn concluído! UID: ${response.user!.id}');
      final name = response.user!.userMetadata?['name'] as String? ?? 'Usuário';
      return UserModel(
        id: response.user!.id,
        name: name,
        email: email,

      );
    }
    return null;
  }

  Future<void> signOut() async {
    debugPrint('➡️ [Supabase Auth] Iniciando signOut');
    await _client.auth.signOut();
    debugPrint('✅ [Supabase Auth] signOut concluído');
  }

  /// Atualiza o nome e o telefone (contato) do usuário logado no Supabase Auth
  Future<void> updateProfile(String name, String phone) async {
    debugPrint('➡️ [Supabase Auth] Iniciando updateProfile (name: $name, phone: $phone)');
    await _client.auth.updateUser(
      UserAttributes(
        data: {
          'name': name,
          'phone': phone,
        },
      ),
    );
    debugPrint('✅ [Supabase Auth] updateProfile concluído');
  }
}
