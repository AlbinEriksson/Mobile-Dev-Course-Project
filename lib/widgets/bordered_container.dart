import 'package:dva232_project/theme.dart';
import 'package:flutter/material.dart';

class BorderedContainer extends StatelessWidget {
  final Widget child;
  final double padding;

  BorderedContainer({
    @required this.child,
    this.padding: 16.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        border: Border.all(
          color: LanGuideTheme.primaryColor(context).shade400,
          width: 3.0,
        ),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: child,
    );
  }
}
