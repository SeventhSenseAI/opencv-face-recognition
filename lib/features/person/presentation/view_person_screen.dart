// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:faceapp/core/constants/app_paddings.dart';
import 'package:faceapp/core/constants/color_codes.dart';
import 'package:faceapp/core/utils/extensions.dart';
import 'package:faceapp/core/widgets/boiler_plate_widgets/common_app_bar.dart';
import 'package:faceapp/core/widgets/boiler_plate_widgets/common_back_button.dart';
import 'package:faceapp/core/widgets/boiler_plate_widgets/common_page_boiler_plate.dart';
import 'package:faceapp/core/widgets/common_elevated_button.dart';
import 'package:faceapp/core/widgets/common_snack_bar.dart';
import 'package:faceapp/core/widgets/gap_widgets/horizontal_gap_consistent.dart';
import 'package:faceapp/core/widgets/gap_widgets/vertical_gap_consistent.dart';
import 'package:faceapp/features/person/bloc/person_bloc.dart';
import 'package:faceapp/features/person/bloc/person_event.dart';
import 'package:faceapp/features/person/bloc/person_state.dart';
import 'package:faceapp/features/person/presentation/widget/collection_grid.dart';
import 'package:faceapp/features/person/presentation/widget/details_widget.dart';
import 'package:faceapp/features/person/presentation/widget/person_image_picker.dart';
import 'package:faceapp/features/search/data/model/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/widgets/common_alert.dart';
import '../../../landing_page.dart';
import '../../authentication/bloc/auth_bloc/auth_bloc.dart';
import '../../category/bloc/category_bloc.dart';
import '../../category/bloc/category_event.dart';
import '../../sidemenu/bloc/menu_bloc.dart';
import 'save_update_person_screen.dart';

class ViewPersonScreen extends StatefulWidget {
  final String personID;
  final bool isNeedsRedirectToMultipleFacesPage;
  final String baseMultipleFacesImage;
  final String compressBase64Image;
  final bool isFaceLibrary;
  final bool isSavePerson;

  const ViewPersonScreen({
    super.key,
    required this.personID,
    required this.isNeedsRedirectToMultipleFacesPage,
    required this.baseMultipleFacesImage,
    required this.compressBase64Image,
    required this.isFaceLibrary,
    required this.isSavePerson,
  });
  @override
  State<ViewPersonScreen> createState() => _ViewPersonScreenState();
}

class _ViewPersonScreenState extends State<ViewPersonScreen> {
  @override
  void initState() {
    super.initState();
    context.read<PersonBloc>().add(GetPersonEvent(personID: widget.personID));
  }

