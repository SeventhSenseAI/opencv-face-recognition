import 'dart:io';

import 'package:camera/camera.dart';

enum CameraStatus {
  cameraInitial,
  cameraReady,
  cameraPicture,
  error,
  initialError,
}

enum ImageUploadStateStatus {
  initial,
  loading,
  success,
  failure,
}

class CameraState {
  final CameraController? controller;
  final String errorMessage;
  final CameraStatus status;
  final String imageBytes;
  final String compressBase64Image;
  final File cameraImageFle;
  final ImageUploadStateStatus? imageUploadStateStatus;

  const CameraState({
    required this.controller,
    required this.errorMessage,
    required this.status,
    required this.imageBytes,
    required this.compressBase64Image,
    required this.cameraImageFle,
    this.imageUploadStateStatus,
  });

  static CameraState initial() => CameraState(
        controller: null,
        errorMessage: '',
        compressBase64Image: "",
        status: CameraStatus.cameraInitial,
        imageBytes: '',
        cameraImageFle: File(""),
        imageUploadStateStatus: ImageUploadStateStatus.initial,
      );

  CameraState copyWith({
    CameraController? controller,
    String? errorMessage,
    CameraStatus? status,
    String? imageBytes,
    String? compressBase64Image,
    File? cameraImageFle,
    ImageUploadStateStatus? imageUploadStateStatus,
    bool? isBack,
  }) {
    return CameraState(
      controller: controller ?? this.controller,
      errorMessage: errorMessage ?? this.errorMessage,
      status: status ?? this.status,
      imageBytes: imageBytes ?? this.imageBytes,
      compressBase64Image: compressBase64Image ?? this.compressBase64Image,
      cameraImageFle: cameraImageFle ?? this.cameraImageFle,
      imageUploadStateStatus:
          imageUploadStateStatus ?? this.imageUploadStateStatus,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CameraState &&
        other.controller == controller &&
        other.errorMessage == errorMessage &&
        other.status == status &&
        other.imageBytes == imageBytes &&
        other.compressBase64Image == compressBase64Image &&
        other.cameraImageFle == cameraImageFle &&
        other.imageUploadStateStatus == imageUploadStateStatus;
  }

  @override
  int get hashCode {
    return controller.hashCode ^
        errorMessage.hashCode ^
        status.hashCode ^
        imageBytes.hashCode ^
        compressBase64Image.hashCode ^
        cameraImageFle.hashCode ^
        imageUploadStateStatus.hashCode;
  }
}
