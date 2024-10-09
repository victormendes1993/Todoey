import 'package:flutter/material.dart';

const TextStyle kEmptyTasksMessageStyle = TextStyle(
  color: Colors.black,
  fontSize: 50.0,
  fontWeight: FontWeight.bold,
);

EdgeInsetsGeometry emptyListPadding = const EdgeInsets.all(15.0);
EdgeInsetsGeometry filledListPadding =
    const EdgeInsets.only(left: 5.0, right: 5.0, top: 5.0);

InputBorder? textFormBorder = UnderlineInputBorder().copyWith(
    borderSide: BorderSide(
  color: Colors.grey,
  width: 1.0,
));
