import 'package:shared_preferences/shared_preferences.dart';

import 'package:movemate/features/auth/data/models/request/sign_up_request.dart';

class SharedPreferencesUtils {
  // onboarding
  static const _keyOnboardingCompleted = 'onboardingCompleted';

  static Future<bool> isOnboardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getBool(_keyOnboardingCompleted) ?? false;
  }

  static Future<void> setOnboardingCompleted(bool completed) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyOnboardingCompleted, completed);
  }

  // system
  static Future<void> setSignInRequestInfo(
      SignUpRequest request, String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, request.toJson());
  }

  static Future<SignUpRequest?> getSignInRequestInfo(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final request = prefs.getString(key) ?? '';
    if (request.isNotEmpty) {
      return SignUpRequest.fromJson(request);
    }

    return null;
  }

  static Future<void> setVerificationId(
      String verificationId, String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, verificationId);
  }

  static Future<String?> getVerificationId(String key) async {
    final prefs = await SharedPreferences.getInstance();

    final verificationId = prefs.getString(key) ?? '';

    if (verificationId.isNotEmpty) {
      return verificationId;
    }
    return null;
  }
}
