import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/app_paddings.dart';
import '../../../../../core/constants/color_codes.dart';
import '../../../../../core/utils/assets.dart';
import '../../../../../core/widgets/common_elevated_button.dart';
import '../../../../../core/widgets/gap_widgets/vertical_gap_consistent.dart';
import '../../../../category/presentation/category_screen.dart';
import '../../../../dashboard/presentation/home_screen.dart';
import '../../../../person/presentation/view_person_screen.dart';
import '../../../bloc/search_bloc.dart';
import '../../../data/model/user.dart';
import 'bottom_sheet_icon_button_widget.dart';

class BottomSheetBottomPartWidget extends StatelessWidget {
  const BottomSheetBottomPartWidget({
    super.key,
    required this.isSaveBtnActive,
    this.isProfileIconActive = false,
    this.isMultipleFaces = false,
    this.keys,
  });

  final bool isSaveBtnActive;
  final bool isProfileIconActive;
  final bool isMultipleFaces;
  final Key? keys;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            BottomSheetIconButtonWidget(
              onTap: () {
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
              },
              svgIcon: Assets.topCameraIcon,
              text: "Home",
              isSvg: false,
              isBtnActive: true,
            ),
            if (!isMultipleFaces)
              BottomSheetIconButtonWidget(
                key: keys,
                onTap: () {
                  final state = context.read<SearchBloc>().state;
                  final searchBloc = context.read<SearchBloc>();
                  if (isProfileIconActive) {
                    final Person person = state.searchResults![0].persons![0];
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BlocProvider.value(
                          value: searchBloc,
                          child: ViewPersonScreen(
                            compressBase64Image:
                                searchBloc.state.compressBase64Image!,
                            isFaceLibrary: false,
                            baseMultipleFacesImage:
                                searchBloc.state.compressBase64Image!,
                            isNeedsRedirectToMultipleFacesPage: false,
                            personID: person.id!,
                            isSavePerson: false,
                          ),
                        ),
                      ),
                    );
                  }

                  if (!isProfileIconActive) {
                    final thumbnail = state.base64Image;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BlocProvider.value(
                          value: searchBloc,
                          child: CategoryScreen(
                            baseMultipleFacesImage: "",
                            compressBase64Image: "",
                            isNeedsRedirectToMultipleFacesPage: false,
                            thumbnail: thumbnail,
                            isFaceLib: false,
                            isSavePerson: true,
                          ),
                        ),
                      ),
                    );

                    if (state.searchResultStateStatus!.isIdentified) {
                      if (state.spoofingStateStatus!.isLiveNoSpoofingDetected) {
                        settingModalBottomSheet(context);
                      }
                    }
                  }
                },
                svgIcon: isProfileIconActive
                    ? Assets.userRoundedBold
                    : Assets.saveSolid,
                text: isProfileIconActive ? "Profile" : "Enroll",
                isBtnActive: isSaveBtnActive,
              ),
          ],
        ),
      ],
    );
  }

  void settingModalBottomSheet(context) {
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
                children: [
                  Text(
                    textScaleFactor: 1.0,
                    "Already in your face library!",
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
                      Navigator.pop(context);
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
                  "This person is already in your face library. Are you sure you want to save this person again?",
                  style: theme.textTheme.titleSmall!.copyWith(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
              VerticalGapWidget(
                AppPaddings.p32.h,
              ),
              Container(
                height: 53.h,
                width: 361.w,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      ColorCodes.primaryColor,
                      ColorCodes.darkBlueColor,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CustomElevatedButtonWidget(
                  buttonText: "Enroll",
                  onPressed: () {
                    final state = context.read<SearchBloc>().state;
                    final thumbnail = state.base64Image;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CategoryScreen(
                          baseMultipleFacesImage: "",
                          compressBase64Image: "",
                          isNeedsRedirectToMultipleFacesPage: false,
                          thumbnail: thumbnail,
                          isFaceLib: false,
                          isSavePerson: false,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}