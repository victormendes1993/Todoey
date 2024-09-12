import 'package:flutter/material.dart';
import 'package:todoey/widgets/task_tile.dart';
import '../models/task.dart';

class TasksList extends StatefulWidget {
  const TasksList({super.key, required this.tasksList});

  final List<Task> tasksList;

  @override
  State<TasksList> createState() => _TasksListState();
}

class _TasksListState extends State<TasksList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return TaskTile(
          taskTitle: widget.tasksList[index].name,
          isChecked: widget.tasksList[index].isDone,
          getCheckboxState: (bool? passCheckboxState) {
            setState(() {
              widget.tasksList[index].changeCheckboxState(passCheckboxState);
            });
          },
        );
      },
      itemCount: widget.tasksList.length,
    );
  }
}
