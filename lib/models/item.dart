class Subtask {
  String title;
  bool completed;

  Subtask({
    required this.title,
    this.completed = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'completed': completed,
    };
  }

  factory Subtask.fromMap(Map<String, dynamic> map) {
    return Subtask(
      title: map['title'],
      completed: map['completed'],
    );
  }
}

class Item {
  String title;
  String description;
  bool completed;
  List<Subtask> subtasks;

  Item({
    required this.title,
    required this.description,
    this.completed = false,
    List<Subtask>? subtasks,
  }) : subtasks = subtasks ?? []; // Initialize with an empty list if null

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'completed': completed,
      'subtasks': subtasks.map((subtask) => subtask.toMap()).toList(),
    };
  }

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      title: map['title'],
      description: map['description'],
      completed: map['completed'],
      subtasks: (map['subtasks'] as List<dynamic>?)
          ?.map<Subtask>((subtask) => Subtask.fromMap(subtask))
          .toList() ?? [],
    );
  }
}

