import 'package:dva232_project/widgets/nav_button.dart';
import 'package:flutter/material.dart';

import '../../routes.dart';

class ReadingResults extends StatelessWidget {
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
            NavButton("Back home", Routes.home),
          ],
        ),
      ),
    );
  }
}
