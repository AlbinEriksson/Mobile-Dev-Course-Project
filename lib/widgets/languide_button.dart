import 'package:flutter/material.dart';

class LanGuideButton extends StatelessWidget {
  final String text;
  final Function() onPressed;

  LanGuideButton({Key key, this.text, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: 21,
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(100.0),
      ),
      color: Colors.purple,
      onPressed: onPressed,
    );
  }
}
