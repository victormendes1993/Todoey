import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:provider/provider.dart';
import 'package:todoey/constants/constants.dart';
import 'package:todoey/models/task_data.dart';
import 'package:todoey/screens/widgets/task_sheet.dart';
import 'package:todoey/screens/widgets/task_tile.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();

    // Load tasks from the database after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TaskData>(context, listen: false).loadTasksFromDb();
    });
  }

  final fabKey = GlobalKey<ExpandableFabState>();

  @override
  Widget build(BuildContext context) {
    var taskData = Provider.of<TaskData>(context, listen: false);
    var listenableTaskData = Provider.of<TaskData>(context);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(listenableTaskData),
          _buildTaskViewer(listenableTaskData),
        ],
      ),
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: _buildExpandableFab(taskData),
    );
  }

  //Screen Section
  Widget _buildHeader(TaskData listenableTaskData) {
    return Container(
      padding: const EdgeInsets.only(
        top: 90.0,
        left: 30.0,
        right: 30.0,
        bottom: 30.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const CircleAvatar(
            radius: 20.0,
            backgroundColor: Colors.white,
            child: Icon(
              color: Colors.black,
              Icons.list,
              size: 30.0,
            ),
          ),
          const SizedBox(height: 10.0),
          const Text(
            'Todoey',
            style: TextStyle(
                color: Colors.lightBlue,
                fontSize: 70.0,
                fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 10.0),
          Text(
            '${listenableTaskData.length} Tasks',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskViewer(TaskData listenableTaskData) {
    return Expanded(
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        child: Padding(
          padding:
              listenableTaskData.isEmpty ? emptyListPadding : filledListPadding,
          child: _buildTaskList(listenableTaskData),
        ),
      ),
    );
  }

  Widget _buildTaskList(TaskData listenableTaskData) {
    return ListView.builder(
      itemBuilder: (context, index) {
        var taskData = Provider.of<TaskData>(context, listen: false);
        return TaskTile(
          taskTitle: listenableTaskData.getName(index),
          isChecked: listenableTaskData.getIsDone(index),
          toggleCheckbox: (checkboxState) {
            taskData.toggleTaskCompletion(index);
          },
          index: index,
        );
      },
      itemCount: listenableTaskData.length,
    );
  }

  //FAB Section
  ExpandableFab _buildExpandableFab(TaskData taskData) {
    return ExpandableFab(
      pos: ExpandableFabPos.right,
      childrenOffset: const Offset(5.0, 5.0),
      overlayStyle: ExpandableFabOverlayStyle(
          color: Colors.blueGrey.withOpacity(0.3), blur: 5.0),
      key: fabKey,
      distance: 130,
      openButtonBuilder: _buildOpenFab(),
      closeButtonBuilder: _buildCloseFab(),
      children: _buildFabChildren(taskData),
    );
  }

  FloatingActionButtonBuilder _buildOpenFab() {
    return FloatingActionButtonBuilder(
      size: 5.0,
      builder: (context, onPressed, progress) {
        return _buildFabChildrenButton(
          onPressed: () {
            if (fabKey.currentState != null) {
              fabKey.currentState!.toggle();
            }
          },
          icon: Icons.menu_rounded,
        );
      },
    );
  }

  FloatingActionButtonBuilder _buildCloseFab() {
    return FloatingActionButtonBuilder(
      size: 5.0,
      builder: (context, onPressed, progress) {
        return FloatingActionButton(
          shape: const CircleBorder(),
          onPressed: () {
            if (fabKey.currentState != null && fabKey.currentState!.isOpen) {
              fabKey.currentState!.toggle();
            }
          },
          backgroundColor: Colors.lightBlue,
          child: const Icon(
            Icons.clear,
            color: Colors.white,
          ),
        );
      },
    );
  }

  List<Widget> _buildFabChildren(TaskData taskData) {
    return [
      _buildFabChildrenButton(
        title: 'Add New Task',
        onPressed: () {
          showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            builder: (context) => const TaskSheet(),
          ).whenComplete(() {
            if (fabKey.currentState != null && fabKey.currentState!.isOpen) {
              fabKey.currentState!.toggle();
            }
          });
        },
        icon: Icons.add,
      ),
      _buildFabChildrenButton(
        title: 'Delete Completed',
        onPressed: () {
          taskData.deleteCompletedTasks(context);
          if (fabKey.currentState != null) {
            fabKey.currentState!.toggle();
          }
        },
        icon: Icons.delete_outline,
      ),
      _buildFabChildrenButton(
          title: 'Complete All',
          onPressed: () {
            taskData.toggleAll();

            if (fabKey.currentState != null) {
              fabKey.currentState!.toggle();
            }
          },
          icon: Icons.check_box_outlined)
    ];
  }

  Widget _buildFabChildrenButton(
      {String? title, required onPressed, required IconData icon}) {
    return FloatingActionButton(
      shape: const CircleBorder(),
      tooltip: title,
      backgroundColor: Colors.lightBlue,
      onPressed: onPressed,
      child: Icon(
        icon,
        color: Colors.white,
        size: 30.0,
      ),
    );
  }
} //TasksScreenState
