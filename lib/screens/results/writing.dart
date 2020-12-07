import 'package:dva232_project/routes.dart';
import 'package:dva232_project/widgets/back_nav_button.dart';
import 'package:flutter/material.dart';

class WritingResults extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Results"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BackNavButton("Back to home", Routes.home),
          ],
        ),
      ),
    );
  }
}
