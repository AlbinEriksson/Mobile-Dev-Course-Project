import 'package:flutter/material.dart';

class LanGuideNavBar extends StatelessWidget with PreferredSizeWidget {
  final Function onBackIconPressed;
  final bool showBackIcon;
  final bool showFlag;

  LanGuideNavBar({
    this.onBackIconPressed,
    this.showBackIcon = true,
    this.showFlag = false,
  });

  @override
  Widget build(BuildContext context) {
    var topWidgets = <Widget>[];

    if (showBackIcon) {
      topWidgets.add(IconButton(
        icon: Icon(Icons.arrow_back),
        iconSize: 40.0,
        onPressed: () => _backIconPressed(context),
      ));
    }

    if (showFlag) {
      topWidgets.add(IconButton(
        icon: Image.asset("icons/flags/png/gb.png", package: "country_icons"),
        iconSize: 60.0,
      ));
    }

    return SafeArea(
      child: Container(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: topWidgets,
          ),
        ),
      ),
    );
  }

  void _backIconPressed(BuildContext context) {
    if (onBackIconPressed != null) {
      onBackIconPressed();
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Size get preferredSize => Size.fromHeight(100);
}
