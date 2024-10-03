import 'package:flutter/material.dart';
import 'package:todoey/models/class/task.dart';
import 'package:todoey/models/database/database_helper.dart';
import 'package:todoey/widgets/alert_pop_up.dart';

class TaskData extends ChangeNotifier {
  final List<Task> _tasks = [];

  List<Task> get tasks => _tasks;

  bool get isEmpty => _tasks.isEmpty;

  bool get areAllDone => _tasks.every((task) => task.isCompleted);

  int get length => _tasks.length;

  int get doneLength => _tasks.where((task) => task.isCompleted).length;

  String getName(int index) => getTaskOfIndex(index).title;

  bool getIsDone(int index) => getTaskOfIndex(index).isCompleted;

  Future<void> loadTasksFromDb() async {
    _tasks.clear(); // Pre-built list method to clear existing tasks.
    final List<Task> tasksFromDb = await DatabaseHelper().fetchTasks();
    if (tasksFromDb.isNotEmpty) {
      _tasks.addAll(tasksFromDb);
    } // Store in memory
    notifyListeners(); // Notify listeners to update UI
  }

  Future<String?> addTask({
    required String taskDescription,
    String category = '',
    int priority = 2,
  }) async {
    final newTask = Task(
      title: taskDescription,
      category: category,
      priority: priority,
    );
    _tasks.add(newTask);
    try {
      await DatabaseHelper().persistTask(newTask.toMap());
      notifyListeners();
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  void toggleTaskCompletion(int index) {
    final task = getTaskOfIndex(index);
    task.isCompleted = !task.isCompleted; // Toggle completion
    notifyListeners();
  }

  void toggleAll() {
    for (var task in _tasks) {
      task.isCompleted = !task.isCompleted;
    }
    notifyListeners();
  }

  void editTask(int index, String newTaskDescription) {
    final task = getTaskOfIndex(index);
    task.title = newTaskDescription;
    task.isCompleted = false;
    notifyListeners();
  }

  bool editSelectedTask({
    required String atTitle,
    required String newTaskDescription,
  }) {
    final index = _tasks.indexWhere((task) => task.title == atTitle);
    if (index != -1) {
      editTask(index, newTaskDescription);
      return true;
    }
    return false;
  }

  void deleteTaskByTitle(String title) {
    _tasks.removeWhere((task) => task.title == title);
    notifyListeners();
  }

  void deleteCompletedTasks(BuildContext context) {
    if (isEmpty) {
      AlertPopUp.showErrorAlert(
        context: context,
        title: 'Empty List',
        desc: 'Cannot delete items from an empty list. Add todos.',
      );
      return;
    }
    _tasks.removeWhere((task) => task.isCompleted);
    notifyListeners();
  }

  Task getTaskOfIndex(int index) {
    if (index < 0 || index >= _tasks.length) {
      throw IndexError.withLength(_tasks.length, index);
    }
    return _tasks[index];
  }
}
