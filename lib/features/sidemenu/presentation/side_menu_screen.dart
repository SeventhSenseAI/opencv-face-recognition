import 'dart:ui';

import 'package:faceapp/core/utils/extensions.dart';
import 'package:faceapp/core/widgets/common_snack_bar.dart';
import 'package:faceapp/features/myapi/bloc/myapi_bloc.dart';
import 'package:faceapp/features/myapi/bloc/myapi_provider.dart';
import 'package:faceapp/features/myapi/presentation/subscription_screen.dart';
import 'package:faceapp/features/sidemenu/bloc/menu_bloc.dart';
import 'package:faceapp/landing_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import '../../../core/constants/app_paddings.dart';
import '../../../core/constants/color_codes.dart';
import '../../../core/services/shared_preferences_service.dart';
import '../../../core/utils/assets.dart';
import '../../../core/widgets/boiler_plate_widgets/common_app_bar.dart';
import '../../../core/widgets/boiler_plate_widgets/common_back_button.dart';
import '../../../core/widgets/boiler_plate_widgets/common_page_boiler_plate.dart';
import '../../../core/widgets/gap_widgets/vertical_gap_consistent.dart';
import '../../authentication/bloc/auth_bloc/auth_bloc.dart';
import '../../category/bloc/category_bloc.dart';
import '../../category/bloc/category_event.dart';
import '../../category/presentation/category_screen.dart';
import '../../compare_photos/view/pages/compare_photos_page.dart';
import '../../person/bloc/person_bloc.dart';
import '../../person/bloc/person_event.dart';
import '../data/model/menu_content.dart';
import '../widget/content_list_view.dart';

class SideMenuScreen extends StatefulWidget {
  const SideMenuScreen({super.key});

  @override
  _SideMenuScreenState createState() => _SideMenuScreenState();
}

class _SideMenuScreenState extends State<SideMenuScreen> {
  final List<MenuContent> menuContents = [];
  GlobalKey personButton = GlobalKey();
  GlobalKey compareButton = GlobalKey();
  GlobalKey keyButton = GlobalKey();
  late TutorialCoachMark tutorialCoachMark;
  bool _isFirstTime = true;

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
        identify: "personButton",
        keyTarget: personButton,
        alignSkip: Alignment.topRight,
        enableOverlayTab: true,
        shape: ShapeLightFocus.RRect,
        radius: 5,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    textScaleFactor: 1.0,
                    "View and manage enrolled persons and collections here.",
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

