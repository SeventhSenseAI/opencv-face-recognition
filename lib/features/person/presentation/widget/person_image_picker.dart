// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dotted_border/dotted_border.dart';
import 'package:faceapp/core/constants/app_paddings.dart';
import 'package:faceapp/features/person/bloc/person_bloc.dart';
import 'package:faceapp/features/person/bloc/person_event.dart';
import 'package:faceapp/features/person/bloc/person_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../core/constants/color_codes.dart';
import '../../../../core/utils/assets.dart';
import '../../../../core/utils/image_picker.dart';
import '../../../../core/widgets/common_snack_bar.dart';

class CustomImagePicker extends StatefulWidget {
  final int index;
  final String? initialImage;
  final String? initialImageID;
  final String? personId;

  const CustomImagePicker({
    super.key,
    required this.index,
    this.initialImage,
    this.initialImageID,
    this.personId,
  });

  @override
  CustomImagePickerState createState() => CustomImagePickerState();
}

class CustomImagePickerState extends State<CustomImagePicker> {
  File? _image;
  List<int>? _initialImage;
  String imageID = "";
  bool isImageUpload = false;
  @override
  void initState() {
    super.initState();
    if (widget.initialImage != null) {
      imageID = widget.initialImageID!;
      _initialImage = base64Decode(widget.initialImage!);
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
          title: const Text(textScaleFactor: 1.0, 'Permission Denied'),
          content: Text(textScaleFactor: 1.0, message),
          actions: <CupertinoDialogAction>[
            CupertinoDialogAction(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(textScaleFactor: 1.0, 'Cancel'),
            ),
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () => _openSettingPage(),
              child: const Text(textScaleFactor: 1.0, 'Settings'),
            ),
          ],
        ),
      );

  Future<void> _pickImage() async {
    ImagePickerService.pickImageFromGallery().then((value) async {
      if (value.success) {
        if (value.imageFile != null) {
          isImageUpload = true;
          context.read<PersonBloc>().add(ResetStateEvent());
          _image = value.imageFile;

          String imageString =
              ImageConverterService.encodeImageToBase64(value.imageFile!);
          context.read<PersonBloc>().add(
                ManageImageUpload(
                  image: imageString,
                ),
              );
        }
      } else {
        var status = await Permission.photos.status;
        if (status.isDenied) {
          showAlertDialog(
            context,
            'You need to allow "photos" permission to proceed',
          );
        }
      }
    });
  }

  void _closeImage() {
    context.read<PersonBloc>().add(
          DeletePersonImageEvent(
            personId: widget.personId!,
            thumnailID: imageID,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<PersonBloc, PersonState>(
          listenWhen: (previous, current) =>
              previous.deleteimageStatus != current.deleteimageStatus,
          listener: (context, state) {
            if (state.deleteimageStatus == PersonImageDeleteStatus.error) {
              context.read<PersonBloc>().add(ResetStateEvent());
            } else if (state.deleteimageStatus ==
                PersonImageDeleteStatus.success) {
              if (state.deleteImageId == imageID) {
                setState(() {
                  _image = null;
                  _initialImage = null;
                });
              }
            }
          },
        ),
        BlocListener<PersonBloc, PersonState>(
          listenWhen: (previous, current) =>
              previous.uploadImageStatus != current.uploadImageStatus,
          listener: (context, state) {
            if (state.uploadImageStatus == PersonImageUploadStatus.error) {
              context.read<PersonBloc>().add(ResetStateEvent());
              setState(() {
                _image = null;
              });
            } else if (state.uploadImageStatus ==
                PersonImageUploadStatus.success) {
              if (state.updateImageIndex == widget.index) {
                setState(() {
                  imageID = state.imageId;
                });
              }
            }
          },
        ),
        BlocListener<PersonBloc, PersonState>(
          listenWhen: (previous, current) =>
              previous.imageUploadStatus != current.imageUploadStatus,
          listener: (context, state) async {
            if (state.imageUploadStatus == ImageUploadStatus.failure) {
              _image = null;
            } else if (state.imageUploadStatus == ImageUploadStatus.success) {
              if (isImageUpload) {
                isImageUpload = false;
              String imageString =
                  ImageConverterService.encodeImageToBase64(_image!);
              context.read<PersonBloc>().add(
                    UpdatePersonImageEvent(
                      images: [imageString],
                      personId: widget.personId!,
                      imageIndex: widget.index,
                    ),
                  );
              setState(() {
                _initialImage = null;
              });
              }

            }
          },
        ),
      ],
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          DottedBorder(
            color: ColorCodes.whiteColor.withOpacity(0.2),
            strokeWidth: 1,
            dashPattern: const [4],
            borderType: BorderType.RRect,
            radius: Radius.circular(5.r),
            child: Material(
              borderRadius: BorderRadius.all(Radius.circular(5.r)),
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.all(Radius.circular(5.r)),
                splashColor: ColorCodes.whiteColor.withOpacity(0.1),
                highlightColor: Colors.transparent,
                child: GestureDetector(
                  onTap: () => _image != null || _initialImage != null
                      ? {}
                      : _pickImage(),
                  child: Container(
                    width: 107.w,
                    height: 107.w,
                    decoration: ShapeDecoration(
                      color: const Color(0x66212121),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      shadows: const [
                        BoxShadow(
                          color: Color(0x0C000000),
                          blurRadius: 100,
                          offset: Offset(0, 0),
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: Center(
                      child: _image == null && _initialImage == null
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  Assets.solarGallerySendBoldSvg,
                                  fit: BoxFit.fill,
                                  colorFilter: const ColorFilter.mode(
                                    ColorCodes.whiteColor,
                                    BlendMode.srcIn,
                                  ),
                                  width: AppPaddings.p36.w,
                                  height: AppPaddings.p36.h,
                                ),
                              ],
                            )
                          : _initialImage == null
                              ? Image.file(
                                  File(_image!.path),
                                  fit: BoxFit.fill,
                                )
                              : Image.memory(
                                  Uint8List.fromList(
                                    _initialImage!,
                                  ),
                                  fit: BoxFit.cover,
                                ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (_image != null || _initialImage != null)
            GestureDetector(
              onTap: _closeImage,
              child: const Icon(Icons.close, color: ColorCodes.whiteColor),
            ),
        ],
      ),
    );
  }
}
