// ver: https://youtu.be/-RD60uMX7WE?si=_sy6AhcZTZZbd7OP

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

var path;

class BasedatoHelper {
  Future<Database> _openDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'database.db');

    return openDatabase(path, onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE habits (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            description TEXT
          )
        ''');
      },
      version: 1,
    );
  }

  Future<void> addData(Map<String, dynamic> habit) async {
    final db = await _openDatabase();
    await db.insert('habits', habit);
  }
}



/* class BasedatoHelper {
  static final BasedatoHelper _instance = BasedatoHelper._internal();
  factory BasedatoHelper() => _instance;
  BasedatoHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'habits.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE habits (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            description TEXT
          )
        ''');
      },
    );
  }

  Future<int> insertHabit(Map<String, dynamic> habit) async {
    final db = await database;
    return await db.insert('habits', habit);
  }

  Future<List<Map<String, dynamic>>> getHabits() async {
    final db = await database;
    return await db.query('habits');
  }
}

*/