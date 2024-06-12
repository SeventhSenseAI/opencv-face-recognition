import 'dart:convert';

import 'package:faceapp/core/constants/color_codes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_paddings.dart';
import '../../../../core/utils/assets.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/widgets/gap_widgets/vertical_gap_consistent.dart';
import 'bottom_sheet_bottom_part/bottom_sheet_bottom_part_widget.dart';
import 'bottom_sheet_top_part/bottom_sheet_top_part_primary_title_widget.dart';

class FaceIdentifiedWidget extends StatelessWidget {
  const FaceIdentifiedWidget({
    super.key,
    required this.isSpoofingDetect,
    required this.isSpoofingEnabled,
    required this.personName,
    required this.score,
  });

  final bool isSpoofingDetect;
  final bool isSpoofingEnabled;
  final String personName;
  final double score;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          VerticalGapWidget(AppPaddings.p12.h),
          Column(
            children: [ 
              if (isSpoofingEnabled)
                BottomSheetTopPartPrimaryTitleWidget(
                  iconColor: isSpoofingDetect ? Colors.red : Colors.green,
                  svgIcon: isSpoofingDetect
                      ? Assets.shieldWarningBold
                      : Assets.greenCircle,
                  text: isSpoofingDetect
                      ? "Spoofing Detected!"
                      : "Live! No Spoofing",
                ),
              VerticalGapWidget(AppPaddings.p12.h),
              Text(
                 textScaleFactor: 1.0,
                personName,
                style: context.theme.textTheme.headlineLarge!.copyWith(
                  fontWeight: FontWeight.w500,
                  fontSize: 30.sp,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              VerticalGapWidget(AppPaddings.p12.h),
              Text(
                 textScaleFactor: 1.0,
                'Face Identified - ${(score * 100).toStringAsFixed(2)}%',
                style: context.theme.textTheme.headlineSmall!.copyWith(
                  color: ColorCodes.whiteColor,
                  fontSize: 22.sp,
                ),
              ),
            ],
          ),
          VerticalGapWidget(AppPaddings.p12.h),
          const Divider(
            height: 1,
            color: ColorCodes.greyColor,
          ),
          VerticalGapWidget(AppPaddings.p12.h),
          const BottomSheetBottomPartWidget(
            isSaveBtnActive: true,
            isProfileIconActive: true,
          ),
        ],
      ),
    );
  }
}
