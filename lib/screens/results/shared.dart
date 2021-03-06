import 'package:dva232_project/client/user_api_client.dart';
import 'package:dva232_project/routes.dart';
import 'package:dva232_project/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Widget resultsDisplay(
    BuildContext context, double accuracy, int score, int maxScore) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Text(
        AppLocalizations.of(context).yourScoreIs,
        style: Theme.of(context).textTheme.headline4,
      ),
      Text(
        "${(100 * accuracy).toStringAsFixed(0)}%",
        style: Theme.of(context).textTheme.headline1,
      ),
      Text(AppLocalizations.of(context)
          .correctAnswers
          .replaceAll("\$1", "$score")
          .replaceAll("\$2", "$maxScore")),
    ],
  );
}

Widget backHomeButton(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: ElevatedButton(
      onPressed: () {
        Navigator.popUntil(context, ModalRoute.withName(Routes.home));
      },
      child: Text(AppLocalizations.of(context).backHome),
    ),
  );
}

void alertSubmitErrors(BuildContext context, Future<UserAPIResult> future) {
  future.then((result) {
    switch (result) {
      case UserAPIResult.serverError:
        _validationDialog(
            context, AppLocalizations.of(context).alertServerProblem);
        break;
      case UserAPIResult.clientError:
        _validationDialog(
            context, AppLocalizations.of(context).alertSubmitFailed);
        break;
      case UserAPIResult.accessTokenExpired:
      case UserAPIResult.noRefreshToken:
        _validationDialog(
            context, AppLocalizations.of(context).alertSessionError);
        break;
      case UserAPIResult.noInternetConnection:
        _validationDialog(
            context, AppLocalizations.of(context).alertInternetConnection);
        break;
      case UserAPIResult.serverUnavailable:
        _validationDialog(
            context, AppLocalizations.of(context).alertServerMaintenance);
        break;
      default:
        break;
    }
  });
}

Future<T> _validationDialog<T>(BuildContext context, String text) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      content: Text(text),
    ),
  );
}

Future<bool> backPressed(BuildContext context) async {
  Navigator.popUntil(context, ModalRoute.withName(Routes.home));
  return false;
}

Widget answers(
    BuildContext context, List<String> editedWords, List<String> correctWords) {
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
    widgets.add(_answerTile(context, editedWords[i], correctWords[i]));
  }

  return Column(children: widgets);
}

Widget _answerTile(
    BuildContext context, String editedWord, String correctWord) {
  bool correct = editedWord.toLowerCase() == correctWord.toLowerCase();

  return ListTile(
    leading: Text(correctWord),
    trailing: Text(
      editedWord,
      style: correct
          ? LanGuideTheme.correctAnswerText(context)
          : LanGuideTheme.incorrectAnswerText(context),
    ),
  );
}
