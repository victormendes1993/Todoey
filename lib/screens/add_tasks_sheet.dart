import 'package:flutter/material.dart';

class AddTasksSheet extends StatefulWidget {
  const AddTasksSheet({super.key, required this.addTask});

  final Function(String) addTask;

  @override
  State<AddTasksSheet> createState() => _AddTasksSheetState();
}

class _AddTasksSheetState extends State<AddTasksSheet> {
  late String newTaskTitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.only(
            left: 30.0,
            right: 30.0,
            bottom: 20.0,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 20),
              const Text(
                'Add Task',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextField(
                textAlign: TextAlign.center,
                autofocus: true,
                onChanged: (newTitle) {
                  newTaskTitle = newTitle;
                },
              ),
              const SizedBox(height: 20),
              FilledButton(
                style: const ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(Colors.lightBlue),
                ),
                onPressed: () {
                  widget.addTask(newTaskTitle);
                  Navigator.pop(context);
                },
                child: const Text('Go'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
