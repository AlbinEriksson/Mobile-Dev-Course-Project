import 'package:dva232_project/theme.dart';
import 'package:flutter/material.dart';

class LanGuideTextField extends StatelessWidget {
  final IconData icon;
  final String hintText;
  final Function(String) onChanged;
  final Function() onEditingComplete;
  final bool obscureText;
  final FocusNode focusNode;
  final TextEditingController controller;
  final bool enabled;
  final bool enableSuggestions;

  LanGuideTextField(
      {Key key,
      this.icon,
      this.hintText,
      this.onChanged,
      this.onEditingComplete,
      this.obscureText: false,
      this.focusNode,
      this.controller,
      this.enabled: true,
      this.enableSuggestions: true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Icon prefixIcon;
    if (icon != null) {
      prefixIcon = Icon(icon);
    }

    return TextField(
      controller: controller,
      focusNode: focusNode,
      obscureText: obscureText,
      style: LanGuideTheme.inputFieldText(),
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
      onEditingComplete: onEditingComplete,
      enabled: enabled,
      enableSuggestions: enableSuggestions,
      autocorrect: enableSuggestions,
      keyboardType: enableSuggestions ? TextInputType.text : TextInputType.visiblePassword,
    );
  }
}
