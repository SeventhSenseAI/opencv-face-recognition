import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../core/constants/app_paddings.dart';
import '../../../../../core/constants/color_codes.dart';
import '../../../../../core/utils/extensions.dart';
import '../../../../../core/widgets/gap_widgets/vertical_gap_consistent.dart';

class BottomSheetIconButtonWidget extends StatelessWidget {
  const BottomSheetIconButtonWidget({
    super.key,
    this.onTap,
    required this.svgIcon,
    required this.text,
    required this.isBtnActive,
    this.isSvg = true,
  });
  final Function()? onTap;
  final String svgIcon;
  final String text;
  final bool isBtnActive;
  final bool isSvg;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isBtnActive ? onTap : null,
      child: Column(
        children: [
          isSvg
              ? SvgPicture.asset(
                  svgIcon,
                  fit: BoxFit.fill,
                  colorFilter: ColorFilter.mode(
                    isBtnActive ? ColorCodes.whiteColor : Colors.grey.shade900,
                    BlendMode.srcIn,
                  ),
                )
              : Image.asset(
                  svgIcon,
                  fit: BoxFit.fill,
                  color: isBtnActive ? ColorCodes.whiteColor : Colors.grey.shade900,
                  width: 23.w,
                  height: 23.w,
                ),
          VerticalGapWidget(AppPaddings.p8.h),
          Text(
             textScaleFactor: 1.0,
            text,
            style: context.theme.textTheme.labelSmall!.copyWith(
              fontWeight: FontWeight.w400,
              color: isBtnActive ? ColorCodes.whiteColor : Colors.grey.shade900,
            ),
          ),
        ],
      ),
    );
  }
}
