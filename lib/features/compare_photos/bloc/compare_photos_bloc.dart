import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:faceapp/core/constants/error_messages.dart';
import 'package:flutter/foundation.dart';

import '../../../core/constants/error_codes.dart';
import '../../../core/networking/api_exception.dart';
import '../../../core/utils/image_size_calculator.dart';
import '../data/repository/image_repository.dart';

part 'compare_photos_event.dart';
part 'compare_photos_state.dart';

class ComparePhotosBloc extends Bloc<ComparePhotosEvent, ComparePhotosState> {
  final ImageRepository imageRepository;

  ComparePhotosBloc({
    required this.imageRepository,
  }) : super(ComparePhotosState.initial()) {
    on<ComparePhotosEvent>(
      (event, emit) async => switch (event) {
        PickImage() => _pickImage(event, emit),
        CompareImages() => _compareImages(event, emit),
        UpdateRepositories() => _updateRepositories(event, emit),
      },
    );
  }
  FutureOr<void> _pickImage(
    PickImage event,
    Emitter<ComparePhotosState> emit,
  ) async {
    emit(
      state.copyWith(
        imageUploadState: ImageUploadStateStatus.loading,
      ),
    );
    try {
      if (event.compareImageType.isBaseImage) {
        final result = await imageRepository.pickImageFromGallery();
        if (result.success) {
          if (result.imageFile != null) {
            if (result.imageFile == null) return;

            final baseImageString = await imageRepository.convertImageToBase64(
              imagePath: result.imageFile!.path,
            );

            final isValidate = isImageSizeValidate(baseImageString, emit);
            if (!isValidate) return;
            emit(
              state.copyWith(
                baseImageFile: result.imageFile,
                baseImageString: baseImageString,
                isNeedPermission: false,
              ),
            );
          }
        } else {
          emit(
            state.copyWith(
              baseImageFile: null,
              baseImageString: null,
              isNeedPermission: true,
              imageUploadState: ImageUploadStateStatus.failure,
            ),
          );
        }
      } else {
        final result = await imageRepository.pickImageFromGallery();
        if (result.success) {
          if (result.imageFile != null) {
            if (result.imageFile == null) return;

            final comparisonImageString =
                await imageRepository.convertImageToBase64(
              imagePath: result.imageFile!.path,
            );

            final isValidate = isImageSizeValidate(comparisonImageString, emit);
            if (!isValidate) return;

            emit(
              state.copyWith(
                comparisonImageFile: result.imageFile,
                comparisonImageString: comparisonImageString,
                isNeedPermission: false,
              ),
            );
          }
        } else {
          emit(
            state.copyWith(
              baseImageFile: null,
              baseImageString: null,
              isNeedPermission: true,
              imageUploadState: ImageUploadStateStatus.failure,
            ),
          );
        }
      }

      if (state.baseImageString != "" && state.comparisonImageString != "") {
        emit(
          state.copyWith(
            imageUploadState: ImageUploadStateStatus.success,
          ),
        );
      }
    } catch (e) {
      if (e is ApiException) {
        if (e.errorCode == ErrorCodes.invalidAPIKey ||
            e.errorCode == ErrorCodes.invalidBearToken ||
            e.errorCode == ErrorCodes.expiredSubscription ||
            e.errorCode == ErrorCodes.customerNotFound) {
          emit(
            state.copyWith(
              isAPITokenError: true,
              imageUploadState: ImageUploadStateStatus.failure,
              isNeedPermission: false,
              failureMessage: e.errorCode == ErrorCodes.expiredSubscription
                  ? ErrorMessage.expiredSubscriptionError
                  : ErrorMessage.accountDeletedError,
            ),
          );
          return;
        }

        emit(
          state.copyWith(
            imageUploadState: ImageUploadStateStatus.failure,
            failureMessage: e.message,
            isNeedPermission: false,
          ),
        );
      } else {
        emit(
          state.copyWith(
            imageUploadState: ImageUploadStateStatus.failure,
            failureMessage: ErrorMessage.pleasetryAgainError,
            isNeedPermission: false,
          ),
        );
      }
    }
  }

  FutureOr<void> _compareImages(
    CompareImages event,
    Emitter<ComparePhotosState> emit,
  ) async {
    emit(
      state.copyWith(
        comparePhotosState: ComparePhotosStateStatus.loading,
      ),
    );

    try {
      final comparisonScore = await imageRepository.compareImages(
        baseImageString: state.baseImageString!,
        comparisonImageString: state.comparisonImageString!,
      );

      if (comparisonScore != null && comparisonScore >= 0.7) {
        emit(
          state.copyWith(
            comparePhotosState: ComparePhotosStateStatus.matching,
            comparePercentage: comparisonScore,
          ),
        );
      } else {
        emit(
          state.copyWith(
            comparePhotosState: ComparePhotosStateStatus.notMatching,
            comparePercentage: comparisonScore,
          ),
        );
      }
    } catch (e) {
      if (e is ApiException) {
        if (e.errorCode == ErrorCodes.invalidAPIKey ||
            e.errorCode == ErrorCodes.invalidBearToken ||
            e.errorCode == ErrorCodes.expiredSubscription ||
            e.errorCode == ErrorCodes.customerNotFound) {
          emit(
            state.copyWith(
              isAPITokenError: true,
              comparePhotosState: ComparePhotosStateStatus.failure,
              failureMessage: e.errorCode == ErrorCodes.expiredSubscription
                  ? ErrorMessage.expiredSubscriptionError
                  : ErrorMessage.accountDeletedError,
            ),
          );
          return;
        }

        emit(
          state.copyWith(
            comparePhotosState: ComparePhotosStateStatus.failure,
            failureMessage: e.message,
          ),
        );
      } else {
        emit(
          state.copyWith(
            comparePhotosState: ComparePhotosStateStatus.failure,
            failureMessage: ErrorMessage.pleasetryAgainError,
          ),
        );
      }
    }
  }

  bool isImageSizeValidate(
    String baseImageString,
    Emitter<ComparePhotosState> emit,
  ) {
    final imageSize = imageSizeCalculator(baseImageString);

    if (imageSize > 2) {
      emit(
        state.copyWith(
          imageUploadState: ImageUploadStateStatus.failure,
          failureMessage: 'Maximum allowed image size for upload is 2 MB',
        ),
      );
      emit(
        state.copyWith(
          imageUploadState: ImageUploadStateStatus.initial,
        ),
      );
      return false;
    }
    return true;
  }

  FutureOr<void> _updateRepositories(
    UpdateRepositories event,
    Emitter<ComparePhotosState> emit,
  ) {
    imageRepository.apiProvider.updateApiKey(event.apiKey, event.token);
  }
}
