import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // String operations
  static Future<bool> setString(String key, String value) {
    return _prefs.setString(key, value);
  }

  static String? getString(String key) {
    return _prefs.getString(key);
  }

  // Bool operations
  static Future<bool> setBool(String key, bool value) {
    return _prefs.setBool(key, value);
  }

  static bool? getBool(String key) {
    return _prefs.getBool(key);
  }

  // Int operations
  static Future<bool> setInt(String key, int value) {
    return _prefs.setInt(key, value);
  }

  static int? getInt(String key) {
    return _prefs.getInt(key);
  }

  // Remove key
  static Future<bool> remove(String key) {
    return _prefs.remove(key);
  }

  // Clear all
  static Future<bool> clear() {
    return _prefs.clear();
  }
}