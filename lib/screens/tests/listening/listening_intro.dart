import 'dart:convert';
import 'package:dva232_project/routes.dart';
import 'package:dva232_project/screens/tests/listening/question_data.dart';
import 'package:dva232_project/widgets/languide_navbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../shared.dart';

class ListeningTestIntro extends StatefulWidget {
  @override
  _ListeningTestIntroState createState() => _ListeningTestIntroState();
}

class _ListeningTestIntroState extends State<ListeningTestIntro> {

  Future<String> getJson() {
    return rootBundle.loadString('lib/jsonFiles/listening.json');
  }

  Future _showData() async {
    String jsonString = await getJson();
    final jsonResponse = json.decode(jsonString);
    QuestionData question = QuestionData.fromJson(jsonResponse);

    return question;
  }

  @override
  void initState() {
    super.initState();
    _showData();
  }

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
                  FutureBuilder(
                    future: _showData(),
                    builder: (BuildContext context,
                        AsyncSnapshot<dynamic> snapshot) {
                      if (snapshot.hasData) {
                        return Text(
                              '${snapshot.data.instructions}',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.normal,
                              ),
                            );
                      } else {
                        return CircularProgressIndicator();
                      }
                    },
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
