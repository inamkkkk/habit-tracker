import 'package:flutter/material.dart';
import 'package:habit_tracker/models/habit.dart';
import 'package:habit_tracker/screens/add_habit_screen.dart';
import 'package:habit_tracker/widgets/habit_tile.dart';
import 'package:provider/provider.dart';
import 'package:habit_tracker/main.dart';

class HabitListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final habitProvider = Provider.of<HabitProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Habit Tracker'),
      ),
      body: habitProvider.habits.isEmpty
          ? Center(child: Text('No habits yet. Add one!'))
          : ListView.builder(
              itemCount: habitProvider.habits.length,
              itemBuilder: (context, index) {
                final habit = habitProvider.habits[index];
                return HabitTile(habit: habit);
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddHabitScreen()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}