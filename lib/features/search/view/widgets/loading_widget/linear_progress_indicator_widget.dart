import 'package:flutter/material.dart';

import '../../../../../core/constants/color_codes.dart';

class LinearProgressIndicatorWidget extends StatelessWidget {
  const LinearProgressIndicatorWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 16,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xff128efe), Color(0xff063056)],
        ),
      ),
      child: const LinearProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(
          ColorCodes.whiteColor,
        ),
        backgroundColor: Colors.transparent,
      ),
    );
  }
}