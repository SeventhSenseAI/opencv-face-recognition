import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../../core/constants/app_paddings.dart';
import '../../../../../core/widgets/boiler_plate_widgets/common_app_bar.dart';
import '../../../../../core/widgets/boiler_plate_widgets/common_back_button.dart';
import '../../../../../core/widgets/boiler_plate_widgets/common_page_boiler_plate.dart';
import '../../../../../core/widgets/common_snack_bar.dart';
import '../../../../../core/widgets/gap_widgets/vertical_gap_consistent.dart';
import '../../../../../landing_page.dart';
import '../../../../authentication/bloc/auth_bloc/auth_bloc.dart';
import '../../../../category/bloc/category_bloc.dart';
import '../../../../category/bloc/category_event.dart';
import '../../../../person/bloc/person_bloc.dart';
import '../../../../person/bloc/person_event.dart';
import '../../../../sidemenu/bloc/menu_bloc.dart';
import '../../../bloc/compare_photos_bloc.dart';
import 'bottom_scan_button_widget.dart';
import 'photo_add_widget.dart';

class ComparePhotosPageBodyWidget extends StatelessWidget {
  const ComparePhotosPageBodyWidget({
    super.key,
  });

  void _openSettingPage(context) {
    Navigator.of(context).pop();
    openAppSettings();
  }

  showAlertDialog(context, String message) => showCupertinoDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: const Text( textScaleFactor: 1.0,'Permission Denied'),
          content: Text( textScaleFactor: 1.0,message),
          actions: <CupertinoDialogAction>[
            CupertinoDialogAction(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text( textScaleFactor: 1.0,'Cancel'),
            ),
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () => _openSettingPage(context),
              child: const Text( textScaleFactor: 1.0,'Settings'),
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
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
        BlocListener<ComparePhotosBloc, ComparePhotosState>(
          listenWhen: (previous, current) =>
              previous.imageUploadState != current.imageUploadState,
          listener: (context, state) {
            if (state.isNeedPermission!) {
                showAlertDialog(
                  context,
                  'You need to allow "photos" permission to proceed',
                );
            } else {
              if (state.imageUploadState!.isFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  AppSnackBar.showErrorSnackBar(
                    context,
                    state.failureMessage!,
                  ),
                );
              }
            }
          },
        ),
        BlocListener<ComparePhotosBloc, ComparePhotosState>(
          listenWhen: (previous, current) =>
              previous.comparePhotosState != current.comparePhotosState,
          listener: (context, state) {
            if (state.comparePhotosState!.isFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                AppSnackBar.showErrorSnackBar(
                  context,
                  state.failureMessage!,
                ),
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

                  return;
                });
              }
              Navigator.pop(context);
            }
          },
        ),
      ],
      child: CommonPageBoilerPlate(
        commonAppBar: const CommonAppBar(
          leadingWidget: CommonBackButtonWidget(
            buttonText: "Back",
          ),
          titleWidget: Text(
             textScaleFactor: 1.0,
            "Compare",
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
                  Expanded(
                    child: BlocBuilder<ComparePhotosBloc, ComparePhotosState>(
                      buildWhen: (previous, current) =>
                          previous.baseImageFile != current.baseImageFile,
                      builder: (context, state) {
                        return PhotoAddWidget(
                          imageFile: state.baseImageFile,
                          onTap: () {
                            context.read<ComparePhotosBloc>().add(
                                  PickImage(
                                    compareImageType:
                                        CompareImageType.baseImage,
                                  ),
                                );
                          },
                        );
                      },
                    ),
                  ),
                  VerticalGapWidget(
                    AppPaddings.p24.h,
                  ),
                  Expanded(
                    child: BlocBuilder<ComparePhotosBloc, ComparePhotosState>(
                      buildWhen: (previous, current) =>
                          previous.comparisonImageFile !=
                          current.comparisonImageFile,
                      builder: (context, state) {
                        return PhotoAddWidget(
                          imageFile: state.comparisonImageFile,
                          onTap: () {
                            context.read<ComparePhotosBloc>().add(
                                  PickImage(
                                    compareImageType:
                                        CompareImageType.comparisonImage,
                                  ),
                                );
                          },
                        );
                      },
                    ),
                  ),
                  BlocBuilder<ComparePhotosBloc, ComparePhotosState>(
                    buildWhen: (previous, current) =>
                        previous.imageUploadState != current.imageUploadState,
                    builder: (context, state) {
                      return VerticalGapWidget(
                        state.imageUploadState!.isSuccess
                            ? 85.h
                            : AppPaddings.p24.h,
                      );
                    },
                  ),
                ],
              ),
              const BottomScanButtonWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
