import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/app_paddings.dart';
import '../../../../../core/constants/color_codes.dart';
import '../../../../../core/widgets/gap_widgets/vertical_gap_consistent.dart';
import '../../../../category/presentation/category_screen.dart';
import '../../../../person/presentation/view_person_screen.dart';
import '../../../bloc/search_bloc.dart';
import '../../../data/model/user.dart';
import '../bottom_sheet_bottom_part/bottom_sheet_bottom_part_widget.dart';
import 'multiple_faces_card_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MultipleFacesDetectWidget extends StatelessWidget {
  const MultipleFacesDetectWidget({
    super.key,
    required this.svgIcon,
    this.isSaveBtnActive = true,
  });

  final String svgIcon;
  final bool isSaveBtnActive;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          VerticalGapWidget(AppPaddings.p16.h),
          SizedBox(
            height: 196.h,
            child: BlocBuilder<SearchBloc, SearchState>(
              builder: (context, state) {
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: state.searchResults!.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return MultipleFacesCardWidget(
                      onTap: () {
                        final searchBloc = context.read<SearchBloc>();
                        final searchResult = state.searchResults![index];
                        if (state.searchResults![index].persons!.isEmpty) {
                          /// undefine face
                          final thumbnail = searchResult.thumbnail;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CategoryScreen(
                                baseMultipleFacesImage:
                                    searchBloc.state.base64Image!,
                                compressBase64Image:
                                    searchBloc.state.compressBase64Image!,
                                isNeedsRedirectToMultipleFacesPage: true,
                                thumbnail: thumbnail,
                                isFaceLib: false,
                                isSavePerson: true,
                              ),
                            ),
                          );
                        } else {
                          /// defined face
                          final searchBloc = context.read<SearchBloc>();
                          final Person person = searchResult.persons![0];
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BlocProvider.value(
                                value: searchBloc,
                                child: ViewPersonScreen(
                                  isFaceLibrary: false,
                                  baseMultipleFacesImage:
                                      searchBloc.state.base64Image!,
                                  compressBase64Image:
                                      searchBloc.state.compressBase64Image!,
                                  isNeedsRedirectToMultipleFacesPage: true,
                                  personID: person.id!,
                                  isSavePerson: false,
                                ),
                              ),
                            ),
                          );
                        }
                      },
                      base64Image: state.searchResults![index].thumbnail!,
                      name: state.searchResults![index].persons!.isNotEmpty
                          ? state.searchResults![index].persons![0].name!
                          : AppLocalizations.of(context)!.unidentified_face,
                    );
                  },
                );
              },
            ),
          ),
          VerticalGapWidget(AppPaddings.p16.h),
          const Divider(
            height: 1,
            color: ColorCodes.greyColor,
          ),
          VerticalGapWidget(AppPaddings.p16.h),
          BottomSheetBottomPartWidget(
            isSaveBtnActive: isSaveBtnActive,
            isMultipleFaces: true,
          ),
        ],
      ),
    );
  }
}