part of 'register_bloc.dart';

sealed class RegisterEvent {}

// class ResetTimerEvent extends RegisterEvent {}

class ChangeRemainingTimeEvent extends RegisterEvent {
  final int time;

  ChangeRemainingTimeEvent(this.time);
}

class CreateRegisterInfoEvent extends RegisterEvent {
  final String firstName;
  final String lastName;
  final String companyName;
  final String email;
  final String mobile;
  final String region;

  CreateRegisterInfoEvent(this.firstName, this.lastName, this.companyName,
      this.email, this.mobile, this.region);
}

class CreatePasswordEvent extends RegisterEvent {
  final String password;

  CreatePasswordEvent(this.password);
}

class SendOTPEvent extends RegisterEvent {
  final String type;

  SendOTPEvent(this.type);
}

class VerifyOTPEvent extends RegisterEvent {
  final String type;
  final String otp;

  VerifyOTPEvent(this.type, this.otp);
}

class ChangeRegisterStatusEvent extends RegisterEvent {
  final RegisterStatus registerStatus;

  ChangeRegisterStatusEvent(this.registerStatus);
}
