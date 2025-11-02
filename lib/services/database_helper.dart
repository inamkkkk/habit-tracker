import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:habit_tracker/models/habit.dart';
import 'dart:io' as io;
import 'package:intl/intl.dart';

class DatabaseHelper {
  Database? _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db!;
    }
    _db = await initializeDatabase();
    return _db!;
  }

  Future<Database> initializeDatabase() async {
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'habits.db');
    var db = await openDatabase(path, version: 2, onCreate: _onCreate);
    return db;
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(
        'CREATE TABLE habits (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, completions TEXT)');
  }

  Future<List<Habit>> getHabits() async {
    final dbClient = await db;
    final List<Map<String, dynamic>> maps = await dbClient.query('habits');
    return List.generate(maps.length, (i) {
      return Habit.fromMap(maps[i]);
    });
  }

  Future<int> insertHabit(Habit habit) async {
    final dbClient = await db;
    return await dbClient.insert('habits', habit.toMap());
  }

  Future<int> updateHabit(Habit habit) async {
    final dbClient = await db;
    return await dbClient.update(
      'habits',
      habit.toMap(),
      where: 'id = ?',
      whereArgs: [habit.id],
    );
  }

  Future<int> deleteHabit(int id) async {
    final dbClient = await db;
    return await dbClient.delete(
      'habits',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> updateCompletion(int habitId, DateTime date, bool isCompleted) async {
    final dbClient = await db;
    final habits = await getHabits();
    final habit = habits.firstWhere((h) => h.id == habitId);
    final formattedDate = DateFormat('yyyy-MM-dd').format(date);

    habit.completions[formattedDate] = isCompleted;

    await dbClient.update(
      'habits',
      habit.toMap(),
      where: 'id = ?',
      whereArgs: [habitId],
    );
  }
}
