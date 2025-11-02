import 'package:flutter/material.dart';
import 'package:habit_tracker/screens/habit_list_screen.dart';
import 'package:provider/provider.dart';
import 'package:habit_tracker/models/habit.dart';
import 'package:habit_tracker/services/database_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dbHelper = DatabaseHelper();
  await dbHelper.initializeDatabase();

  runApp(MyApp(dbHelper: dbHelper));
}

class MyApp extends StatelessWidget {
  final DatabaseHelper dbHelper;
  const MyApp({Key? key, required this.dbHelper}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HabitProvider(dbHelper),
      child: MaterialApp(
        title: 'Habit Tracker',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: HabitListScreen(),
      ),
    );
  }
}

class HabitProvider extends ChangeNotifier {
  List<Habit> _habits = [];
  final DatabaseHelper dbHelper;

  HabitProvider(this.dbHelper) {
    loadHabits();
  }

  List<Habit> get habits => _habits;

  Future<void> loadHabits() async {
    _habits = await dbHelper.getHabits();
    notifyListeners();
  }

  Future<void> addHabit(Habit habit) async {
    await dbHelper.insertHabit(habit);
    await loadHabits();
  }

  Future<void> updateHabit(Habit habit) async {
    await dbHelper.updateHabit(habit);
    await loadHabits();
  }

  Future<void> deleteHabit(int id) async {
    await dbHelper.deleteHabit(id);
    await loadHabits();
  }

  Future<void> toggleCompletion(int habitId, DateTime date, bool isCompleted) async {
    await dbHelper.updateCompletion(habitId, date, isCompleted);
    await loadHabits();
  }
}