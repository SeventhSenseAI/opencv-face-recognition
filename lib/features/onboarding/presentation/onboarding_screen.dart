import 'package:faceapp/core/constants/color_codes.dart';
import 'package:faceapp/core/utils/extensions.dart';
import 'package:faceapp/core/widgets/gap_widgets/horizontal_gap_consistent.dart';
import 'package:faceapp/core/widgets/gap_widgets/vertical_gap_consistent.dart';
import 'package:faceapp/features/authentication/presentation/screens/login_view.dart';
import 'package:faceapp/landing_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../core/constants/app_paddings.dart';
import '../../../core/utils/assets.dart';
import '../../../core/widgets/boiler_plate_widgets/common_page_boiler_plate.dart';
import '../../../core/widgets/common_elevated_button.dart';
import '../data/model/onboarding_contents.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late PageController _controller;
  bool isScale = false;
  double? textScaleFactor;
  @override
  void initState() {
    _controller = PageController();
    super.initState();
  }

  int _currentPage = 0;

  AnimatedContainer _buildDots({
    required int index,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(70),
        ),
        color: ColorCodes.onboardColor,
      ),
      margin: const EdgeInsets.only(right: 5),
      height: 10,
      curve: Curves.easeIn,
      width: _currentPage == index ? 20 : 10,
    );
  }

  @override
  Widget build(BuildContext context) {
    getFixedSize();
    return CommonPageBoilerPlate(
      pageBody: Stack(
        children: [
          Column(
            children: [
              VerticalGapWidget(20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  HorizontalGapWidget(
                    MediaQuery.of(context).size.width / 2 - 36.w,
                  ),
                  Image.asset(
                    Assets.appLogoNew,
                    fit: BoxFit.fill,
                    height: 50.w,
                    width: 50.w,
                  ),
                  HorizontalGapWidget(82.w),
                  if (_currentPage != contents.length - 1)
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LandingPage(),
                          ),
                        );
                      },
                      style: TextButton.styleFrom(
                        elevation: 0,
                      ),
                      child: Text(
                        textScaleFactor: textScaleFactor,
                        "Login",
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                              color: ColorCodes.onboardColor,
                            ),
                      ),
                    ),
                ],
              ),
              SizedBox(
                height: 550.h,
                child: PageView.builder(
                  physics: const BouncingScrollPhysics(),
                  controller: _controller,
                  onPageChanged: (value) =>
                      setState(() => _currentPage = value),
                  itemCount: contents.length,
                  itemBuilder: (context, i) {
                    return Column(
                      children: [
                        VerticalGapWidget(isScale ? 15.h : 40.h),
                        Image.asset(
                          contents[i].image,
                          height: isScale ? 285.h : 310.h,
                          fit: BoxFit.fill,
                        ),
                        VerticalGapWidget(isScale ? 20.h : 25.h),
                        Text(
                          textScaleFactor: 1.0,
                          contents[i].title,
                          textAlign: TextAlign.center,
                          style:
                              Theme.of(context).textTheme.titleSmall!.copyWith(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 21,
                                  ),
                        ),
                        VerticalGapWidget(10.h),
                        Text(
                          textScaleFactor: 1.0,
                          contents[i].desc,
                          style:
                              Theme.of(context).textTheme.titleSmall!.copyWith(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 15,
                                  ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    );
                  },
                ),
              ),
              VerticalGapWidget(isScale ? 18.h : 25.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  contents.length,
                  (int index) => _buildDots(index: index),
                ),
              ),
              VerticalGapWidget(isScale ? 35.h : 40.h),
              if (_currentPage + 1 == contents.length)
                buildStartButton(context),
              VerticalGapWidget(30.h),
            ],
          ),
        ],
      ),
    );
  }

  void getFixedSize() {
    MediaQueryData windowData =
        MediaQueryData.fromView(WidgetsBinding.instance.window);
    if (windowData.textScaleFactor < 1) {
      textScaleFactor = windowData.textScaleFactor;
    } else if (windowData.textScaleFactor > 1) {
      textScaleFactor = 1.0;
    } else {
      textScaleFactor = 1.0;
    }
    isScale = windowData.textScaleFactor != 1.0 ? true : false;
    print(windowData.textScaleFactor);
  }

  Widget buildStartButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ColorCodes.onboardButtonColor,
        borderRadius: BorderRadius.circular(10),
      ),
      width: 310.w,
      height: 43.h,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const LandingPage(),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          foregroundColor: ColorCodes.whiteColor,
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              textScaleFactor: 1.0,
              "Get Started",
              style: context.theme.textTheme.titleSmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
