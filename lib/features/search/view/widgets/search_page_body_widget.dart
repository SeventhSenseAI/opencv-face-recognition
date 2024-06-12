import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:faceapp/core/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import '../../../../core/constants/color_codes.dart';
import '../../../../core/services/shared_preferences_service.dart';
import '../../../../core/utils/assets.dart';
import '../../../../core/widgets/boiler_plate_widgets/common_page_boiler_plate.dart';
import '../../../../core/widgets/common_snack_bar.dart';
import '../../../../landing_page.dart';
import '../../../authentication/bloc/auth_bloc/auth_bloc.dart';
import '../../../category/bloc/category_bloc.dart';
import '../../../category/bloc/category_event.dart';
import '../../../dashboard/presentation/home_screen.dart';
import '../../../person/bloc/person_bloc.dart';
import '../../../person/bloc/person_event.dart';
import '../../../sidemenu/bloc/menu_bloc.dart';
import '../../bloc/search_bloc.dart';
import 'face_identified_widget.dart';
import 'loading_widget/identifying_widget.dart';
import 'loading_widget/linear_progress_indicator_widget.dart';
import 'multiple_faces_detect/multiple_faces_detect_widget.dart';
import 'no_face_detected_and_unidentified_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SearchPageBodyWidget extends StatelessWidget {
  final String base64Image;
  final String compressBase64Image;
  SearchPageBodyWidget({
    super.key,
    required this.base64Image,
    required this.compressBase64Image,
  });
  late TutorialCoachMark tutorialCoachMark;
  GlobalKey keyFaceNavigation = GlobalKey();
  bool _isFirstTime = true;

  Future<void> setupOnboard(BuildContext context) async {
    _isFirstTime = await SharedPreferencesService.getSearch();
    if (!_isFirstTime) {
      Future.delayed(const Duration(milliseconds: 200), () {
        createTutorial();
        showTutorial(context);
        SharedPreferencesService.setSearch(true);
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
        identify: "keyFaceNavigation",
        keyTarget: keyFaceNavigation,
        alignSkip: Alignment.topRight,
        enableOverlayTab: true,
        shape: ShapeLightFocus.RRect,
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
                    "Tap here to enroll the person.",
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
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushAndRemoveUntil(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) {
              return const HomeScreen();
            },
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
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
        // // Return true if the user confirms exit, otherwise return false.
        return false;
      },
      child: MultiBlocListener(
        listeners: [
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
          BlocListener<SearchBloc, SearchState>(
            listenWhen: (previous, current) =>
                previous.spoofingStateStatus != current.spoofingStateStatus &&
                previous.errorMessage != current.errorMessage,
            listener: (context, state) {
              if (state.spoofingStateStatus!.isFailure &&
                  state.errorMessage != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  AppSnackBar.showErrorSnackBar(context, state.errorMessage!),
                );
                if (state.isAPITokenError!) {
                  Future.delayed(const Duration(milliseconds: 1500), () {
                    final authBloc = BlocProvider.of<AuthBloc>(context);
                    authBloc.add(LogoutUserEvent());
                    context
                        .read<CategoryBloc>()
                        .add(ForceLogOutCollectionEvent());
                    context.read<MenuBloc>().add(ForceLogOutMenuEvent());
                    context.read<PersonBloc>().add(ForceLogOutPersonEvent());
                  });
                } else {
                  Navigator.pushAndRemoveUntil(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) {
                        return const HomeScreen();
                      },
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
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
              }
            },
          ),
          BlocListener<SearchBloc, SearchState>(
            listenWhen: (previous, current) =>
                previous.searchResultStateStatus !=
                    current.searchResultStateStatus &&
                previous.errorMessage != current.errorMessage,
            listener: (context, state) {
              if (state.searchResultStateStatus!.isFailure &&
                  state.errorMessage != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  AppSnackBar.showErrorSnackBar(context, state.errorMessage!),
                );
                Navigator.pushAndRemoveUntil(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) {
                      return const HomeScreen();
                    },
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
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
          horizontalPadding: 0,
          isNeedToApplySafeArea: false,
          pageBody: Stack(
            children: [
              Positioned.fill(
                child: Align(
                  alignment: Alignment.center,
                  child: Image.memory(
                    base64.decode(compressBase64Image),
                    fit: BoxFit.contain,
                    alignment: Alignment.center,
                    width: double.infinity,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: BlocBuilder<SearchBloc, SearchState>(
                  buildWhen: (previous, current) =>
                      previous.searchResultStateStatus !=
                      current.searchResultStateStatus,
                  builder: (context, state) {
                    double containerHeight = 56.h;
                    if (state.searchResultStateStatus!.isLoading) {
                      containerHeight = 56.h;
                    }
                    if (state.searchResultStateStatus!.isIdentified) {
                      if (state.isSpoofingEnabled!) {
                        containerHeight = Platform.isAndroid ? 250.h : 265.h;
                      } else {
                        containerHeight = 220.h;
                      }
                    }
                    if (state
                        .searchResultStateStatus!.isMultipleFacesDetected) {
                      containerHeight = 334.h;
                    }
                    if (state.searchResultStateStatus!.isUnidentified ||
                        state.searchResultStateStatus!.isNoFaceDetected) {
                      containerHeight = 138.h;
                    }

                    return Column(
                      children: [
                        if (state.searchResultStateStatus!.isLoading)
                          const LinearProgressIndicatorWidget(),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          height: containerHeight,
                          decoration: const BoxDecoration(
                            color: ColorCodes.secondaryColor,
                          ),
                          child: SingleChildScrollView(
                            child: Builder(
                              builder: (context) {
                                if (state.searchResultStateStatus!
                                    .isNoFaceDetected) {
                                  // if(isNoFaceDetected)
                                  return NoFaceDetectedAndUnidentifiedWidget(
                                    svgIcon: Assets.shieldWarningBold,
                                    text: "No Face Detected!",
                                    isSaveBtnActive: false,
                                  );
                                } else if (state
                                    .searchResultStateStatus!.isIdentified) {
                                  // if(isIdentified)
                                  if (state.isSpoofingEnabled!) {
                                    // if(isIdentified && isSpoofingEnabled)
                                    if (state.spoofingStateStatus!
                                        .isSpoofingDetected) {
                                      // if(isIdentified && isSpoofingEnabled && isSpoofingDetect)
                                      return FaceIdentifiedWidget(
                                        score: state.searchResults![0]
                                            .persons![0].score!,
                                        isSpoofingEnabled: true,
                                        isSpoofingDetect: true,
                                        personName: state.searchResults![0]
                                            .persons![0].name!,
                                      );
                                    } else {
                                      // if(isIdentified && isSpoofingEnabled && !isSpoofingDetect)
                                      return FaceIdentifiedWidget(
                                        score: state.searchResults![0]
                                            .persons![0].score!,
                                        isSpoofingEnabled: true,
                                        isSpoofingDetect: false,
                                        personName: state.searchResults![0]
                                            .persons![0].name!,
                                      );
                                    }
                                  } else {
                                    // if(isIdentified && !isSpoofingEnabled)
                                    return FaceIdentifiedWidget(
                                      score: state
                                          .searchResults![0].persons![0].score!,
                                      isSpoofingEnabled: false,
                                      isSpoofingDetect: false,
                                      personName: state
                                          .searchResults![0].persons![0].name!,
                                    );
                                  }
                                } else if (state
                                    .searchResultStateStatus!.isUnidentified) {
                                  setupOnboard(context);
                                  // if(isUnidentified)
                                  return NoFaceDetectedAndUnidentifiedWidget(
                                    keys: keyFaceNavigation,
                                    svgIcon: Assets.shieldWarningBold,
                                    text: AppLocalizations.of(context)!
                                        .unidentified_face,
                                    isSaveBtnActive: true,
                                  );
                                } else if (state.searchResultStateStatus!
                                    .isMultipleFacesDetected) {
                                  // if(isMultipleFacesDetected)
                                  return MultipleFacesDetectWidget(
                                    svgIcon: Assets.shieldWarningBold,
                                    isSaveBtnActive: true,
                                  );
                                } else {
                                  // if(!isIdentified)
                                  return const IdentifyingWidget();
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
