import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/app_paddings.dart';
import '../../../../../core/constants/color_codes.dart';
import '../../../../../core/utils/extensions.dart';
import '../../../../../core/widgets/gap_widgets/vertical_gap_consistent.dart';

class ImageAnalyzingWaitingWidget extends StatelessWidget {
  const ImageAnalyzingWaitingWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: AppPaddings.p64.r,
          height: AppPaddings.p64.r,
          child: const CircularProgressIndicator(
            strokeWidth: 8,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.black54),
            backgroundColor: ColorCodes.whiteColor,
          ),
        ),
        VerticalGapWidget(AppPaddings.p32.h),
        Text(
          textScaleFactor: 1.0,
          'Analyzing the pixels...',
          textAlign: TextAlign.center,
          style: context.theme.textTheme.headlineLarge,
        ),
      ],
    );
  }
}
