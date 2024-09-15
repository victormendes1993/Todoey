import 'package:flutter/material.dart';
import 'package:todoey/models/task_data.dart';
import 'package:todoey/widgets/task_tile.dart';
import 'package:provider/provider.dart';

class TasksList extends StatelessWidget {
  const TasksList({super.key});

  @override
  Widget build(BuildContext context) {

    return Consumer<TaskData>(
      builder: (context, pTaskData, child) { // pTaskData = Provider.of<TaskData>(context)
        return ListView.builder(
          itemBuilder: (context, index) {
            return TaskTile(
              taskTitle: pTaskData.tasks[index].name,
              isChecked: pTaskData.tasks[index].isDone,
              getCheckboxState: (bool? passCheckboxState) {
                /*setState(() {
                Provider.of<TaskData>(context).tasks[index].changeCheckboxState(passCheckboxState);
              });*/
              },
            );
          },
          itemCount: pTaskData.tasksCount,
        );
      },
    );
  }
}
