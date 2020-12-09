import 'package:dva232_project/routes.dart';
import 'package:dva232_project/widgets/nav_button.dart';
import 'package:flutter/material.dart';

class VocabularyTest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Vocabulary Test"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            NavButton("Submit answers", Routes.vocabularyResults),
            NavButton("Back home", Routes.home),
          ],
        ),
      ),
    );
  }
}
