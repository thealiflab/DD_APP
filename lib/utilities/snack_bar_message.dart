import 'package:flutter/material.dart';

SnackBar snackBarMessage(String msg, bool colorType) {
  return SnackBar(
    content: Text(
      msg,
      textAlign: TextAlign.center,
      style: TextStyle(
          color: colorType ? Colors.green : Colors.red,
          fontWeight: FontWeight.bold),
    ),
    duration: const Duration(milliseconds: 2000),
    width: 280.0,
    backgroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(
      horizontal: 8.0, // Inner padding for SnackBar content.
    ),
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
  );
}
