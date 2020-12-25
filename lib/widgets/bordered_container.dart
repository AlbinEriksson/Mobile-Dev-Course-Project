import 'package:flutter/material.dart';

class BorderedContainer extends StatelessWidget {
  final Widget child;

  BorderedContainer({@required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.purple.shade400, width: 3.0),
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: child,
    );
  }
}
