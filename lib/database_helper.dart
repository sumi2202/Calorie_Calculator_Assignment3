// database_helper.dart
import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'food_model.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'calories_database.db');

    return await openDatabase(path, version: 1, onCreate: _createDb);
  }

  Future<void> _createDb(Database db, int version) async {
    await db.execute('''
      CREATE TABLE foods(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        calories REAL,
        date TEXT
      )
    ''');

    // Insert sample data during database creation
    for (int i = 1; i <= 20; i++) {
      await db.insert('foods', {
        'name': 'Food $i',
        'calories': i * 10.0,
        'date': DateTime(2023, 1, 1).toIso8601String(),
      });
    }
  }

  Future<int> insertFood(Food food) async {
    Database db = await database;
    return await db.insert('foods', {
      'name': food.name,
      'calories': food.calories,
      'date': food.date.toIso8601String(),
    });
  }

  Future<List<Food>> getAllFoods() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query('foods');

    return List.generate(maps.length, (i) {
      return Food.fromMap(maps[i]);
    });
  }

  Future<List<Food>> getMealPlanForDate(DateTime date) async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(
      'foods',
      where: 'date = ?',
      whereArgs: [date.toIso8601String()],
    );

    return List.generate(maps.length, (i) {
      return Food.fromMap(maps[i]);
    });
  }

  Future<int> updateFood(Food food) async {
    Database db = await database;
    return await db.update(
      'foods',
      food.toMap(),
      where: 'id = ?',
      whereArgs: [food.id],
    );
  }

  Future<int> deleteFood(int id) async {
    Database db = await database;
    return await db.delete(
      'foods',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}


