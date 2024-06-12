import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:faceapp/core/utils/extensions.dart';
import 'package:faceapp/core/widgets/boiler_plate_widgets/common_page_boiler_plate.dart';
import 'package:faceapp/features/sidemenu/bloc/menu_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:page_transition/page_transition.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import '../../../core/constants/color_codes.dart';
import '../../../core/services/shared_preferences_service.dart';
import '../../../core/utils/assets.dart';
import '../../../core/utils/image_picker.dart';
import '../../../core/utils/image_size_calculator.dart';
import '../../../core/widgets/common_snack_bar.dart';
import '../../search/view/pages/image_identify_page.dart';
import '../../sidemenu/presentation/side_menu_screen.dart';
import '../bloc/camera_bloc.dart';
import '../bloc/camera_event.dart';
import '../bloc/camera_state.dart';
import '../widget/circle_widget.dart';
import '../widget/image_button.dart';

bool isBackCameraEnabled = true;

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CameraBloc>(
      create: (context) => CameraBloc(),
      child: const HomeScreenBody(),
    );
  }
}

class HomeScreenBody extends StatefulWidget {
  const HomeScreenBody({super.key});

  @override
  State<HomeScreenBody> createState() => _HomeScreenBodyState();
}

class _HomeScreenBodyState extends State<HomeScreenBody>
    with WidgetsBindingObserver {
  late CameraBloc _cameraBloc;
  final List<double> zoomItem = [0.5, 1, 2, 3];
  int selectedIndex = 1;
  String selectedText = "1";
  bool _isTakeImage = false;
  bool _isTapToggle = true;
  bool _isCameraDispose = false;
  bool _isCameraPermission = true;
  bool _isBackCamEnable = true;
  late TutorialCoachMark tutorialCoachMark;

  GlobalKey keyBottomNavigation = GlobalKey();
  bool _isFirstTime = true;

  @override
  void initState() {
    super.initState();
    setupOnboard();
    _cameraBloc = BlocProvider.of<CameraBloc>(context);
    WidgetsBinding.instance.addObserver(this);
    _initCameraAsync();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _initCameraAsync();
    } else if (state == AppLifecycleState.paused) {
      _isCameraDispose = true;
      _cameraBloc.add(DisposeCamera());
    }
  }

  Future<void> setupOnboard() async {
    _isFirstTime = await SharedPreferencesService.getLogin();
    if (!_isFirstTime) {
      Future.delayed(const Duration(milliseconds: 260), () {
        createTutorial();
        showTutorial();
        SharedPreferencesService.setLogin(true);
      });
    }
  }

  void showTutorial() {
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
        identify: "keyBottomNavigation",
        keyTarget: keyBottomNavigation,
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
                    "Tap here to capture a facial image for enrollment and recognition.",
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

  Future<void> _initCameraAsync() async {
    try {
      if (!isBackCameraEnabled) {
        _isBackCamEnable = !isBackCameraEnabled;
        _toggleCamera();
      } else {
        _cameraBloc.add(InitializeCamera());
      }
    } catch (e) {
      log("Error initializing camera: $e");
    }
  }

  void _openSettingPage() {
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
              onPressed: () => _openSettingPage(),
              child: const Text( textScaleFactor: 1.0,'Settings'),
            ),
          ],
        ),
      );

  Future<void> openGallery() async {
    _isCameraPermission = true;
    ImagePickResult? result = await ImagePickerService.pickImageFromGallery();
    if (result.success) {
      if (result.imageFile != null) {
        String base64String =
            ImageConverterService.encodeImageToBase64(result.imageFile!);
        final imageFile = isImageSizeValidate(base64String);
        if (!imageFile) return;
        final compressedImage =
            await ImagePickerService.compressImageAndGetBase64(
          result.imageFile!,
        );
        pushToNext(
          base64String: base64String,
          compressBase64Image: compressedImage,
          isSpoofing: false,
          imageXFile: result.imageFile!,
        );
      }
    } else {
      var status = await Permission.photos.status;
      if (status.isDenied && _isCameraPermission) {
        _isCameraPermission = false;
          showAlertDialog(
            context,
            'You need to allow "photos" permission to proceed',
          );
      }
    }
  }

  bool isImageSizeValidate(
    String baseImageString,
  ) {
    final imageSize = imageSizeCalculator(baseImageString);

    if (imageSize > 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        AppSnackBar.showErrorSnackBar(
          context,
          'Maximum allowed image size for upload is 4 MB',
        ),
      );
      return false;
    }
    return true;
  }

  void _sideMenuNavigation() {
    Navigator.push(
      context,
      PageTransition(
        type: PageTransitionType.leftToRight,
        duration: const Duration(milliseconds: 500),
        child: SideMenuProvider(
          child: const SideMenuScreen(),
        ),
      ),
    );
  }

  void pushToNext({
    String? base64String,
    String? compressBase64Image,
    bool? isSpoofing,
    File? imageXFile,
  }) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ImageIdentifyPage(
          compressBase64Image: compressBase64Image!,
          base64Image: base64String!,
          isLivenessCheck: false,
          // imageXFile: imageXFile!,
        ),
      ),
    );
  }

  void _toggleCamera() async {
    selectedIndex = 1;
    if (_isTapToggle) {
      _isCameraDispose = true;
      _isTapToggle = false;
      _isCameraPermission = true;
      _cameraBloc.add(ToggleCamera());
      _isBackCamEnable = !_isBackCamEnable;
      isBackCameraEnabled = _isBackCamEnable;
    }
  }

  void _takeCameraImage() async {
    _isTakeImage = false;
    _cameraBloc.add(TakePicture());
  }

  Widget setScreenButton() {
    return Stack(
      children: [
        Positioned(
          top: 70.h,
          left: 16.w,
          child: ImageButton(
            imagePath: Assets.sideMenu,
            onPressed: _sideMenuNavigation,
            width: 48.h,
            height: 48.h,
            isEnabled: true,
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 106.h,
            color: ColorCodes.secondaryColor,
          ),
        ),
        Positioned(
          bottom: 25.h,
          left: 35.w,
          child: ImageButton(
            imagePath: Assets.gallery,
            onPressed: openGallery,
            width: 53.h,
            height: 53.h,
            isEnabled: true,
          ),
        ),
        Positioned(
          bottom: 40.h,
          left: MediaQuery.of(context).size.width / 2 - 50.w,
          child: ImageButton(
            key: keyBottomNavigation,
            imagePath: Assets.camera,
            onPressed: _takeCameraImage,
            width: 100.w,
            height: 100.w,
            isEnabled: true,
          ),
        ),
        Positioned(
          bottom: 25.h,
          right: 35.w,
          child: ImageButton(
            imagePath: Assets.toggle,
            onPressed: _toggleCamera,
            width: 53.h,
            height: 53.h,
            isEnabled: true,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    final size = MediaQuery.of(context).size;

    return MultiBlocListener(
      listeners: [
        BlocListener<CameraBloc, CameraState>(
          listenWhen: (previous, current) =>
              previous.imageBytes != current.imageBytes,
          listener: (context, state) async {
            if (state.status == CameraStatus.cameraPicture) {
              if (!_isTakeImage) {
                _isTakeImage = true;
                bool isSpoofing = await SharedPreferencesService.getLiveness();
                pushToNext(
                  base64String: state.imageBytes,
                  isSpoofing: isSpoofing,
                  compressBase64Image: state.compressBase64Image,
                  imageXFile: state.cameraImageFle,
                );
              }
            } else if (state.status == CameraStatus.error) {}
          },
        ),
        BlocListener<CameraBloc, CameraState>(
          listenWhen: (previous, current) => previous.status != current.status,
          listener: (context, state) async {
            if (state.status == CameraStatus.initialError) {
              var cameraStatus = await Permission.camera.status;
              if ((cameraStatus.isDenied) && _isCameraPermission) {
                _isCameraPermission = false;
                  showAlertDialog(
                    context,
                    'You need to allow "camera" permission to proceed',
                  );
              }
            }
          },
        ),
        BlocListener<CameraBloc, CameraState>(
          listenWhen: (previous, current) =>
              previous.imageUploadStateStatus != current.imageUploadStateStatus,
          listener: (context, state) {
            if (state.imageUploadStateStatus ==
                ImageUploadStateStatus.failure) {
              ScaffoldMessenger.of(context).showSnackBar(
                AppSnackBar.showErrorSnackBar(
                  context,
                  state.errorMessage,
                ),
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
            BlocBuilder<CameraBloc, CameraState>(
              builder: (context, state) {
                if ((state.status == CameraStatus.cameraReady) &&
                    (state.controller != null)) {
                  _isCameraDispose = false;
                  _isTapToggle = true;
                  if (!_isCameraDispose) {
                    return Stack(
                      children: [
                        ClipRect(
                          child: OverflowBox(
                            alignment: Alignment.center,
                            child: FittedBox(
                              fit: BoxFit.fitHeight,
                              child: SizedBox(
                                width: size.width,
                                height: size.width *
                                    state.controller!.value.aspectRatio,
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: <Widget>[
                                    CameraPreview(state.controller!),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 180.h,
                          left: MediaQuery.of(context).size.width / 2 - 79.w,
                          child: Stack(
                            children: [
                              Container(
                                width: 157.w,
                                height: 45.h,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(23.h),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(23.h),
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(
                                      sigmaX: 5.0,
                                      sigmaY: 5.0,
                                    ),
                                    child: Container(
                                      color:
                                          ColorCodes.blackColor.withOpacity(.3),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 0,
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    for (int i = 0; i < zoomItem.length; i++)
                                      CircleWidget(
                                        isSelected: i == selectedIndex,
                                        text: i == selectedIndex
                                            ? '${i == 0 ? '${zoomItem[i]}' : '${zoomItem[i].round()}'}x'
                                            : i == 0
                                                ? '${zoomItem[i]}'
                                                : '${zoomItem[i].round()}',
                                        onTap: () {
                                          setState(() {
                                            selectedIndex = i;
                                            _cameraBloc.add(
                                              UpdateZoomLevel(
                                                (selectedIndex) {
                                                  switch (selectedIndex) {
                                                    case 0:
                                                      return 1.0;
                                                    case 1:
                                                      return 1.5;
                                                    case 2:
                                                      return 2.0;
                                                    case 3:
                                                      return 2.5;
                                                    default:
                                                      return 1.0;
                                                  }
                                                }(selectedIndex),
                                              ),
                                            );
                                          });
                                        },
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
            setScreenButton(),
          ],
        ),
      ),
    );
  }
}
