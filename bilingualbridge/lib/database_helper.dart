import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:bilingualbridge/models/word.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._();
  static Database? _database;

  DatabaseHelper._();

  factory DatabaseHelper() {
    return _instance;
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "dictionary.db");
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE Dictionary (
        id INTEGER PRIMARY KEY,
        english TEXT,
        turkish TEXT,
        image TEXT
      )
    ''');
  }

  Future<int> insertWord(Map<String, dynamic> row) async {
    Database db = await _instance.database;
    return await db.insert('Dictionary', row);
  }

  Future<List<Map<String, dynamic>>> queryAllWords() async {
    Database db = await _instance.database;
    return await db.query('Dictionary');
  }

  Future<List<Word>> getWords() async {
    final List<Map<String, dynamic>> maps = await queryAllWords();
    return List.generate(maps.length, (i) {
      return Word.fromMap(maps[i]);
    });
  }

  Future<int> updateWord(Word word) async {
    Database db = await _instance.database;
    return await db.update('Dictionary', word.toMap(),
        where: 'id = ?', whereArgs: [word.id]);
  }

  Future<int> deleteWord(int id) async {
    Database db = await _instance.database;
    return await db.delete('Dictionary', where: 'id = ?', whereArgs: [id]);
  }
}
