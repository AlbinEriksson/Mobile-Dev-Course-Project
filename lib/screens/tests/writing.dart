import 'package:dva232_project/routes.dart';
import 'package:dva232_project/widgets/nav_button.dart';
import 'package:flutter/material.dart';

class WritingTest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Writing Test"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            NavButton("Submit answers", Routes.writingResults),
            NavButton("Back home", Routes.home),
          ],
        ),
      ),
    );
  }
}
