import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/app_paddings.dart';
import '../../../../../core/constants/color_codes.dart';

class MultipleFacesCardWidget extends StatelessWidget {
  const MultipleFacesCardWidget({
    super.key,
    required this.base64Image,
    required this.name,
    required this.onTap,
  });
  final String base64Image;
  final String name;

  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.only(right: AppPaddings.p16.w),
        child: Container(
          width: 124.w,
          height: 196.h,
          decoration: const ShapeDecoration(
            color: Color(0x66212121),
            shape: RoundedRectangleBorder(
              side: BorderSide(width: 1, color: Color(0x66212121)),
            ),
          ),
          child: Column(
            children: [
              Image.memory(
                base64.decode(base64Image),
                fit: BoxFit.fill,
                alignment: Alignment.center,
                width: 124.w,
                height: 124.h,
              ),
              Expanded(
                child: Center(
                  child: Text(
                    textScaleFactor: 1.0,
                    name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: ColorCodes.whiteColor,
                      fontSize: 16,
                      fontFamily: 'SF Pro',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}