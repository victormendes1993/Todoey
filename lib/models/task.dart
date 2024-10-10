class Task {
  Task({
    required this.title,
    this.id = 0,
    this.isCompleted = false,
    this.category = '',
    this.priority = 2,
  });

  int id;
  String title;
  String category;
  bool isCompleted;
  int priority;

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'isCompleted': isCompleted ? 1 : 0,
      'category': category,
      'priority': priority,
    };
  }
}
