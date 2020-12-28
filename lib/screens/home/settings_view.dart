import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:dva232_project/settings.dart';

class SettingsView extends StatefulWidget {
  @override
  _SettingsViewState createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  String dropDownValue = 'light';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(left: 16, top: 25, right: 16),
        child: ListView(
          scrollDirection: Axis.vertical,
          children: [
            SizedBox(
              height: 5,
            ),
            ExpansionTile(
              title: Row(
                children: [
                  Icon(
                    Icons.person,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    "Account",
                    style: TextStyle(
                      fontSize: 23,
                      //fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
                ],
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
                  child: Row(
                      children: [
                        Text(
                            "Name:",
                            style: TextStyle(
                              fontSize: 23,
                            )
                        ),
                        Spacer(),
                        Text(
                            "Ben Dover",
                            style: TextStyle(
                              fontSize: 23,
                            )
                        )
                      ]
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
                  child: Row(
                    children: [
                      Text(
                        "Email:",
                        style: TextStyle(
                          fontSize: 23,
                        )
                      ),
                      Spacer(),
                      Text(
                        "benDover99@gmail.com",
                        style: TextStyle(
                          fontSize: 23,
                        )
                      )
                    ]
                  )
                )
              ]
            ), //Account information
            ExpansionTile(
              title: Row(
                children: [
                  Icon(
                    Icons.lock,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    "Privacy & Security",
                    style: TextStyle(
                      fontSize: 23,
                      //fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
                ],
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
                  child: GestureDetector(
                      onTap:() {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              content: Text("A confirmation email has been sent to your email adress."),
                            );
                          },
                        );
                      },
                      child: Row(
                        children: [
                          Text(
                              "Reset password",
                              style: TextStyle(
                                fontSize: 23,
                              )
                          ),
                          Spacer(),
                        ]
                    ),
                  )
                )
              ]
            ),
            ExpansionTile(
              title: Row(
                children: [
                  Icon(
                    Icons.nightlight_round,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    "Light/Dark theme",
                    style: TextStyle(
                      fontSize: 23,
                      //fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
                ],
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
                  child: Row(
                      children: [
                          DropdownButton<String>(
                            value: dropDownValue,
                            style: TextStyle(fontSize: 23, color: Colors.blue,),
                            underline: Container(
                              height: 2,
                            ),
                            onChanged: (String newValue) {
                              setState(() {
                                dropDownValue = newValue;
                                if(dropDownValue == 'light'){
                                  Settings.setThemeMode(ThemeMode.light);
                                }
                                else if(dropDownValue == 'dark'){
                                  Settings.setThemeMode(ThemeMode.dark);
                                }
                                else if(dropDownValue == 'system'){
                                  Settings.setThemeMode(ThemeMode.system);
                                }
                                Settings.updateTheme();
                              });
                            },
                            items: <String>['light', 'dark', 'system']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                        ),
                      ]
                  ),
                )
              ]
            ),
          ],
        ),
      ),
    );
  }
}
