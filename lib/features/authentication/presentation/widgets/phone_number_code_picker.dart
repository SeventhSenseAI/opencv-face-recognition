// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'package:faceapp/core/constants/color_codes.dart';
import 'package:faceapp/core/utils/extensions.dart';

import '../../../../core/constants/app_paddings.dart';
import '../../../../core/utils/assets.dart';

class PhoneNumberCodePicker extends StatelessWidget {
  const PhoneNumberCodePicker({
    super.key,
    required this.textEditingController,
    required this.initSelection,
    required this.onCountryCodeChanged,
  });

  final TextEditingController textEditingController;
  final String initSelection;
  final void Function(CountryCode)? onCountryCodeChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: AppPaddings.p16,
            right: AppPaddings.p12,
          ),
          child: SvgPicture.asset(
            Assets.phoneIcon,
          ),
        ),
        MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.0)),
          child: CountryCodePicker(
            barrierColor: Colors.transparent,
            dialogBackgroundColor: ColorCodes.secondaryColor,
            searchStyle: context.theme.textTheme.titleSmall!.copyWith(
              fontWeight: FontWeight.w300,
            ),
            dialogTextStyle: context.theme.textTheme.titleSmall!.copyWith(
              fontWeight: FontWeight.w300,
            ),
            textStyle: context.theme.textTheme.titleSmall!.copyWith(
              fontWeight: FontWeight.w300,
            ),
            searchDecoration: InputDecoration(
              hintText: 'Search',
              prefixIconColor: ColorCodes.whiteColor,
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: ColorCodes.whiteColor,
                  width: 1,
                ),
              ),
              border: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: ColorCodes.whiteColor,
                  width: 1,
                ),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: ColorCodes.whiteColor,
                  width: 1,
                ),
              ),
              hintStyle: context.theme.textTheme.titleMedium!.copyWith(
                fontWeight: FontWeight.w300,
                color: ColorCodes.whiteColor.withOpacity(.2),
              ),
            ),
            onChanged: (CountryCode value) {
              if (value.dialCode != null) {
                textEditingController.text = value.dialCode!;
                onCountryCodeChanged?.call(value);
              }
            },
            initialSelection: initSelection,
            showFlag: false,
            flagWidth: 30.w,
            builder: (CountryCode? selectedItem) {
              if (selectedItem == null) {
                return const SizedBox();
              } else {
                return SizedBox(
                  width: 115,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        child: Image.asset(
                          selectedItem.flagUri!,
                          package: 'country_code_picker',
                          width: 20.w,
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        selectedItem.dialCode ?? '',
                        style: context.theme.textTheme.titleMedium!
                            .copyWith(fontWeight: FontWeight.w300),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: AppPaddings.p4,
                          right: AppPaddings.p12,
                        ),
                        child: SvgPicture.asset(
                          Assets.downArrow,
                        ),
                      ),
                    ],
                  ),
                );
              }
            },
          ),
        ),
        Container(
          width: 1,
          height: 24.h,
          color: ColorCodes.greyColor,
        ),
        SizedBox(
          width: 12.w,
        ),
      ],
    );
  }
}
