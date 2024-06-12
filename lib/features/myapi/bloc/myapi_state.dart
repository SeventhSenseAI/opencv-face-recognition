// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'myapi_bloc.dart';

enum MyapiStatus { initial, buySubscription, fetchSubscription, error }

enum CustomerType { free, starter, custom, basic, standard, enterprise, trail }

class MyapiState extends Equatable {
  final MyapiStatus status;
  final String errorMessage;
  final Subscription? subscription;
  final String? customerType;
  final bool? isAPITokenError;

  const MyapiState({
    required this.status,
    required this.errorMessage,
    this.subscription,
    this.customerType,
    this.isAPITokenError,
  });

  static MyapiState initialState() => const MyapiState(
        errorMessage: '',
        customerType: '',
        status: MyapiStatus.initial,
        isAPITokenError: false,
      );

  @override
  List<Object?> get props =>
      [status, errorMessage, subscription, customerType, isAPITokenError];
}
