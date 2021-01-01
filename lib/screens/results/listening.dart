import 'package:dva232_project/client/user_api_client.dart';
import 'package:dva232_project/screens/results/shared.dart';
import 'package:flutter/material.dart';
import 'package:dva232_project/widgets/languide_navbar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../theme.dart';

class ListeningResults extends StatelessWidget {
  final int score;
  final List<String> rightAnswers, correctedWordsList;
  final String difficulty;
  final double accuracy;
  final Future<UserAPIResult> submitFuture;

  ListeningResults({
    Key key,
    @required this.rightAnswers,
    @required this.correctedWordsList,
    @required this.score,
    @required this.difficulty,
  })  : accuracy = score/rightAnswers.length,
        submitFuture =
        UserAPIClient.submitTestResults("listening", difficulty, score/rightAnswers.length),
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
        resultsDisplay(context, accuracy, score, correctedWordsList.length),
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

    for (int i = 0; i < correctedWordsList.length; i++) {
      widgets.add(_answerTile(i, context));
    }

    return Column(children: widgets);
  }
  Widget _answerTile(int index, BuildContext context) {
    bool correct =
        correctedWordsList[index].toLowerCase() == rightAnswers[index].toLowerCase();

    return ListTile(
      leading: Text(rightAnswers[index]),
      trailing: Text(
        correctedWordsList[index],
        style: correct
            ? LanGuideTheme.correctAnswerText(context)
            : LanGuideTheme.incorrectAnswerText(context),
      ),
    );
  }
}
