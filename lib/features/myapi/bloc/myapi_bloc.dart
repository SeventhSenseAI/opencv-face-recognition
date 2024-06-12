// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:faceapp/core/networking/api_exception.dart';
import 'package:faceapp/features/authentication/data/repository/subscription_repository.dart';
import 'package:faceapp/features/myapi/data/model/sub.dart';

import '../../../core/constants/error_codes.dart';
import '../../../core/constants/error_messages.dart';

part 'myapi_event.dart';
part 'myapi_state.dart';

class MyapiBloc extends Bloc<MyapiEvent, MyapiState> {
  MyapiBloc() : super(MyapiState.initialState()) {
    on<InitializeSearch>(
      (event, emit) => _mapInitializeSearchState(event, emit),
    );
    on<BuySubscription>((event, emit) => _mapBuySubscriptionState(event, emit));
  }

  FutureOr<void> _mapInitializeSearchState(
    InitializeSearch event,
    Emitter<MyapiState> emit,
  ) async {
    try {
      emit(
        const MyapiState(
          errorMessage: '',
          status: MyapiStatus.initial,
          subscription: null,
        ),
      );
      Subscription? subscription =
          await SubscriptionRepository().getSubscriptionDetails();
      String customerType = _mapCustomerType(subscription!.customerType);

      emit(
        MyapiState(
          errorMessage: '',
          status: MyapiStatus.fetchSubscription,
          subscription: subscription,
          customerType: customerType,
        ),
      );
    } catch (e) {
      if (e is ApiException) {
        if (e.errorCode == ErrorCodes.invalidAPIKey ||
            e.errorCode == ErrorCodes.invalidBearToken ||
            e.errorCode == ErrorCodes.expiredSubscription ||
            e.errorCode == ErrorCodes.customerNotFound) {
          emit(
            MyapiState(
              isAPITokenError: true,
              errorMessage: e.errorCode == ErrorCodes.expiredSubscription
                  ? ErrorMessage.expiredSubscriptionError
                  : ErrorMessage.accountDeletedError,
              status: MyapiStatus.error,
              subscription: null,
            ),
          );
          return;
        }
        emit(
          MyapiState(
            errorMessage: e.message,
            status: MyapiStatus.error,
            subscription: null,
          ),
        );
      } else {
        emit(
          MyapiState(
            errorMessage: ErrorMessage.somethingWentWrongError,
            status: MyapiStatus.error,
            subscription: null,
          ),
        );
      }
    }
  }

  String _mapCustomerType(String? type) {
    final Map<String, String> typeMap = {
      'FREE': 'Free',
      'STARTER': 'Starter',
      'TRIALBU': '30 Days Trial',
      'TRIAL': '15 Days Trial',
      'BASIC': 'Basic',
      'BASIC_LIVENESS': 'Basic + Liveness',
      'STANDARD2': 'Standard',
      'STANDARD2_LIVENESS': 'Standard + Liveness',
      'ENTERPRISE': 'Enterprise',
      'ENTERPRISE_LIVENESS': 'Enterprise + Liveness',
    };
    return typeMap[type] ?? 'Custom';
  }

  FutureOr<void> _mapBuySubscriptionState(
    BuySubscription event,
    Emitter<MyapiState> emit,
  ) async {
    try {
      emit(
        const MyapiState(
          errorMessage: '',
          status: MyapiStatus.initial,
          subscription: null,
        ),
      );
      Subscription? subscription =
          await SubscriptionRepository().buySubscription(event.productId);
      emit(
        MyapiState(
          errorMessage: '',
          status: MyapiStatus.fetchSubscription,
          subscription: subscription,
        ),
      );
    } catch (e) {
      if (e is ApiException) {
        if (e.errorCode == ErrorCodes.invalidAPIKey ||
            e.errorCode == ErrorCodes.invalidBearToken ||
            e.errorCode == ErrorCodes.expiredSubscription ||
            e.errorCode == ErrorCodes.customerNotFound) {
          emit(
            MyapiState(
              isAPITokenError: true,
              errorMessage: e.errorCode == ErrorCodes.expiredSubscription
                  ? ErrorMessage.expiredSubscriptionError
                  : ErrorMessage.accountDeletedError,
              status: MyapiStatus.error,
              subscription: null,
            ),
          );
          return;
        }
        emit(
          MyapiState(
            errorMessage: e.message,
            status: MyapiStatus.error,
            subscription: null,
          ),
        );
      } else {
        emit(
          MyapiState(
            errorMessage: ErrorMessage.somethingWentWrongError,
            status: MyapiStatus.error,
            subscription: null,
          ),
        );
      }
    }
  }
}
