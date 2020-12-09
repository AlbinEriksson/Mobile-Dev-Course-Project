import 'package:flutter/material.dart';

/// This button will return to a previous activity.<br>
/// NOTE: The specified route string must be present on the stack of activities.
/// If not, the app will stop running.
class BackHomeButton extends StatelessWidget {
  final String routeTo;

  BackHomeButton(this.routeTo);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.home),
      onPressed: () => _onPressed(context),
    );
  }

  void _onPressed(BuildContext context) {
    Navigator.popUntil(context, ModalRoute.withName(routeTo));
  }
}