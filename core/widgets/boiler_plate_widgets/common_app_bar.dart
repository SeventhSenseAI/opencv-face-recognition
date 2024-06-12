import 'package:faceapp/core/constants/app_paddings.dart';
import 'package:faceapp/core/constants/color_codes.dart';
import 'package:faceapp/core/widgets/gap_widgets/horizontal_gap_consistent.dart';
import 'package:faceapp/features/dashboard/presentation/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../utils/assets.dart';
import '../../utils/extensions.dart';

class CommonAppBar extends StatelessWidget {
  /// The [CommonAppBar] widget provides a customizable app bar for common pages.
  /// It allows customization of various aspects such as the leading widget,
  /// action widget, title widget, centering of the title, and toolbar height.
  /// The app bar is designed to have a transparent background and zero elevation.
  const CommonAppBar({
    super.key,
    this.leadingWidget,
    this.actionWidget,
    this.isCenterTitle = true,
    this.toolbarHeight = 54,
    this.leadingWidth = 100,
    this.titleWidget,
    this.isHomeRedirectEnable = true,
  });

  /// Optional widget to be displayed as the leading position of the app bar.
  final Widget? leadingWidget;

  /// Optional widget to be displayed as an action in the app bar.
  final Widget? actionWidget;

  /// isCenterTitle = true,
  final bool isCenterTitle;

  /// toolbarHeight = 44,
  final double toolbarHeight;

  /// leadingWidth = 100,
  final double leadingWidth;

  /// Optional widget to be displayed as the title of the app bar.
  final Widget? titleWidget;

  final bool isHomeRedirectEnable;

  @override
  Widget build(BuildContext context) {
    return Container(
          decoration: const BoxDecoration(
      border: Border(
        bottom: BorderSide(
          color: ColorCodes.greyColor,
          width: 1.0,
        ),
      ),
    ),
      child: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0.0,
        centerTitle: isCenterTitle,
        toolbarHeight: toolbarHeight.h,
        leadingWidth: leadingWidth.w,
        automaticallyImplyLeading: false,
        leading: (leadingWidget != null) ? leadingWidget : null,
        title: titleWidget,
        titleTextStyle: context.theme.textTheme.titleMedium!.copyWith(
          fontSize: 17.sp,
          fontWeight: FontWeight.w600,
          color: ColorCodes.whiteColor,
        ),
        actions: [
          if (actionWidget != null) actionWidget!,
          if (isHomeRedirectEnable)
            Row(
              children: [
                HorizontalGapWidget(AppPaddings.p16.w),
                Material(
                  borderRadius: BorderRadius.all(Radius.circular(5.r)),
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.all(Radius.circular(5.r)),
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
                    child: Padding(
                      padding: EdgeInsets.all(8.w),
                      child: Image.asset(
                        Assets.topCameraIcon,
                        height: 22.r,
                        width: 22.r,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          HorizontalGapWidget(AppPaddings.p8.w),
        ],
      ),
    );
  }
}
