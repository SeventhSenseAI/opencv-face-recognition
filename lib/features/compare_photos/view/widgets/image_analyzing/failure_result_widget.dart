import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../core/constants/app_paddings.dart';
import '../../../../../core/constants/error_messages.dart';
import '../../../../../core/utils/assets.dart';
import '../../../../../core/utils/extensions.dart';
import '../../../../../core/widgets/common_elevated_button.dart';
import '../../../../../core/widgets/gap_widgets/vertical_gap_consistent.dart';
import '../../../bloc/compare_photos_bloc.dart';

class FailureResultWidget extends StatelessWidget {
  const FailureResultWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: AppPaddings.p24.h,
        horizontal: AppPaddings.p16.w,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox.shrink(),
          Column(
            children: [
              SizedBox(
                height: 48.r,
                width: 48.r,
                child: SvgPicture.asset(
                  Assets.solarShieldWarningBoldSvg,
                ),
              ),
              VerticalGapWidget(AppPaddings.p32.h),
              Text(
                 textScaleFactor: 1.0,
                ErrorMessage.somethingWentWrongError,
                textAlign: TextAlign.center,
                maxLines: 2,
                style: context.theme.textTheme.headlineLarge,
                overflow: TextOverflow.visible,
              ),
            ],
          ),
          CustomElevatedButtonWidget(
            buttonText: "Try again",
            onPressed: () {
              context.read<ComparePhotosBloc>().add(CompareImages());
            },
          ),
        ],
      ),
    );
  }
}
