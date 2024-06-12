import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../core/constants/app_paddings.dart';
import '../../../../../core/constants/color_codes.dart';
import '../../../../../core/utils/extensions.dart';
import '../../../../../core/widgets/gap_widgets/horizontal_gap_consistent.dart';

class BottomSheetTopPartPrimaryTitleWidget extends StatelessWidget {
  const BottomSheetTopPartPrimaryTitleWidget({
    super.key,
    required this.text,
    this.svgIcon,
    this.iconColor = ColorCodes.whiteColor,
  });

  final String text;
  final String? svgIcon;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (svgIcon != null)
          SvgPicture.asset(
            svgIcon!,
            fit: BoxFit.fill,
            colorFilter: ColorFilter.mode(
              iconColor,
              BlendMode.srcIn,
            ),
          ),
        HorizontalGapWidget(AppPaddings.p8.w),
        Text(
           textScaleFactor: 1.0,
          text,
          style: context.theme.textTheme.titleMedium!.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
