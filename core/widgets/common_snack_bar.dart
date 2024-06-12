import 'package:flutter/material.dart';

import '../constants/color_codes.dart';

class AppSnackBar {
  static SnackBar showErrorSnackBar(BuildContext context, String error) {
    return SnackBar(
      content: Row(
        children: [
          Expanded(
            child: Text(
               textScaleFactor: 1.0,
              error,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: ColorCodes.whiteColor),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
            color: ColorCodes.whiteColor,
          ),
        ],
      ),
      backgroundColor: Colors.redAccent,
      duration: const Duration(seconds: 3),
    );
  }
}
