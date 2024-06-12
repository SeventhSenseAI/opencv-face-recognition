import 'package:flutter/material.dart';

/// Extension on [ThemeExtension] for accessing the current ThemeData
/// from the BuildContext.
extension ThemeExtension on BuildContext {
  ThemeData get theme => Theme.of(this);
}
