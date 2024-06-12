import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';

import '../../../core/constants/error_codes.dart';
import '../../../core/constants/error_messages.dart';
import '../../../core/networking/api_exception.dart';
import '../../../core/services/shared_preferences_service.dart';
import '../data/model/user.dart';
import '../data/repository/search_repository.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchBlocEvent, SearchState> {
  final SearchDataRepository searchDataRepository;
  bool isSpoofing = false;
  SearchBloc({
    required this.searchDataRepository,
  }) : super(SearchState.initialState()) {
    on<SearchBlocEvent>(
      (event, emit) async => switch (event) {
        ImageSearched() => _imageSearched(event, emit),
        SpoofingDetected() => _spoofingDetected(event, emit),
        UpdateRepositories() => _updateRepositories(event, emit),
      },
    );
  }
  FutureOr<void> _imageSearched(
    ImageSearched event,
    Emitter<SearchState> emit,
  ) async {
    emit(
      state.copyWith(
        searchResultStateStatus: SearchResultStateStatus.loading,
        isLivenessCheck: event.isLivenessCheck,
      ),
    );

    try {
      isSpoofing = await SharedPreferencesService.getLiveness();

      List<DetectResponse> result = await searchDataRepository.detectFaces(
        base64Image: event.base64Image,
      );

      if (result.isEmpty) {
        /// noFaceDetected
        emit(
          state.copyWith(
            searchResultStateStatus: SearchResultStateStatus.noFaceDetected,
            compressBase64Image: event.compressBase64Image,
            base64Image: event.base64Image,
          ),
        );
      } else if (result.isNotEmpty) {
        if (result.length == 1 && result.first.persons!.isEmpty) {
          /// unidentified
          emit(
            state.copyWith(
              base64Image: event.base64Image,
              compressBase64Image: event.compressBase64Image,
              searchResultStateStatus: SearchResultStateStatus.unidentified,
            ),
          );
        } else {
          add(
            SpoofingDetected(
              compressBase64Image: event.compressBase64Image,
              result: result,
              base64Image: event.base64Image,
              isSpoofing: isSpoofing,
            ),
          );
        }
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
              spoofingStateStatus: SpoofingStateStatus.failure,
              errorMessage: e.errorCode == ErrorCodes.expiredSubscription
                  ? ErrorMessage.expiredSubscriptionError
                  : ErrorMessage.accountDeletedError,
              base64Image: event.base64Image,
              compressBase64Image: event.compressBase64Image,
            ),
          );
          return;
        }

        /// spoofingDetected
        emit(
          state.copyWith(
            spoofingStateStatus: SpoofingStateStatus.failure,
            errorMessage: e.message,
            base64Image: event.base64Image,
            compressBase64Image: event.compressBase64Image,
          ),
        );
      } else {
        emit(
          state.copyWith(
            spoofingStateStatus: SpoofingStateStatus.failure,
            errorMessage: ErrorMessage.pleasetryAgainError,
            base64Image: event.base64Image,
            compressBase64Image: event.compressBase64Image,
          ),
        );
      }
    }
  }

  FutureOr<void> _spoofingDetected(
    SpoofingDetected event,
    Emitter<SearchState> emit,
  ) async {
    try {
      if (event.result.length == 1) {
        if (!event.isSpoofing) {
          emit(
            state.copyWith(
              searchResultStateStatus: SearchResultStateStatus.identified,
              searchResults: event.result,
              isSpoofingEnabled: event.isSpoofing,
              compressBase64Image: event.compressBase64Image,
            ),
          );
          return;
        }

        /// Identified
        final score = await searchDataRepository.livenessCheck(
          base64Image: event.base64Image,
        );
        if (score >= 0.7) {
          /// liveNoSpoofingDetected
          emit(
            state.copyWith(
              searchResultStateStatus: SearchResultStateStatus.identified,
              spoofingStateStatus: SpoofingStateStatus.liveNoSpoofingDetected,
              searchResults: event.result,
              compressBase64Image: event.compressBase64Image,
              isSpoofingEnabled: event.isSpoofing,
              score: score,
            ),
          );
        } else {
          emit(
            state.copyWith(
              searchResultStateStatus: SearchResultStateStatus.identified,
              spoofingStateStatus: SpoofingStateStatus.spoofingDetected,
              searchResults: event.result,
              isSpoofingEnabled: event.isSpoofing,
              compressBase64Image: event.compressBase64Image,
            ),
          );
        }
      } else {
        /// multipleFacesDetected
        emit(
          state.copyWith(
            searchResultStateStatus:
                SearchResultStateStatus.multipleFacesDetected,
            searchResults: event.result,
            base64Image: event.base64Image,
            compressBase64Image: event.compressBase64Image,
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
              spoofingStateStatus: SpoofingStateStatus.failure,
              errorMessage: e.errorCode == ErrorCodes.expiredSubscription
                  ? ErrorMessage.expiredSubscriptionError
                  : ErrorMessage.accountDeletedError,
              base64Image: event.base64Image,
              compressBase64Image: event.compressBase64Image,
            ),
          );
          return;
        }

        if (e.errorCode == ErrorCodes.restrictedAPI) {
          emit(
            state.copyWith(
              spoofingStateStatus: SpoofingStateStatus.failure,
              errorMessage: ErrorMessage.restrictedAPI,
              base64Image: event.base64Image,
              compressBase64Image: event.compressBase64Image,
            ),
          );
          return;
        }
        emit(
          state.copyWith(
            spoofingStateStatus: SpoofingStateStatus.failure,
            errorMessage: e.message,
            base64Image: event.base64Image,
            compressBase64Image: event.compressBase64Image,
          ),
        );
      } else {
        emit(
          state.copyWith(
            spoofingStateStatus: SpoofingStateStatus.failure,
            errorMessage: ErrorMessage.pleasetryAgainError,
            base64Image: event.base64Image,
            compressBase64Image: event.compressBase64Image,
          ),
        );
      }
    }
  }

  FutureOr<void> _updateRepositories(
    UpdateRepositories event,
    Emitter<SearchState> emit,
  ) {
    searchDataRepository.apiProvider.updateApiKey(event.apiKey, event.token);
    add(
      ImageSearched(
        compressBase64Image: event.compressBase64Image,
        base64Image: event.base64Image,
        isLivenessCheck: event.isLivenessCheck,
      ),
    );
  }
}
