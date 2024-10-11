import 'package:flutter/material.dart';
import 'package:todoey/models/database_helper.dart';
import 'package:todoey/models/task.dart';
import 'package:todoey/widgets/alert_pop_up.dart';

class TaskData extends ChangeNotifier {
  final List<Task> _tasks = [];

  List<Task> get tasks => _tasks;

  bool get isListEmpty => _tasks.isEmpty;

  int get listLength => _tasks.length;

  String getTitle(int index) => getTaskOfIndex(index).title;
  String getCategory(int index) => getTaskOfIndex(index).category;
  int getPriority(int index) => getTaskOfIndex(index).priority;
  int getId(int index) => getTaskOfIndex(index).id;
  bool getIsDone(int index) => getTaskOfIndex(index).isCompleted;

  String getPriorityIntToString(int priority) {
    switch (priority) {
      case 1:
        return 'High';
      case 2:
        return 'Normal';
      case 3:
        return 'Low';
      default:
        return 'Normal'; // Default case
    }
  }

  int getPriorityStringToInt(String label) {
    switch (label) {
      case 'High':
        return 1;
      case 'Normal':
        return 2;
      case 'Low':
        return 3;
      default:
        return 2; // Default to 'Normal'
    }
  }

  Task getTaskOfIndex(int index) {
    if (index < 0 || index >= _tasks.length) {
      throw IndexError.withLength(_tasks.length, index);
    }
    return _tasks[index];
  }

  //Finished Methods
  Future<void> addNewTask(
    String title, {
    String category = '',
    int priority = 2,
  }) async {
    final task = Task(
      title: title,
      category: category,
      priority: priority,
    );
    int? id = await DatabaseHelper().insert(task.toMap());
    task.id = id ?? 0;
    _tasks.add(task);
    notifyListeners();
  }

  Future<void> editTask({
    required int index,
    required String newTitle,
    required int newPriority,
    required String newCategory,
  }) async {
    final task = getTaskOfIndex(index);
    task.title = newTitle;
    task.priority = newPriority;
    task.category = newCategory;
    await DatabaseHelper().update(
      task.id, //Used as argument for whereArgs
      newTitle,
      newPriority,
      newCategory,
    );
    notifyListeners();
  }

  Future<void> toggleSingleTask(int index) async {
    final task = getTaskOfIndex(index);
    task.isCompleted = !task.isCompleted; // Toggle completion
    await DatabaseHelper().updateCheckbox(task.id, task.isCompleted);
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
    await DatabaseHelper().updateAllCheckbox(!allCompleted);
    notifyListeners();
  }

  Future<void> deleteTaskById(int id) async {
    _tasks.removeWhere((task) => task.id == id);
    await DatabaseHelper().delete(id);
    notifyListeners();
  }

  Future<void> deleteCompletedTasks(BuildContext context) async {
    if (isListEmpty) {
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
