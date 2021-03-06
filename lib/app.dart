import 'dart:ui';

import 'package:dva232_project/routes.dart';
import 'package:dva232_project/settings.dart';
import 'package:dva232_project/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  Locale locale;
  ThemeMode themeMode;

  _AppState() {
    String langCode = Settings.get(SettingKey.uiLanguage);
    String countryCode = Settings.get(SettingKey.uiCountry);
    locale = Locale(langCode, countryCode);

    themeMode = Settings.getThemeMode();
  }

  @override
  Widget build(BuildContext context) {
    Settings.notifyNextLanguageChange((langCode, countryCode) {
      setState(() {
        locale = Locale(langCode, countryCode);
      });
    });

    Settings.notifyNextThemeChange((themeMode) {
      setState(() {
        this.themeMode = themeMode;
      });
    });

    return MaterialApp(
      title: 'LanGuide',
      theme: LanGuideTheme.data(),
      darkTheme: LanGuideTheme.darkData(),
      themeMode: themeMode,
      onGenerateRoute: Routes.factory(),
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale("en", ""),
        const Locale("sv", ""),
      ],
      locale: locale,
    );
  }
}
