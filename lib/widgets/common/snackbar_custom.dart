import 'package:flutter/material.dart';

class CustomSnackbar {
  static SnackBar create(String message, Color bgcolor) {
    return SnackBar(
      backgroundColor: bgcolor,
      behavior: SnackBarBehavior.floating,
      content: Text(
        message,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
      action: SnackBarAction(
        label: 'Dismiss',
        textColor: Colors.white,
        onPressed: () {},
      ),
    );
  }
}