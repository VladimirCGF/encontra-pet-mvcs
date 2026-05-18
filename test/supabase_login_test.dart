import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() {
  test('Teste de Autenticação Real Supabase', () async {
    // 1. Carrega as chaves do .env
    await dotenv.load(fileName: ".env");
    final url = dotenv.env['SUPABASE_URL']!;
    final anonKey = dotenv.env['SUPABASE_ANON_KEY']!;

    print('Instanciando SupabaseClient puro para teste com URL: $url');

    // 2. Cria o cliente puro
    final client = SupabaseClient(url, anonKey);

    try {
      print('Tentando fazer login real com vladimircgf@gmail.com...');
      final response = await client.auth.signInWithPassword(
        email: 'vladimir_project@hotmail.com',
        password: '12345678',
      );

      print('SUCESSO! Usuário logado: ${response.user?.id}');
      expect(response.user, isNotNull);
    } on AuthException catch (authErr) {
      print('--- ERRO DO SUPABASE AUTH ---');
      print('Mensagem: ${authErr.message}');
      print('Status: ${authErr.statusCode}');
      print('Código: ${authErr.code}');
      print('-----------------------------');
      fail('Falhou com erro do Supabase: ${authErr.message}');
    } catch (e) {
      print('Erro inesperado: $e');
      fail('Erro desconhecido: $e');
    }
  });
}
