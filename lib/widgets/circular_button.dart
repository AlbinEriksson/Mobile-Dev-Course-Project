import 'package:flutter/material.dart';

class CircularButton extends StatelessWidget {
  final Function onPressed;
  final Color color;
  final Icon icon;
  final String text;
  final double size;
  final Color textColor;

  CircularButton({
    Key key,
    @required this.onPressed,
    this.color: Colors.grey,
    this.icon,
    this.text,
    this.size,
    this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox.fromSize(
      child: RawMaterialButton(
        onPressed: () => this.onPressed(),
        elevation: 5.0,
        fillColor: color,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            if (text != null)
              Text(
                text,
                textScaleFactor: 1.5,
                style: TextStyle(
                  color: textColor,
                )
              ),
          ],
        ),
        shape: CircleBorder(),
      ),
      size: Size.square(size),
      key: Key(""),
    );
  }
}
