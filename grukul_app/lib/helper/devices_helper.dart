import 'package:flutter/foundation.dart';

class DevicesHelper {
  const DevicesHelper();
  bool isRunningOnAndroidEmulator() {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return true;
    } else {
      return false;
    }
  }
}
