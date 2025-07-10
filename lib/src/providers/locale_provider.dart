import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider with ChangeNotifier {
  Locale _locale = const Locale('en', 'US');

  static const String _localeKey = 'locale';

  Locale get locale => _locale;

  // Initialize locale from shared preferences
  Future<void> initializeLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString(_localeKey);

    if (languageCode != null) {
      switch (languageCode) {
        case 'si':
          _locale = const Locale('si', 'LK');
          break;
        case 'en':
        default:
          _locale = const Locale('en', 'US');
          break;
      }
      notifyListeners();
    }
  }

  // Set locale and persist to shared preferences
  Future<void> setLocale(Locale locale) async {
    if (_locale == locale) return;

    _locale = locale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localeKey, locale.languageCode);
    notifyListeners();
  }

  // Toggle between English and Sinhala
  Future<void> toggleLocale() async {
    if (_locale.languageCode == 'en') {
      await setLocale(const Locale('si', 'LK'));
    } else {
      await setLocale(const Locale('en', 'US'));
    }
  }

  // Get display name for current locale
  String get currentLanguageName {
    switch (_locale.languageCode) {
      case 'si':
        return 'සිංහල';
      case 'en':
      default:
        return 'English';
    }
  }

  // Check if current locale is Sinhala
  bool get isSinhala => _locale.languageCode == 'si';

  // Check if current locale is English
  bool get isEnglish => _locale.languageCode == 'en';
}
