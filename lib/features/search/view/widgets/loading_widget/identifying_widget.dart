import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/app_paddings.dart';
import '../../../../../core/utils/extensions.dart';
import '../../../../../core/widgets/gap_widgets/vertical_gap_consistent.dart';

class IdentifyingWidget extends StatelessWidget {
  const IdentifyingWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          VerticalGapWidget(AppPaddings.p16.h),
          Text(
             textScaleFactor: 1.0,
            AppLocalizations.of(context)!.identifying,
            style: context.theme.textTheme.titleMedium!.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          VerticalGapWidget(AppPaddings.p16.h),
        ],
      ),
    );
  }
}
