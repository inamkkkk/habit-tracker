import 'package:flutter/material.dart';
import 'package:habit_tracker/models/habit.dart';
import 'package:provider/provider.dart';
import 'package:habit_tracker/main.dart';
import 'package:intl/intl.dart';

class HabitTile extends StatelessWidget {
  final Habit habit;

  const HabitTile({Key? key, required this.habit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              habit.name,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _buildCompletionCheckboxes(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildCompletionCheckboxes(BuildContext context) {
    List<Widget> checkboxes = [];
    DateTime now = DateTime.now();
    for (int i = 6; i >= 0; i--) {
      DateTime date = now.subtract(Duration(days: i));
      String formattedDate = DateFormat('yyyy-MM-dd').format(date);
      bool isCompleted = habit.completions[formattedDate] ?? false;

      checkboxes.add(
        Column(
          children: [
            Text(DateFormat('EEE').format(date)),
            Checkbox(
              value: isCompleted,
              onChanged: (bool? value) {
                if (value != null) {
                  Provider.of<HabitProvider>(context, listen: false)
                      .toggleCompletion(habit.id!, date, value);
                }
              },
            ),
          ],
        ),
      );
    }
    return checkboxes;
  }
}