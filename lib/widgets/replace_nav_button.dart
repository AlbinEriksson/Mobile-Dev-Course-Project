import 'package:flutter/material.dart';

/// This button will replace the topmost activity with another.
class ReplaceNavButton extends StatelessWidget {
  final String text;
  final String routeTo;

  ReplaceNavButton(this.text, this.routeTo);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      child: Text(text),
      onPressed: () => _onPressed(context),
    );
  }

  void _onPressed(BuildContext context) {
    Navigator.popAndPushNamed(context, routeTo);
  }
}

