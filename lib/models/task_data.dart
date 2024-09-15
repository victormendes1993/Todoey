import 'package:flutter/material.dart';
import 'package:todoey/models/task.dart';

class TaskData extends ChangeNotifier {
  final List<Task> _tasks = [
    Task(name: 'Comprar ração para Iver'),
  ];

  List<Task> get tasks => _tasks;

  int get tasksCount => tasks.length;
}
