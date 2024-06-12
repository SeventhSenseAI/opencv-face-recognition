import 'package:faceapp/core/constants/color_codes.dart';
import 'package:faceapp/core/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CircleWidget extends StatelessWidget {
  final bool isSelected;
  final String text;
  final VoidCallback onTap; // Add this callback

  const CircleWidget({
    super.key,
    required this.isSelected,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Transform.scale(
        scale: isSelected ? 1.2 : 1.0,
        child: Container(
          width: 29.h,
          height: 29.h,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: ColorCodes.blackColor.withOpacity(.2),
          ),
          child: Center(
            child: Text(
               textScaleFactor: 1.0,
              text,
              style: context.theme.textTheme.labelSmall!.copyWith(
                fontSize: 10.5.sp,
                color: isSelected
                    ? ColorCodes.zoomSelectTextColor
                    : ColorCodes.whiteColor,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
