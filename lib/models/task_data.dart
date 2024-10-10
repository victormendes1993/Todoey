import 'package:flutter/material.dart';
import 'package:todoey/models/database_helper.dart';
import 'package:todoey/models/task.dart';
import 'package:todoey/widgets/alert_pop_up.dart';

class TaskData extends ChangeNotifier {
  final List<Task> _tasks = [];

  List<Task> get tasks => _tasks;

  bool get isEmpty => _tasks.isEmpty;

  int get length => _tasks.length;

  String getTitle(int index) => getTaskOfIndex(index).title;
  String getCategory(int index) => getTaskOfIndex(index).category;
  int getPriority(int index) => getTaskOfIndex(index).priority;
  int getId(int index) => getTaskOfIndex(index).id;
  bool getIsDone(int index) => getTaskOfIndex(index).isCompleted;

  Task getTaskOfIndex(int index) {
    if (index < 0 || index >= _tasks.length) {
      throw IndexError.withLength(_tasks.length, index);
    }
    return _tasks[index];
  }

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
    int? newTaskId = await DatabaseHelper().addNewTask(newTask.toMap());
    newTask.id = newTaskId ?? 0;
    _tasks.add(newTask);
    notifyListeners();
  }

  Future<void> editTask({
    required int index,
    required String newTaskDescription,
    required int newPriority,
    required String newCategory,
  }) async {
    final Task task = getTaskOfIndex(index);
    task.title = newTaskDescription;
    task.priority = newPriority;
    task.category = newCategory;
    await DatabaseHelper().editTask(
      task.id,
      newTaskDescription,
      newPriority,
      newCategory,
    );
    notifyListeners();
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

  Future<void> deleteTaskById(int id) async {
    _tasks.removeWhere((task) => task.id == id);
    await DatabaseHelper().deleteTaskById(id);
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
