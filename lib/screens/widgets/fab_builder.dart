import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:todoey/models/task_data.dart';
import 'package:todoey/screens/widgets/task_sheet.dart';

class FabBuilder extends StatefulWidget {
  const FabBuilder({super.key, required this.taskData});

  final TaskData taskData;

  @override
  State<FabBuilder> createState() => _FabBuilderState();
}

class _FabBuilderState extends State<FabBuilder> {
  final fabKey = GlobalKey<ExpandableFabState>();

  @override
  Widget build(BuildContext context) {
    return ExpandableFab(
      type: ExpandableFabType.up,
      pos: ExpandableFabPos.right,
      overlayStyle: ExpandableFabOverlayStyle(
        color: Colors.black87,
        blur: 5.0,
      ),
      key: fabKey,
      distance: 80,
      openButtonBuilder: _buildOpenFab(),
      closeButtonBuilder: _buildCloseFab(),
      children: _buildFabChildren(widget.taskData),
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
      _buildFabChildrenRow(
        title: 'Add New task',
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
      _buildFabChildrenRow(
        title: 'Delete Completed',
        onPressed: () {
          taskData.deleteCompletedTasks(context);
          if (fabKey.currentState!.isOpen) {
            fabKey.currentState!.toggle();
          }
        },
        icon: Icons.delete_outline,
      ),
      _buildFabChildrenRow(
          title: 'Complete All',
          onPressed: () {
            taskData.toggleAllTasks();

            if (fabKey.currentState != null) {
              fabKey.currentState!.toggle();
            }
          },
          icon: Icons.check_box_outlined),
    ];
  }

  Row _buildFabChildrenRow(
      {String? title, required onPressed, required IconData icon}) {
    return Row(
      children: [
        _buildFabChildrenDescription(title),
        SizedBox(width: 10.0),
        _buildFabChildrenButton(
          title: title,
          onPressed: onPressed,
          icon: icon,
        ),
      ],
    );
  }

  Text _buildFabChildrenDescription(String? title) {
    return Text(
      title!,
      style: TextStyle(color: Colors.white),
    );
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
}
