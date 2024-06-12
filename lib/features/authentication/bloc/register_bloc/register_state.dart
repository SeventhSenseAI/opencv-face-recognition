part of 'register_bloc.dart';

enum RegisterStatus {
  initiated,
  submitted,
  emailVerified,
  phoneVerified,
  otpError,
  loading,
  error,
}

class RegisterState {
  final String error;
  final bool submitting;
  final RegisterInfo registerInfo;
  final String registrationToken;
  final RegisterStatus registerStatus;
  final int remainingSecForResend;

  const RegisterState({
    required this.error,
    required this.submitting,
    required this.registerInfo,
    required this.registrationToken,
    required this.registerStatus,
    required this.remainingSecForResend,
  });

  static RegisterState get initialState => RegisterState(
        error: '',
        submitting: false,
        registerInfo: RegisterInfo(
          firstName: '',
          lastName: '',
          companyName: '',
          email: '',
          mobile: '',
          region: '',
        ),
        registrationToken: '',
        registerStatus: RegisterStatus.initiated,
        remainingSecForResend: 180,
      );

  RegisterState clone({
    String? error,
    bool? submitting,
    RegisterInfo? registerInfo,
    String? registrationToken,
    RegisterStatus? registerStatus,
    int? remainingSecForResend,
  }) {
    return RegisterState(
      error: error ?? this.error,
      submitting: submitting ?? this.submitting,
      registerInfo: registerInfo ?? this.registerInfo,
      registrationToken: registrationToken ?? this.registrationToken,
      registerStatus: registerStatus ?? this.registerStatus,
      remainingSecForResend:
          remainingSecForResend ?? this.remainingSecForResend,
    );
  }
}
