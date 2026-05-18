import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:encontrapet/model/pet_model.dart';
import 'dart:io';

void main() {
  test('Supabase Pet Insert Diagnostic Test', () async {
    // 1. Lê e parseia o arquivo .env manualmente para evitar problemas de versão do dotenv
    final env = <String, String>{};
    final envFile = File('.env');
    if (await envFile.exists()) {
      final lines = envFile.readAsLinesSync();
      for (var line in lines) {
        final trimmed = line.trim();
        if (trimmed.isEmpty || trimmed.startsWith('#')) continue;
        final index = trimmed.indexOf('=');
        if (index != -1) {
          final key = trimmed.substring(0, index).trim();
          final val = trimmed.substring(index + 1).trim();
          env[key] = val;
        }
      }
    }

    // 2. Inicializa o cliente do Supabase desativando a gravação local de sessão para rodar em teste
    await Supabase.initialize(
      url: env['SUPABASE_URL']!,
      anonKey: env['SUPABASE_ANON_KEY']!,
      authOptions: const FlutterAuthClientOptions(
        localStorage: EmptyLocalStorage(),
      ),
    );

    final client = Supabase.instance.client;
    print('--------------------------------------------------');
    print('1. Cliente Supabase inicializado em modo teste.');

    // 3. Tenta fazer login com a conta de teste para garantir sessão ativa
    try {
      final response = await client.auth.signInWithPassword(
        email: 'vladimir_project@hotmail.com',
        password: 'vladimirpassword123',
      );
      print('2. Autenticação realizada com sucesso. ID do Usuário: ${response.user?.id}');
    } catch (e) {
      print('Aviso: Login falhou: $e');
      print('Tentando inserção com perfil anônimo...');
    }

    // 4. Cria um PetModel de teste
    final testPet = PetModel(
      id: 'diagnostic-pet-uuid-12345',
      name: 'Pet de Teste Diagnóstico',
      breed: 'Cachorro - SRD - Caramelo',
      imageUrl: 'https://images.unsplash.com/photo-1543466835-00a7907e9de1',
      location: 'Rua de Teste, 123',
      date: '18/05/2026',
      isLost: true,
      syncStatus: 'synced',
    );

    // 5. Executa a inserção diretamente no Supabase e captura o diagnóstico exato
    print('3. Iniciando tentativa de inserção direta na tabela "pets"...');
    try {
      await client.from('pets').insert(testPet.toMap());
      print('✅ SUCESSO! O pet de teste foi inserido com sucesso no Supabase!');
      
      // Limpa o pet criado após o teste
      await client.from('pets').delete().eq('id', testPet.id!);
      print('4. Pet de teste deletado para limpar o banco.');
    } on PostgrestException catch (e) {
      print('❌ ERRO DO POSTGRES/SUPABASE DETECTADO!');
      print('Código de Erro: ${e.code}');
      print('Mensagem de Erro: ${e.message}');
      print('Detalhes: ${e.details}');
      print('Dica do PostgreSQL: ${e.hint}');
    } catch (e) {
      print('❌ OUTRO ERRO DETECTADO: $e');
    }
    print('--------------------------------------------------');
  });
}
