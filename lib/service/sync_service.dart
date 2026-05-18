import 'package:connectivity_plus/connectivity_plus.dart';
import '../database/pet_dao.dart';
import '../api/pet_api.dart';
import '../model/pet_model.dart';
import '../database/user_dao.dart';
import '../api/auth_api.dart';
import '../model/user_model.dart';
import 'package:flutter/foundation.dart';

class SyncService {
  final PetDao _petDao = PetDao();
  final PetApi _petApi = PetApi();
  final UserDao _userDao = UserDao();
  final AuthApi _authApi = AuthApi();

  bool _isSyncing = false;

  Future<void> syncPets() async {
    if (_isSyncing) return;
    
    // Verifica Conectividade
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.none)) {
      return; // Offline, não tenta sincronizar
    }

    _isSyncing = true;

    try {
      // 0. PUSH PERFIL: Sincroniza dados cadastrais do usuário pendentes
      final pendingUser = await _userDao.getPendingUser();
      if (pendingUser != null && pendingUser.syncStatus == 'pending_update') {
        try {
          await _authApi.updateProfile(pendingUser.name, pendingUser.phone ?? '');
          // Se o upload do perfil deu certo, marca localmente como synced
          final syncedUser = UserModel(
            id: pendingUser.id,
            email: pendingUser.email,
            name: pendingUser.name,
            phone: pendingUser.phone,
            syncStatus: 'synced',
          );
          await _userDao.insertUser(syncedUser);
        } catch (e) {
          debugPrint('Erro ao sincronizar perfil do usuário em segundo plano: $e');
        }
      }

      // 1. PUSH: Pega todos os registros que estão pendentes no celular e envia pro Supabase
      final pendingPets = await _petDao.getPendingPets();
      for (var pet in pendingPets) {
        if (pet.syncStatus == 'pending_insert') {
          // Prepara o objeto para a nuvem mudando o status para synced
          final map = pet.toMap();
          map['sync_status'] = 'synced';
          final petToUpload = PetModel.fromMap(map);

          try {
            await _petApi.insertPet(petToUpload);
            // Se o upload funcionou, atualiza o SQLite local informando que não está mais pendente
            await _petDao.updatePet(petToUpload);
          } catch (e) {
            debugPrint('Erro no upload para a API: $e');
          }
        }
      }

      // 2. PULL: Busca todos os registros novos da nuvem e coloca no cache local
      try {
         final remotePets = await _petApi.fetchPets();
         for (var remotePet in remotePets) {
           await _petDao.insertPet(remotePet); // Como o SQLite tem conflictAlgorithm.replace, ele atualiza
         }
      } catch(e) {
         debugPrint('Erro no pull da API: $e');
      }
    } catch (e) {
      debugPrint('Erro fatal na sincronização: $e');
    } finally {
      _isSyncing = false;
    }
  }
}
