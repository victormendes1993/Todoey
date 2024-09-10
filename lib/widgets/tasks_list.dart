import 'package:flutter/material.dart';
import 'package:todoey/widgets/task_tile.dart';

class TasksList extends StatelessWidget {
  const TasksList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const <Widget>[
        TaskTile(text: 'Levar cachorro para caminhar',),
        TaskTile(text: 'Pagar as contas'),
        TaskTile(text: 'Tirar coco do cachorro'),
      ],
    );
  }
}



