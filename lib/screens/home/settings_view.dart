import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SettingsView extends StatefulWidget {
  @override
  _SettingsViewState createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(left: 16, top: 25, right: 16),
        child: ListView(
          children: [
            SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: (){

              },
              child: Row(
                children: [
                  Icon(
                    Icons.person,
                    color: Colors.purple,
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
                  Icon(
                    Icons.arrow_forward_ios,
                  )
                ],
              ),
            ),
            Divider(
              height: 50,
              thickness: 2,
              indent: 0,
              endIndent: 0,
            ),
            GestureDetector(
              onTap: (){

              },
              child: Row(
                children: [
                  Icon(
                    Icons.lock,
                    color: Colors.purple,
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
                  Icon(
                    Icons.arrow_forward_ios,
                  )
                ],
              ),
            ),
            Divider(
              height: 50,
              thickness: 2,
              indent: 0,
              endIndent: 0,
            ),
            GestureDetector(
              onTap: (){

              },
              child: Row(
                children: [
                  Icon(
                    FontAwesomeIcons.globe,
                    color: Colors.purple,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    "Language",
                    style: TextStyle(
                      fontSize: 23,
                      //fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
                  Icon(
                    Icons.arrow_forward_ios,
                  )
                ],
              ),
            ),
            Divider(
              height: 50,
              thickness: 2,
              indent: 0,
              endIndent: 0,
            ),
            GestureDetector(
              onTap: (){

              },
              child: Row(
                children: [
                  Icon(
                    Icons.nightlight_round,
                    color: Colors.purple,
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
                  Icon(
                    Icons.arrow_forward_ios,
                  )
                ],
              ),
            ),
            Divider(
              height: 50,
              thickness: 2,
              indent: 0,
              endIndent: 0,
            ),
          ],
        ),
      ),
    );
  }
}
