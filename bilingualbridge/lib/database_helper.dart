import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'words_database.db');
    return openDatabase(
      path,
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE words(id INTEGER PRIMARY KEY, english TEXT, turkish TEXT, image TEXT)",
        );
      },
      version: 1,
    );
  }

  Future<void> insertWord(Map<String, dynamic> word) async {
    final db = await database;
    await db.insert('words', word,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> getWords() async {
    final db = await database;
    return await db.query('words');
  }

  Future<void> deleteWord(int id) async {
    final db = await database;
    await db.delete('words', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> updateWord(Map<String, dynamic> word) async {
    final db = await database;
    await db.update('words', word, where: 'id = ?', whereArgs: [word['id']]);
  }
}
