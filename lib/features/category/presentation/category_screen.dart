import 'dart:ui';

import 'package:faceapp/core/widgets/category_item.dart';
import 'package:faceapp/features/person/bloc/person_bloc.dart';
import 'package:faceapp/features/search/data/model/user.dart';
import 'package:faceapp/features/sidemenu/bloc/menu_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import '../../../core/constants/app_paddings.dart';
import '../../../core/constants/color_codes.dart';
import '../../../core/services/shared_preferences_service.dart';
import '../../../core/utils/extensions.dart';
import '../../../core/widgets/boiler_plate_widgets/common_app_bar.dart';
import '../../../core/widgets/boiler_plate_widgets/common_back_button.dart';
import '../../../core/widgets/boiler_plate_widgets/common_page_boiler_plate.dart';
import '../../../core/widgets/common_elevated_button.dart';
import '../../../core/widgets/common_snack_bar.dart';
import '../../../landing_page.dart';
import '../../authentication/bloc/auth_bloc/auth_bloc.dart';
import '../../person/bloc/person_event.dart';
import '../../person/presentation/save_update_person_screen.dart';
import '../bloc/category_bloc.dart';
import '../bloc/category_event.dart';
import '../bloc/category_state.dart';
import 'create_category_screen.dart';
import 'widget/category_list.dart';

class CategoryScreen extends StatelessWidget {
  final bool isFaceLib;
  final String? thumbnail;
  final bool isNeedsRedirectToMultipleFacesPage;
  final String baseMultipleFacesImage;
  final String compressBase64Image;
  GlobalKey keyAddNavigation = GlobalKey();
  bool _isFirstTime = true;
  late TutorialCoachMark tutorialCoachMark;
  final bool isSavePerson;

  CategoryScreen({
    super.key,
    required this.isSavePerson,
    required this.isFaceLib,
    this.thumbnail,
    required this.isNeedsRedirectToMultipleFacesPage,
    required this.baseMultipleFacesImage,
    required this.compressBase64Image,
  });

  Future<void> setupOnboard(BuildContext context) async {
    _isFirstTime = await SharedPreferencesService.getCollection();
    if (!_isFirstTime) {
      Future.delayed(const Duration(milliseconds: 200), () {
        createTutorial();
        showTutorial(context);
        SharedPreferencesService.setCollection(true);
      });
    }
  }

  void showTutorial(BuildContext context) {
    tutorialCoachMark.show(context: context);
  }

  void createTutorial() {
    tutorialCoachMark = TutorialCoachMark(
      targets: _createTargets(),
      colorShadow: ColorCodes.primaryColor,
      textSkip: "SKIP",
      paddingFocus: 10,
      opacityShadow: 0.5,
      imageFilter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
    );
  }

