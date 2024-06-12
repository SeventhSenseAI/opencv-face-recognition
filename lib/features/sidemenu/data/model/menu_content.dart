import 'package:flutter/material.dart';

enum ContentType { liveness, person, compare, myApi, delete, logout }

class MenuContent {
  final String title;
  final bool isSwitchIcon;
  final String? leftIcon;
  final String? rightIcon;
  final bool isEnableLiveness;
  final Key key;
  final ContentType contentType;

  MenuContent(
      {required this.title,
      required this.isSwitchIcon,
      this.leftIcon,
      this.rightIcon,
      required this.isEnableLiveness,
      required this.key,
      required this.contentType,
});
}