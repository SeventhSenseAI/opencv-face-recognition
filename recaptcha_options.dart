import 'dart:io';

abstract class RecaptchaOptions {
  static const _androidSiteKey = "6LdOkEMpAAAAAG4I6KE-BFDU_rAAUQrE4ylwt5hU";
  static const _iosSiteKey = "6LesElUpAAAAAM8NX9K7pSjqwVorQdU7XWmsEbwv";

  static getSiteKey() {
    if (Platform.isAndroid) {
      return _androidSiteKey;
    } else {
      return _iosSiteKey;
    }
  }
}