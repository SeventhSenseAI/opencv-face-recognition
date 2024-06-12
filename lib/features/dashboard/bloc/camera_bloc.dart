import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';
import 'package:synchronized/synchronized.dart';

import '../../../core/services/shared_preferences_service.dart';
import '../../../core/utils/image_picker.dart';
import '../../../core/utils/image_size_calculator.dart';
import 'camera_event.dart';
import 'camera_state.dart';

class CameraBloc extends Bloc<CameraEvent, CameraState> {
  CameraController? _cameraController;
  final _lock = Lock();

  CameraBloc() : super(CameraState.initial()) {
    on<InitializeCamera>(
      (event, emit) => _mapInitializeCameraToState(event, emit),
    );
    on<ToggleCamera>((event, emit) => _mapToggleCameraToState(event, emit));
    on<TakePicture>((event, emit) => _mapTakePictureToState(event, emit));
    on<DisposeCamera>((event, emit) => _mapDisposeCameraToState(event, emit));
    on<UpdateZoomLevel>(
      (event, emit) => _mapUpdateZoomLevelToState(event, emit),
    );
  }

  FutureOr<void> _mapUpdateZoomLevelToState(
    UpdateZoomLevel event,
    Emitter<CameraState> emit,
  ) async {
    try {
      _cameraController?.setZoomLevel(event.zoomLevel);
      emit(
        CameraState(
          controller: _cameraController,
          errorMessage: '',
          status: CameraStatus.cameraReady,
          imageBytes: '',
          compressBase64Image: '',
          cameraImageFle: File(""),
        ),
      );
    } catch (e) {
      // Handle exception
      print('Error in _mapUpdateZoomLevelToState: $e');
    }
  }

  FutureOr<void> _mapInitializeCameraToState(
    InitializeCamera event,
    Emitter<CameraState> emit,
  ) async {
    try {
      emit(
        CameraState(
          controller: null,
          errorMessage: '',
          status: CameraStatus.cameraInitial,
          imageBytes: '',
          compressBase64Image: '',
          cameraImageFle: File(""),
        ),
      );

      await _lock.synchronized(() async {
        final cameras = await availableCameras();
        final firstCamera = cameras.first;
        _cameraController = CameraController(
          firstCamera,
          ResolutionPreset.medium,
          enableAudio: false,
        );
        await _cameraController!.initialize();
      });

      emit(
        CameraState(
          controller: _cameraController,
          errorMessage: '',
          status: CameraStatus.cameraReady,
          imageBytes: '',
          compressBase64Image: '',
          cameraImageFle: File(""),
        ),
      );
      add(UpdateZoomLevel(1.5));
    } catch (e) {
      emit(
        CameraState(
          controller: null,
          errorMessage: 'Error initializing camera: $e',
          status: CameraStatus.initialError,
          imageBytes: '',
          compressBase64Image: '',
          cameraImageFle: File(""),
        ),
      );
    }
  }

  FutureOr<void> _mapToggleCameraToState(
    ToggleCamera event,
    Emitter<CameraState> emit,
  ) async {
    try {
      emit(
        CameraState(
          controller: null,
          errorMessage: '',
          status: CameraStatus.cameraInitial,
          imageBytes: '',
          compressBase64Image: '',
          cameraImageFle: File(""),
        ),
      );

      await _lock.synchronized(() async {
        if (_cameraController != null) {
          await _cameraController!.dispose();
          final newCamera = (await availableCameras()).firstWhere(
            (c) =>
                c.lensDirection != _cameraController!.description.lensDirection,
          );
          _cameraController = CameraController(
            newCamera,
            ResolutionPreset.medium,
            enableAudio: false,
          );
          await _cameraController!.initialize();
        } else {
          final cameras = await availableCameras();
          final frontCamera = cameras.firstWhere(
            (camera) => camera.lensDirection == CameraLensDirection.front,
            orElse: () => cameras.first,
          );
          _cameraController = CameraController(
            frontCamera,
            ResolutionPreset.medium,
            enableAudio: false,
          );
          await _cameraController!.initialize();
        }
      });

      emit(
        CameraState(
          controller: _cameraController,
          errorMessage: '',
          status: CameraStatus.cameraReady,
          imageBytes: '',
          compressBase64Image: '',
          cameraImageFle: File(""),
        ),
      );
      add(UpdateZoomLevel(1.5));
    } catch (e) {
      emit(
        CameraState(
          controller: null,
          errorMessage: 'Error toggling camera:  $e',
          status: CameraStatus.initialError,
          imageBytes: '',
          compressBase64Image: '',
          cameraImageFle: File(""),
        ),
      );
    }
  }

  FutureOr<void> _mapTakePictureToState(
    TakePicture event,
    Emitter<CameraState> emit,
  ) async {
    try {
      final image = await _cameraController!.takePicture();
      String base64String =
          await ImagePickerService.convertImageToBase64(image.path);

      final isValidate = isImageSizeValidate(base64String, emit);
      if (!isValidate) return;

      final compressedImage =
          await ImagePickerService.compressImageAndGetBase64(File(image.path));

      emit(
        CameraState(
          controller: _cameraController,
          errorMessage: '',
          status: CameraStatus.cameraPicture,
          imageBytes: base64String,
          compressBase64Image: compressedImage!,
          cameraImageFle: File(image.path),
        ),
      );
    } catch (e) {
      emit(
        CameraState(
          controller: null,
          errorMessage: 'Error taking picture: $e',
          status: CameraStatus.error,
          imageBytes: '',
          compressBase64Image: '',
          cameraImageFle: File(""),
        ),
      );
    }
  }

  FutureOr<void> _mapDisposeCameraToState(
    DisposeCamera event,
    Emitter<CameraState> emit,
  ) async {
    try {
      await _lock.synchronized(() async {
        await _cameraController!.dispose();
      });
      emit(
        CameraState(
          controller: null,
          errorMessage: '',
          status: CameraStatus.cameraInitial,
          imageBytes: '',
          compressBase64Image: '',
          cameraImageFle: File(""),
        ),
      );
    } catch (e) {
      emit(
        CameraState(
          controller: null,
          errorMessage: 'Error disposing camera: $e',
          status: CameraStatus.error,
          imageBytes: '',
          compressBase64Image: '',
          cameraImageFle: File(""),
        ),
      );
    }
  }

  bool isImageSizeValidate(
    String baseImageString,
    Emitter<CameraState> emit,
  ) {
    try {
      final imageSize = imageSizeCalculator(baseImageString);

      if (imageSize > 4) {
        emit(
          state.copyWith(
            imageUploadStateStatus: ImageUploadStateStatus.failure,
            errorMessage: 'Maximum allowed image size for upload is 4MB',
          ),
        );
        emit(
          state.copyWith(
            imageUploadStateStatus: ImageUploadStateStatus.initial,
            errorMessage: "",
          ),
        );
        return false;
      }
      return true;
    } catch (e) {
      print('Error in isImageSizeValidate: $e');
      return false;
    }
  }
}
