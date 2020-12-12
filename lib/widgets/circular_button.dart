import 'package:flutter/material.dart';

class CircularButton extends StatelessWidget {
  final Function onPressed;
  final Color color;
  final Icon icon;
  final String text;
  final double size;

  CircularButton({
    @required this.onPressed,
    this.color: Colors.grey,
    this.icon,
    this.text,
    this.size,
  });

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
            Text(
              text,
              textScaleFactor: 1.5,
            ),
          ],
        ),
        shape: CircleBorder(),
      ),
      size: Size.square(size),
    );
  }
}
