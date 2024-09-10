import 'package:flutter/material.dart';

class ListStream extends StatefulWidget {
  const ListStream({super.key});

  @override
  State<ListStream> createState() => _ListStreamState();
}

class _ListStreamState extends State<ListStream> {
  bool isChecked = false;
  List<Widget> listStream = [];

  void addItemToList() {
    setState(() {
      listStream.add(
        Text(
          'Levar cachorro para caminhar',
          style: TextStyle(
            decoration:
                isChecked ? TextDecoration.lineThrough : TextDecoration.none,
            decorationColor: Colors.black,
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: listStream,
        )
      ],
    );
  }
}
