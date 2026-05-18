import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'encontrapet.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Tabela Pets - Sem BLOBs, imageUrl salva apenas a string do caminho local ou URL
    await db.execute('''
      CREATE TABLE pets(
        id TEXT PRIMARY KEY,
        name TEXT,
        breed TEXT,
        imageUrl TEXT,
        location TEXT,
        date TEXT,
        isLost INTEGER
      )
    ''');

    // Tabela Users
    await db.execute('''
      CREATE TABLE users(
        id TEXT PRIMARY KEY,
        name TEXT,
        email TEXT,
        phone TEXT
      )
    ''');
  }
}
