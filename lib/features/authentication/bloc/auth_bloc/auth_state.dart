part of 'auth_bloc.dart';

enum AuthStatus {
  authenticated,
  unauthenticated,
  loading,
  error,
}

class AuthState {
  final String error;
  final bool submitting;
  final AuthStatus authStatus;
  final String jwtToken;
  final String devToken;
  final String email;
  final String phone;
  final String region;
  final String apiKey;
  final String customerId;
  final bool sentResetLink;

  const AuthState({
    required this.error,
    required this.submitting,
    required this.authStatus,
    required this.jwtToken,
    required this.devToken,
    required this.email,
    required this.phone,
    required this.region,
    required this.apiKey,
    required this.customerId,
    required this.sentResetLink,
  });

  static AuthState get initialState => const AuthState(
        error: '',
        submitting: false,
        authStatus: AuthStatus.loading,
        devToken: '',
        jwtToken: '',
        email: '',
        phone: '',
        region: '',
        apiKey: '',
        customerId: '',
        sentResetLink: false,
      );

  AuthState clone({
    String? error,
    bool? submitting,
    AuthStatus? authStatus,
    String? jwtToken,
    String? devToken,
    String? email,
    String? phone,
    String? region,
    String? apiKey,
    String? customerId,
    bool? sentResetLink,
  }) {
    return AuthState(
      error: error ?? this.error,
      submitting: submitting ?? this.submitting,
      authStatus: authStatus ?? this.authStatus,
      jwtToken: jwtToken ?? this.jwtToken,
      devToken: devToken ?? this.devToken,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      region: region ?? this.region,
      apiKey: apiKey ?? this.apiKey,
      customerId: customerId ?? this.customerId,
      sentResetLink: sentResetLink ?? this.sentResetLink,
    );
  }
}
