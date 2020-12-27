import 'dart:ui';

import 'package:localstorage/localstorage.dart';

enum SettingKey {
  /// String, language code (e.g. "en" for English, "ar" for Arabic etc.)
  uiLanguage,
  /// String, country code (e.g. "us" for the USA, "se" for Sweden etc.)
  uiCountry,
}

class Settings {
  Settings._(); // Prevent instantiation of this class

  static LocalStorage _storage = LocalStorage("settings.json");
  static final List<Function(String, String)> _languageCallbacks = [];

  static Future<void> init() async {
    await _storage.ready;

    String languageCode = get(SettingKey.uiLanguage);
    if(languageCode == null || languageCode == '') {
      setLocale(window.locale);
    }
  }

  static String _getKeyName(SettingKey key) {
    return key.toString().split(".").last;
  }

  static dynamic get(SettingKey key) {
    return _storage.getItem(_getKeyName(key));
  }

  static Future<void> set(SettingKey key, dynamic value) {
    return _storage.setItem(_getKeyName(key), value);
  }

  static Future<void> delete(SettingKey key) {
    return _storage.deleteItem(_getKeyName(key));
  }

  static void updateLanguage() {
    String language = get(SettingKey.uiLanguage);
    String country = get(SettingKey.uiCountry);
    _languageCallbacks.removeWhere((callback) {
      callback(language, country);
      return true;
    });
  }

  static void notifyNextLanguageChange(SettingKey key, void Function(String, String) callback) {
    _languageCallbacks.add(callback);
  }

  static void setLocale(Locale locale) async {
    await Settings.set(SettingKey.uiLanguage, locale.languageCode.toLowerCase());
    await Settings.set(SettingKey.uiCountry, locale.countryCode.toLowerCase());
  }
}
