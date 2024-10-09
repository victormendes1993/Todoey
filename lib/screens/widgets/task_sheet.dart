// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoey/constants/constants.dart';
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
  String selectedPriority = 'Normal';
  String selectedCategory = 'No Category';

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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 20),
            Text(
              textAlign: TextAlign.center,
              widget.initialTaskTitle == null ? 'Add Task' : 'Edit Task',
              // Dynamic title
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            _buildTextField(),
            const SizedBox(height: 30),
            _buildDropDownPriorityMenu(),
            const SizedBox(height: 30),
            _buildDropDownCategoryMenu(),
            const SizedBox(height: 30),
            _buildSubmitButton(context),
            const SizedBox(height: 30),
            //todo: Allow edits to the Category
            //todo: Allow edits to the Priority
          ],
        ),
      ),
    );
  }

  Widget _buildTextField() {
    return TextField(
      cursorColor: Colors.lightBlueAccent,
      controller: _taskController,
      textAlign: TextAlign.center,
      focusNode: _focusNode,
      decoration: InputDecoration(
        border: textFormBorder,
        enabledBorder: textFormBorder,
        focusedBorder: textFormBorder,
        labelText: 'Enter task description',
        labelStyle: TextStyle(
          color: Colors.grey.shade500,
          fontSize: 18.0,
        ),
        floatingLabelStyle: TextStyle(
          color: Colors.lightBlueAccent,
          fontSize: 20.0,
        ),
      ),
    );
  }

  Widget _buildDropDownPriorityMenu() {
    final List<DropdownMenuEntry<String>> items = [
      DropdownMenuEntry(value: 'Low', label: 'Low'),
      DropdownMenuEntry(value: 'Normal', label: 'Normal'),
      DropdownMenuEntry(value: 'High', label: 'High'),
    ];

    void onPressed(String? selected) {
      setState(() {
        selectedPriority = selected!;
      });
    }

    return customDropDownMenu(
      items: items,
      onPressed: onPressed,
      label: 'Set Priority',
    );
  }

  // The _buildDropDownCategoryMenu is already refactored, so no change needed here.
  Widget _buildDropDownCategoryMenu() {
    final List<DropdownMenuEntry<String>> items = [
      DropdownMenuEntry(value: 'Work', label: 'Work'),
      DropdownMenuEntry(value: 'Home', label: 'Home'),
      DropdownMenuEntry(value: 'Office', label: 'Office'),
      DropdownMenuEntry(value: 'School', label: 'School'),
      DropdownMenuEntry(
        value: 'Add New',
        label: 'Add New',
        trailingIcon: Icon(Icons.add),
      ),
    ];

    void onPressed(String? selected) {
      setState(() {
        selectedCategory = selected!;
      });
    }

    return customDropDownMenu(
      items: items,
      onPressed: onPressed,
      label: 'Set Category',
    );
  }

  DropdownMenu<String> customDropDownMenu({
    required List<DropdownMenuEntry<String>> items,
    required void Function(String?)? onPressed,
    required String label,
  }) {
    return DropdownMenu<String>(
      expandedInsets: EdgeInsets.zero,
      inputDecorationTheme: InputDecorationTheme(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade400),
          borderRadius: BorderRadius.all(Radius.circular(30.0)),
        ),
      ),
      menuStyle: MenuStyle(
        backgroundColor: WidgetStatePropertyAll(Colors.grey.shade100),
      ),
      dropdownMenuEntries: items,
      onSelected: onPressed,
      label: Text(label),
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
      child: const Text('Send'),
    );
  }
}
