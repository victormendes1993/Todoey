import 'package:flutter/material.dart';

class TaskTile extends StatelessWidget {
  const TaskTile(
      {super.key,
      required this.taskTitle,
      required this.isChecked,
      required this.getCheckboxState});

  final String taskTitle;
  final bool isChecked;
  final void Function(bool?) getCheckboxState;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        taskTitle,
        style: TextStyle(
          fontSize: 18.0,
          decoration:
              isChecked ? TextDecoration.lineThrough : TextDecoration.none,
          decorationColor: Colors.black,
        ),
      ),
      trailing: Checkbox(
        value: isChecked,
        activeColor: Colors.lightBlueAccent,
        onChanged: getCheckboxState,
      ),
    );
  }
}
