import 'package:faceapp/core/utils/assets.dart';
import 'package:faceapp/core/utils/extensions.dart';
import 'package:faceapp/features/category/bloc/category_event.dart';
import 'package:faceapp/features/person/bloc/person_bloc.dart';
import 'package:faceapp/features/person/bloc/person_event.dart';
import 'package:faceapp/features/person/presentation/widget/collection_dropdown.dart';
import 'package:faceapp/features/person/presentation/widget/custom_chip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_paddings.dart';
import '../../../../core/constants/color_codes.dart';
import '../../../../core/widgets/common_elevated_button.dart';
import '../../../../core/widgets/common_snack_bar.dart';
import '../../../../core/widgets/gap_widgets/vertical_gap_consistent.dart';
import '../../../category/bloc/category_bloc.dart';
import '../../../category/bloc/category_state.dart';
import '../../bloc/person_state.dart';

class CollectionGrid extends StatelessWidget {
  final String personID;
  const CollectionGrid({super.key, required this.personID});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        return Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: AppPaddings.p8,
          children: [
            ...state.selectedCollections.map(
              (e) => CustomChip(id: e.id!, label: e.name!),
            ),
            GestureDetector(
              child: Image.asset(
                Assets.plusIcon,
                width: AppPaddings.p36.w,
                height: AppPaddings.p36.h,
              ),
              onTap: () {
                context.read<CategoryBloc>().add(
                      UpdateSelectedCollectionsPopup(
                        selectedCollections: context
                            .read<CategoryBloc>()
                            .state
                            .selectedCollections,
                      ),
                    );

                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    ThemeData theme = Theme.of(context);
                    return AlertDialog(
                      backgroundColor: ColorCodes.greyColor,
                      titleTextStyle: context.theme.textTheme.titleSmall!,
                      contentTextStyle: theme.textTheme.bodySmall!,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          AppPaddings.p12.r,
                        ),
                      ),
                      title: Row(
                        children: [
                          Text(
                            textScaleFactor: 1.0,
                            'Add Collections',
                            style: theme.textTheme.titleSmall!.copyWith(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            icon: const Icon(
                              Icons.close,
                              color: ColorCodes.whiteColor,
                            ),
                            onPressed: () {
                              context.read<CategoryBloc>().add(
                                    SetIsOpenDropdownEvent(
                                      isOpen: true,
                                    ),
                                  );
                              context.read<CategoryBloc>().add(
                                    UpdateFilterText(text: ''),
                                  );
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ),
                      content: SingleChildScrollView(
                        physics: const NeverScrollableScrollPhysics(),
                        child: CollectionDropdown(
                          personID: personID,
                        ),
                      ),
                      actions: [
                        BlocListener<PersonBloc, PersonState>(
                          listenWhen: (previous, current) =>
                              previous.updateStatus != current.updateStatus,
                          listener: (context, state) {
                            if (state.updateStatus ==
                                PersonUpdateStatus.error) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                AppSnackBar.showErrorSnackBar(
                                  context,
                                  context.read<PersonBloc>().state.errorMessage,
                                ),
                              );
                              context.read<PersonBloc>().add(ResetStateEvent());
                            }
                            if (state.updateStatus ==
                                PersonUpdateStatus.success) {
                              context.read<CategoryBloc>().add(
                                    UpdateSelectedCollections(
                                      selectedCollections: context
                                          .read<CategoryBloc>()
                                          .state
                                          .selectCollections,
                                    ),
                                  );
                              context.read<CategoryBloc>().add(
                                    SetIsColUpdatedEvent(
                                      isColUpdated: !context
                                          .read<CategoryBloc>()
                                          .state
                                          .isColUpdated,
                                    ),
                                  );
                              context.read<CategoryBloc>().add(
                                    UpdateFilterText(text: ''),
                                  );
                              context.read<CategoryBloc>().add(
                                    SetIsOpenDropdownEvent(
                                      isOpen: true,
                                    ),
                                  );
                              Navigator.of(context).pop();
                              context.read<PersonBloc>().add(ResetStateEvent());
                            }
                          },
                          child: BlocBuilder<CategoryBloc, CategoryState>(
                            buildWhen: (previous, current) =>
                                previous.isDropdownOpen !=
                                    current.isDropdownOpen ||
                                previous.updateStatus != current.updateStatus,
                            builder: (context, state) {
                              return !state.isDropdownOpen
                                  ? BlocBuilder<PersonBloc, PersonState>(
                                      builder: (context, state) {
                                        return CustomElevatedButtonWidget(
                                          isSubmitting: state.updateStatus ==
                                              PersonUpdateStatus.submitting,
                                          buttonText: 'Save',
                                          onPressed: () {
                                            context.read<PersonBloc>().add(
                                                  ManagePersonCategoryEvent(
                                                    personId: personID,
                                                    collections: context
                                                        .read<CategoryBloc>()
                                                        .state
                                                        .selectCollections,
                                                    collectionId: context
                                                            .read<
                                                                CategoryBloc>()
                                                            .state
                                                            .currentCategory
                                                            .id ??
                                                        '',
                                                  ),
                                                );
                                          },
                                        );
                                      },
                                    )
                                  : const SizedBox.shrink();
                            },
                          ),
                        ),
                        VerticalGapWidget(16.h),
                        BlocBuilder<CategoryBloc, CategoryState>(
                          buildWhen: (previous, current) =>
                              previous.isDropdownOpen != current.isDropdownOpen,
                          builder: (context, state) {
                            return !state.isDropdownOpen
                                ? CustomElevatedButtonWidget(
                                    isDeleteAction: true,
                                    buttonText: 'Cancel',
                                    onPressed: () {
                                      context.read<CategoryBloc>().add(
                                            SetIsOpenDropdownEvent(
                                              isOpen: true,
                                            ),
                                          );
                                      context.read<CategoryBloc>().add(
                                            UpdateFilterText(text: ''),
                                          );
                                      Navigator.of(context).pop();
                                    },
                                  )
                                : const SizedBox.shrink();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        );
      },
    );
  }
}