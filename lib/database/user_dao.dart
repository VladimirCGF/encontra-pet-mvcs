import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import '../model/user_model.dart';
import 'db_helper.dart';

class UserDao {
  // Singleton
  static final UserDao _instance = UserDao._internal();
  factory UserDao() => _instance;
  UserDao._internal();

  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<void> insertUser(UserModel user) async {
    final db = await _dbHelper.database;
    await db.insert(
      'users',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<UserModel?> getUser(String id) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return UserModel.fromMap(maps.first);
    }
    return null;
  }

  /// Recupera o usuário local com modificações de perfil pendentes de sincronização
  Future<UserModel?> getPendingUser() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'sync_status = ?',
      whereArgs: ['pending_update'],
      limit: 1,
    );

    if (maps.isNotEmpty) {
      return UserModel.fromMap(maps.first);
    }
    return null;
  }

  Future<void> clearUserData() async {
    try {
      // 1. Obtém a instância do banco de dados através do seu _dbHelper interno
      final db = await _dbHelper.database;

      // 2. Deleta todas as linhas da tabela 'users'
      await db.delete('users');

      debugPrint('Sucesso: Dados locais do usuário foram limpos do SQLite.');
    } catch (e) {
      debugPrint('Erro ao limpar a tabela users no SQLite: $e');
      rethrow;
    }
  }

}
