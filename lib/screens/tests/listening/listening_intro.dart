import 'dart:convert';
import 'package:dva232_project/routes.dart';
import 'package:dva232_project/screens/tests/listening/question_data.dart';
import 'package:dva232_project/screens/tests/shared.dart';
import 'package:dva232_project/widgets/bordered_container.dart';
import 'package:dva232_project/widgets/languide_navbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ListeningTestIntro extends StatefulWidget {
  final String difficulty;

  ListeningTestIntro(this.difficulty);

  @override
  _ListeningTestIntroState createState() =>
      _ListeningTestIntroState(difficulty);
}

class _ListeningTestIntroState extends State<ListeningTestIntro> {
  final String difficulty;

  _ListeningTestIntroState(this.difficulty);

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
          onBackIconPressed: () => backIconPressed(context, false)),
      body: Container(
        alignment: Alignment.topCenter,
        child: ListView(
          scrollDirection: Axis.vertical,
          padding: EdgeInsets.all(20.5),
          children: [
            BorderedContainer(
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
              child: ElevatedButton(
                child: Text(
                  AppLocalizations.of(context).start,
                ),
                onPressed: () => Navigator.popAndPushNamed(
                  context,
                  Routes.listeningTestQuestions,
                  arguments: {
                    "difficulty": difficulty,
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
