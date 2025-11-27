import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

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

  // JSON operations for complex objects
  static Future<bool> setJson(String key, Map<String, dynamic> value) {
    try {
      final jsonString = json.encode(value);
      return _prefs.setString(key, jsonString);
    } catch (e) {
      print('Error encoding JSON: $e');
      return Future.value(false);
    }
  }

  static Map<String, dynamic>? getJson(String key) {
    try {
      final jsonString = _prefs.getString(key);
      if (jsonString == null) return null;
      return json.decode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      print('Error decoding JSON: $e');
      return null;
    }
  }

  // List operations for storing arrays
  static Future<bool> setStringList(String key, List<String> value) {
    return _prefs.setStringList(key, value);
  }

  static List<String>? getStringList(String key) {
    return _prefs.getStringList(key);
  }

  // JSON List operations for complex arrays
  static Future<bool> setJsonList(
      String key, List<Map<String, dynamic>> value) {
    try {
      final jsonString = json.encode(value);
      return _prefs.setString(key, jsonString);
    } catch (e) {
      print('Error encoding JSON list: $e');
      return Future.value(false);
    }
  }

  static List<Map<String, dynamic>>? getJsonList(String key) {
    try {
      final jsonString = _prefs.getString(key);
      if (jsonString == null) return null;
      final decoded = json.decode(jsonString);
      if (decoded is List) {
        return decoded.map((e) => e as Map<String, dynamic>).toList();
      }
      return null;
    } catch (e) {
      print('Error decoding JSON list: $e');
      return null;
    }
  }

  // Remove key
  static Future<bool> remove(String key) {
    return _prefs.remove(key);
  }

  // Clear all
  static Future<bool> clear() {
    return _prefs.clear();
  }

  // Check if key exists
  static bool containsKey(String key) {
    return _prefs.containsKey(key);
  }

  // Get all keys
  static Set<String> getAllKeys() {
    return _prefs.getKeys();
  }
}
