import 'package:faceapp/core/utils/extensions.dart';
import 'package:flutter/material.dart';

class Details extends StatelessWidget {
  final String title;
  final String value;
  final CrossAxisAlignment crossAxisAlignment;
  const Details({
    super.key,
    required this.title,
    required this.value,
    this.crossAxisAlignment = CrossAxisAlignment.center,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: crossAxisAlignment,
      children: [
        Text(
           textScaleFactor: 1.0,
          title,
          style: context.theme.textTheme.titleSmall!.copyWith(
            fontWeight: FontWeight.w400,
          ),
        ),
        Text(
           textScaleFactor: 1.0,
          value,
          style: context.theme.textTheme.titleMedium!.copyWith(
            fontWeight: FontWeight.w300,
          ),
        ),
      ],
    );
  }
}
