import 'package:uuid/uuid.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../model/pet_model.dart';
import '../database/pet_dao.dart';
import 'sync_service.dart';

class PetService {
  final PetDao _petDao = PetDao();
  final SyncService _syncService = SyncService();

  Future<List<PetModel>> getAllPets() async {
    // 1. Tenta sincronizar em background sempre que a tela pedir os dados
    _syncService.syncPets();
    
    // 2. Retorna a lista local instantaneamente para a UI não travar
    return await _petDao.getPets();
  }

  Future<PetModel> createPet(PetModel pet) async {
    // 1. Cria um ID único offline com UUID
    final newId = const Uuid().v4();
    final currentUserId = Supabase.instance.client.auth.currentUser?.id;
    
    final localPet = PetModel(
      id: newId,
      userId: currentUserId,
      name: pet.name,
      breed: pet.breed,
      imageUrl: pet.imageUrl,
      location: pet.location,
      date: pet.date,
      isLost: pet.isLost,
      syncStatus: 'pending_insert', // Marcador para o SyncService achar depois!
    );

    // 2. Salva no SQLite local (imediato)
    await _petDao.insertPet(localPet);

    // 3. Aciona o SyncService para tentar empurrar pro Supabase se tiver internet
    _syncService.syncPets();
    
    return localPet;
  }
  Future<PetModel> updatePet(PetModel pet) async {
    final map = pet.toMap();
    
    // Injeta o userId do usuário logado se ele estiver nulo para não perder a autoria
    if (map['user_id'] == null) {
      map['user_id'] = Supabase.instance.client.auth.currentUser?.id;
    }

    // 1. Marca como pendente de atualização
    map['sync_status'] = 'pending_update';
    final updatedPet = PetModel.fromMap(map);

    // 2. Salva localmente
    await _petDao.updatePet(updatedPet);

    // 3. Dispara a sincronização
    _syncService.syncPets();
    
    return updatedPet;
  }

  Future<void> deletePet(String id) async {
    // Busca apenas o pet alvo diretamente por ID (O(1) em vez de O(n))
    final pet = await _petDao.getPetById(id);
    if (pet == null) return;
    
    final map = pet.toMap();
    map['sync_status'] = 'pending_delete';
    await _petDao.updatePet(PetModel.fromMap(map));
    
    _syncService.syncPets();
  }
}
