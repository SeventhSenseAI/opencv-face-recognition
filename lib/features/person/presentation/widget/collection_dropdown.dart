import 'package:faceapp/core/constants/color_codes.dart';
import 'package:faceapp/core/utils/extensions.dart';
import 'package:faceapp/features/category/bloc/category_bloc.dart';
import 'package:faceapp/features/category/bloc/category_event.dart';
import 'package:faceapp/features/category/bloc/category_state.dart';
import 'package:faceapp/features/person/presentation/widget/collection_detail.dart';
import 'package:faceapp/features/person/presentation/widget/custom_option.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_paddings.dart';

class CollectionDropdown extends StatefulWidget {
  final String personID;
  const CollectionDropdown({super.key, required this.personID});

  @override
  State<CollectionDropdown> createState() => _CollectionDropdownState();
}

class _CollectionDropdownState extends State<CollectionDropdown> {
  TextEditingController collectionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
                   MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.0)),

        child: TextField(
          controller: collectionController,
          readOnly: true,
          decoration: InputDecoration(
            hintText: 'Select Collection',
            hintStyle: context.theme.textTheme.bodyMedium!,
            suffixIcon: const Icon(
              Icons.arrow_drop_down_outlined,
              color: ColorCodes.whiteColor,
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: AppPaddings.p16.w,
              vertical: AppPaddings.p8.h,
            ),
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(0),
              ),
              borderSide: BorderSide(
                color: ColorCodes.whiteColor,
              ),
            ),
          ),
          onTap: () => {
            context.read<CategoryBloc>().add(
                  SetIsOpenDropdownEvent(
                    isOpen: !context.read<CategoryBloc>().state.isDropdownOpen,
                  ),
                ),
          },
        ),
                   ),
        SizedBox(
          width: 400.w,
          height: 200.h,
          child: BlocBuilder<CategoryBloc, CategoryState>(
            builder: (context, state) {
              return state.isDropdownOpen
                  ? Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: ColorCodes.whiteColor, width: 0.5.r,),
                      ),
                      child: Scrollbar(
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          scrollDirection: Axis.vertical,
                          itemCount: state.categoryList.length,
                          itemBuilder: (BuildContext context, int index) {
                            final categoryName =
                                state.categoryList[index].name!.toLowerCase();
                            if (state.filterText.isNotEmpty &&
                                !categoryName.startsWith(state.filterText)) {
                              return const SizedBox.shrink();
                            }
                            return CustomOption(
                              personID: widget.personID,
                              name: state.categoryList[index].name!,
                              collectionId: state.categoryList[index].id!,
                              isSelected: state.selectCollections
                                  .where(
                                    (element) =>
                                        element.id ==
                                        state.categoryList[index].id,
                                  )
                                  .isNotEmpty,
                            );
                          },
                        ),
                      ),
                    )
                  : Wrap(
                      spacing: AppPaddings.p8,
                      children: [
                        ...state.selectCollections.map(
                          (e) => CollectionDetail(
                            collectionId: e.id!,
                            name: e.name!,
                          ),
                        ),
                      ],
                    );
            },
          ),
        ),
      ],
    );
  }
}
