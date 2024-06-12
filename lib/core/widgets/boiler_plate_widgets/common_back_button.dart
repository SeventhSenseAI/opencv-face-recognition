import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../constants/color_codes.dart';
import '../../utils/assets.dart';

class CommonBackButtonWidget extends StatelessWidget {
  /// This [CommonBackButtonWidget] widget is typically used as the
  /// leading widget in an app bar to provide a back navigation functionality.
  /// It displays a back arrow icon and a "Back" text label.
  /// Tapping on the widget triggers the navigation to the previous screen.
  const CommonBackButtonWidget({
    super.key,
    required this.buttonText,
  });

  /// buttonText = "Back",
  final String buttonText;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.all(Radius.circular(5.r)),
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.all(Radius.circular(5.r)),
        onTap: () {
          Navigator.pop(context);
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SvgPicture.asset(
                Assets.backArrowSvg,
                fit: BoxFit.fill,
                colorFilter: const ColorFilter.mode(
                  ColorCodes.whiteColor,
                  BlendMode.srcIn,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
