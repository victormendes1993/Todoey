import 'package:flutter/material.dart';

const TextStyle kEmptyTasksMessageStyle = TextStyle(
  color: Colors.black,
  fontSize: 50.0,
  fontWeight: FontWeight.bold,
);

EdgeInsetsGeometry emptyListPadding = const EdgeInsets.all(15.0);

EdgeInsetsGeometry filledListPadding =
    const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 80.0, top: 15.0);

//BottomSheet Decorations

InputBorder? borderBottomSheet = OutlineInputBorder().copyWith(
    borderRadius: BorderRadius.circular(30.0),
    borderSide: BorderSide(
      color: Colors.grey,
      width: 1.0,
    ));

TextStyle? blueFloatingLabelBottomSheet = TextStyle(
  color: Colors.lightBlueAccent,
  fontSize: 20.0,
);

TextStyle? lightGreyLabelBottomSheet = TextStyle(
  color: Colors.grey.shade500,
);
