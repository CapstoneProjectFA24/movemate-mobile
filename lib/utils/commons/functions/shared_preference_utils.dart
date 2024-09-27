import 'package:movemate/models/user_model.dart';
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

  static Future<void> removeSignInRequestInfo(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
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

  static Future<void> removeVerificationId(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }
// get token
  static Future<UserModel?> getInstance(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final user = prefs.getString(key) ?? '';
    if (user.isNotEmpty) {
      return UserModel.fromJson(user);
    }
    return null;
  }

  // set token
  static Future<void> setInstance(UserModel user, String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
    await prefs.setString(key, user.toJson());
  }

  // set token
  static Future<void> clearInstance(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }

  // get user permission
  static Future<bool?> getUserPermission(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final permission = prefs.getBool(key);
    return permission;
  }

  // set user permission
  static Future<void> setUserPermission(bool value, String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
    await prefs.setBool(key, value);
  }
}
