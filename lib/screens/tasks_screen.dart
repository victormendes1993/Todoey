import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:provider/provider.dart';
import 'package:todoey/constants/constants.dart';
import 'package:todoey/models/task_data.dart';
import 'package:todoey/screens/widgets/fab_builder.dart';
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
      floatingActionButton: FabBuilder(taskData: taskData),
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
            '${listenableTaskData.listLength} Tasks',
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
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white,
              Colors.blueGrey.shade100,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        child: Padding(
          padding: listenableTaskData.isListEmpty
              ? emptyListPadding
              : filledListPadding,
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
          taskTitle: listenableTaskData.getTitle(index),
          isChecked: listenableTaskData.getIsDone(index),
          priority: listenableTaskData.getPriority(index),
          category: listenableTaskData.getCategory(index),
          index: index,
          toggleCheckbox: (checkboxState) {
            taskData.toggleSingleTask(index);
          },
        );
      },
      itemCount: listenableTaskData.listLength,
    );
  }
} //TasksScreenState
