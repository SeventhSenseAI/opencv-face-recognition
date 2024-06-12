part of 'auth_bloc.dart';

sealed class AuthEvent {}

class ForgotPasswordEvent extends AuthEvent {
  final String email;
  final String region;

  ForgotPasswordEvent(this.email, this.region);
}

class UpdateFcmToken extends AuthEvent {}

class GetAPIKeyEvent extends AuthEvent {}

class LogoutUserEvent extends AuthEvent {}

class GetLoggedUser extends AuthEvent {}

class LoginUserEvent extends AuthEvent {
  final String email;
  final String password;
  final String region;

  LoginUserEvent({
    required this.email,
    required this.password,
    required this.region,
  });
}
