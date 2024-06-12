import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../core/constants/app_paddings.dart';
import '../../../../../core/constants/color_codes.dart';
import '../../../../../core/utils/assets.dart';
import '../../../../../core/utils/extensions.dart';
import '../../../../../core/widgets/gap_widgets/vertical_gap_consistent.dart';

class PhotoAddWidget extends StatelessWidget {
  const PhotoAddWidget({
    super.key,
    required this.onTap,
    required this.imageFile,
  });

  final VoidCallback? onTap;
  final File? imageFile;

  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      color: ColorCodes.whiteColor.withOpacity(0.2),
      strokeWidth: 1,
      dashPattern: const [4],
      borderType: BorderType.RRect,
      radius: Radius.circular(5.r),
      child: Material(
        borderRadius: BorderRadius.all(Radius.circular(5.r)),
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.all(Radius.circular(5.r)),
          splashColor: ColorCodes.whiteColor.withOpacity(0.1),
          highlightColor: Colors.transparent,
          onTap: onTap,
          child: Container(
            decoration: ShapeDecoration(
              color: const Color(0x66212121),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              shadows: const [
                BoxShadow(
                  color: Color(0x0C000000),
                  blurRadius: 100,
                  offset: Offset(0, 0),
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Center(
              child: imageFile == null
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          Assets.solarGallerySendBoldSvg,
                          fit: BoxFit.fill,
                          colorFilter: const ColorFilter.mode(
                            ColorCodes.whiteColor,
                            BlendMode.srcIn,
                          ),
                          width: AppPaddings.p36.w,
                          height: AppPaddings.p36.h,
                        ),
                        VerticalGapWidget(AppPaddings.p24.h),
                        Text(
                          textScaleFactor: 1.0,
                          'Touch here to add a photo',
                          style: context.theme.textTheme.headlineSmall,
                        ),
                      ],
                    )
                  : Image.file(
                      imageFile!,
                      fit: BoxFit.fill,
                    ),
            ),
          ),
        ),
      ),
    );
  }
}