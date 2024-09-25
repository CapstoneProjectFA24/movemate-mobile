import 'package:movemate/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesUtils {
  static const _keyOnboardingCompleted = 'onboardingCompleted';

  static Future<bool> isOnboardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getBool(_keyOnboardingCompleted) ?? false;
  }

  static Future<void> setOnboardingCompleted(bool completed) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyOnboardingCompleted, completed);
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


