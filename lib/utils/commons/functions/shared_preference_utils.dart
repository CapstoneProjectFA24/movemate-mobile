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
}
