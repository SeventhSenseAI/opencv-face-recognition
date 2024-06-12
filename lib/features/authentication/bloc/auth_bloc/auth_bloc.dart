import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:faceapp/core/constants/api_constants.dart';
import 'package:faceapp/core/networking/api_exception.dart';
import 'package:faceapp/core/services/baseurl_service.dart';
import 'package:faceapp/core/services/shared_preferences_service.dart';
import 'package:faceapp/core/services/utility_service.dart';
import 'package:faceapp/core/services/recaptcha_service.dart';
import 'package:faceapp/features/authentication/data/repository/subscription_repository.dart';
import 'package:faceapp/features/authentication/data/repository/user_repository.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';

import '../../../../core/constants/error_codes.dart';
import '../../../../core/constants/error_messages.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final userRepository = UserRepository();
  RecaptchaService? recaptchaService;

  AuthBloc() : super(AuthState.initialState) {
    on<LoginUserEvent>(_loginUserEvent);
    on<GetLoggedUser>(_getLoggedUser);
    on<LogoutUserEvent>(_logoutUserEvent);
    on<GetAPIKeyEvent>(_getAPIKeyEvent);
    on<ForgotPasswordEvent>(_forgotPasswordEvent);
    on<UpdateFcmToken>(_updateFcmToken);
    _init();
  }

  void _init() async {
    add(GetLoggedUser());
    recaptchaService = await RecaptchaService.getInstance();
  }

  String _getCustomerId(String jwtToken) {
    String customerId = '';
    final normalizedSource = base64Url.normalize(jwtToken.split(".")[1]);
    final decodedString = utf8.decode(base64Url.decode(normalizedSource));
    final jsonData = json.decode(decodedString);
    customerId = jsonData['customer_id'];
    return customerId;
  }

  Future<String?> _firebaseToken() async {
    late String? fcmToken;

    if (Platform.isIOS) {
      await FirebaseMessaging.instance.requestPermission(
        sound: true,
        badge: true,
        alert: true,
      );

      // For apple platforms, ensure the APNS token is available before making any FCM plugin API calls
      final apnsToken = await FirebaseMessaging.instance.getAPNSToken();
      if (apnsToken != null) {
        // APNS token is available, make FCM plugin API requests...
        fcmToken = await FirebaseMessaging.instance.getToken();
      }
    }
    if (Platform.isAndroid) {
      fcmToken = await FirebaseMessaging.instance.getToken();
    }

    log(
      fcmToken.toString(),
      name: "Firebase Messaging token",
    );

    return fcmToken;
  }

  Future<void> _loginUserEvent(
    LoginUserEvent event,
    Emitter<AuthState> emitter,
  ) async {
    emitter(state.clone(submitting: true));
    updateBaseURl(event.region);

    final headers = {
      'Content-Type': 'application/json',
      'x-client': UtilityService.getPlatform(),
      'Region': event.region,
    };
    try {
      final recaptcha = await recaptchaService!.getReCaptcha();
      final authDetails = await userRepository.login(
        {
          "email": event.email,
          "password": event.password,
          "recaptcha_token": recaptcha,
        },
        headers,
      );
      await SharedPreferencesService.setDevToken(authDetails.devToken);
      await SharedPreferencesService.setJwtToken(authDetails.jwtToken);
      await SharedPreferencesService.setEmail(event.email);
      await SharedPreferencesService.setRegion(event.region);
      await SharedPreferencesService.setLiveness(false);

      emitter(
        state.clone(
          authStatus: AuthStatus.authenticated,
          devToken: authDetails.devToken,
          jwtToken: authDetails.jwtToken,
          region: event.region,
        ),
      );
      add(UpdateFcmToken());
      add(GetAPIKeyEvent());
    } catch (e) {
      if (e is ApiException) {
        emitter(state.clone(error: e.message));
      } else if (e is PlatformException) {
        final networkStatus = await Connectivity().checkConnectivity();
        if (networkStatus == ConnectivityResult.none) {
          emitter(
            state.clone(
              error: "No internet connection, please try again",
              submitting: false,
            ),
          );
          return;
        }
        emitter(
          state.clone(
            error:
                "reCAPTCHA check failed, please try clear the app and try again",
          ),
        );
      } else {
        emitter(state.clone(error: e.toString()));
      }
    } finally {
      emitter(state.clone(error: ''));
    }
    emitter(state.clone(submitting: false));
  }

  Future<void> _getLoggedUser(
    GetLoggedUser event,
    Emitter<AuthState> emitter,
  ) async {
    final email = await SharedPreferencesService.getEmail();
    if (email != '') {
      final devToken = await SharedPreferencesService.getDevToken();
      final jwtToken = await SharedPreferencesService.getJwtToken();
      final region = await SharedPreferencesService.getRegion();
      final apiToken = await SharedPreferencesService.getAPIToken();
      updateBaseURl(region);

      emitter(
        state.clone(
          devToken: devToken,
          jwtToken: jwtToken,
          region: region,
          apiKey: apiToken,
        ),
      );
      add(GetAPIKeyEvent());
      emitter(state.clone(authStatus: AuthStatus.authenticated));
    } else {
      emitter(state.clone(authStatus: AuthStatus.unauthenticated));
    }
  }

  Future<void> _logoutUserEvent(
    LogoutUserEvent event,
    Emitter<AuthState> emitter,
  ) async {
    await SharedPreferencesService.setDevToken('');
    await SharedPreferencesService.setJwtToken('');
    await SharedPreferencesService.setEmail('');
    await SharedPreferencesService.setRegion('');
    await SharedPreferencesService.setAPIToken('');

    emitter(
      AuthState.initialState.clone(authStatus: AuthStatus.unauthenticated),
    );
    final headers = {
      'Content-Type': 'application/json',
      'x-client': UtilityService.getPlatform(),
      'Authorization': 'Bearer ${state.devToken}',
      'jwt_token': state.jwtToken,
    };
    try {
      final id = _getCustomerId(state.jwtToken);
      await userRepository.deleteFcmToken(
        {
          "customer_id": id,
          "device_token": SharedPreferencesService.getFcmToken(),
        },
        headers,
      );
      SharedPreferencesService.setFcmToken('');
    } catch (e) {
      log(e.toString());
      if (e is ApiException) {
        emitter(state.clone(error: e.message));
      } else {
        emitter(state.clone(error: e.toString()));
      }
    } finally {
      emitter(state.clone(error: ''));
    }
  }

  Future<void> _getAPIKeyEvent(
    GetAPIKeyEvent event,
    Emitter<AuthState> emitter,
  ) async {
    final headers = {
      'Content-Type': 'application/json',
      'x-client': UtilityService.getPlatform(),
      'Authorization': 'Bearer ${state.devToken}',
      'jwt_token': state.jwtToken,
    };
    try {
      final key = await SubscriptionRepository().getKey(headers);
      emitter(state.clone(apiKey: key));
      await SharedPreferencesService.setAPIToken(key);
      log('AuthBloc -> _getAPIKeyEvent $key');
    } catch (e) {
      log(e.toString());
      if (e is ApiException) {
        if (e.errorCode == ErrorCodes.invalidAPIKey ||
            e.errorCode == ErrorCodes.invalidBearToken ||
            e.errorCode == ErrorCodes.expiredSubscription ||
            e.errorCode == ErrorCodes.customerNotFound) {
          emitter(state.clone(
            error: e.errorCode == ErrorCodes.expiredSubscription
                ? ErrorMessage.expiredSubscriptionError
                : ErrorMessage.accountDeletedError,
          ),);
          return;
        }
        emitter(state.clone(error: e.message));
      } else {
        emitter(state.clone(error: e.toString()));
      }
    } finally {
      emitter(state.clone(error: ''));
    }
  }

  Future<void> _forgotPasswordEvent(
    ForgotPasswordEvent event,
    Emitter<AuthState> emitter,
  ) async {
    emitter(state.clone(submitting: true));

    final headers = {
      'Content-Type': 'application/json',
      'x-client': UtilityService.getPlatform(),
      'Region': event.region,
    };
    try {
      final recaptcha = await recaptchaService!.getReCaptcha();
      await userRepository.forgetPassword(
        {
          "email": event.email,
          "recaptcha_token": recaptcha,
        },
        headers,
      );

      emitter(state.clone(sentResetLink: true));
    } catch (e) {
      if (e is ApiException) {
        if (e.errorCode == "INVALID_REQUEST") {
          emitter(state.clone(error: "The user email does not exist"));
        } else {
          emitter(state.clone(error: e.message));
        }
      } else {
        emitter(state.clone(error: e.toString()));
      }
    } finally {
      emitter(state.clone(error: ''));
    }
    emitter(state.clone(submitting: false, sentResetLink: false));
  }

  Future<void> _updateFcmToken(
    UpdateFcmToken event,
    Emitter<AuthState> emitter,
  ) async {
    final id = _getCustomerId(state.jwtToken);
    final headers = {
      'Content-Type': 'application/json',
      'x-client': UtilityService.getPlatform(),
      'Authorization': 'Bearer ${state.devToken}',
      'jwt_token': state.jwtToken,
    };

    try {
      final token = await _firebaseToken();
      if (token == null) {
        throw Exception('Failed to get FCM token');
      } else {
        await userRepository.updateFcmToken(
          {
            "customer_id": id,
            "device_token": token,
          },
          headers,
        );
        log("FCM token updated for customer $id");
        SharedPreferencesService.setFcmToken(token);
      }
    } catch (e) {
      if (e is ApiException) {
        emitter(state.clone(error: e.message));
      } else {
        emitter(state.clone(error: e.toString()));
      }
    } finally {
      emitter(state.clone(error: ''));
    }
  }

  void updateBaseURl(String region) {
//release
    if (region == 'Singapore') {
      BaseURLService().setBaseURL(ApiConstants.baseSGURL);
    } else if (region == 'Europe') {
      BaseURLService().setBaseURL(ApiConstants.baseEUURL);
    } else {
      BaseURLService().setBaseURL(ApiConstants.baseUSURL);
    }
    //develop
    // BaseURLService().setBaseURL(ApiConstants.baseDevURL);
  }
}
