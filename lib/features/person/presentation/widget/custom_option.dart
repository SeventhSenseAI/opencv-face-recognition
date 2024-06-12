import 'dart:convert';

import 'package:faceapp/core/constants/app_paddings.dart';
import 'package:faceapp/core/constants/color_codes.dart';
import 'package:faceapp/core/utils/extensions.dart';
import 'package:faceapp/core/widgets/gap_widgets/horizontal_gap_consistent.dart';
import 'package:faceapp/features/category/bloc/category_bloc.dart';
import 'package:faceapp/features/search/data/model/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../category/bloc/category_event.dart';

class CustomOption extends StatefulWidget {
  final String personID;
  final String name;
  final String collectionId;
  final bool isSelected;
  const CustomOption({
    super.key,
    required this.personID,
    required this.name,
    required this.collectionId,
    required this.isSelected,
  });

  @override
  State<CustomOption> createState() => _CustomOptionState();
}

class _CustomOptionState extends State<CustomOption> {
  @override
  Widget build(BuildContext context) {
    bool selectedValue = widget.isSelected;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => {
        setState(() {
          selectedValue = !selectedValue;
        }),
        if (selectedValue == true)
          {
            context.read<CategoryBloc>().add(
                  UpdateSelectedCollectionsPopup(
                    selectedCollections: [
                      ...context.read<CategoryBloc>().state.selectCollections,
                      Collection(id: widget.collectionId, name: widget.name),
                    ],
                  ),
                ),
          }
        else
          {
            context.read<CategoryBloc>().add(
                  UpdateSelectedCollectionsPopup(
                    selectedCollections: [
                      ...context
                          .read<CategoryBloc>()
                          .state
                          .selectCollections
                          .where(
                            (collection) =>
                                collection.id != widget.collectionId,
                          ),
                    ],
                  ),
                ),
          },
        context.read<CategoryBloc>().add(
              SetIsOpenDropdownEvent(
                isOpen: false,
              ),
            ),
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: AppPaddings.p12,
          horizontal: AppPaddings.p8,
        ),
        color: selectedValue
            ? ColorCodes.acceptColour.withOpacity(0.1)
            : Colors.transparent,
        child: Row(
          children: [
            Text(
               textScaleFactor: 1.0,
              widget.name,
              style: context.theme.textTheme.bodySmall!.copyWith(
                fontSize: AppPaddings.p16.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
            const Spacer(),
            selectedValue
                ? const Icon(
                    Icons.check_sharp,
                    color: ColorCodes.acceptColour,
                  )
                : const SizedBox.shrink(),
            HorizontalGapWidget(
              AppPaddings.p16.w,
            ),
          ],
        ),
      ),
    );
  }
}
