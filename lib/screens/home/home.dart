import 'package:dva232_project/widgets/back_nav_button.dart';
import 'package:dva232_project/widgets/nav_button.dart';
import 'package:flutter/material.dart';

import '../../routes.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            NavButton("Settings", Routes.settings),
            BackNavButton("Log out", Routes.intro),
            NavButton("Speaking test", Routes.speakingTest),
            NavButton("Vocabulary test", Routes.vocabularyTest),
            NavButton("Writing test", Routes.writingTest),
            NavButton("Listening test", Routes.listeningTestIntro),
            NavButton("Reading test", Routes.readingTest),
          ],
        ),
      ),
    );
  }
}
