import 'package:shared_preferences/shared_preferences.dart';

class BookingSharedPreferences {
  static const _keyHouseType = 'houseType';
  static const _keyNumberOfRooms = 'numberOfRooms';
  static const _keyNumberOfFloors = 'numberOfFloors';

  static Future<String?> getHouseType() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyHouseType);
  }

  static Future<void> setHouseType(String? houseType) async {
    final prefs = await SharedPreferences.getInstance();
    if (houseType != null) {
      await prefs.setString(_keyHouseType, houseType);
    } else {
      await prefs.remove(_keyHouseType);
    }
  }

  static Future<int> getNumberOfRooms() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyNumberOfRooms) ?? 1;
  }

  static Future<void> setNumberOfRooms(int numberOfRooms) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyNumberOfRooms, numberOfRooms);
  }

  static Future<int> getNumberOfFloors() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyNumberOfFloors) ?? 1;
  }

  static Future<void> setNumberOfFloors(int numberOfFloors) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyNumberOfFloors, numberOfFloors);
  }
}
