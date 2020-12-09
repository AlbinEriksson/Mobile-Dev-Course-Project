
import 'package:dva232_project/widgets/back_icon_button.dart';
import 'package:dva232_project/widgets/back_nav_button.dart';
import 'package:flutter/material.dart';

import '../../routes.dart';

class SpeakingResults extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Results"),
        actions: [
          BackIconButton(
            routeTo: Routes.home,
            icon: Icons.home,
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BackNavButton("Back home", Routes.home),
          ],
        ),
      ),
    );
  }
}
