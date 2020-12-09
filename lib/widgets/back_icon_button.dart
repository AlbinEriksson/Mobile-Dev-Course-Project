import 'package:flutter/material.dart';

/// This button will return to a previous activity.<br>
/// NOTE: The specified route string must be present on the stack of activities.
/// If not, the app will stop running.
class BackIconButton extends StatelessWidget {
  final String routeTo;
  final IconData icon;
  final Function onPressed;

  BackIconButton({
    @required this.icon,
    this.routeTo,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon),
      onPressed: () => _onPressed(context),
    );
  }

  void _onPressed(BuildContext context) {
    if(onPressed != null) {
      onPressed();
    } else if(routeTo != null) {
      Navigator.popUntil(context, ModalRoute.withName(routeTo));
    }
  }
}