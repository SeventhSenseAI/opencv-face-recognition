import 'package:faceapp/features/person/presentation/view_person_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../features/dashboard/presentation/home_screen.dart';
import '../../features/search/view/pages/image_identify_page.dart';
import '../constants/app_paddings.dart';
import '../utils/assets.dart';
import '../utils/extensions.dart';
import 'boiler_plate_widgets/common_page_boiler_plate.dart';

class CommonAlert extends StatefulWidget {
  final String message;
  final bool isFaceLibrary;
  final bool isNeedsRedirectToMultipleFacesPage;
  final String baseMultipleFacesImage;
  final String compressBase64Image;
  final bool isUpdate;
  final String? personID;

  const CommonAlert({
    super.key,
    required this.message,
    required this.isFaceLibrary,
    required this.isNeedsRedirectToMultipleFacesPage,
    required this.baseMultipleFacesImage,
    required this.compressBase64Image,
    required this.isUpdate,
    this.personID,
  });

  @override
  State<CommonAlert> createState() => _CommonAlertState();
}

class _CommonAlertState extends State<CommonAlert> {
  @override
  void initState() {
    redirect();
    super.initState();
  }

  Future<void> redirect() async {
    Future.delayed(const Duration(seconds: 3), () {
      if (widget.isUpdate && widget.isFaceLibrary) {
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) {
              return ViewPersonScreen(
                personID: widget.personID!,
                baseMultipleFacesImage: widget.baseMultipleFacesImage,
                compressBase64Image: widget.compressBase64Image,
                isNeedsRedirectToMultipleFacesPage:
                    widget.isNeedsRedirectToMultipleFacesPage,
                isFaceLibrary: widget.isFaceLibrary, isSavePerson: false,
              );
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
        );
        return;
      }
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
        return;
      }
      if (widget.isFaceLibrary) {
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pop(context);
        return;
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
    });
  }

  @override
  Widget build(BuildContext context) {
    return CommonPageBoilerPlate(
      pageBody: Stack(
        children: [
          Positioned(
            top: 0,
            bottom: 0,
            left: 0,
            right: 0,
            child: buildMessage(context),
          ),
        ],
      ),
    );
  }

  Widget buildMessage(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          Assets.alertCheck,
        ),
        SizedBox(
          height: AppPaddings.p24.h,
        ),
        Text(
           textScaleFactor: 1.0,
          widget.message,
          style: context.theme.textTheme.headlineLarge,
        ),
      ],
    );
  }
}
