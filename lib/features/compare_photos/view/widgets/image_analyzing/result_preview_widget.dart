import 'package:faceapp/core/constants/color_codes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../core/constants/app_paddings.dart';
import '../../../../../core/utils/assets.dart';
import '../../../../../core/utils/extensions.dart';
import '../../../../../core/widgets/gap_widgets/vertical_gap_consistent.dart';
import '../../../../dashboard/presentation/home_screen.dart';

class ResultPreviewWidget extends StatelessWidget {
  const ResultPreviewWidget({
    super.key,
    required this.isMatching,
    required this.percentage,
  });

  final bool isMatching;
  final double percentage;

  @override
  Widget build(BuildContext context) {
    int score = (percentage * 100).toInt();
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const SizedBox.shrink(),
        Column(
          children: [
            SizedBox(
              height: 48.r,
              width: 48.r,
              child: SvgPicture.asset(
                isMatching
                    ? Assets.solarCheckCircleColdSvg
                    : Assets.solarShieldWarningBoldSvg,
              ),
            ),
            VerticalGapWidget(AppPaddings.p32.h),
            Text(
               textScaleFactor: 1.0,
              isMatching ? 'Faces match!' : 'Faces doesn’t match!',
              textAlign: TextAlign.center,
              style: context.theme.textTheme.headlineLarge,
            ),
            VerticalGapWidget(AppPaddings.p8.h),
            Text(
               textScaleFactor: 1.0,
              'Score ${score.toStringAsFixed(2)}%',
              textAlign: TextAlign.center,
              style: context.theme.textTheme.headlineSmall!.copyWith(
                color:
                    isMatching ? ColorCodes.acceptColour : ColorCodes.redColor,
              ),
            ),
          ],
        ),
        Column(
          children: [
            Divider(
              color: Colors.grey.shade800,
            ),
            VerticalGapWidget(AppPaddings.p16.h),
            Material(
              borderRadius: BorderRadius.all(Radius.circular(5.r)),
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.all(Radius.circular(5.r)),
                splashColor: ColorCodes.whiteColor.withOpacity(0.1),
                highlightColor: Colors.transparent,
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) {
                        return const HomeScreen();
                      },
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        return SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(-1.0, 0.0),
                            end: Offset.zero,
                          ).animate(animation),
                          child: child,
                        );
                      },
                    ),
                    (route) => false,
                  );
                },
                child: SizedBox.square(
                  dimension: AppPaddings.p64.r,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: AppPaddings.p28.r,
                        width: AppPaddings.p28.r,
                        child: 
                        Image.asset(
                          Assets.topCameraIcon,
                        ),
                      ),
                      VerticalGapWidget(AppPaddings.p12.h),
                      Text(
                         textScaleFactor: 1.0,
                        'Home',
                        textAlign: TextAlign.center,
                        style: context.theme.textTheme.labelSmall!.copyWith(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            VerticalGapWidget(AppPaddings.p16.h),
          ],
        ),
      ],
    );
  }
}
