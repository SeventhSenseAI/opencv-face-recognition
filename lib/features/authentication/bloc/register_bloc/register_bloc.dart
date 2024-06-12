import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:faceapp/core/networking/api_exception.dart';
import 'package:faceapp/core/services/utility_service.dart';
import 'package:faceapp/features/authentication/data/model/register_info.dart';

import '../../../../core/services/recaptcha_service.dart';
import '../../data/repository/user_repository.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final userRepository = UserRepository();
  Map<String, String>? headers;
  Timer? timer;
  RecaptchaService? recaptchaService;

  RegisterBloc() : super(RegisterState.initialState) {
    on<CreateRegisterInfoEvent>(_crateRegisterInfoEvent);
    on<CreatePasswordEvent>(_createPasswordEvent);
    on<VerifyOTPEvent>(_verifyOTPEvent);
    on<SendOTPEvent>(_sendOTPEvent);
    on<ChangeRegisterStatusEvent>(_changeRegisterStatusEvent);
    on<ChangeRemainingTimeEvent>(_changeRemainingTimeEvent);
    _init();
  }

  void _init() async {
    recaptchaService = await RecaptchaService.getInstance();
  }

  void _crateRegisterInfoEvent(
    CreateRegisterInfoEvent event,
    Emitter<RegisterState> emitter,
  ) {
    final regInfo = RegisterInfo(
      firstName: event.firstName,
      lastName: event.lastName,
      companyName: event.companyName,
      email: event.email,
      mobile: event.mobile,
      region: event.region,
    );
    emitter(state.clone(registerInfo: regInfo));
  }

  Future<void> _createPasswordEvent(
    CreatePasswordEvent event,
    Emitter<RegisterState> emitter,
  ) async {
    RegisterInfo regInfo = state.registerInfo;
    regInfo.password = event.password;
    emitter(state.clone(registerInfo: regInfo));
    log('_createPasswordEvent password ${regInfo.password}');
    log('_createPasswordEvent email ${regInfo.email}');
    log('_createPasswordEvent email ${regInfo.mobile}');
    emitter(state.clone(submitting: true));

    headers = {
      'Content-Type': 'application/json',
      'Region': state.registerInfo.region,
      'x-client': UtilityService.getPlatform(),
    };

    try {
      final recaptcha = await recaptchaService!.getReCaptcha();
      final registerToken = await userRepository.register(
        {
          ...state.registerInfo.toJson(),
          "recaptcha_token": recaptcha,
        },
        headers,
      );
      emitter(
        state.clone(
          registrationToken: registerToken,
          registerStatus: RegisterStatus.submitted,
        ),
      );
      log("_createPasswordEvent $registerToken");
      add(SendOTPEvent('email'));
    } catch (e) {
      log("_createPasswordEvent error $e");
      if (e is ApiException) {
        emitter(state.clone(error: e.message));
      } else {
        emitter(state.clone(error: e.toString()));
      }
    } finally {
      emitter(state.clone(error: ''));
    }

    emitter(state.clone(submitting: false));
  }

  Future<void> _sendOTPEvent(
    SendOTPEvent event,
    Emitter<RegisterState> emitter,
  ) async {
    _resetTimerEvent(emitter);
    try {
      final recaptcha = await recaptchaService!.getReCaptcha();
      await userRepository.sendOTP(
        event.type,
        {
          "registration_token": state.registrationToken,
          "mobile": state.registerInfo.mobile,
          "email": state.registerInfo.email,
          "recaptcha_token": recaptcha,
        },
        headers,
      );
      timer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (state.remainingSecForResend > 0) {
          add(ChangeRemainingTimeEvent(state.remainingSecForResend - 1));
        }
      });
    } catch (e) {
      log("_sendOTPEvent error $e");
      if (e is ApiException) {
        emitter(state.clone(error: e.message));
      } else {
        emitter(state.clone(error: e.toString()));
      }
    } finally {
      emitter(state.clone(error: ''));
    }
  }

  Future<void> _verifyOTPEvent(
    VerifyOTPEvent event,
    Emitter<RegisterState> emitter,
  ) async {
    // emitter(state.clone(registerStatus: RegisterStatus.submitted));
    try {
      final recaptcha = await recaptchaService!.getReCaptcha();
      await userRepository.verityOTP(
        event.type,
        {
          "registration_token": state.registrationToken,
          "otp": event.otp,
          "mobile": state.registerInfo.mobile,
          "email": state.registerInfo.email,
          "recaptcha_token": recaptcha,
        },
        headers,
      );
      _resetTimerEvent(emitter);
      if (event.type == 'email') {
        emitter(state.clone(registerStatus: RegisterStatus.emailVerified));
        add(SendOTPEvent('mobile'));
      } else {
        emitter(state.clone(registerStatus: RegisterStatus.phoneVerified));
      }
    } catch (e) {
      if (e is ApiException) {
        if (e.errorCode == "EXPIRED_OTP") {
          emitter(
            state.clone(
              registerStatus: RegisterStatus.otpError,
              error: "OTP expired. Please click on resend OTP",
            ),
          );
        } else {
          emitter(
            state.clone(
              registerStatus: RegisterStatus.otpError,
              error: "Invalid Verification Code!",
            ),
          );
        }
      } else {
        emitter(
          state.clone(
            registerStatus: RegisterStatus.otpError,
            error: "Invalid Verification Code!",
          ),
        );
      }
      log("_verifyOTPEvent error $e");
    }
  }

  Future<void> _changeRegisterStatusEvent(
    ChangeRegisterStatusEvent event,
    Emitter<RegisterState> emitter,
  ) async {
    emitter(state.clone(registerStatus: event.registerStatus));
  }

  Future<void> _changeRemainingTimeEvent(
    ChangeRemainingTimeEvent event,
    Emitter<RegisterState> emitter,
  ) async {
    log('RegisterBloc -> _changeRemainingTimeEvent ${event.time.toString()}');
    emitter(state.clone(remainingSecForResend: event.time));
  }

  Future<void> _resetTimerEvent(
    Emitter<RegisterState> emitter,
  ) async {
    timer?.cancel();
    emitter(state.clone(remainingSecForResend: 300));
  }
}
