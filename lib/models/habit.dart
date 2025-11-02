class Habit {
  int? id;
  String name;
  Map<String, bool> completions;

  Habit({
    this.id,
    required this.name,
    required this.completions,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'completions': completions.toString(),
    };
  }

  factory Habit.fromMap(Map<String, dynamic> map) {
    return Habit(
      id: map['id'],
      name: map['name'],
      completions: _parseCompletions(map['completions']),
    );
  }

  static Map<String, bool> _parseCompletions(String completionsString) {
    final map = <String, bool>{};
    if (completionsString == null || completionsString == 'null' || completionsString.isEmpty) {
      return map;
    }

    // Remove curly braces and split into key-value pairs
    final keyValuePairs = completionsString.substring(1, completionsString.length - 1).split(', ');

    for (final pair in keyValuePairs) {
      if (pair.isNotEmpty) {
        final parts = pair.split(': ');
        final key = parts[0];
        final value = parts[1].toLowerCase() == 'true';
        map[key] = value;
      }
    }
    return map;
  }
}
