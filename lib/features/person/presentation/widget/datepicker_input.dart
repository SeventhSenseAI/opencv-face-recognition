import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_paddings.dart';
import '../../../../core/constants/color_codes.dart';
import '../../../../core/utils/extensions.dart';

class DatePickerInput extends StatelessWidget {
  final TextEditingController dobController;
  const DatePickerInput({super.key, required this.dobController});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          textScaleFactor: 1.0,
          AppLocalizations.of(context)!.birthday,
          style: context.theme.textTheme.titleSmall!.copyWith(
            fontWeight: FontWeight.w400,
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: AppPaddings.p16.w),
          margin: EdgeInsets.only(top: AppPaddings.p4.h),
          height: 56.h,
          decoration: BoxDecoration(
            color: ColorCodes.greyColor.withOpacity(0.4),
            borderRadius: BorderRadius.circular(5.r),
            border: Border.all(
              color: ColorCodes.greyColor,
            ),
          ),
          child: MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: const TextScaler.linear(1.0)),
            child: TextField(
              controller: dobController,
              style: context.theme.textTheme.titleMedium!.copyWith(
                fontWeight: FontWeight.w300,
              ),
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.birthday,
                hintStyle: context.theme.textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.w300,
                  color: ColorCodes.greyColor,
                ),
                suffixIcon: const Icon(Icons.calendar_month),
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
              readOnly: true,
              onTap: () async {
                DateTime? date = await showDatePicker(
                  initialEntryMode: DatePickerEntryMode.calendarOnly,
                  context: context,
                  initialDate: dobController.text.isNotEmpty
                      ? DateFormat('yyyy-MM-dd').parse(dobController.text)
                      : DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                  builder: (BuildContext context, Widget? child) {
                    bool isDark = MediaQuery.of(context).platformBrightness ==
                        Brightness.dark;
                    return Theme(
                      data: isDark
                          ? Theme.of(context).copyWith(
                              colorScheme: const ColorScheme.dark(
                                primary: ColorCodes.darkBlueColor,
                                onPrimary: ColorCodes.whiteColor,
                                surface: ColorCodes.greyColor,
                              ),
                              textButtonTheme: TextButtonThemeData(
                                style: TextButton.styleFrom(
                                  foregroundColor: ColorCodes
                                      .whiteColor, // ok , cancel    buttons
                                ),
                              ),
                            )
                          : Theme.of(context).copyWith(
                              colorScheme: const ColorScheme.dark(
                                primary: ColorCodes.darkBlueColor,
                                onPrimary: ColorCodes.whiteColor,
                                surface: ColorCodes.greyColor,
                              ),
                              textButtonTheme: TextButtonThemeData(
                                style: TextButton.styleFrom(
                                  foregroundColor: ColorCodes
                                      .whiteColor, // ok , cancel    buttons
                                ),
                              ),
                            ),
                      child: child!,
                    );
                  },
                );
                dobController.text =
                    DateFormat('yyyy-MM-dd').format(date ?? DateTime.now());
              },
            ),
          ),
        ),
      ],
    );
  }
}
