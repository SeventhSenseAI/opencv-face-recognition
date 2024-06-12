import 'dart:async';

import 'package:faceapp/core/constants/app_paddings.dart';
import 'package:faceapp/core/constants/color_codes.dart';
import 'package:faceapp/core/utils/assets.dart';
import 'package:faceapp/core/utils/extensions.dart';
import 'package:faceapp/core/widgets/boiler_plate_widgets/common_app_bar.dart';
import 'package:faceapp/core/widgets/gap_widgets/vertical_gap_consistent.dart';
import 'package:faceapp/features/authentication/presentation/widgets/app_bar_back_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/widgets/boiler_plate_widgets/common_page_boiler_plate.dart';

class ThankingPageView extends StatefulWidget {
  const ThankingPageView({super.key});

  @override
  State<ThankingPageView> createState() => _ThankingPageViewState();
}

class _ThankingPageViewState extends State<ThankingPageView> {
//In some cases, when the widget is disposed before the timer completes, the callback may not be executed.
  @override
  void initState() {
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
            height: 110.h,
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
            'Thanks for your',
            style: context.theme.textTheme.headlineLarge,
          ),
          Text(
             textScaleFactor: 1.0,
            'registration!',
            style: context.theme.textTheme.headlineLarge,
          ),
          VerticalGapWidget(AppPaddings.p36.h),
          Text(
             textScaleFactor: 1.0,
            'Due to high demand, you have been added to our waitlist. Please wait for our account activation email to get started.\n\nIf you urgently need to activate your account, please contact us at:',
            style: context.theme.textTheme.titleMedium!
                .copyWith(fontWeight: FontWeight.w300),
            textAlign: TextAlign.center,
          ),
          VerticalGapWidget(AppPaddings.p24.h),
          InkWell(
            onTap: () => _launchEmail(
              'fr@opencv.org',
            ),
            child: Text(
               textScaleFactor: 1.0,
              'fr@opencv.org',
              style: context.theme.textTheme.titleMedium!.copyWith(
                fontWeight: FontWeight.w300,
                color: ColorCodes.primaryColor,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: CommonPageBoilerPlate(
        pageBody: body,
        commonAppBar: CommonAppBar(
          leadingWidget: AppBarBackButton(
            backButtonOnTap: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
          ),
          isHomeRedirectEnable: false,
        ),
      ),
    );
  }
  
_launchEmail(String email) async {
  final Uri emailLaunchUri = Uri(
    scheme: 'mailto',
    path: email,
  );

  if (await canLaunch(emailLaunchUri.toString())) {
    await launch(emailLaunchUri.toString());
  } else {
    throw 'Could not launch email';
  }
}

}
