import 'package:dva232_project/client/user_api_client.dart';
import 'package:dva232_project/routes.dart';
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
    submitFuture.then((result) {
      switch (result) {
        case UserAPIResult.serverError:
          _validationDialog(
              context, AppLocalizations.of(context).alertServerProblem);
          break;
        case UserAPIResult.clientError:
          _validationDialog(context,
              "The app has failed to submit your result. Please report this issue to the developers.");
          break;
        case UserAPIResult.accessTokenExpired:
        case UserAPIResult.noRefreshToken:
          _validationDialog(context,
              "Something went wrong with your session. Please login again.");
          break;
        case UserAPIResult.noInternetConnection:
          _validationDialog(context,
              AppLocalizations.of(context).alertInternetConnection);
          break;
        case UserAPIResult.serverUnavailable:
          _validationDialog(context,
              AppLocalizations.of(context).alertServerMaintenance);
          break;
        default:
          break;
      }
    });

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
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Your score is",
              style: Theme.of(context).textTheme.headline4,
            ),
            Text(
              "${(100 * accuracy).toStringAsFixed(0)}%",
              style: Theme.of(context).textTheme.headline1,
            ),
            Text("$score correct answers out of ${this.editedWords.length}"),
          ],
        ),
        _answers(context),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: ElevatedButton(
            onPressed: () {
              Navigator.popUntil(context, ModalRoute.withName(Routes.home));
            },
            child: const Text("Back home"),
          ),
        ),
      ],
    );
  }

  Widget _answers(BuildContext context) {
    List<Widget> widgets = [
      ListTile(
        leading: Text(
          "Correct answer",
          style: Theme.of(context).textTheme.bodyText1,
        ),
        trailing: Text(
          "Your answer",
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

  Future<T> _validationDialog<T>(BuildContext context, String text) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(text),
      ),
    );
  }
}
