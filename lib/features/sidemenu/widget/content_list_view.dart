import 'package:faceapp/core/constants/color_codes.dart';
import 'package:faceapp/core/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/constants/app_paddings.dart';
import '../../../core/services/shared_preferences_service.dart';
import '../../../core/widgets/common_snack_bar.dart';
import '../../../core/widgets/gap_widgets/horizontal_gap_consistent.dart';
import 'custom_switch.dart';

class ContetListView extends StatefulWidget {
  final String title;
  final String? leftIcon;
  final String? rightIcon;
  final bool isSwitchIcon;
  final double opacity;
  final Key keys;

  const ContetListView({
    super.key,
    required this.keys,
    required this.title,
    required this.isSwitchIcon,
    this.leftIcon,
    this.rightIcon,
    this.opacity = 1.0,
  });

  @override
  State<ContetListView> createState() => _ContetListViewState();
}

class _ContetListViewState extends State<ContetListView> {
  bool? switchValue;

  @override
  void initState() {
    _getLiveness();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: widget.opacity,
      child: Container(
        key: widget.keys,
        height: 60.h,
        decoration: const BoxDecoration(
          color: Colors.transparent,
        ),
        child: Container(
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: ColorCodes.greyColor)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (widget.leftIcon != null)
                Image.asset(
                  widget.leftIcon!,
                  width: 24.w,
                  height: 24.w,
                  fit: BoxFit.fill,
                ),
              HorizontalGapWidget(
                AppPaddings.p24.w,
              ),
              Expanded(
                child: Text(
                      textScaleFactor: 1.0,
                  widget.title,
                  style: context.theme.textTheme.titleMedium!,
                ),
              ),
              if (widget.isSwitchIcon)
                CustomSwitch(
                  value: switchValue ?? false,
                  enableColor: ColorCodes.switchEnableColor,
                  disableColor: ColorCodes.switchDisableColor,
                  width: 56.w,
                  height: 32.h,
                  switchWidth: 22.r,
                  switchHeight: 22.r,
                  onChanged: (value) async {
                    if (widget.opacity == 1.0) {
                      setState(() {
                        switchValue = value;
                      });
                    }
                    await _updateLiveness(value);
                  },
                ),
              if (widget.rightIcon != null)
                Image.asset(
                  widget.rightIcon!,
                  width: 10.w,
                  height: 20.h,
                  fit: BoxFit.fill,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _updateLiveness(bool value) async {
    if (widget.opacity == 1.0) {
      await SharedPreferencesService.setLiveness(value);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        AppSnackBar.showErrorSnackBar(
          context,
          "Your current plan does not support the liveness feature.",
        ),
      );
    }
  }

  Future<void> _getLiveness() async {
    final val = await SharedPreferencesService.getLiveness();
    if (widget.opacity == 1.0) {
      setState(() {
        switchValue = val;
      });
    }
  }
}
