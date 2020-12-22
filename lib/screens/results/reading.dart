import 'package:dva232_project/widgets/back_icon_button.dart';
import 'package:dva232_project/widgets/back_nav_button.dart';
import 'package:flutter/material.dart';
import 'package:dva232_project/widgets/languide_navbar.dart';
import '../../routes.dart';

import 'package:dva232_project/screens/tests/shared.dart';

class ReadingResults extends StatelessWidget {
  final int score;

  ReadingResults({Key key, @required this.score}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: LanGuideNavBar(
        showBackIcon: false,
      ),
      body: Container(
        alignment: Alignment.center,
        child: ListView(
          scrollDirection: Axis.vertical,
          padding: EdgeInsets.all(20.0),
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.5,
              height: MediaQuery.of(context).size.height * 0.4,
              decoration: BoxDecoration(
                color: Colors.deepPurple.shade100,
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                      padding: EdgeInsets.fromLTRB(0, 20.0, 0, 0),
                      child: Row(

                        mainAxisAlignment: MainAxisAlignment.center,
                        children:[
                          Text(
                            "Results",
                            style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.purple.shade800,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ]
                      )
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:[
                      Text(
                        "$score",
                        style: TextStyle(
                          fontSize: 200.0,
                          color: Colors.purple.shade900,
                          fontWeight: FontWeight.bold,
                        )
                      )
                    ]
                  ),
                ],
              ),
            ),
            MaterialButton(
              onPressed: () {
                Navigator.popAndPushNamed(context, Routes.home);
              },
              minWidth: 160,
              color: Colors.purple,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ),
              child: const Text(
                  "Back home",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 17.0,
                  )
              ),
            ),
          ],
        ),
      ),
    );
  }
}
