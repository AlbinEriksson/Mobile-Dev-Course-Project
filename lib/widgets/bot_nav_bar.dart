import 'package:flutter/material.dart';
import '../routes.dart';
import 'back_home_button.dart';


class BotNavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BackHomeButton(Routes.home),
          ],
        ));
  }
}