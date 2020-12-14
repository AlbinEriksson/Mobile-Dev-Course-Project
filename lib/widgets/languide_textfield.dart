import 'package:flutter/material.dart';

class LanGuideTextField extends StatelessWidget {
  final IconData icon;
  final String hintText;
  final Function(String) onChanged;
  final bool obscureText;

  LanGuideTextField(
      {Key key,
      this.icon,
      this.hintText,
      this.onChanged,
      this.obscureText: false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Icon prefixIcon;
    if (icon != null) {
      prefixIcon = Icon(icon);
    }

    return TextField(
      obscureText: obscureText,
      style: TextStyle(
        fontSize: 17.0,
      ),
      decoration: InputDecoration(
        prefixIcon: prefixIcon,
        hintText: hintText,
        hintStyle: TextStyle(
            //color: Colors.purple,
            ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100.0),
          borderSide: BorderSide(
            color: Colors.purple,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100.0),
          borderSide: BorderSide(
            color: Colors.purple,
          ),
        ),
      ),
      onChanged: onChanged,
    );
  }
}