    targets.add(
      TargetFocus(
        identify: "compareButton",
        keyTarget: compareButton,
        alignSkip: Alignment.topRight,
        enableOverlayTab: true,
        shape: ShapeLightFocus.RRect,
        radius: 5,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    textScaleFactor: 1.0,
                    "Compare two facial images to verify if they belong to the same person.",
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

    targets.add(
      TargetFocus(
        identify: "keyButton",
        keyTarget: keyButton,
        alignSkip: Alignment.topRight,
        enableOverlayTab: true,
        shape: ShapeLightFocus.RRect,
        radius: 5,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    textScaleFactor: 1.0,
                    "Grab your API Key here to integrate our Face Recognition technology into your applications.",
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

  Future<void> setupOnboard(BuildContext context) async {
    _isFirstTime = await SharedPreferencesService.getMenu();
    if (!_isFirstTime) {
      Future.delayed(const Duration(milliseconds: 500), () {
        createTutorial();
        showTutorial(context);
        SharedPreferencesService.setMenu(true);
      });
    }
  }

  Widget _listViewWidget(BuildContext context) {
    final authBloc = BlocProvider.of<AuthBloc>(context);
    final menuBloc = BlocProvider.of<MenuBloc>(context);
    return Expanded(
      child: ListView.builder(
        padding: EdgeInsets.zero,
        scrollDirection: Axis.vertical,
        itemCount: menuContents.length,
        itemBuilder: (context, index) {
          final menuContent = menuContents[index];
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 2.h),
            child: GestureDetector(
              onTap: () {
                if (menuContent.isEnableLiveness) {
                  toNavigate(index, context, authBloc, menuBloc);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    AppSnackBar.showErrorSnackBar(
                      context,
                      "Your current plan does not support the liveness feature.",
                    ),
                  );
                }
              },
              child: ContetListView(
                keys: menuContent.key,
                title: menuContent.title,
                isSwitchIcon: menuContent.isSwitchIcon,
                leftIcon: menuContent.leftIcon,
                rightIcon: menuContent.rightIcon,
                opacity: menuContent.isEnableLiveness ? 1.0 : 0.5,
              ),
            ),
          );
        },
      ),
    );
  }

  void _deleteAccount(BuildContext context, MenuBloc menuBloc) {
    final categoryBloc = BlocProvider.of<CategoryBloc>(context);
    final personBloc = BlocProvider.of<PersonBloc>(context);
    final authBloc = BlocProvider.of<AuthBloc>(context);
    menuBloc.add(ForceLogOutMenuEvent());
    categoryBloc.add(ForceLogOutCollectionEvent());
    personBloc.add(ForceLogOutPersonEvent());

    menuBloc.add(InitializeEvent());
    authBloc.add(LogoutUserEvent());
  }

  showAlertDialog(BuildContext context, MenuBloc menuBloc) =>
      showCupertinoDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: const Text(textScaleFactor: 1.0, 'Delete Account?'),
          content: const Text(
            textScaleFactor: 1.0,
            'Deleting your account will permanently remove all your data from our systems. If you wish to proceed, please confirm your account deletion.',
          ),
          actions: <CupertinoDialogAction>[
            CupertinoDialogAction(
              onPressed: () => _deleteAccount(context, menuBloc),
              child: const Text(textScaleFactor: 1.0, 'Delete'),
            ),
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(textScaleFactor: 1.0, 'Cancel'),
            ),
          ],
        ),
      );

  Future<void> toNavigate(
    int index,
    BuildContext context,
    AuthBloc authBloc,
    MenuBloc menuBloc,
  ) async {
    switch (menuContents[index].contentType) {
      case ContentType.liveness:
        break;

      case ContentType.person:
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) {
              return CategoryScreen(
                compressBase64Image: "",
                baseMultipleFacesImage: "",
                isNeedsRedirectToMultipleFacesPage: false,
                isFaceLib: true,
                isSavePerson: false,
              );
            },
          ),
        );

      case ContentType.compare:
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) {
              return const ComparePhotosPage();
            },
          ),
        );

      case ContentType.myApi:
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) {
              return MyAPIProvider(
                child: const SubscriptionScreen(),
              );
            },
          ),
        );

      case ContentType.delete:
        showAlertDialog(context, menuBloc);

      case ContentType.logout:
        authBloc.add(LogoutUserEvent());
        context.read<CategoryBloc>().add(ForceLogOutCollectionEvent());
        context.read<MenuBloc>().add(ForceLogOutMenuEvent());
        context.read<PersonBloc>().add(ForceLogOutPersonEvent());

    }
  }

  void addMenuContent(BuildContext context) {
    menuContents.clear();
    final myApiBloc = context.read<MyapiBloc>();
    final subscription = myApiBloc.state.subscription;
    bool isLiveness = true;
    if (subscription != null) {
      final customerType = subscription.customerType;
      if (customerType == "FREE") {
        isLiveness = false;
      }
    }
    menuContents.add(
      MenuContent(
        title: AppLocalizations.of(context)!.liveness_check,
        isSwitchIcon: true,
        leftIcon: Assets.menuLive,
        rightIcon: null,
        contentType: ContentType.liveness,
        isEnableLiveness: isLiveness,
        key: const ValueKey<String>('liveness'),
      ),
    );

    menuContents.add(
      MenuContent(
        title: AppLocalizations.of(context)!.person,
        isSwitchIcon: false,
        rightIcon: Assets.arrowRight,
        leftIcon: Assets.menuFace,
        contentType: ContentType.person,
        isEnableLiveness: true,
        key: personButton,
      ),
    );
    menuContents.add(
      MenuContent(
        title: AppLocalizations.of(context)!.compare_image,
        isSwitchIcon: false,
        rightIcon: Assets.arrowRight,
        leftIcon: Assets.menuCompare,
        contentType: ContentType.compare,
        isEnableLiveness: true,
        key: compareButton,
      ),
    );

    menuContents.add(
      MenuContent(
        title: AppLocalizations.of(context)!.my_api,
        isSwitchIcon: false,
        rightIcon: Assets.arrowRight,
        leftIcon: Assets.menuApi,
        contentType: ContentType.myApi,
        isEnableLiveness: true,
        key: keyButton,
      ),
    );

    if (subscription != null) {
      final customerType = subscription.customerType;
      if ((customerType == "FREE") ||
          (customerType == "TRIALBU") ||
          (customerType == "TRIAL")) {
        menuContents.add(
          MenuContent(
            title: "Delete Account",
            isSwitchIcon: false,
            rightIcon: null,
            leftIcon: Assets.menuDelete,
            contentType: ContentType.delete,
            isEnableLiveness: true,
            key: const ValueKey<String>('delete'),
          ),
        );
      }
    }

    menuContents.add(
      MenuContent(
        title: AppLocalizations.of(context)!.signout,
        isSwitchIcon: false,
        rightIcon: null,
        leftIcon: Assets.menuSignout,
        contentType: ContentType.logout,
        isEnableLiveness: true,
        key: const ValueKey<String>('signout'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    MediaQuery.of(context).copyWith(boldText: false);
    addMenuContent(context);
    setupOnboard(context);
    return MultiBlocListener(
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
        BlocListener<MenuBloc, MenuState>(
          listenWhen: (previous, current) => previous.status != current.status,
          listener: (context, state) {
            if (state.status == MenuStatus.error) {
              ScaffoldMessenger.of(context).showSnackBar(
                AppSnackBar.showErrorSnackBar(context, state.errorMessage),
              );
            }
          },
        ),
        BlocListener<MenuBloc, MenuState>(
          listener: (context, state) {
            if (state.deleteAccountStatus == DeleteAccountStatus.error) {
              ScaffoldMessenger.of(context).showSnackBar(
                AppSnackBar.showErrorSnackBar(context, state.errorMessage),
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
              }
            }
          },
        ),
        BlocListener<MyapiBloc, MyapiState>(
          listenWhen: (previous, current) => previous.status != current.status,
          listener: (context, state) {
            if (state.status == MyapiStatus.fetchSubscription) {
              setState(() {});
            }
          },
        ),
      ],
      child: CommonPageBoilerPlate(
        commonAppBar: CommonAppBar(
          leadingWidget: CommonBackButtonWidget(
            buttonText: AppLocalizations.of(context)!.back,
          ),
          titleWidget: Text(
            textScaleFactor: 1.0,
            AppLocalizations.of(context)!.menu,
          ),
        ),
        pageBody: Center(
          child: Stack(
            clipBehavior: Clip.antiAlias,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  VerticalGapWidget(
                    AppPaddings.p24.h,
                  ),
                  _listViewWidget(context),
                ],
              ),
              Positioned(
                bottom: 30.h,
                child: FutureBuilder<String>(
                  future: _getVersionDetails(),
                  builder: (context, snapshot) => Text(
                    textScaleFactor: 1.0,
                    "Version: ${snapshot.data ?? '1.0.0'}",
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontWeight: FontWeight.w500,
                          fontSize: 10,
                        ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<String> _getVersionDetails() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }
}
