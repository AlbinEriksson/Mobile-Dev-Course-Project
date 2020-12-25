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
        buttonTheme: ButtonThemeData(
          alignedDropdown: true,
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
      );

  static ShapeDecoration inputFieldBorder() => ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: Colors.purple,
            width: 1.0,
            style: BorderStyle.solid,
          ),
          borderRadius: BorderRadius.circular(100.0),
        ),
      );

  static TextStyle inputFieldText() => TextStyle(fontSize: 17.0);
}
