import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';
import '../model/pet_model.dart';

class PetApi {
  final SupabaseClient _client = Supabase.instance.client;

  Future<List<PetModel>> fetchPets() async {
    debugPrint('➡️ [Supabase] Iniciando fetchPets...');
    final List<dynamic> data = await _client.from('pets').select();
    debugPrint('✅ [Supabase] fetchPets concluído. Pets recebidos: ${data.length}');
    
    return data.map((json) => PetModel.fromMap(json as Map<String, dynamic>)).toList();
  }

  Future<void> insertPet(PetModel pet) async {
    debugPrint('➡️ [Supabase] Iniciando insertPet para o ID: ${pet.id}');
    debugPrint('➡️ [Supabase] Payload: ${pet.toMap()}');
    await _client.from('pets').insert(pet.toMap());
    debugPrint('✅ [Supabase] insertPet concluído com sucesso!');
  }

  Future<void> updatePet(PetModel pet) async {
    debugPrint('➡️ [Supabase] Iniciando updatePet para o ID: ${pet.id}');
    debugPrint('➡️ [Supabase] Payload: ${pet.toMap()}');
    await _client.from('pets').update(pet.toMap()).eq('id', pet.id!);
    debugPrint('✅ [Supabase] updatePet concluído com sucesso!');
  }

  Future<void> deletePet(String id) async {
    debugPrint('➡️ [Supabase] Iniciando deletePet para o ID: $id');
    await _client.from('pets').delete().eq('id', id);
    debugPrint('✅ [Supabase] deletePet concluído com sucesso!');
  }
}
