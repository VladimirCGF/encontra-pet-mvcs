import 'package:supabase_flutter/supabase_flutter.dart';
import '../model/pet_model.dart';

class PetApi {
  final SupabaseClient _client = Supabase.instance.client;

  Future<List<PetModel>> fetchPets() async {
    final List<dynamic> data = await _client.from('pets').select();
    
    return data.map((json) => PetModel.fromMap(json as Map<String, dynamic>)).toList();
  }

  Future<void> insertPet(PetModel pet) async {
    await _client.from('pets').insert(pet.toMap());
  }

  Future<void> updatePet(PetModel pet) async {
    await _client.from('pets').update(pet.toMap()).eq('id', pet.id!);
  }

  Future<void> deletePet(String id) async {
    await _client.from('pets').delete().eq('id', id);
  }
}
