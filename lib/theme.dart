import 'dart:ui' as ui;
import 'package:dva232_project/settings.dart';
import 'package:flutter/material.dart';

class LanGuideTheme {
  static ThemeData data() => ThemeData(
        primarySwatch: Colors.purple,
        brightness: Brightness.light,
        iconTheme: IconThemeData(
          color: Colors.purple,
        ),
        // accentColor: Colors.purpleAccent,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100.0),
            ),
            minimumSize: Size.fromHeight(50),
            elevation: 5.0,
          ),
        ),
        buttonTheme: ButtonThemeData(
          alignedDropdown: true,
        ),
        textTheme: TextTheme(
          headline3: TextStyle(
            color: Colors.black,
          ),
          bodyText1: TextStyle(
            fontSize: 16.0,
          ),
          bodyText2: TextStyle(
            fontSize: 16.0,
          ),
          button: TextStyle(
            color: Colors.white,
            fontSize: 21,
            fontWeight: FontWeight.normal,
          ),
          overline: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        appBarTheme: AppBarTheme(
          color: Colors.white,
          iconTheme: IconThemeData(
            color: Colors.black,
            size: 40.0,
          ),
        ),
        dividerTheme: DividerThemeData(
          thickness: 4.0,
          indent: 20.0,
          endIndent: 20.0,
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          selectedItemColor: Colors.purple,
          unselectedItemColor: Colors.black,
        ),
        inputDecorationTheme: InputDecorationTheme(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(100.0),
            borderSide: BorderSide(
              color: Colors.purple,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(100.0),
            borderSide: BorderSide(
              color: Colors.purple,
            ),
          ),
        ),
      );

  static ThemeData darkData() => ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
        iconTheme: IconThemeData(color: Colors.blue),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100.0),
            ),
            minimumSize: Size.fromHeight(50),
            elevation: 5.0,
          ),
        ),
        buttonTheme: ButtonThemeData(
          alignedDropdown: true,
        ),
        textTheme: TextTheme(
          headline3: TextStyle(
            color: Colors.white,
          ),
          bodyText1: TextStyle(
            fontSize: 16.0,
          ),
          bodyText2: TextStyle(
            fontSize: 16.0,
          ),
          button: TextStyle(
            color: Colors.white,
            fontSize: 21,
            fontWeight: FontWeight.normal,
          ),
          overline: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        appBarTheme: AppBarTheme(
          color: Colors.black45,
          iconTheme: IconThemeData(
            color: Colors.blue,
            size: 40.0,
          ),
        ),
        dividerTheme: DividerThemeData(
          thickness: 4.0,
          indent: 20.0,
          endIndent: 20.0,
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.black45,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.white,
        ),
        inputDecorationTheme: InputDecorationTheme(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(100.0),
            borderSide: BorderSide(
              color: Colors.blue,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(100.0),
            borderSide: BorderSide(
              color: Colors.blue,
            ),
          ),
        ),
      );

  static bool _useDarkTheme(BuildContext context) {
    ThemeMode mode = Settings.getThemeMode();
    Brightness platformBrightness = MediaQuery.platformBrightnessOf(context);
    bool useDarkTheme = mode == ThemeMode.dark ||
        (mode == ThemeMode.system && platformBrightness == ui.Brightness.dark);
    return useDarkTheme;
  }

  static ShapeDecoration inputFieldBorder(BuildContext context) {
    return ShapeDecoration(
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: primaryColor(context),
          width: 1.0,
          style: BorderStyle.solid,
        ),
        borderRadius: BorderRadius.circular(100.0),
      ),
    );
  }

  static TextStyle inputFieldText() => TextStyle(fontSize: 17.0);

  static TextStyle writingTestOption(BuildContext context) {
    return TextStyle(
        color: primaryColor(context),
        fontWeight: FontWeight.bold,
        decoration: TextDecoration.underline,
        decorationThickness: 2,
        fontSize: 20.0,
      );
  }

  static Color readingTestColor(BuildContext context) {
    bool useDarkTheme = _useDarkTheme(context);
    return useDarkTheme ? Colors.purple[300] : Colors.purple[100];
  }

  static Color speakingTestColor(BuildContext context) {
    bool useDarkTheme = _useDarkTheme(context);
    return useDarkTheme ? Colors.cyan[300] : Colors.cyan[100];
  }

  static Color listeningTestColor(BuildContext context) {
    bool useDarkTheme = _useDarkTheme(context);
    return useDarkTheme ? Colors.green[300] : Colors.green[100];
  }

  static Color writingTestColor(BuildContext context) {
    bool useDarkTheme = _useDarkTheme(context);
    return useDarkTheme ? Colors.orange[300] : Colors.orange[100];
  }

  static Color vocabularyTestColor(BuildContext context) {
    bool useDarkTheme = _useDarkTheme(context);
    return useDarkTheme ? Colors.red[300] : Colors.red[100];
  }

  static MaterialColor primaryColor(BuildContext context) {
    bool useDarkTheme = _useDarkTheme(context);
    return useDarkTheme ? Colors.blue : Colors.purple;
  }

  static Color testIconColor(BuildContext context) {
    bool useDarkTheme = _useDarkTheme(context);
    return useDarkTheme ? Colors.white : Colors.black;
  }

  static Color vocabularyHighlightColor(BuildContext context) {
    bool useDarkTheme = _useDarkTheme(context);
    return useDarkTheme ? Colors.green[600] : Colors.green[200];
  }

  static Color vocabularySelectColor(BuildContext context) {
    bool useDarkTheme = _useDarkTheme(context);
    return useDarkTheme ? Colors.blue[600] : Colors.blue[200];
  }
}
