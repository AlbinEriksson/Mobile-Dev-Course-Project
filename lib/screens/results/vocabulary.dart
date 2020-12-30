import 'package:dva232_project/client/user_api_client.dart';
import 'package:dva232_project/routes.dart';
import 'package:dva232_project/screens/results/shared.dart';
import 'package:dva232_project/theme.dart';
import 'package:flutter/material.dart';
import 'package:dva232_project/widgets/languide_navbar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class VocabularyResults extends StatelessWidget {
  final int score;
  final List<String> editedWords, correctWords;
  final double accuracy;
  final String difficulty;

  Future<UserAPIResult> submitFuture;

  VocabularyResults({
    Key key,
    @required this.score,
    @required this.editedWords,
    @required this.correctWords,
    @required this.difficulty,
  })  : accuracy = score / editedWords.length,
        super(key: key) {
    submitFuture =
        UserAPIClient.submitTestResults("vocabulary", difficulty, accuracy);
  }

  @override
  Widget build(BuildContext context) {
    alertSubmitErrors(context, submitFuture);

    return WillPopScope(
      onWillPop: () async {
        Navigator.popUntil(context, ModalRoute.withName(Routes.home));
        return false;
      },
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
            }),
      ),
    );
  }

  Widget _results(BuildContext context) {
    return ListView(
      scrollDirection: Axis.vertical,
      padding: EdgeInsets.all(8.0),
      children: [
        resultsDisplay(context, accuracy, score, this.editedWords.length),
        _answers(context),
        backHomeButton(context),
      ],
    );
  }

  Widget _answers(BuildContext context) {
    List<Widget> widgets = [
      ListTile(
        leading: Text(
          AppLocalizations.of(context).correctAnswer,
          style: Theme.of(context).textTheme.bodyText1,
        ),
        trailing: Text(
          AppLocalizations.of(context).yourAnswer,
          style: Theme.of(context).textTheme.bodyText1,
        ),
      ),
    ];

    for (int i = 0; i < editedWords.length; i++) {
      widgets.add(_answerTile(i, context));
    }

    return Column(children: widgets);
  }

  Widget _answerTile(int index, BuildContext context) {
    bool correct =
        editedWords[index].toLowerCase() == correctWords[index].toLowerCase();

    return ListTile(
      leading: Text(correctWords[index]),
      trailing: Text(
        editedWords[index],
        style: correct
            ? LanGuideTheme.correctAnswerText(context)
            : LanGuideTheme.incorrectAnswerText(context),
      ),
    );
  }
}
