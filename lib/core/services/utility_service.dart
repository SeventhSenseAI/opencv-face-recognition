import 'dart:io';

abstract class UtilityService {
  static const _android = 'android';
  static const _iso = 'ios';
  static String getPlatform() {
    if (Platform.isAndroid) {
      return _android;
    } else {
      return _iso;
    }
  }
}
