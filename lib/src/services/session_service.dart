import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  static const String _keyUserId = 'user_id';
  static const _keyOnboardingCompleted = 'onboardingCompleted';

  static Future<void> setUserId(String id) async {
   final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUserId, id);
  }

  static Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserId);
  }

   static Future<void> setOnboardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyOnboardingCompleted, true);
  }

  static Future<bool> isOnboardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyOnboardingCompleted) ?? false;
  }

  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
