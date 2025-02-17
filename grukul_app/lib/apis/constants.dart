import 'package:mcq_learning_app/helper/devices_helper.dart';

class ApiConstants {
  static const String appName = "My Flutter App";
  static const String apiBaseUrlAndroid = "http://10.0.2.2:8080";
  static const String apiBaseUrl = "http://localhost:8080";

  // static const String baseUrl = "https://api.example.com";
  // static const String login = "$baseUrl/auth/login";
  // static const String register = "$baseUrl/auth/register";

  static getApiBaseUrl() async {
    if (DevicesHelper().isRunningOnAndroidEmulator()) {
      return apiBaseUrlAndroid;
    } else {
      return apiBaseUrl;
    }
  }
}
