import 'package:dva232_project/routes.dart';
import 'package:dva232_project/widgets/languide_navbar.dart';
import 'package:flutter/material.dart';

import '../shared.dart';

class ListeningTestIntro extends StatefulWidget {
  @override
  _ListeningTestIntroState createState() => _ListeningTestIntroState();
}

class _ListeningTestIntroState extends State<ListeningTestIntro> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: LanGuideNavBar(
          onBackIconPressed: () => backIconPressed(context, true)),
      body: Container(
        alignment: Alignment.topCenter,
        child: ListView(
          scrollDirection: Axis.vertical,
          padding: EdgeInsets.all(20.5),
          children: [
            Container(
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.purple.shade400, width: 3.0),
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Column(
                children: [
                  Text(
                    'You will hear a radio programme about the life of the singer, Lena Horne.'
                    ' For questions 1-8, complete the sentences.',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Container(
                height: 50.0,
                child: RaisedButton(
                  color: Colors.purple,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  child: Text(
                    "Start Test",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 21.0,
                    ),
                  ),
                  onPressed: () => Navigator.pushNamed(
                      context, Routes.listeningTestQuestions,
                      arguments: null),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
