class Task {
  Task({
    required this.title,
    this.isCompleted = false,
    this.category = '',
    this.priority = 2,
  });

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
