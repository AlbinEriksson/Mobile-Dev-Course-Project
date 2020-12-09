import 'package:dva232_project/widgets/bot_nav_bar.dart';
import 'package:flutter/material.dart';

class ListeningResults extends StatelessWidget {
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

          ],
        ),
      ),
      bottomNavigationBar: BotNavBar(),
    );
  }
}
