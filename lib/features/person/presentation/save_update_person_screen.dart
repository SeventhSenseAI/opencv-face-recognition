import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import '../../../core/constants/color_codes.dart';
import '../../../core/services/shared_preferences_service.dart';
import '../../../core/utils/extensions.dart';
import '../../../core/widgets/boiler_plate_widgets/common_app_bar.dart';
import '../../../core/widgets/boiler_plate_widgets/common_back_button.dart';
import '../../../core/widgets/boiler_plate_widgets/common_page_boiler_plate.dart';
import '../../../core/widgets/common_alert.dart';
import '../../../core/widgets/common_elevated_button.dart';
import '../../../core/widgets/common_snack_bar.dart';
import '../../../core/widgets/common_text_field.dart';
import '../../../landing_page.dart';
import '../../authentication/bloc/auth_bloc/auth_bloc.dart';
import '../../category/bloc/category_bloc.dart';
import '../../category/bloc/category_event.dart';
import '../../search/data/model/user.dart';
import '../../search/view/pages/image_identify_page.dart';
import '../../sidemenu/bloc/menu_bloc.dart';
import '../bloc/person_bloc.dart';
import '../bloc/person_event.dart';
import '../bloc/person_state.dart';
import 'widget/combo_box_input.dart';
import 'widget/datepicker_input.dart';

class SaveUpdatePersonScreen extends StatefulWidget {
  final String option;
  final Person? person;
  final String? thumbnail;
  final List<Collection> collections;
  final List<String>? base64Images;
  final bool isWithCategory;
  final bool isNeedsRedirectToMultipleFacesPage;
  final String baseMultipleFacesImage;
  final String compressBase64Image;
  final bool isFaceLibrary;
  final bool isSavePerson;

  const SaveUpdatePersonScreen({
    super.key,
    required this.option,
    this.person,
    this.thumbnail,
    required this.collections,
    this.base64Images,
    required this.isWithCategory,
    required this.isNeedsRedirectToMultipleFacesPage,
    required this.baseMultipleFacesImage,
    required this.compressBase64Image,
    this.isFaceLibrary = true,
    this.isSavePerson = true,
  });
  @override
  State<SaveUpdatePersonScreen> createState() => _SaveUpdatePersonScreenState();
}

class _SaveUpdatePersonScreenState extends State<SaveUpdatePersonScreen> {
  late TextEditingController nameController;
  late TextEditingController dobController;
  late TextEditingController nationalityController;
  late TextEditingController notesController;
  late PersonBloc personBloc;
  late TutorialCoachMark tutorialCoachMark;
  GlobalKey keyNavigation = GlobalKey();
  GlobalKey keySaveNavigation = GlobalKey();
  bool _isFirstTime = true;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    dobController = TextEditingController();
    nationalityController = TextEditingController();
    notesController = TextEditingController();

    personBloc = BlocProvider.of<PersonBloc>(context);

