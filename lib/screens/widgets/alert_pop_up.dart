import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class AlertPopUp {
  static void showErrorAlert(
      {required BuildContext context, required String desc, required title}) {
    Alert(
      buttons: [
        DialogButton(
            color: Colors.lightBlueAccent,
            child: const Text(
              'Return',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
      ],
      context: context,
      title: title,
      desc: desc,
      style: const AlertStyle(
        titleStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        descStyle: TextStyle(color: Colors.grey, fontSize: 18.0),
        //backgroundColor: Colors.lightBlueAccent,
      ),
    ).show();
  }
}
