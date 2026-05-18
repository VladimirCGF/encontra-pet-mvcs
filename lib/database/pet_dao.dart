import 'package:sqflite/sqflite.dart';
import '../model/pet_model.dart';
import 'db_helper.dart';

class PetDao {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<void> insertPet(PetModel pet) async {
    final db = await _dbHelper.database;
    await db.insert(
      'pets',
      pet.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<PetModel>> getPets() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('pets');

    return List.generate(maps.length, (i) {
      return PetModel.fromMap(maps[i]);
    });
  }

  Future<void> updatePet(PetModel pet) async {
    final db = await _dbHelper.database;
    await db.update(
      'pets',
      pet.toMap(),
      where: 'id = ?',
      whereArgs: [pet.id],
    );
  }

  Future<void> deletePet(String id) async {
    final db = await _dbHelper.database;
    await db.delete(
      'pets',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
