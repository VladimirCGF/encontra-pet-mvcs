import 'package:uuid/uuid.dart';
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
    final localPet = PetModel(
      id: newId,
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
}
