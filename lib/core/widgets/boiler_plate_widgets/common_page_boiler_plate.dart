import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constants/app_paddings.dart';
import '../../constants/color_codes.dart';
import 'common_app_bar.dart';
import 'common_back_button.dart';
import 'page_background.dart';

class CommonPageBoilerPlate extends StatelessWidget {
  /// The [CommonPageBoilerPlate] widget is used to create
  /// a common layout for pages
  /// in the application. It includes a background widget,
  /// a safe area, a transparent
  /// scaffold, and a preferred-sized app bar. The widget
  /// allows customization of the
  /// page body and the app bar widget to provide flexibility
  /// in page design.
  const CommonPageBoilerPlate({
    super.key,
    this.pageBody,
    this.commonAppBar,
    this.horizontalPadding = AppPaddings.p16,
    this.appBarPreferredSize = 44,
    this.isNeedToApplySafeArea = true,
  });

  /// Optional widget to be displayed as page body.
  final Widget? pageBody;

  /// Optional widget to be displayed as app bar.
  final Widget? commonAppBar;

  /// horizontalPadding = 16,
  final double horizontalPadding;

  /// appBarPreferredSize = 44,
  final double appBarPreferredSize;

  /// isNeedToApplySafeArea = true,
  final bool isNeedToApplySafeArea;

  @override
  Widget build(BuildContext context) {
    return PageBackground(
      body: KeyboardDismissOnTap(
        child: SafeArea(
          bottom: isNeedToApplySafeArea,
          left: isNeedToApplySafeArea,
          right: isNeedToApplySafeArea,
          top: isNeedToApplySafeArea,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: (commonAppBar != null)
                ? PreferredSize(
                    preferredSize: Size.fromHeight(appBarPreferredSize.h),
                    child: commonAppBar!,
                  )
                : null,
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding.w),
              child: pageBody,
            ),
          ),
        ),
      ),
    );
  }
}

/// The [SamplePage] widget represents a page for comparing photos.
/// It demonstrates the usage of the [CommonPageBoilerPlate], [CommonAppBar], and [CommonBackButtonWidget] widgets.
class SamplePage extends StatelessWidget {
  const SamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return CommonPageBoilerPlate(
      commonAppBar: CommonAppBar(
        /// The widget to be displayed at the leading position of the app bar.
        leadingWidget: const CommonBackButtonWidget(
          buttonText: "Back",
        ),

        /// The widget to be displayed as an action in the app bar.
        actionWidget: const Icon(Icons.settings),

        /// The widget to be displayed as the title of the app bar.
        titleWidget: Text(
           textScaleFactor: 1.0,
          "Sample page title",
          maxLines: 1,
          style: TextStyle(
            color: ColorCodes.whiteColor,
            fontSize: 17.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      pageBody: const Center(
        child: Text("Page body", textScaleFactor: 1.0,),
      ),
    );
  }
}
