import 'package:flutter/material.dart';

class TaskTile extends StatefulWidget {
  const TaskTile({super.key, required this.text});
  final String text;

  @override
  State<TaskTile> createState() => _TaskTileState();
}

class _TaskTileState extends State<TaskTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title:  Text(
        widget.text,
        style: const TextStyle(
          decorationColor: Colors.black,
        ),
      ),
      trailing: Checkbox(value: false, onChanged: (bool? checked){}),
    );
  }
}
