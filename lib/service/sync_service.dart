import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
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
      debugPrint('➡️ [SyncService] Encontrados ${pendingPets.length} pets pendentes de envio.');

      for (var pet in pendingPets) {
        if (pet.syncStatus == 'pending_insert') {
          final map = pet.toMap();

          try {
            // Upload da foto para o Storage se for um caminho local
            if (map['imageUrl'] != null && !map['imageUrl'].toString().startsWith('http')) {
              final file = File(map['imageUrl']);
              if (await file.exists()) {
                final fileExt = file.path.split('.').last;
                final fileName = '${pet.id}_${DateTime.now().millisecondsSinceEpoch}.$fileExt';
                
                debugPrint('➡️ [SyncService] Fazendo upload da imagem para o Storage: $fileName');
                await Supabase.instance.client.storage
                    .from('pet-images')
                    .upload(fileName, file);
                
                final publicUrl = Supabase.instance.client.storage
                    .from('pet-images')
                    .getPublicUrl(fileName);
                
                debugPrint('✅ [SyncService] Upload da imagem concluído. URL Pública: $publicUrl');
                map['imageUrl'] = publicUrl;
              }
            }

            // Prepara o objeto para a nuvem mudando o status para synced
            map['sync_status'] = 'synced';
            final petToUpload = PetModel.fromMap(map);

            await _petApi.insertPet(petToUpload);
            // Se o upload funcionou, atualiza o SQLite local
            await _petDao.updatePet(petToUpload);
          } catch (e) {
            debugPrint('❌ [SyncService] Erro no upload do Pet para a API: $e');
          }
        } else if (pet.syncStatus == 'pending_update') {
          final map = pet.toMap();
          try {
            // Se tiver uma nova foto local (edição com nova foto), faz o upload
            if (map['imageUrl'] != null && !map['imageUrl'].toString().startsWith('http')) {
              final file = File(map['imageUrl']);
              if (await file.exists()) {
                final fileExt = file.path.split('.').last;
                final fileName = '${pet.id}_${DateTime.now().millisecondsSinceEpoch}.$fileExt';
                debugPrint('➡️ [SyncService] Fazendo upload da NOVA imagem para o Storage: $fileName');
                await Supabase.instance.client.storage.from('pet-images').upload(fileName, file);
                map['imageUrl'] = Supabase.instance.client.storage.from('pet-images').getPublicUrl(fileName);
                debugPrint('✅ [SyncService] Upload da nova imagem concluído. URL: ${map['imageUrl']}');
              }
            }

            map['sync_status'] = 'synced';
            final petToUpload = PetModel.fromMap(map);
            await _petApi.updatePet(petToUpload);
            await _petDao.updatePet(petToUpload);
          } catch (e) {
            debugPrint('❌ [SyncService] Erro no update do Pet para a API: $e');
          }
        } else if (pet.syncStatus == 'pending_delete') {
          try {
            await _petApi.deletePet(pet.id!);
            await _petDao.deletePet(pet.id!); // Remove fisicamente do SQLite
            debugPrint('✅ [SyncService] Pet removido fisicamente do SQLite após delete da nuvem.');
          } catch (e) {
            debugPrint('❌ [SyncService] Erro no delete do Pet para a API: $e');
          }
        }
      }

      // 2. PULL: Busca todos os registros novos da nuvem e coloca no cache local
      try {
         debugPrint('➡️ [SyncService] Buscando atualizações (Pull) da nuvem...');
         final remotePets = await _petApi.fetchPets();
         for (var remotePet in remotePets) {
           await _petDao.insertPet(remotePet); // Como o SQLite tem conflictAlgorithm.replace, ele atualiza
         }
         debugPrint('✅ [SyncService] Pull concluído. Banco local sincronizado.');
      } catch(e) {
         debugPrint('❌ [SyncService] Erro no pull da API: $e');
      }
    } catch (e) {
      debugPrint('❌ [SyncService] Erro fatal na sincronização: $e');
    } finally {
      debugPrint('➡️ [SyncService] Ciclo de sincronização finalizado.');
      _isSyncing = false;
    }
  }
}
