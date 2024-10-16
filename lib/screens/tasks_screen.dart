import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:provider/provider.dart';
import 'package:todoey/constants/constants.dart';
import 'package:todoey/models/filter_data.dart';
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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
    var listenableFilterData = Provider.of<FilterData>(context);
    var filterData = Provider.of<FilterData>(context, listen: false);

    return Scaffold(
      key: _scaffoldKey,
      endDrawerEnableOpenDragGesture: false,
      endDrawer: NavigationDrawer(
        backgroundColor: Colors.black,
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
            child: Column(
              children: [
                Text(
                  'Select Filters',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.lightBlueAccent,
                      fontSize: 35.0,
                      fontWeight: FontWeight.bold),
                ),
                ListTile(
                  leading: Icon(
                    size: 25.0,
                    Icons.low_priority,
                    color: Colors.lightBlueAccent,
                  ),
                  title: Text(
                    'Priorities',
                    style: TextStyle(color: Colors.white, fontSize: 25.0),
                  ),
                ),
                Wrap(
                  spacing: 10.0,
                  runSpacing: 10.0,
                  children:
                      listenableFilterData.priorityFilters.map((priority) {
                    return _buildFilterChip(priority, filterData,
                        isPriority: true);
                  }).toList(),
                ),
                SizedBox(
                  height: 15.0,
                ),
                Divider(
                  indent: 10.0,
                  endIndent: 10.0,
                  height: 5.0,
                  color: Colors.grey.shade800,
                ),
                ListTile(
                  leading: Icon(
                    size: 25.0,
                    Icons.category,
                    color: Colors.lightBlueAccent,
                  ),
                  title: Text(
                    'Categories',
                    style: TextStyle(color: Colors.white, fontSize: 25.0),
                  ),
                ),
                Wrap(
                  spacing: 10.0,
                  runSpacing: 10.0,
                  children: listenableFilterData.categoryFilters.map(
                    (category) {
                      return _buildFilterChip(category, filterData);
                    },
                  ).toList(),
                ),
              ],
            ),
          )
        ],
      ),
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

  FilterChip _buildFilterChip(String label, FilterData filterData,
      {isPriority = false}) {
    bool selected = isPriority
        ? filterData.isPrioritySelected(label)
        : filterData.isCategorySelected(label);

    return FilterChip(
      color: WidgetStateProperty.resolveWith((Set<WidgetState> state) {
        if (state.contains(WidgetState.selected)) {
          return Colors.grey.shade900;
        } else {
          return Colors.black;
        }
      }),
      selected: selected,
      checkmarkColor: Colors.lightBlueAccent,
      label: Text(label),
      labelStyle: TextStyle(color: Colors.white),
      onSelected: (_) {
        if (isPriority) {
          filterData.priorityHandler(label);
        } else {
          filterData.categoryHandler(label);
        }
      },
    );
  }

  //Screen Section
  Widget _buildHeader(TaskData listenableTaskData) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.only(
          left: 30.0,
          right: 30.0,
          bottom: 10.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Todoey',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.lightBlue,
                  fontSize: 70.0,
                  fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${listenableTaskData.listLength} Tasks',
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
                ActionChip(
                  backgroundColor: Colors.black,
                  avatar: Icon(
                    Icons.check,
                    color: Colors.blueAccent,
                  ),
                  label: Text(
                    'Filter',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () {
                    _scaffoldKey.currentState?.openEndDrawer();
                  },
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTaskViewer(TaskData listenableTaskData) {
    return Expanded(
      child: Container(
        padding: filledListPadding,
        decoration: BoxDecoration(
          color: Colors.blueGrey.shade300,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        child: _buildTaskList(listenableTaskData),
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
