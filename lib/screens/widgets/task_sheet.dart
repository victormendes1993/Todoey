import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoey/constants/constants.dart';
import 'package:todoey/models/filter_data.dart';
import 'package:todoey/models/task_data.dart';
import 'package:todoey/screens/widgets/alert_pop_up.dart';

class TaskSheet extends StatefulWidget {
  const TaskSheet({super.key, this.initialTaskTitle, this.index});

  final String? initialTaskTitle;
  final int? index;

  @override
  State<TaskSheet> createState() => _TaskSheetState();
}

class _TaskSheetState extends State<TaskSheet> {
  final TextEditingController _taskController = TextEditingController();
  final TextEditingController _priorityController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  late final TaskData taskData;
  bool isInitialTaskTitleNull = true;
  int priority = 2;
  String category = 'No Category';

  @override
  void initState() {
    super.initState();
    taskData = Provider.of<TaskData>(context, listen: false);

    // Initialize the controller with the current task title if in edit mode
    if (widget.initialTaskTitle != null) {
      isInitialTaskTitleNull = false;

      _taskController.text = widget.initialTaskTitle!;
      // Initialize priority and category with existing values
      priority = taskData.getPriority(widget.index!);
      _priorityController.text = taskData.getPriorityIntToString(priority);
      _categoryController.text = taskData.getCategory(widget.index!);
    }
    // Automatically request focus on the text field when the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _taskController.dispose();
    _categoryController.dispose();
    _priorityController.dispose();
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
              textAlign: TextAlign.center,
              widget.initialTaskTitle == null ? 'Add Task' : 'Edit Task',
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            _buildTextField(),
            const SizedBox(height: 30),
            _buildPriorityMenu(),
            const SizedBox(height: 30),
            _buildCategoryMenu(context),
            const SizedBox(height: 30),
            _buildSubmitButton(),
            const SizedBox(height: 30),
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
      focusNode: isInitialTaskTitleNull ? _focusNode : null,
      decoration: InputDecoration(
        border: borderBottomSheet,
        enabledBorder: borderBottomSheet,
        focusedBorder: borderBottomSheet,
        labelText: 'Enter task description',
        labelStyle: lightGreyLabelBottomSheet,
        floatingLabelStyle: blueFloatingLabelBottomSheet,
      ),
    );
  }

  Widget _buildPriorityMenu() {
    final List<DropdownMenuEntry<String>> items = [
      DropdownMenuEntry(value: 'High', label: 'High'),
      DropdownMenuEntry(value: 'Normal', label: 'Normal'),
      DropdownMenuEntry(value: 'Low', label: 'Low'),
    ];

    void onPressed(String? selectedPriority) {
      setState(() {
        _priorityController.text = selectedPriority!;
        priority = taskData.getPriorityStringToInt(selectedPriority);
      });
    }

    return customDropDownMenu<String>(
      items: items,
      onPressed: onPressed,
      label: 'Set Priority',
      isPriority: true,
    );
  }

  Widget _buildCategoryMenu(BuildContext context) {
    FilterData listenableFilterData = Provider.of<FilterData>(context);
    FilterData filterData = Provider.of<FilterData>(context, listen: false);

    List<DropdownMenuEntry<String>> items =
        listenableFilterData.categoryMenuEntries.map(
      (category) {
        return DropdownMenuEntry(
          value: category,
          label: category,
        );
      },
    ).toList();

    void onPressed(String? selectedCategory) {
      if (selectedCategory == 'Add New') {
        //Alert(context: context);
        showDialog(
            barrierColor: Colors.black87,
            context: context,
            builder: (context) {
              String newCategory = '';
              return AlertDialog(
                title: Text('Add Category'),
                content: TextField(
                  onChanged: (value) {
                    newCategory = value;
                  },
                ),
                actions: [
                  TextButton(
                    child: Text('Add'),
                    onPressed: () {
                      if (newCategory.isNotEmpty) {
                        filterData.addCategory(newCategory);
                        Navigator.pop(context);
                      }
                    },
                  ),
                ],
              );
            });
      } else {
        setState(() {
          category = selectedCategory!;
          _categoryController.text = category;
        });
      }
    }

    return customDropDownMenu(
      items: items,
      onPressed: onPressed,
      label: 'Set Category',
      isPriority: false,
    );
  }

  DropdownMenu<E> customDropDownMenu<E>({
    required List<DropdownMenuEntry<E>> items,
    required void Function(E?)? onPressed,
    required String label,
    required bool isPriority,
  }) {
    return DropdownMenu<E>(
      initialSelection: isPriority
          ? _priorityController.text as E?
          : _categoryController.text as E?,
      controller: isPriority ? _priorityController : _categoryController,
      expandedInsets: EdgeInsets.zero,
      inputDecorationTheme: InputDecorationTheme(
        labelStyle: lightGreyLabelBottomSheet,
        floatingLabelStyle: blueFloatingLabelBottomSheet,
        enabledBorder: borderBottomSheet,
      ),
      menuStyle: MenuStyle(
        backgroundColor: WidgetStatePropertyAll(Colors.grey.shade100),
      ),
      dropdownMenuEntries: items,
      onSelected: onPressed,
      label: Text(label),
    );
  }

  Widget _buildSubmitButton() {
    return FilledButton(
      style: FilledButton.styleFrom(
        backgroundColor: Colors.lightBlueAccent,
      ),
      onPressed: () {
        final taskDescription = _taskController.text;

        if (taskDescription.isEmpty) {
          AlertPopUp.showErrorAlert(
            context: context,
            title: 'Empty Task',
            desc: 'The task description cannot be empty.',
          );
          return;
        }

        if (widget.initialTaskTitle != null && widget.index != null) {
          taskData.editTask(
            index: widget.index!,
            newTitle: taskDescription,
            newPriority: priority,
            newCategory: category,
          );
          Navigator.pop(context);
          return;
        }

        taskData.addNewTask(
          taskDescription,
          priority: priority,
          category: category,
        );
        Navigator.pop(context);
      },
      child: const Text('Send'),
    );
  }
}
