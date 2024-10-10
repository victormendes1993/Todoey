import 'package:flutter/material.dart';
import 'package:todoey/models/task.dart';
import 'package:todoey/models/database_helper.dart';
import 'package:todoey/widgets/alert_pop_up.dart';

class TaskData extends ChangeNotifier {
  final List<Task> _tasks = [];

  String _selectedPriority = 'Normal';
  String _selectedCategory = 'No Category';

  String getSelectedPriority() => _selectedPriority;

  String getSelectedCategory() => _selectedCategory;

  List<Task> get tasks => _tasks;

  bool get isEmpty => _tasks.isEmpty;

  int get length => _tasks.length;

  String getTitle(int index) => getTaskOfIndex(index).title;

  String getCategory(int index) => getTaskOfIndex(index).category;

  String? getPriority(int index) {
    int priority = getTaskOfIndex(index).priority;

    switch (priority) {
      case 1:
        return 'High';
      case 2:
        return 'Normal';
      case 3:
        return 'Low';
      default:
        return null;
    }
  }

  void setSelectedPriority(String priority) {
    _selectedPriority = priority;
    notifyListeners();
  }

  void setSelectedCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  bool getIsDone(int index) => getTaskOfIndex(index).isCompleted;

  Task getTaskOfIndex(int index) {
    if (index < 0 || index >= _tasks.length) {
      throw IndexError.withLength(_tasks.length, index);
    }
    return _tasks[index];
  }

  //Todo: Update the edit to priority and Category

  //Finished Methods
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

  Future<bool> editTaskTitle({
    required String atTitle,
    required String newTaskDescription,
    required int newPriority,
    required String newCategory,
  }) async {
    final index = _tasks.indexWhere((task) => task.title == atTitle);
    if (index != -1) {
      final task = getTaskOfIndex(index);
      task.title = newTaskDescription;
      await DatabaseHelper().editTaskTitle(
        atTitle,
        newTaskDescription,
        newPriority,
        newCategory,
      );
      notifyListeners();
      return true;
    }
    return false;
  }

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

  Future<void> deleteTaskByTitle(String title) async {
    _tasks.removeWhere((task) => task.title == title);
    await DatabaseHelper().deleteTaskByTitle(title);
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
