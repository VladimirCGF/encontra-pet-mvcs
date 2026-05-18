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
      version: 3,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
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
        isLost INTEGER,
        sync_status TEXT
      )
    ''');

    // Tabela Users
    await db.execute('''
      CREATE TABLE users(
        id TEXT PRIMARY KEY,
        name TEXT,
        email TEXT,
        phone TEXT,
        sync_status TEXT
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE pets ADD COLUMN sync_status TEXT DEFAULT "synced"');
    }
    if (oldVersion < 3) {
      await db.execute('ALTER TABLE users ADD COLUMN sync_status TEXT DEFAULT "synced"');
    }
  }
}
