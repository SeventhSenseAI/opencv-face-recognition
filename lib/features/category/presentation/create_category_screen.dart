import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/constants/app_paddings.dart';
import '../../../core/utils/extensions.dart';
import '../../../core/widgets/boiler_plate_widgets/common_app_bar.dart';
import '../../../core/widgets/boiler_plate_widgets/common_back_button.dart';
import '../../../core/widgets/boiler_plate_widgets/common_page_boiler_plate.dart';
import '../../../core/widgets/common_elevated_button.dart';
import '../../../core/widgets/common_snack_bar.dart';
import '../../../core/widgets/common_text_field.dart';
import '../../../landing_page.dart';
import '../../authentication/bloc/auth_bloc/auth_bloc.dart';
import '../../person/bloc/person_bloc.dart';
import '../../person/bloc/person_event.dart';
import '../../person/presentation/save_update_person_screen.dart';
import '../../sidemenu/bloc/menu_bloc.dart';
import '../bloc/category_bloc.dart';
import '../bloc/category_event.dart';
import '../bloc/category_state.dart';

class CreateCategoryScreen extends StatefulWidget {
  final String? id;
  final String? thumbnail;
  final bool isFaceLib;
  final String? name;
  final bool isNeedsRedirectToMultipleFacesPage;
  final String baseMultipleFacesImage;
  final String compressBase64Image;
  final bool isSavePerson;

  const CreateCategoryScreen({
    super.key,
    this.id,
    this.thumbnail,
    required this.isFaceLib,
    this.name,
    required this.isNeedsRedirectToMultipleFacesPage,
    required this.baseMultipleFacesImage,
    required this.compressBase64Image,
    required this.isSavePerson,

  });

  @override
  State<CreateCategoryScreen> createState() => _CreateCategoryScreenState();
}

class _CreateCategoryScreenState extends State<CreateCategoryScreen> {
  late TextEditingController categoryNameController;
  late PersonBloc personBloc;

  @override
  void initState() {
    super.initState();
    categoryNameController = TextEditingController();

    personBloc = BlocProvider.of<PersonBloc>(context);
    if (widget.name != null) {
      categoryNameController.text = widget.name ?? "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return CommonPageBoilerPlate(
      pageBody: buildContent(context),
      commonAppBar: CommonAppBar(
        isCenterTitle: true,
        titleWidget: Text(
           textScaleFactor: 1.0,
          widget.id != null
              ? AppLocalizations.of(context)!.update_category
              : AppLocalizations.of(context)!.create_category,
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

  Widget buildTextField(BuildContext context) {
    return CommonTextField(
      controller: categoryNameController,
      fieldName: AppLocalizations.of(context)!.name,
      lines: 1,
      autofocus: true,
    );
  }

  Widget buildCreateButton(BuildContext context) {
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
        BlocListener<CategoryBloc, CategoryState>(
          listenWhen: (previous, current) =>
              previous.saveStatus != current.saveStatus ||
              previous.updateStatus != current.updateStatus,
          listener: (context, state) {
            final categoryBloc = BlocProvider.of<CategoryBloc>(context);
            if (state.saveStatus == CategorySaveStatus.error ||
                state.updateStatus == CategoryUpdateStatus.error) {
              ScaffoldMessenger.of(context).showSnackBar(
                AppSnackBar.showErrorSnackBar(
                  context,
                  state.errorMessage,
                ),
              );
              if (state.isAPITokenError) {
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
              categoryBloc.add(
                ResetCategoryStatus(),
              );
              return;
            }
            if ((!widget.isFaceLib) &&
                categoryBloc.state.saveStatus == CategorySaveStatus.success) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SaveUpdatePersonScreen(
                    baseMultipleFacesImage: widget.baseMultipleFacesImage,
                    compressBase64Image: widget.compressBase64Image,
                    option: AppLocalizations.of(context)!.save,
                    collections: [categoryBloc.state.currentCategory],
                    thumbnail: widget.thumbnail,
                    isWithCategory: true,
                    isNeedsRedirectToMultipleFacesPage:
                        widget.isNeedsRedirectToMultipleFacesPage,
                    isFaceLibrary: widget.isFaceLib,
                    isSavePerson: widget.isSavePerson,
                  ),
                ),
              );
              categoryBloc.add(
                ResetCategoryStatus(),
              );
              return;
            }

            if (widget.isFaceLib &&
                categoryBloc.state.saveStatus == CategorySaveStatus.success) {
              categoryBloc.add(
                ResetCategoryStatus(),
              );
              Navigator.pop(context);
            }
            if (categoryBloc.state.updateStatus ==
                CategoryUpdateStatus.success) {
              categoryBloc.add(
                ResetCategoryStatus(),
              );
              Navigator.pop(context);
            }
          },
        ),
      ],
      child: BlocConsumer<CategoryBloc, CategoryState>(
        bloc: BlocProvider.of<CategoryBloc>(context),
        builder: (context, state) {
          return CustomElevatedButtonWidget(
            isSubmitting: state.saveStatus == CategorySaveStatus.submitting ||
                state.updateStatus == CategoryUpdateStatus.submitting,
            buttonText: widget.id != null
                ? AppLocalizations.of(context)!.update
                : AppLocalizations.of(context)!.save,
            onPressed: () {
              final categoryBloc = BlocProvider.of<CategoryBloc>(context);
              if (widget.id != null) {
                categoryBloc.add(
                  UpdateCategoryEvent(
                    collectionID: widget.id!,
                    collectionName: categoryNameController.text,
                  ),
                );
                return;
              }
              categoryBloc.add(
                AddCategoryEvent(
                  collectionName: categoryNameController.text,
                ),
              );
            },
          );
        },
        listener: (context, state) {},
      ),
    );
  }

  Widget buildContent(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Positioned(
          top: 24.h,
          left: 0,
          right: 0,
          child: buildTextField(context),
        ),
        Positioned(
          bottom: AppPaddings.p24.h,
          left: 0,
          right: 0,
          child: buildCreateButton(context),
        ),
      ],
    );
  }
}
