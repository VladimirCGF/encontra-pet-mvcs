import 'package:flutter_test/flutter_test.dart';
import 'package:encontrapet/model/pet_model.dart';

void main() {
  group('PetModel Tests - Offline First', () {
    test('toMap() deve incluir o sync_status e converter bool para int', () {
      final pet = PetModel(
        id: 'uuid-123',
        name: 'Bolinha',
        breed: 'Poodle',
        imageUrl: 'local/path/image.jpg',
        location: 'São Paulo, SP',
        date: 'Hoje',
        isLost: true,
        syncStatus: 'pending_insert',
      );

      final map = pet.toMap();

      expect(map['name'], 'Bolinha');
      expect(map['isLost'], 1, reason: 'O SQLite não suporta bool, deve ser convertido para 1');
      expect(map['sync_status'], 'pending_insert', reason: 'O status de sync deve ser preservado para controle do Service');
    });

    test('fromMap() deve restaurar o objeto corretamente a partir do SQLite', () {
      final map = {
        'id': 'uuid-456',
        'name': 'Rex',
        'breed': 'Pastor Alemão',
        'imageUrl': 'local/path/rex.jpg',
        'location': 'Rio de Janeiro, RJ',
        'date': 'Ontem',
        'isLost': 0, // SQLite int false
        'sync_status': 'synced',
      };

      final pet = PetModel.fromMap(map);

      expect(pet.name, 'Rex');
      expect(pet.isLost, false, reason: '0 no SQLite deve ser convertido para false no Model');
      expect(pet.syncStatus, 'synced');
    });
  });
}
