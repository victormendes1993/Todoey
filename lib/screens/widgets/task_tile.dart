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
  final ValueChanged<bool?> toggleCheckbox;
  final int index;

  static const double _cardRadius = 15.0;
  static const double _titleFontSize = 18.0;
  static const Color _activeColorCheckBox = Colors.lightBlueAccent;

  @override
  Widget build(BuildContext context) {
    // Only listen to changes when necessary
    final taskData = Provider.of<TaskData>(context);

    return Card(
      shape: RoundedRectangleBorder(
        side: const BorderSide(
          color: Colors.lightBlueAccent,
          strokeAlign: BorderSide.strokeAlignCenter,
        ),
        borderRadius: BorderRadius.circular(_cardRadius),
      ),
      child: ListTile(
        subtitle: Text(
          'Priority: ${taskData.getPriority(index)}\nCategory: ${taskData.getCategory(index)}',
        ),
        leading: _buildMenu(context, taskData),
        title: _buildTaskTitle(),
        trailing: _buildCheckbox(),
      ),
    );
  }

  Widget _buildMenu(BuildContext context, TaskData taskData) {
    final MenuController menuController = MenuController();

    return MenuAnchor(
      style: MenuStyle(
        shape: WidgetStatePropertyAll(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_cardRadius),
        )),
        padding: const WidgetStatePropertyAll(EdgeInsets.all(5.0)),
        backgroundColor: WidgetStatePropertyAll(Colors.blueGrey.shade50),
      ),
      controller: menuController,
      menuChildren: _buildMenuChildren(context, taskData),
      child: IconButton(
        onPressed: menuController.open,
        icon: const Icon(Icons.more_vert),
      ),
    );
  }

  List<Widget> _buildMenuChildren(BuildContext context, TaskData taskData) {
    return [
      MenuItemButton(
        onPressed: () => toggleCheckbox(true),
        child: const Text('Mark as done'),
      ),
      MenuItemButton(
        onPressed: () => _showEditTaskSheet(context),
        child: const Text('Edit'),
      ),
      MenuItemButton(
        onPressed: () => taskData.deleteTaskByTitle(taskTitle),
        child: const Text('Delete'),
      ),
    ];
  }

  Widget _buildTaskTitle() {
    return Text(
      taskTitle,
      style: TextStyle(
        fontSize: _titleFontSize,
        decorationColor: Colors.black,
        decoration:
            isChecked ? TextDecoration.lineThrough : TextDecoration.none,
      ),
    );
  }

  Widget _buildCheckbox() {
    return Checkbox(
      value: isChecked,
      activeColor: _activeColorCheckBox,
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
