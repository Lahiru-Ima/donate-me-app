import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  static const String _keyUserId = 'user_id';
  
  static Future<void> setUserId(String id) async {
   final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUserId, id);
  }

  static Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserId);
  }

  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
