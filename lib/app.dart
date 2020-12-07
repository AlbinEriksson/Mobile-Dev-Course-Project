import 'package:dva232_project/routes.dart';
import 'package:dva232_project/theme.dart';
import 'package:flutter/material.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LanGuide',
      theme: LanGuideTheme.data(),
      onGenerateRoute: Routes.factory(),
    );
  }
}
