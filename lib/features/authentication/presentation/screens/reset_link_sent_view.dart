import 'dart:async';

import 'package:faceapp/core/constants/app_paddings.dart';
import 'package:faceapp/core/utils/assets.dart';
import 'package:faceapp/core/utils/extensions.dart';
import 'package:faceapp/core/widgets/gap_widgets/vertical_gap_consistent.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/widgets/boiler_plate_widgets/common_page_boiler_plate.dart';

class ResetLinkSentView extends StatefulWidget {
  const ResetLinkSentView({super.key});

  @override
  State<ResetLinkSentView> createState() => _ResetLinkSentViewState();
}

class _ResetLinkSentViewState extends State<ResetLinkSentView> {
  @override
  void initState() {
    final timer = Timer(
      const Duration(seconds: 3),
      () {
        Navigator.of(context).popUntil((route) => route.isFirst);
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget body = SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          SizedBox(
            height: 48.h,
            width: 51.28.w,
            child: SvgPicture.asset(
              Assets.logo,
            ),
          ),
          SizedBox(
            height: 206.h,
          ),
          SizedBox(
            width: 48.w,
            height: 48.h,
            child: SvgPicture.asset(
              Assets.checkCircle,
            ),
          ),
          VerticalGapWidget(
            AppPaddings.p24.h,
          ),
          Text(
             textScaleFactor: 1.0,
            'Reset Link Send',
            style: context.theme.textTheme.headlineLarge!,
          ),
          VerticalGapWidget(AppPaddings.p36.h),
          Text(
             textScaleFactor: 1.0,
            'Please check your inbox and follow the link to create a new password.',
            style: context.theme.textTheme.titleMedium!
                .copyWith(fontWeight: FontWeight.w300),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: CommonPageBoilerPlate(
        pageBody: body,
      ),
    );
  }
}
