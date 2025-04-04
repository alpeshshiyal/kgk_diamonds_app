import 'package:flutter/material.dart';

class SnackBarUtil {
  static void showMessage(
      BuildContext context,
      String message, {
        Color backgroundColor = Colors.black87,
        Duration duration = const Duration(seconds: 3),
        SnackBarAction? action,
      }) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: backgroundColor,
      duration: duration,
      action: action,
    );

    // Hide any existing snackbar before showing a new one
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}
