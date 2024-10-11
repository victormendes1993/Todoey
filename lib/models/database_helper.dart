// ignore_for_file: avoid_print

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todoey/models/task.dart';

class DatabaseHelper {
  // Singleton instance of DatabaseHelper
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  // Private constructor
  DatabaseHelper._internal();

  // Factory constructor to return the singleton instance
  factory DatabaseHelper() => _instance;

  static Database? _database;

  // Getter for the database
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  // Method to initialize the database
  Future<Database> _initDB() async {
    // Safely join the database path and file name
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'todoey.db'); // Using join

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  // Create the tasks table
  void _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE tasks(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        isCompleted INTEGER DEFAULT 0,
        category TEXT,
        priority INTEGER DEFAULT 2
      )
    ''');
  }

  Future<int?> insert(Map<String, dynamic> task) async {
    final db = await database;
    try {
      return await db.insert('tasks', task);
    } catch (e) {
      print('THE ERROR IS: ${e.toString()}');
      return null;
    }
  }

  Future<List<Task>> fetchTasks() async {
    final db = await database; //getting database instance
    final List<Map<String, dynamic>> taskMaps = await db.query('tasks');

    /*Creates a list with length positions and fills it with values
    created by calling generator for each index in the range*/
    return List.generate(taskMaps.length, (i) {
      return Task(
        id: taskMaps[i]['id'],
        title: taskMaps[i]['title'],
        isCompleted: taskMaps[i]['isCompleted'] == 1,
        category: taskMaps[i]['category'],
        priority: taskMaps[i]['priority'],
      );
    });
  }

  Future<void> deleteCompletedTasks() async {
    final db = await database;
    await db.delete(
      'tasks',
      where: 'isCompleted = ?',
      whereArgs: [1],
    );
  }

  Future<void> updateCheckbox(int? id, bool isCompleted) async {
    try {
      final db = await database;
      await db.update(
        'tasks',
        {'isCompleted': isCompleted ? 1 : 0},
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      print('Error updating task completion: $e');
    }
  }

  Future<void> updateAllCheckbox(bool isCompleted) async {
    final db = await database;

    Batch batch = db.batch();

    batch.update(
      'tasks',
      {'isCompleted': isCompleted ? 1 : 0},
      where: '1 = 1', //Can remove the where completely
    );

    await batch.commit(noResult: true);
  }

  Future<void> delete(int id) async {
    final db = await database;
    await db.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> update(
    int id,
    String newTitle,
    int newPriority,
    String newCategory,
  ) async {
    final db = await database;
    await db.update(
      'tasks',
      {
        'title': newTitle,
        'priority': newPriority,
        'category': newCategory,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
