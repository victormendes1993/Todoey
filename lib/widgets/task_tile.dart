import 'package:flutter/material.dart';
import 'package:todoey/widgets/tasks_checkbox.dart';

class TaskTile extends StatefulWidget {
  const TaskTile({super.key, required this.text});

  final String text;
  final bool isChecked = false;

  @override
  State<TaskTile> createState() => _TaskTileState();
}

class _TaskTileState extends State<TaskTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        widget.text,
        style: TextStyle(
          decoration: widget.isChecked
              ? TextDecoration.lineThrough
              : TextDecoration.none,
          decorationColor: Colors.black,
        ),
      ),
      trailing: TasksCheckbox(
        checkBoxState: widget.isChecked,
      ),
    );
  }
}
