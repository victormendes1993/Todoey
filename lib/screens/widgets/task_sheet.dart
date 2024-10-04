// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoey/models/task_data.dart';
import 'package:todoey/widgets/alert_pop_up.dart';

class TaskSheet extends StatefulWidget {
  const TaskSheet({super.key, this.initialTaskTitle});

  final String? initialTaskTitle; // Use a nullable parameter for edit mode

  @override
  State<TaskSheet> createState() => _TaskSheetState();
}

class _TaskSheetState extends State<TaskSheet> {
  final TextEditingController _taskController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    // Initialize the controller with the current task title if in edit mode
    if (widget.initialTaskTitle != null) {
      _taskController.text = widget.initialTaskTitle!;
    }

    // Automatically request focus on the text field when the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _taskController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: _buildBottomSheet(context),
    );
  }

  Widget _buildBottomSheet(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
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
            Text(
              widget.initialTaskTitle == null ? 'Add Task' : 'Edit Task',
              // Dynamic title
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            _buildTextField(),
            const SizedBox(height: 20),
            _buildSubmitButton(context),
            //TODO: Create a category selector during add task
            //TODO: Create a priority selector during add task
            //todo: Allow edits to the Category
            //todo: Allow edits to the Priority
          ],
        ),
      ),
    );
  }

  Widget _buildTextField() {
    return TextField(
      controller: _taskController,
      textAlign: TextAlign.center,
      focusNode: _focusNode,
      decoration: const InputDecoration(
        hintText: 'Enter task description',
      ),
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return FilledButton(
      style: FilledButton.styleFrom(
        backgroundColor: Colors.lightBlue,
      ),
      onPressed: () {
        final taskDescription = _taskController.text;
        final taskData = Provider.of<TaskData>(context, listen: false);

        // Check for empty task description
        if (taskDescription.isEmpty) {
          AlertPopUp.showErrorAlert(
            context: context,
            title: 'Empty Task',
            desc: 'The task description cannot be empty.',
          );
          return;
        }

        // Edit existing task
        if (widget.initialTaskTitle != null) {
          taskData.editTaskTitle(
            atTitle: widget.initialTaskTitle!,
            newTaskDescription: taskDescription,
          );
          Navigator.pop(context);
          return;
        }
        taskData.addNewTask(taskDescription);
        Navigator.pop(context);
      },
      child: const Text('Go'),
    );
  }
}
