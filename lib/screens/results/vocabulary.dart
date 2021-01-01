import 'package:dva232_project/client/user_api_client.dart';
import 'package:dva232_project/screens/results/shared.dart';
import 'package:flutter/material.dart';
import 'package:dva232_project/widgets/languide_navbar.dart';

class VocabularyResults extends StatelessWidget {
  final int score;
  final List<String> editedWords, correctWords;
  final double accuracy;
  final String difficulty;

  final Future<UserAPIResult> submitFuture;

  VocabularyResults({
    Key key,
    @required this.score,
    @required this.editedWords,
    @required this.correctWords,
    @required this.difficulty,
  })  : accuracy = score / editedWords.length,
        submitFuture = UserAPIClient.submitTestResults(
            "vocabulary", difficulty, score / editedWords.length),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    alertSubmitErrors(context, submitFuture);

    return WillPopScope(
      onWillPop: () => backPressed(context),
      child: Scaffold(
        appBar: LanGuideNavBar(
          showBackIcon: false,
        ),
        body: FutureBuilder(
          future: submitFuture,
          builder: (context, data) {
            if (data.hasData) {
              return _results(context);
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

  Widget _results(BuildContext context) {
    return ListView(
      scrollDirection: Axis.vertical,
      padding: EdgeInsets.all(8.0),
      children: [
        resultsDisplay(context, accuracy, score, this.editedWords.length),
        answers(context, editedWords, correctWords),
        backHomeButton(context),
      ],
    );
  }
}
