import 'package:flutter/material.dart';

class NoInternetException implements Exception {
  final String _message;

  NoInternetException([String message = 'NoInternetException Occurred'])
      : _message = message;

  void showSnackBar(BuildContext context) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    scaffoldMessenger.showSnackBar(SnackBar(content: Text(_message, textScaleFactor: 1.0,)));
  }

  @override
  String toString() {
    return _message;
  }
}
