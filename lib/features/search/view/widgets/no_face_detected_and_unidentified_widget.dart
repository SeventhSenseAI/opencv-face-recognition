import 'package:faceapp/core/constants/color_codes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_paddings.dart';
import '../../../../core/widgets/gap_widgets/vertical_gap_consistent.dart';
import 'bottom_sheet_bottom_part/bottom_sheet_bottom_part_widget.dart';
import 'bottom_sheet_top_part/bottom_sheet_top_part_primary_title_widget.dart';

class NoFaceDetectedAndUnidentifiedWidget extends StatelessWidget {
  const NoFaceDetectedAndUnidentifiedWidget({
    super.key,
    required this.text,
    required this.svgIcon,
    this.isSaveBtnActive = true,
    this.keys,
  });

  final String text;
  final String svgIcon;
  final bool isSaveBtnActive;
  final Key? keys;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          VerticalGapWidget(AppPaddings.p16.h),
          BottomSheetTopPartPrimaryTitleWidget(
            svgIcon: svgIcon,
            text: text,
          ),
          VerticalGapWidget(AppPaddings.p16.h),
          const Divider(
            height: 1,
            color: ColorCodes.greyColor,
          ),
          VerticalGapWidget(AppPaddings.p16.h),
          BottomSheetBottomPartWidget(
            keys: keys,
            isSaveBtnActive: isSaveBtnActive,
          ),
        ],
      ),
    );
  }
}
