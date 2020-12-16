import 'package:flutter/material.dart';

/// This button will push a new activity to the stack.<br>
/// If you need a button which returns to a previous activity, see
/// BackNavButton.<br>
/// If you need a button which replaces the topmost activity, see
/// ReplaceNavButton.
class NavButton extends StatelessWidget {
  final String text;
  final String routeTo;

  NavButton(this.text, this.routeTo);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      child: Text(text),
      color: Colors.purple,
      onPressed: () => _onPressed(context),
    );
  }

  void _onPressed(BuildContext context) {
    Navigator.pushNamed(context, routeTo, arguments: null);
  }
}

