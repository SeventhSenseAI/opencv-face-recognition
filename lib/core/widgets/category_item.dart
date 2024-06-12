import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../features/category/bloc/category_bloc.dart';
import '../../features/category/bloc/category_event.dart';
import '../../features/category/presentation/create_category_screen.dart';
import '../../features/person/bloc/person_bloc.dart';
import '../../features/person/bloc/person_event.dart';
import '../../features/person/presentation/person_screen.dart';
import '../../features/person/presentation/save_update_person_screen.dart';
import '../../features/search/data/model/user.dart';
import '../constants/app_paddings.dart';
import '../constants/color_codes.dart';
import '../utils/assets.dart';
import '../utils/extensions.dart';
import 'common_elevated_button.dart';
import 'gap_widgets/horizontal_gap_consistent.dart';
import 'gap_widgets/vertical_gap_consistent.dart';

class CategoryItem extends StatefulWidget {
  final bool isFaceLib;
  final Collection collection;
  final String? thumbnail;
  final String baseMultipleFacesImage;
  final String compressBase64Image;
  final bool isNeedsRedirectToMultipleFacesPage;
  final bool isAll;
  final bool isSavePerson;

  const CategoryItem({
    super.key,
    required this.isFaceLib,
    required this.collection,
    this.thumbnail,
    required this.baseMultipleFacesImage,
    required this.compressBase64Image,
    required this.isNeedsRedirectToMultipleFacesPage,
    required this.isAll,
    required this.isSavePerson,
  });

  @override
  State<CategoryItem> createState() => _CategoryItemState();
}

class _CategoryItemState extends State<CategoryItem> {
  late CategoryBloc categoryBloc;

  @override
  void initState() {
    super.initState();
    categoryBloc = BlocProvider.of<CategoryBloc>(context);
  }

  void _settingModalBottomSheet(context) {
    String name = widget.collection.name!;

    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        ThemeData theme = Theme.of(context);
        return Container(
          color: ColorCodes.secondaryColor,
          padding: EdgeInsets.all(16.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  HorizontalGapWidget(AppPaddings.p36.w),
                  const Spacer(),
                  Text(
                    textScaleFactor: 1.0,
                    AppLocalizations.of(context)!.delete_category,
                    style: theme.textTheme.titleSmall!.copyWith(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(
                      Icons.close,
                      color: ColorCodes.whiteColor,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
              VerticalGapWidget(
                AppPaddings.p32.h,
              ),
              Center(
                child: Text(
                  textScaleFactor: 1.0,
                  "${AppLocalizations.of(context)!.delete_name}$name ?",
                  style: theme.textTheme.titleSmall!.copyWith(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
              VerticalGapWidget(
                AppPaddings.p32.h,
              ),
              buildCreateButton(context),
            ],
          ),
        );
      },
    );
  }

  Widget buildCreateButton(BuildContext context) {
    return CustomElevatedButtonWidget(
      buttonText: AppLocalizations.of(context)!.delete,
      onPressed: () {
        deleteCollection();
      },
    );
  }

  void deleteCollection() {
    categoryBloc.add(DeleteCategoryEvent(collectionID: widget.collection.id!));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    // PersonBloc personBloc = BlocProvider.of<PersonBloc>(context);
    return Container(
      height: 72.h,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: ColorCodes.greyColor,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: ListTile(
              leading: Image.asset(
                widget.isAll ? Assets.allPersonsIcon : Assets.collectionIcon,
                width: 26.w,
                height: 23.h,
                fit: BoxFit.fill,
              ),
              title: Text(
                textScaleFactor: 1.0,
                widget.collection.name!,
                style: context.theme.textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.w300,
                ),
              ),
              contentPadding: const EdgeInsets.all(0),
              onTap: () {
                categoryBloc.add(
                  SetCurrentCategoryEvent(
                    collection: widget.collection,
                  ),
                );
                if (widget.isFaceLib) {
                  PersonBloc personBloc = BlocProvider.of<PersonBloc>(context);
                  personBloc.add(
                    FetchAllPersonsEvent(
                      collectionId: widget.isAll ? '' : widget.collection.id!,
                    ),
                  );
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PersonScreen(
                        isNeedsRedirectToMultipleFacesPage: false,
                        currentCategory: widget.collection,
                      ),
                    ),
                  );
                  return;
                }

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SaveUpdatePersonScreen(
                      compressBase64Image: widget.compressBase64Image,
                      baseMultipleFacesImage: widget.baseMultipleFacesImage,
                      isNeedsRedirectToMultipleFacesPage:
                          widget.isNeedsRedirectToMultipleFacesPage,
                      option: AppLocalizations.of(context)!.save,
                      collections: [widget.collection],
                      thumbnail: widget.thumbnail,
                      isWithCategory: true,
                      isFaceLibrary: widget.isFaceLib,
                      isSavePerson: widget.isSavePerson,
                    ),
                  ),
                );
              },
            ),
          ),
          if (widget.isFaceLib && !widget.isAll)
            PopupMenuButton<int>(
              offset: Offset(-30.w, 25.h),
              elevation: 2,
              color: ColorCodes.secondaryColor,
              icon: Image.asset(
                Assets.menuDots,
                width: 20.r,
                height: 20.r,
                fit: BoxFit.fill,
              ),
              onSelected: (int value) {
                switch (value) {
                  case 0:
                    categoryBloc.add(
                      SetCurrentCategoryEvent(
                        collection: widget.collection,
                      ),
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CreateCategoryScreen(
                          baseMultipleFacesImage: widget.baseMultipleFacesImage,
                          compressBase64Image: widget.compressBase64Image,
                          isNeedsRedirectToMultipleFacesPage: false,
                          isFaceLib: widget.isFaceLib,
                          isSavePerson: widget.isSavePerson,
                          id: widget.isFaceLib ? widget.collection.id : null,
                          name:
                              widget.isFaceLib ? widget.collection.name : null,
                        ),
                      ),
                    );
                  case 1:
                    _settingModalBottomSheet(context);
                }
              },
              itemBuilder: (BuildContext context) {
                return <PopupMenuEntry<int>>[
                  PopupMenuItem<int>(
                    value: 0,
                    padding: EdgeInsets.only(left: 16.w),
                    child: Container(
                      color: Colors.transparent,
                      child: ListTile(
                        leading: const Icon(
                          Icons.edit,
                          color: ColorCodes.whiteColor,
                        ), // Icon on the left side
                        title: Text(
                          textScaleFactor: 1.0,
                          AppLocalizations.of(context)!.edit,
                          style: context.theme.textTheme.titleSmall!.copyWith(
                            color: ColorCodes.whiteColor,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const PopupMenuDivider(
                    height: 2,
                  ),
                  PopupMenuItem<int>(
                    value: 1,
                    padding: EdgeInsets.only(left: 16.w),
                    child: Container(
                      color: Colors.transparent,
                      child: ListTile(
                        leading: const Icon(
                          Icons.delete,
                          color: ColorCodes.whiteColor,
                        ),
                        title: Text(
                          textScaleFactor: 1.0,
                          AppLocalizations.of(context)!.delete,
                          style: context.theme.textTheme.titleSmall!.copyWith(
                            color: ColorCodes.whiteColor,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                    ),
                  ),
                ];
              },
            ),
        ],
      ),
    );
  }
}
