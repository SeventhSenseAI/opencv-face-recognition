// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:faceapp/core/constants/color_codes.dart';
import 'package:faceapp/core/utils/extensions.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final bool? obscureText;
  final double? maxWidth;
  final TextInputType? keyboardType;
  final int? maxLength;
  final bool isCapitalize;

  const CustomTextFormField({
    super.key,
    required this.controller,
    required this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.onChanged,
    this.obscureText,
    this.maxWidth,
    this.keyboardType,
    this.maxLength,
    required this.isCapitalize,
  });

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.0)),
      child: TextFormField(
        textCapitalization:
            isCapitalize ? TextCapitalization.sentences : TextCapitalization.none,
        style: context.theme.textTheme.titleMedium!
            .copyWith(fontWeight: FontWeight.w300),
        controller: controller,
        keyboardType: keyboardType,
        maxLength: maxLength,
        decoration: InputDecoration(
          constraints: BoxConstraints(minHeight: 56.h),
          filled: true,
          fillColor: ColorCodes.backgroundColor,
          prefixIcon: prefixIcon,
          prefixIconConstraints: BoxConstraints(
            minHeight: 20.sp,
            minWidth: 20.sp,
            maxWidth: maxWidth ?? double.infinity,
          ),
          suffixIcon: suffixIcon,
          suffixIconConstraints: BoxConstraints(
            minHeight: 20.sp,
            minWidth: 20.sp,
          ),
          hintText: hintText,
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: ColorCodes.greyColor,
              width: 1,
            ),
          ),
          border: const OutlineInputBorder(
            borderSide: BorderSide(
              color: ColorCodes.greyColor,
              width: 1,
            ),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: ColorCodes.greyColor,
              width: 1,
            ),
          ),
          errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: ColorCodes.redColor,
              width: 1,
            ),
          ),
          errorStyle: context.theme.textTheme.titleSmall!.copyWith(
            fontWeight: FontWeight.w300,
            color: ColorCodes.redColor,
          ),
          hintStyle: context.theme.textTheme.titleMedium!.copyWith(
            fontWeight: FontWeight.w300,
            color: ColorCodes.whiteColor.withOpacity(.2),
          ),
        ),
        validator: validator,
        onChanged: onChanged,
        obscureText: obscureText ?? false,
      ),
    );
  }
}