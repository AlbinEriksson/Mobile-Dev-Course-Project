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

  Future<QuestionData> _showData() async {
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
        child: FutureBuilder(
          future: _showData(),
          builder: (BuildContext context,
              AsyncSnapshot<QuestionData> snapshot) {
            if (snapshot.hasData) {
              return ListView(
                padding: EdgeInsets.all(8.0),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      snapshot.data.title,
                      style: Theme.of(context).textTheme.headline4,
                    ),
                  ),
                  BorderedContainer(
                    child: Text(
                      '${snapshot.data.instructions}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.normal,
                      ),
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
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
