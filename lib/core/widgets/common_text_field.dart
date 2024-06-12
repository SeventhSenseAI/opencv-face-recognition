import 'package:faceapp/core/constants/app_paddings.dart';
import 'package:faceapp/core/constants/color_codes.dart';
import 'package:faceapp/core/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CommonTextField extends StatelessWidget {
  final TextEditingController controller;
  final String fieldName;
  final int lines;
  final TextCapitalization textCapitalization;
  final bool autofocus;
  const CommonTextField({
    super.key,
    required this.controller,
    required this.fieldName,
    required this.lines,
    this.textCapitalization = TextCapitalization.sentences,
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
           textScaleFactor: 1.0,
          fieldName,
          style: context.theme.textTheme.titleSmall!.copyWith(
            fontWeight: FontWeight.w400,
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppPaddings.p16.w,
          ),
          margin: EdgeInsets.only(
            top: AppPaddings.p4.h,
            bottom: AppPaddings.p16.h,
          ),
          decoration: BoxDecoration(
            color: ColorCodes.greyColor.withOpacity(0.4),
            borderRadius: BorderRadius.circular(5.r),
            boxShadow: [
              BoxShadow(
                color: ColorCodes.blackColor.withOpacity(0.01),
                spreadRadius: 0,
                blurRadius: 100,
                offset: const Offset(
                  0,
                  0,
                ),
              ),
            ],
            border: Border.all(
              color: ColorCodes.greyColor,
            ),
          ),
          child: MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.0)),
          child: TextField(
            controller: controller,
            maxLines: lines,
            minLines: lines,
            textInputAction: TextInputAction.next,
            autofocus: autofocus,
            style: context.theme.textTheme.titleMedium!.copyWith(
              fontWeight: FontWeight.w300,
            ),
            textCapitalization: textCapitalization,
            decoration: InputDecoration(
              hintText: 'Enter text',
              hintStyle: context.theme.textTheme.titleMedium!.copyWith(
                fontWeight: FontWeight.w300,
                color: ColorCodes.greyColor,
              ),
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
            ),
          ),
        ),
      ),
    ],
  );
}
}