import 'package:flutter/material.dart';
import 'package:todoey/models/task.dart';
import 'package:todoey/models/database_helper.dart';
import 'package:todoey/widgets/alert_pop_up.dart';

class TaskData extends ChangeNotifier {
  final List<Task> _tasks = [];

  List<Task> get tasks => _tasks;

  bool get isEmpty => _tasks.isEmpty;

  int get length => _tasks.length;

  String getName(int index) => getTaskOfIndex(index).title;

  bool getIsDone(int index) => getTaskOfIndex(index).isCompleted;

  Task getTaskOfIndex(int index) {
    if (index < 0 || index >= _tasks.length) {
      throw IndexError.withLength(_tasks.length, index);
    }
    return _tasks[index];
  }

  //TODO: Update editTaskTitle
  bool editTaskTitle({
    required String atTitle,
    required String newTaskDescription,
  }) {
    final index = _tasks.indexWhere((task) => task.title == atTitle);
    if (index != -1) {
      final task = getTaskOfIndex(index);
      task.title = newTaskDescription;
      notifyListeners();
      return true;
    }
    return false;
  }

  //TODO: Update deleteTaskByTitle
  void deleteTaskByTitle(String title) {
    _tasks.removeWhere((task) => task.title == title);
    notifyListeners();
  }

  //Todo: Create a setPriority method
  //Todo: Create a setCategory method

  //Finished Methods

  Future<void> toggleSingleTask(int index) async {
    final task = getTaskOfIndex(index);
    task.isCompleted = !task.isCompleted; // Toggle completion
    await DatabaseHelper().toggleTaskCompletion(task.id, task.isCompleted);
    notifyListeners();
  }

  Future<void> loadTasksFromDb() async {
    _tasks.clear(); // Pre-built list method to clear existing tasks.
    final List<Task> tasksFromDb = await DatabaseHelper().fetchTasks();
    if (tasksFromDb.isNotEmpty) {
      _tasks.addAll(tasksFromDb);
    } // Store in memory
    notifyListeners(); // Notify listeners to update UI
  }

  Future<void> addNewTask(
    String taskDescription, {
    String category = '',
    int priority = 2,
  }) async {
    final newTask = Task(
      title: taskDescription,
      category: category,
      priority: priority,
    );
    _tasks.add(newTask);
    await DatabaseHelper().addNewTask(newTask.toMap());
    notifyListeners();
  }

  Future<void> toggleAllTasks() async {
    // Determine if all tasks are currently completed
    bool allCompleted = _tasks.every((task) => task.isCompleted);

    // Toggle all tasks to the opposite state
    for (var task in _tasks) {
      task.isCompleted = !allCompleted;
    }
    // Update all tasks in the database
    await DatabaseHelper().toggleAll(!allCompleted);
    notifyListeners();
  }

  Future<void> deleteCompletedTasks(BuildContext context) async {
    if (isEmpty) {
      AlertPopUp.showErrorAlert(
        context: context,
        title: 'Empty List',
        desc: 'Cannot delete items from an empty list. Add todos.',
      );
      return;
    }
    _tasks.removeWhere((task) => task.isCompleted);
    await DatabaseHelper().deleteCompletedTasks();
    notifyListeners();
  }
}
