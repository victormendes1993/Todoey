import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoey/models/task_data.dart';
import 'package:todoey/screens/widgets/task_sheet.dart';

class TaskTile extends StatelessWidget {
  const TaskTile({
    super.key,
    required this.taskTitle,
    required this.isChecked,
    required this.toggleCheckbox,
    required this.index,
  });

  final String taskTitle;
  final bool isChecked;
  final ValueChanged<bool?>
      toggleCheckbox; // Use ValueChanged for better clarity
  final int index;

  static const double _cardRadius = 15.0;
  static const double _titleFontSize = 18.0;
  static const Color _activeColor = Colors.lightBlueAccent;

  @override
  Widget build(BuildContext context) {
    var taskData = Provider.of<TaskData>(context, listen: false);
    final MenuController menuController = MenuController();

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_cardRadius),
      ),
      color: Colors.blueGrey.shade50, // Correctly access shade50
      child: ListTile(
        leading: _buildMenu(menuController, taskData, context),
        title: _buildTaskTitle(),
        trailing: _buildCheckbox(),
      ),
    );
  }

  Widget _buildMenu(
      MenuController menuController, TaskData taskData, BuildContext context) {
    return MenuAnchor(
      style: MenuStyle(
        shape: WidgetStatePropertyAll(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_cardRadius),
        )),
        padding: const WidgetStatePropertyAll(EdgeInsets.all(5.0)),
        backgroundColor: WidgetStatePropertyAll(Colors.blueGrey.shade100),
      ),
      controller: menuController,
      menuChildren: [
        MenuItemButton(
          onPressed: () => toggleCheckbox(true),
          child: const Text('Mark as done'),
        ),
        MenuItemButton(
          onPressed: () => _showEditTaskSheet(context), // Pass context here
          child: const Text('Edit'),
        ),
        MenuItemButton(
          onPressed: () => taskData.deleteTaskByTitle(taskTitle),
          child: const Text('Delete'),
        ),
      ],
      child: IconButton(
        onPressed: menuController.open,
        icon: const Icon(Icons.more_vert),
      ),
    );
  }

  Widget _buildTaskTitle() {
    return Text(
      taskTitle,
      style: TextStyle(
        fontSize: _titleFontSize,
        decoration:
            isChecked ? TextDecoration.lineThrough : TextDecoration.none,
        decorationColor: Colors.black,
      ),
    );
  }

  Widget _buildCheckbox() {
    return Checkbox(
      value: isChecked,
      activeColor: _activeColor,
      onChanged: toggleCheckbox,
    );
  }

  void _showEditTaskSheet(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) => TaskSheet(initialTaskTitle: taskTitle),
    );
  }
}