  List<TargetFocus> _createTargets() {
    List<TargetFocus> targets = [];

    targets.add(
      TargetFocus(
        identify: "keyAddNavigation",
        keyTarget: keyAddNavigation,
        alignSkip: Alignment.topRight,
        enableOverlayTab: true,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                     textScaleFactor: 1.0,
                    "Tap here to create a new collection.",
                    style: context.theme.textTheme.titleSmall!.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
    return targets;
  }

  @override
  Widget build(BuildContext context) {
    if (isFaceLib) {
      context.read<CategoryBloc>().add(GetAllCategoryEvent());
    } else {
      setupOnboard(context);
    }
    return MultiBlocListener(
      listeners: [
        BlocListener<CategoryBloc, CategoryState>(
          listenWhen: (previous, current) =>
              previous.isAPITokenError != current.isAPITokenError,
          listener: (context, state) async {
            if (state.isAPITokenError) {
              ScaffoldMessenger.of(context).showSnackBar(
                AppSnackBar.showErrorSnackBar(context, state.errorMessage),
              );
              Future.delayed(const Duration(milliseconds: 1500), () {
                final authBloc = BlocProvider.of<AuthBloc>(context);
                authBloc.add(LogoutUserEvent());
                context.read<CategoryBloc>().add(ForceLogOutCollectionEvent());
                context.read<MenuBloc>().add(ForceLogOutMenuEvent());
                context.read<PersonBloc>().add(ForceLogOutPersonEvent());
              });
            }
          },
        ),
        BlocListener<AuthBloc, AuthState>(
          listenWhen: (previous, current) =>
              previous.authStatus != current.authStatus,
          listener: (context, state) {
            if (state.authStatus == AuthStatus.unauthenticated) {
              Navigator.pushAndRemoveUntil(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) {
                    return const LandingPage();
                  },
                  transitionsBuilder: (
                    context,
                    animation,
                    secondaryAnimation,
                    child,
                  ) {
                    return SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(-1.0, 0.0),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    );
                  },
                ),
                (route) => false,
              );
            }
          },
        ),
      ],
      child: CommonPageBoilerPlate(
        pageBody: buildContent(context),
        commonAppBar: CommonAppBar(
          isCenterTitle: true,
          titleWidget: Text(
             textScaleFactor: 1.0,
            AppLocalizations.of(context)!.select_category,
            style: context.theme.textTheme.titleMedium!.copyWith(
              fontSize: 17.sp,
            ),
          ),
          leadingWidget: CommonBackButtonWidget(
            buttonText: AppLocalizations.of(context)!.back,
          ),
        ),
      ),
    );
  }

  Widget buildContent(BuildContext context) {
    return Stack(
      children: [
        isFaceLib
            ? Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: CategoryItem(
                  baseMultipleFacesImage: baseMultipleFacesImage,
                  compressBase64Image: compressBase64Image,
                  isNeedsRedirectToMultipleFacesPage:
                      isNeedsRedirectToMultipleFacesPage,
                  collection: Collection(
                    name: 'All Persons',
                  ),
                  isFaceLib: isFaceLib,
                  thumbnail: thumbnail,
                  isAll: true,
                  isSavePerson: isSavePerson,
                ),
              )
            : const SizedBox.expand(),
        Positioned(
          top: isFaceLib ? AppPaddings.p64.h : 0.h,
          left: 0,
          right: 0,
          bottom: isFaceLib ? 0 : 140.h,
          child: CategoryList(
            baseMultipleFacesImage: baseMultipleFacesImage,
            compressBase64Image: compressBase64Image,
            isNeedsRedirectToMultipleFacesPage:
                isNeedsRedirectToMultipleFacesPage,
            isFaceLib: isFaceLib,
            thumbnail: thumbnail,
            isSavePerson: isSavePerson,
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 45.h,
          child: Visibility(
            visible: !isFaceLib,
            child: CustomElevatedButtonWidget(
              buttonText: 'Skip & Save',
              onPressed: () {
                if (isNeedsRedirectToMultipleFacesPage) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SaveUpdatePersonScreen(
                        baseMultipleFacesImage: baseMultipleFacesImage,
                        compressBase64Image: compressBase64Image,
                        isNeedsRedirectToMultipleFacesPage:
                            isNeedsRedirectToMultipleFacesPage,
                        option: AppLocalizations.of(context)!.save,
                        collections: const [],
                        isWithCategory: false,
                        thumbnail: thumbnail,
                        isFaceLibrary: isFaceLib,
                        isSavePerson: isSavePerson,
                      ),
                    ),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SaveUpdatePersonScreen(
                        baseMultipleFacesImage: baseMultipleFacesImage,
                        compressBase64Image: compressBase64Image,
                        isNeedsRedirectToMultipleFacesPage:
                            isNeedsRedirectToMultipleFacesPage,
                        option: AppLocalizations.of(context)!.save,
                        collections: const [],
                        isWithCategory: false,
                        thumbnail: thumbnail,
                        isFaceLibrary: isFaceLib,
                        isSavePerson: isSavePerson,
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        ),
        Positioned(
          right: AppPaddings.p24.w,
          bottom: 124.h,
          child: buildCreateCategory(context),
        ),
      ],
    );
  }

  Widget buildCreateCategory(BuildContext context) {
    return GestureDetector(
      key: keyAddNavigation,
      onTap: () {
        if (isFaceLib) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateCategoryScreen(
                isNeedsRedirectToMultipleFacesPage: false,
                baseMultipleFacesImage: baseMultipleFacesImage,
                compressBase64Image: compressBase64Image,
                isFaceLib: isFaceLib,
                thumbnail: thumbnail,
                isSavePerson: isSavePerson,
              ),
            ),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateCategoryScreen(
                baseMultipleFacesImage: baseMultipleFacesImage,
                compressBase64Image: compressBase64Image,
                isNeedsRedirectToMultipleFacesPage:
                    isNeedsRedirectToMultipleFacesPage,
                isFaceLib: isFaceLib,
                thumbnail: thumbnail,
                isSavePerson: isSavePerson,
              ),
            ),
          );
        }
      },
      child: Icon(
        Icons.add_circle,
        color: ColorCodes.whiteColor,
        size: AppPaddings.p64.r,
      ),
    );
  }
}
