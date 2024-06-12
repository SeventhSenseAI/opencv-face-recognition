import 'package:faceapp/core/constants/app_paddings.dart';
import 'package:faceapp/core/constants/color_codes.dart';
import 'package:faceapp/core/utils/assets.dart';
import 'package:faceapp/core/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomDropDownField extends StatelessWidget {
  final List<String> dropdownItems;
  final String? selectedItem;
  final void Function(String?)? onChanged;
  final String? Function(String?)? validator;
  const CustomDropDownField({
    super.key,
    required this.dropdownItems,
    required this.selectedItem,
    this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: const TextScaler.linear(1.0)),
      child: DropdownButtonFormField(
        value: selectedItem,
        icon: SvgPicture.asset(
          Assets.downArrow,
        ),
        dropdownColor: ColorCodes.secondaryColor,
        items: dropdownItems.map((String item) {
          return DropdownMenuItem(
            value: item,
            child: Text(
              textScaleFactor: 1.0,
              item,
              style: context.theme.textTheme.titleMedium!
                  .copyWith(fontWeight: FontWeight.w300),
            ),
          );
        }).toList(),
        onChanged: onChanged,
        decoration: InputDecoration(
          filled: true,
          fillColor: ColorCodes.backgroundColor,
          hintText: 'Cloud Data Storage Region',
          prefixIcon: Padding(
            padding: const EdgeInsets.only(
              left: AppPaddings.p16,
              right: AppPaddings.p12,
            ),
            child: SvgPicture.asset(
              Assets.cloudStorageIcon,
            ),
          ),
          prefixIconConstraints: BoxConstraints(
            minHeight: 20.sp,
            minWidth: 20.sp,
            maxWidth: 170.sp,
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: ColorCodes.greyColor,
              width: 1,
            ),
          ),
          border: const OutlineInputBorder(
            borderSide: BorderSide(
              color: ColorCodes.greyColor,
              width: 1,
            ),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: ColorCodes.greyColor,
              width: 1,
            ),
          ),
          hintStyle: context.theme.textTheme.titleMedium!.copyWith(
            fontWeight: FontWeight.w300,
            color: ColorCodes.whiteColor.withOpacity(.2),
          ),
          errorStyle: context.theme.textTheme.titleSmall!.copyWith(
            fontWeight: FontWeight.w300,
            color: ColorCodes.redColor,
          ),
        ),
        validator: validator,
      ),
    );
  }
}
