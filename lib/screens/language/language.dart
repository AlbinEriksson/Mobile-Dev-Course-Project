import 'package:dva232_project/settings.dart';
import 'package:dva232_project/widgets/languide_navbar.dart';
import 'package:flutter/material.dart';

class LanguageSelection extends StatefulWidget {
  @override
  _LanguageSelectionState createState() => _LanguageSelectionState();
}

class _LanguageSelectionState extends State<LanguageSelection> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _updateLanguage();
        return true;
      },
      child: Scaffold(
        appBar: LanGuideNavBar(
          onBackIconPressed: () {
            _updateLanguage();
            Navigator.pop(context);
          },
        ),
        body: ListView(
          children: [
            _languageOption("English (US)", "en", "us"),
            _languageOption("Svenska", "sv", "se"),
          ],
        ),
      ),
    );
  }

  Widget _languageOption(String name, String langCode, String countryCode) {
    return ListTile(
      title: Text(name),
      leading: Image.asset("icons/flags/png/$countryCode.png", package: "country_icons", width: 64.0),
      selected: langCode == Settings.get(SettingKey.uiLanguage),
      onTap: () async {
        await Settings.set(SettingKey.uiLanguage, langCode);
        await Settings.set(SettingKey.uiCountry, countryCode);
        setState(() {});
      },
      selectedTileColor: Colors.purple[100],
    );
  }

  void _updateLanguage() {
    Settings.updateLanguage();
  }
}

