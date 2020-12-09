import 'package:dva232_project/routes.dart';
import 'package:dva232_project/screens/tests/shared.dart';
import 'package:dva232_project/widgets/back_icon_button.dart';
import 'package:dva232_project/widgets/back_nav_button.dart';
import 'package:dva232_project/widgets/nav_button.dart';
import 'package:flutter/material.dart';

class ListeningTest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => backPressed(context, false),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Listening Test"),
          actions: [
            BackIconButton(
              icon: Icons.home,
              onPressed: () => backIconPressed(context, false),
            )
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              NavButton("Submit answers", Routes.listeningResults),
              BackNavButton("Back home", Routes.home),
            ],
          ),
        ),
      ),
    );
  }
}
