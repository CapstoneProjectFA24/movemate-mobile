import 'package:shared_preferences/shared_preferences.dart';

class OrderSharedPreferences {
  static const _keyIsFindingDriver = 'isFindingDriver';
  static const _keyDriverName = 'driverName';
  static const _keyDriverRating = 'driverRating';
  static const _keyDriverLicensePlate = 'driverLicensePlate';

  static Future<bool> getIsFindingDriver() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsFindingDriver) ?? true;
  }

  static Future<void> setIsFindingDriver(bool isFindingDriver) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsFindingDriver, isFindingDriver);
  }

  static Future<String?> getDriverName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyDriverName);
  }

  static Future<void> setDriverName(String? name) async {
    final prefs = await SharedPreferences.getInstance();
    if (name != null) {
      await prefs.setString(_keyDriverName, name);
    } else {
      await prefs.remove(_keyDriverName);
    }
  }

  static Future<String?> getDriverRating() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyDriverRating);
  }

  static Future<void> setDriverRating(String? rating) async {
    final prefs = await SharedPreferences.getInstance();
    if (rating != null) {
      await prefs.setString(_keyDriverRating, rating);
    } else {
      await prefs.remove(_keyDriverRating);
    }
  }

  static Future<String?> getDriverLicensePlate() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyDriverLicensePlate);
  }

  static Future<void> setDriverLicensePlate(String? licensePlate) async {
    final prefs = await SharedPreferences.getInstance();
    if (licensePlate != null) {
      await prefs.setString(_keyDriverLicensePlate, licensePlate);
    } else {
      await prefs.remove(_keyDriverLicensePlate);
    }
  }
}
