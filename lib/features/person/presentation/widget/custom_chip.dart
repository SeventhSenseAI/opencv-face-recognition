import 'dart:convert';

import 'package:faceapp/core/constants/color_codes.dart';
import 'package:faceapp/core/utils/assets.dart';
import 'package:faceapp/core/utils/extensions.dart';
import 'package:flutter/material.dart';

class CustomChip extends StatelessWidget {
  final String id;
  final String label;
  const CustomChip({
    super.key,
    required this.id,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Image.asset(Assets.collectionIcon),
      backgroundColor: ColorCodes.greyColor,
      label: Text(
         textScaleFactor: 1.0,
        label,
        style: context.theme.textTheme.bodySmall!.copyWith(
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
