import 'package:faceapp/core/constants/color_codes.dart';
import 'package:faceapp/core/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';

class OTPCodeWidget extends StatelessWidget {
  final void Function(String)? onCompleted;
  final void Function()? onTap;
  final bool isError;
  const OTPCodeWidget({
    super.key,
    this.onCompleted,
    this.onTap,
    this.isError = false,
  });

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 50.w,
      height: 50.h,
      textStyle: isError
          ? context.theme.textTheme.headlineSmall!.copyWith(
              color: ColorCodes.redColor,
            )
          : context.theme.textTheme.headlineSmall!,
      decoration: BoxDecoration(
        color: isError
            ? ColorCodes.redColor.withOpacity(.1)
            : ColorCodes.backgroundColor,
        borderRadius: BorderRadius.all(Radius.circular(5.r)),
        border: Border.all(
          color: isError
              ? ColorCodes.redColor.withOpacity(.35)
              : ColorCodes.greyColor,
          width: 1,
        ),
      ),
    );

    return Pinput(
      mainAxisAlignment: MainAxisAlignment.center,
      length: 6,
      keyboardType: TextInputType.number,
      defaultPinTheme: defaultPinTheme,
      onCompleted: onCompleted,
      onTap: onTap,
      inputFormatters: [
        FilteringTextInputFormatter.allow(
          RegExp(r'[0-9]'),
        ),
      ],
    );
  }
}
