import 'package:flutter/material.dart';

class LanGuideButton extends StatelessWidget {
  final String text;
  final Function() onPressed;
  final bool enabled;

  LanGuideButton({Key key, this.text, this.onPressed, this.enabled: true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: Text(text),
      onPressed: enabled ? onPressed : null,
    );
  }
}
