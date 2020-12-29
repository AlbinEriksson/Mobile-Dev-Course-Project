import 'package:dva232_project/theme.dart';
import 'package:flutter/material.dart';

class LanGuideDropdown extends StatefulWidget {
  final String hintText;
  final Function(String) onChanged;
  final Map<String, String> items;
  final String initialValue;

  LanGuideDropdown(
      {@required this.hintText,
      @required this.onChanged,
      @required this.items,
      this.initialValue});

  @override
  _LanGuideDropdownState createState() => _LanGuideDropdownState(
        hintText: hintText,
        onChanged: onChanged,
        items: items,
        initialValue: initialValue,
      );
}

class _LanGuideDropdownState extends State<LanGuideDropdown> {
  final String hintText;
  final Function(String) onChanged;
  final Map<String, String> items;

  String value;

  _LanGuideDropdownState(
      {@required this.hintText,
      @required this.onChanged,
      @required this.items,
      String initialValue}) {
    value = initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      height: 60,
      decoration: LanGuideTheme.inputFieldBorder(context),
      child: DropdownButtonHideUnderline(
        child: ButtonTheme(
          alignedDropdown: true,
          child: DropdownButton<String>(
            isExpanded: true,
            hint: Text(
              hintText,
              style: LanGuideTheme.inputFieldText(),
            ),
            value: value,
            items: items.entries
                .map((entry) => _dropdownItem(entry.key, entry.value))
                .toList(),
            onChanged: (String value) {
              setState(() {
                this.value = value;
              });
              onChanged(value);
            },
          ),
        ),
      ),
    );
  }

  DropdownMenuItem<String> _dropdownItem(String value, String text) {
    return DropdownMenuItem<String>(
      value: value,
      child: Text(
        text,
        style: LanGuideTheme.inputFieldText(),
      ),
    );
  }
}
