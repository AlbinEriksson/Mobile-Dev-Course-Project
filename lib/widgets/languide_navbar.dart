import 'package:dva232_project/routes.dart';
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
    return AppBar(
      automaticallyImplyLeading: false,
      actions: [
        Expanded(
          child: Stack(
            children: [
              if(showBackIcon) Container(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: Icon(Icons.arrow_back),
                  iconSize: 40.0,
                  onPressed: () => _backIconPressed(context),
                ),
              ),
              if(showFlag) Container(
                alignment: Alignment.centerRight,
                child: IconButton(
                  icon: Image.asset("icons/flags/png/gb.png", package: "country_icons"),
                  iconSize: 60.0,
                  onPressed: () => Navigator.pushNamed(context, Routes.languageSelection),
                ),
              )
            ],
          ),
        ),
      ],
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
  Size get preferredSize => Size.fromHeight(55.0);
}