  Widget buildThumbnails(Person person) {
    List<Widget> customImagePickers = [];

    for (int i = 0; i < 3; i++) {
      String? initialImage = (person.thumbnails?.length ?? 0) > i
          ? person.thumbnails![i].thumbnail
          : null;
      String? initialImageID = (person.thumbnails?.length ?? 0) > i
          ? person.thumbnails![i].id
          : null;
      String? personId = person.id;
      customImagePickers.add(
        CustomImagePicker(
          index: i,
          initialImage: initialImage,
          initialImageID: initialImageID,
          personId: personId,
        ),
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: customImagePickers,
    );
  }

  Widget buildEditDetailsButton(BuildContext context, Person person) {
    return CustomElevatedButtonWidget(
      buttonText: AppLocalizations.of(context)!.edit_details,
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SaveUpdatePersonScreen(
              baseMultipleFacesImage: widget.baseMultipleFacesImage,
              isNeedsRedirectToMultipleFacesPage:
                  widget.isNeedsRedirectToMultipleFacesPage,
              option: AppLocalizations.of(context)!.edit_details,
              person: person,
              collections: person.collections ?? [],
              base64Images: null,
              isWithCategory: false,
              compressBase64Image: widget.compressBase64Image,
              isFaceLibrary: widget.isFaceLibrary,
              isSavePerson: widget.isSavePerson,
            ),
          ),
        );
      },
    );
  }

  void _settingModalBottomSheet(context, Person person) {
    String name = person.name!;

    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        ThemeData theme = Theme.of(context);
        return Container(
          color: ColorCodes.secondaryColor,
          padding: EdgeInsets.all(16.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  HorizontalGapWidget(AppPaddings.p36.w),
                  Text(
                    textScaleFactor: 1.0,
                    AppLocalizations.of(context)!.delete_person,
                    style: theme.textTheme.titleSmall!.copyWith(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
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
              buildDeleteButton(context, person),
              VerticalGapWidget(
                AppPaddings.p32.h,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildDeleteButton(BuildContext context, Person person) {
    PersonBloc personBloc = BlocProvider.of<PersonBloc>(context);

    return BlocListener<PersonBloc, PersonState>(
      listenWhen: (previous, current) =>
          previous.deleteStatus != current.deleteStatus,
      listener: (context, state) {
        if (state.deleteStatus == PersonDeleteStatus.success) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return CommonAlert(
                  message: "Deleted!",
                  isFaceLibrary: widget.isFaceLibrary,
                  baseMultipleFacesImage: widget.baseMultipleFacesImage,
                  compressBase64Image: widget.compressBase64Image,
                  isNeedsRedirectToMultipleFacesPage:
                      widget.isNeedsRedirectToMultipleFacesPage,
                  isUpdate: false,
                );
              },
            ),
          );
          context.read<PersonBloc>().add(ResetStateEvent());
        }
      },
      child: CustomElevatedButtonWidget(
        buttonText: AppLocalizations.of(context)!.delete_person,
        isDeleteAction: true,
        onPressed: () {
          personBloc.add(
            DeletePersonEvent(
              personId: person.id!,
            ),
          );
        },
      ),
    );
  }

  Widget buildDeleteDetailsButton(BuildContext context, Person person) {
    return CustomElevatedButtonWidget(
      buttonText: AppLocalizations.of(context)!.delete_person,
      isDeleteAction: true,
      onPressed: () {
        _settingModalBottomSheet(context, person);
      },
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

  Widget buildContent(BuildContext context, Person person) {
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
              previous.deleteimageStatus != current.deleteimageStatus,
          listener: (context, state) {
            if (state.deleteimageStatus == PersonImageDeleteStatus.error) {
              ScaffoldMessenger.of(context).showSnackBar(
                AppSnackBar.showErrorSnackBar(
                  context,
                  state.errorMessage,
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
              previous.imageUploadStatus != current.imageUploadStatus,
          listener: (context, state) {
            if (state.imageUploadStatus == ImageUploadStatus.failure) {
              ScaffoldMessenger.of(context).showSnackBar(
                AppSnackBar.showErrorSnackBar(
                  context,
                  state.errorMessage,
                ),
              );
            }
          },
        ),
        BlocListener<PersonBloc, PersonState>(
          listenWhen: (previous, current) =>
              previous.uploadImageStatus != current.uploadImageStatus,
          listener: (context, state) {
            if (state.uploadImageStatus == PersonImageUploadStatus.error) {
              ScaffoldMessenger.of(context).showSnackBar(
                AppSnackBar.showErrorSnackBar(
                  context,
                  state.errorMessage,
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
      ],
      child: Stack(
        children: [
          Positioned(
            top: AppPaddings.p16.h,
            left: 0,
            right: 0,
            child: buildThumbnails(person),
          ),
          Positioned(
            top: 155.h,
            left: 0,
            child: Details(
              title: AppLocalizations.of(context)!.birthday,
              value: person.dateOfBirth != null
                  ? person.dateOfBirth!.toIso8601String().split('T').first
                  : "",
            ),
          ),
          Positioned(
            top: 155.h,
            left: 206.w,
            child: Details(
              title: AppLocalizations.of(context)!.nationality,
              value: person.nationality ?? "",
            ),
          ),
          Positioned(
            top: 222.h,
            left: 0,
            right: 0,
            bottom: 170.h,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Details(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    title: AppLocalizations.of(context)!.notes,
                    value: person.notes ?? "",
                  ),
                  VerticalGapWidget(
                    AppPaddings.p32.h,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        textScaleFactor: 1.0,
                        'Collections',
                        style: context.theme.textTheme.titleSmall!.copyWith(
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      CollectionGrid(
                        personID: widget.personID,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: AppPaddings.p24.h,
            left: 0,
            right: 0,
            child: buildDeleteDetailsButton(context, person),
          ),
          Positioned(
            bottom: 89.h,
            left: 0,
            right: 0,
            child: buildEditDetailsButton(context, person),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CommonPageBoilerPlate(
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
      pageBody: BlocBuilder<PersonBloc, PersonState>(
        buildWhen: (previous, current) =>
            previous.personStatus != current.personStatus,
        builder: (context, state) {
          if (state.personStatus == FetchPersonStatus.submitting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.personStatus == FetchPersonStatus.success) {
            final personValue = context.read<PersonBloc>().state.personDetail!;
            context.read<CategoryBloc>().add(
                  UpdateSelectedCollections(
                    selectedCollections: personValue.collections ?? [],
                  ),
                );
            context.read<CategoryBloc>().add(
                  UpdateSelectedCollectionsPopup(
                    selectedCollections: personValue.collections ?? [],
                  ),
                );
            return buildContent(context, personValue);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
