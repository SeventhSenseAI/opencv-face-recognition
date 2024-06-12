import 'package:faceapp/core/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/app_paddings.dart';
import '../constants/color_codes.dart';
import 'gap_widgets/horizontal_gap_consistent.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// A custom elevated button widget that provides a customizable button with
/// an optional loading state indicator.
class CustomElevatedButtonWidget extends StatelessWidget {
  /// The text to display on the button.
  final String buttonText;

  /// A callback function to be called when the button is pressed.
  final void Function()? onPressed;

  /// Whether the button is in a submitting/loading state.
  final bool isSubmitting;

  final bool isActive;

  final bool isDeleteAction;

  /// Creates a [CustomElevatedButtonWidget].
  ///
  /// The [buttonText] is required and specifies the text to display on the button.
  /// The [onPressed] callback function is optional and is called when the button is pressed.
  /// The [isSubmitting] flag is optional and controls whether the button is in a submitting/loading state.
  const CustomElevatedButtonWidget({
    super.key,
    required this.buttonText,
    this.onPressed,
    this.isSubmitting = false,
    this.isActive = true,
    this.isDeleteAction = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: isSubmitting
            ? null
            : LinearGradient(
                begin: const Alignment(0.00, -1.00),
                end: const Alignment(0, 4),
                colors: isDeleteAction
                    ? [const Color(0xFFFE1212), const Color(0xFF570606)]
                    : [const Color(0xFF128EFE), const Color(0xFF063056)],
              ),
        color: isSubmitting ? const Color(0xFF212121) : null,
        borderRadius: BorderRadius.circular(5),
      ),
      width: double.infinity,
      height: 53.h,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          foregroundColor: ColorCodes.whiteColor,
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isSubmitting && isActive)
              SizedBox(
                width: 20.r,
                height: 20.r,
                child: const CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.black54),
                  backgroundColor: ColorCodes.whiteColor,
                ),
              ),
            if (isSubmitting && isActive)
              HorizontalGapWidget(AppPaddings.p12.w),
            Text(
              textScaleFactor: 1.0,
              isActive
                  ? isSubmitting
                      ? AppLocalizations.of(context)!.submitting
                      : buttonText
                  : buttonText,
              style: context.theme.textTheme.titleSmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
