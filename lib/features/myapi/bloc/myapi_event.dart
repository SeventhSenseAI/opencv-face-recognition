part of 'myapi_bloc.dart';

sealed class MyapiEvent {}

class InitializeSearch extends MyapiEvent {}

class BuySubscription extends MyapiEvent {
  final String productId;
  BuySubscription({required this.productId});
}
