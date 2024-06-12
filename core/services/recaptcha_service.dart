import 'dart:developer';

import 'package:faceapp/recaptcha_options.dart';
import 'package:flutter/services.dart';
import 'package:recaptcha_enterprise_flutter/recaptcha_action.dart';
import 'package:recaptcha_enterprise_flutter/recaptcha_enterprise.dart';

class RecaptchaService {
  static RecaptchaService? _instance;

static const int maxRetries = 3;
static const Duration retryDelay = Duration(seconds: 2);

static Future<RecaptchaService> getInstance() async {
  int retries = 0;
  while (retries < maxRetries) {
    try {
      bool result = await RecaptchaEnterprise.initClient(
        RecaptchaOptions.getSiteKey(),
      );
      _instance = RecaptchaService._();
      return _instance!;
    } on PlatformException catch (err) {
      log('Caught platform exception on init: $err');
      log('Code: ${err.code} Message ${err.message}');
    } catch (err, stackTrace) {
      log('Caught exception on init: $err');
      log(err.toString());
      log('StackTrace: $stackTrace');
    }
    await Future.delayed(retryDelay);
    retries++;
  }
  _instance = RecaptchaService._();
  return _instance!;
}


  RecaptchaService._();
  Future<String> getReCaptcha() async {
    final rec = await RecaptchaEnterprise.execute(
      RecaptchaAction.custom('all_form_actions'),
    );
    return rec;
  }
}
