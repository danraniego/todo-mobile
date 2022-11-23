import 'package:flutter/material.dart';

class ProgressDialog {

  static spin(context, message) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
              content: Row(
                children: <Widget>[
                  const CircularProgressIndicator(),
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Text(message),
                  )
                ],
              )
          );
        });
  }

  static stop(context) {
    Navigator.of(context).pop();
  }
}