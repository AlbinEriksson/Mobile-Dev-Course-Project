import 'package:flutter/material.dart';

class LanGuideTheme {
  static ThemeData data() => ThemeData(
    primarySwatch: Colors.purple,
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
    textTheme: TextTheme(
      headline3: TextStyle(
        color: Colors.black,
      ),
      button: TextStyle(
        color: Colors.white,
        fontSize: 21,
        fontWeight: FontWeight.normal,
      ),
    ),
  );
}