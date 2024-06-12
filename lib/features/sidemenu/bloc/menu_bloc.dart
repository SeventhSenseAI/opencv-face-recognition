import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:faceapp/core/networking/api_exception.dart';
import 'package:faceapp/features/authentication/data/repository/subscription_repository.dart';
import 'package:faceapp/features/myapi/data/model/sub.dart';
import 'package:faceapp/features/sidemenu/data/model/menu_data.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/error_codes.dart';
import '../../../core/constants/error_messages.dart';

part 'menu_event.dart';
part 'menu_state.dart';

class MenuBloc extends Bloc<MenuEvent, MenuState> {
  MenuBloc() : super(MenuState.initialState()) {
    on<MenuEvent>(
      (event, emit) async => switch (event) {
        InitializeEvent() => _mapInitializeSearchState(event, emit),
        ForceLogOutMenuEvent() => _forceLogOutMenu(event, emit),
      },
    );
  }

  FutureOr<void> _mapInitializeSearchState(
    InitializeEvent event,
    Emitter<MenuState> emit,
  ) async {
    try {
      emit(
        const MenuState(
          errorMessage: '',
          status: MenuStatus.initial,
          deleteAccountStatus: DeleteAccountStatus.processing,
        ),
      );
      MenuData? data = await SubscriptionRepository().deleteAccount();
      if (data!.code == 'DELETED') {
        emit(
          const MenuState(
            errorMessage: '',
            status: MenuStatus.success,
            deleteAccountStatus: DeleteAccountStatus.success,
          ),
        );
      } else {
        emit(
          MenuState(
            deleteAccountStatus: DeleteAccountStatus.error,
            errorMessage: data.message!,
            status: MenuStatus.error,
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
            MenuState(
              isAPITokenError: true,
              errorMessage: e.errorCode == ErrorCodes.expiredSubscription
                  ? ErrorMessage.expiredSubscriptionError
                  : ErrorMessage.accountDeletedError,
              status: MenuStatus.error,
              deleteAccountStatus: DeleteAccountStatus.error,
            ),
          );
          return;
        }

        emit(
          MenuState(
            errorMessage: e.message,
            status: MenuStatus.error,
            deleteAccountStatus: DeleteAccountStatus.error,
          ),
        );
      } else {
        emit(
          MenuState(
            errorMessage: ErrorMessage.somethingWentWrongError,
            status: MenuStatus.error,
            deleteAccountStatus: DeleteAccountStatus.error,
          ),
        );
      }
    } finally {
      emit(
        const MenuState(
          errorMessage: '',
          status: MenuStatus.initial,
          deleteAccountStatus: DeleteAccountStatus.initial,
        ),
      );
    }
  }

  FutureOr<void> _forceLogOutMenu(
    ForceLogOutMenuEvent event,
    Emitter<MenuState> emit,
  ) {
    emit(MenuState.initialState());
  }
}
