import 'package:supabase_flutter/supabase_flutter.dart';
import '../model/user_model.dart';

class AuthApi {
  final SupabaseClient _client = Supabase.instance.client;

  Future<UserModel?> signUp(String email, String password, String name) async {
    final response = await _client.auth.signUp(
      email: email,
      password: password,
      data: {'name': name},
    );

    if (response.user != null) {
      return UserModel(
        id: response.user!.id,
        name: name,
        email: email,
      );
    }
    return null;
  }

  Future<UserModel?> signIn(String email, String password) async {
    final response = await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );

    if (response.user != null) {
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
    await _client.auth.signOut();
  }
}
