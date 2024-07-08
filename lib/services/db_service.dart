import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBService {
  static final DBService _instance = DBService._internal();
  static Database? _database;

  factory DBService() {
    return _instance;
  }

  DBService._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'entries.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE entries (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            type TEXT,
            timestamp TEXT
          )
        ''');
      },
    );
  }

  Future<void> insertEntry(String type) async {
    final db = await database;
    await db.insert(
      'entries',
      {'type': type, 'timestamp': DateTime.now().toIso8601String()},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getEntries() async {
    final db = await database;
    return await db.query('entries', orderBy: 'timestamp DESC');
  }

  Future<void> deleteEntry(int id) async {
    final db = await database;
    await db.delete( 
    'entries',
    where: 'id = ?',
    whereArgs:[id],
    );
  }
}
