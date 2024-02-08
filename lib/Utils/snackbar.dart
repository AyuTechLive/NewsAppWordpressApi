import 'package:flutter/material.dart';

class MySnackbar {
  static void show(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message),
      action: SnackBarAction(
        label: 'OK',
        onPressed: () {
          // Add any action you want to perform when the action button is pressed
          // e.g., navigate to another screen or perform some other operation
        },
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