    if (widget.person != null) {
      nameController.text = widget.person?.name ?? '';
      dobController.text = widget.person!.dateOfBirth != null
          ? widget.person!.dateOfBirth!.toIso8601String().split('T').first
          : '';
      nationalityController.text = widget.person!.nationality ?? '';
      notesController.text = widget.person?.notes ?? '';
      personBloc.add(
        SetNationalityEvent(
          nationality: widget.person!.nationality,
        ),
      );
    }
    if (!widget.isFaceLibrary && widget.isSavePerson) {
      setupOnboard();
    }
  }

  Future<void> setupOnboard() async {
    _isFirstTime = await SharedPreferencesService.getSavePerson();
    if (!_isFirstTime) {
      Future.delayed(const Duration(milliseconds: 200), () {
        createTutorial();
        showTutorial(context);
        SharedPreferencesService.setSavePerson(true);
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
        identify: "keyNavigation",
        keyTarget: keyNavigation,
        alignSkip: Alignment.topRight,
        enableOverlayTab: true,
        shape: ShapeLightFocus.RRect,
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
                    "Enter the person's name here.",
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
        identify: "keySaveNavigation",
        keyTarget: keySaveNavigation,
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
                    "Tap here to save the person's details and complete the enrollment process.",
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

  List<Thumbnail> createThumbnails() {
    List<Thumbnail> thumbnails = [];
    if (widget.base64Images != null) {
      for (String image in widget.base64Images!) {
        thumbnails.add(Thumbnail(thumbnail: image));
      }
    }
    return thumbnails;
  }

  Widget buildNameInput(BuildContext context) {
    return CommonTextField(
      key: keyNavigation,
      controller: nameController,
      fieldName: "Name *",
      lines: 1,
      autofocus: true,
    );
  }

  Widget buildNotesInput(BuildContext context) {
    return CommonTextField(
      controller: notesController,
      fieldName: AppLocalizations.of(context)!.notes,
      lines: 2,
    );
  }

  void callLogoutEvent(BuildContext context) {
    Future.delayed(const Duration(microseconds: 1500), () {
      final authBloc = BlocProvider.of<AuthBloc>(context);
      authBloc.add(LogoutUserEvent());
      context.read<CategoryBloc>().add(ForceLogOutCollectionEvent());
      context.read<MenuBloc>().add(ForceLogOutMenuEvent());
      context.read<PersonBloc>().add(ForceLogOutPersonEvent());
    });
  }

  Widget buildSaveAndUpdateButton(
    BuildContext context,
    PersonBloc personBloc,
  ) {
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
        BlocListener<PersonBloc, PersonState>(
          listenWhen: (previous, current) =>
              previous.saveStatus != current.saveStatus,
          listener: (context, state) {
            if (personBloc.state.saveStatus == PersonSaveStatus.success) {
              successScreen(
                AppLocalizations.of(context)!.saved,
                widget.isFaceLibrary,
              );
              context.read<PersonBloc>().add(ResetStateEvent());
              context
                  .read<PersonBloc>()
                  .add(SetNationalityEvent(nationality: ''));
            } else if (personBloc.state.saveStatus == PersonSaveStatus.error) {
              ScaffoldMessenger.of(context).showSnackBar(
                AppSnackBar.showErrorSnackBar(
                  context,
                  personBloc.state.errorMessage,
                ),
              );
              if (state.isAPITokenError!) {
                callLogoutEvent(context);
              } else {
                context.read<PersonBloc>().add(ResetStateEvent());
              }
            }
          },
        ),
        BlocListener<PersonBloc, PersonState>(
          listenWhen: (previous, current) =>
              previous.updateStatus != current.updateStatus,
          listener: (context, state) {
            if (personBloc.state.updateStatus == PersonUpdateStatus.success) {
              successScreen(
                AppLocalizations.of(context)!.updated,
                widget.isFaceLibrary,
              );
              context.read<PersonBloc>().add(ResetStateEvent());
              context
                  .read<PersonBloc>()
                  .add(SetNationalityEvent(nationality: ''));
            } else if (personBloc.state.updateStatus ==
                PersonUpdateStatus.error) {
              ScaffoldMessenger.of(context).showSnackBar(
                AppSnackBar.showErrorSnackBar(
                  context,
                  personBloc.state.errorMessage,
                ),
              );
              if (state.isAPITokenError!) {
                callLogoutEvent(context);
              }
            }
          },
        ),
      ],
      child: BlocBuilder<PersonBloc, PersonState>(
        buildWhen: (previous, current) =>
            widget.option == AppLocalizations.of(context)!.save
                ? previous.saveStatus != current.saveStatus
                : previous.updateStatus != current.updateStatus,
        builder: (context, state) {
          return CustomElevatedButtonWidget(
            key: keySaveNavigation,
            buttonText: widget.option == AppLocalizations.of(context)!.save
                ? AppLocalizations.of(context)!.save
                : AppLocalizations.of(context)!.update,
            isSubmitting: personBloc.state.saveStatus ==
                    PersonSaveStatus.submitting ||
                personBloc.state.updateStatus == PersonUpdateStatus.submitting,
            onPressed: () {
              final Person newPerson = Person(
                id: widget.person?.id,
                name: nameController.text,
                dateOfBirth: dobController.text.isNotEmpty
                    ? DateTime.parse(dobController.text)
                    : null,
                nationality: personBloc.state.nationality,
                notes: notesController.text,
                thumbnails: widget.option != AppLocalizations.of(context)!.save
                    ? createThumbnails()
                    : [Thumbnail(thumbnail: widget.thumbnail ?? '')],
              );
              if (nameController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  AppSnackBar.showErrorSnackBar(
                    context,
                    'Name field is required',
                  ),
                );
                return;
              }
              personBloc.add(
                widget.option == AppLocalizations.of(context)!.save
                    ? widget.isNeedsRedirectToMultipleFacesPage
                        ? AddMultiPersonEvent(
                            person: newPerson,
                            isWithCategory: widget.isWithCategory,
                            collectionID: widget.collections.isNotEmpty
                                ? widget.collections[0].id
                                : null,
                          )
                        : AddPersonEvent(
                            person: newPerson,
                            isWithCategory: widget.isWithCategory,
                            collectionID: widget.collections.isNotEmpty
                                ? widget.collections[0].id
                                : null,
                          )
                    : UpdatePersonEvent(
                        person: newPerson,
                      ),
              );
            },
          );
        },
      ),
    );
  }

  Widget buildContent(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        height: 521.h,
        child: Stack(
          children: [
            Positioned(
              top: 24.h,
              left: 0,
              right: 0,
              child: buildNameInput(context),
            ),
            Positioned(
              top: 140.h,
              left: 0,
              right: 0,
              child: DatePickerInput(
                dobController: dobController,
              ),
            ),
            Positioned(
              top: 237.h,
              left: 0,
              right: 0,
              child: ComboBoxInput(
                onSelectCountry: (value) {
                  nationalityController.text = value;
                },
              ),
            ),
            Positioned(
              top: 334.h,
              left: 0,
              right: 0,
              child: buildNotesInput(context),
            ),
            Positioned(
              top: 463.h,
              left: 0,
              right: 0,
              child: buildSaveAndUpdateButton(context, personBloc),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CommonPageBoilerPlate(
      pageBody: buildContent(context),
      commonAppBar: CommonAppBar(
        isCenterTitle: true,
        titleWidget: Text(
           textScaleFactor: 1.0,
          AppLocalizations.of(context)!.face_details,
          style: context.theme.textTheme.titleMedium!.copyWith(
            fontSize: 17.sp,
          ),
        ),
        leadingWidget: CommonBackButtonWidget(
          buttonText: AppLocalizations.of(context)!.back,
        ),
      ),
    );
  }

  void successScreen(String message, bool isFaceLibrary) {
    if (widget.isNeedsRedirectToMultipleFacesPage) {
      Navigator.pushAndRemoveUntil(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            return ImageIdentifyPage(
              base64Image: widget.baseMultipleFacesImage,
              compressBase64Image: widget.compressBase64Image,
              isLivenessCheck: false,
            );
          },
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
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
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return CommonAlert(
              message: message,
              isFaceLibrary: isFaceLibrary,
              baseMultipleFacesImage: widget.baseMultipleFacesImage,
              compressBase64Image: widget.compressBase64Image,
              isNeedsRedirectToMultipleFacesPage:
                  widget.isNeedsRedirectToMultipleFacesPage,
              isUpdate: AppLocalizations.of(context)!.save != widget.option,
              personID: widget.person?.id,
            );
          },
        ),
      );
    }
  }
}
