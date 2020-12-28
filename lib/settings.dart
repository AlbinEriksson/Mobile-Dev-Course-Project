import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';

enum SettingKey {
  /// String, language code (e.g. "en" for English, "ar" for Arabic etc.)
  uiLanguage,
  /// String, country code (e.g. "us" for the USA, "se" for Sweden etc.)
  uiCountry,
  /// String, "light", "dark" or "system"
  themeMode,
}

class Settings {
  Settings._(); // Prevent instantiation of this class

  static LocalStorage _storage = LocalStorage("settings.json");
  static final List<Function(String, String)> _languageCallbacks = [];
  static final List<Function(ThemeMode)> _themeCallbacks = [];

  static Future<void> init() async {
    await _storage.ready;

    String languageCode = get(SettingKey.uiLanguage);
    if(languageCode == null || languageCode == '') {
      await setLocale(window.locale);
    }

    ThemeMode themeMode = _toThemeMode(get(SettingKey.themeMode));
    if(themeMode == null) {
      await setThemeMode(ThemeMode.system);
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

  static void notifyNextLanguageChange(void Function(String, String) callback) {
    _languageCallbacks.add(callback);
  }

  static Future<void> setLocale(Locale locale) async {
    await Settings.set(SettingKey.uiLanguage, locale.languageCode.toLowerCase());
    await Settings.set(SettingKey.uiCountry, locale.countryCode.toLowerCase());
  }

  static void updateTheme() {
    ThemeMode mode = _toThemeMode(get(SettingKey.themeMode));
    _themeCallbacks.removeWhere((callback) {
      callback(mode);
      return true;
    });
  }

  static void notifyNextThemeChange(void Function(ThemeMode) callback) {
    _themeCallbacks.add(callback);
  }

  static ThemeMode getThemeMode() {
    return _toThemeMode(get(SettingKey.themeMode));
  }

  static Future<void> setThemeMode(ThemeMode mode) async {
    await Settings.set(SettingKey.themeMode, mode.toString().split(".").last);
  }

  static ThemeMode _toThemeMode(String string) {
    switch(string) {
      case "light": return ThemeMode.light;
      case "dark": return ThemeMode.dark;
      case "system": return ThemeMode.system;
    }
    return ThemeMode.system;
  }
}
