import 'package:flutter/material.dart';
import 'package:todoey/widgets/task_tile.dart';
import '../models/task.dart';

class TasksList extends StatefulWidget {
  const TasksList({super.key});

  @override
  State<TasksList> createState() => _TasksListState();
}

class _TasksListState extends State<TasksList> {
  List<Task> tasks = [
    Task(name: 'Levar cachorro para caminhar'),
    Task(name: 'Pagar as contas'),
    Task(name: 'Tirar coco do cachorro'),
    Task(name: 'Estudar'),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return TaskTile(
          taskTitle: tasks[index].name,
          isChecked: tasks[index].isDone,
          getCheckboxState: (bool? passCheckboxState) {
            setState(() {
              tasks[index].changeCheckboxState(passCheckboxState);
            });
          },
        );
      },
      itemCount: tasks.length,
    );
  }
}
