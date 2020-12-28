import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void submitPressed(BuildContext context, String routeTo,
    Map<String, dynamic> arguments) async {
  if (await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(AppLocalizations.of(context).submitAnswersQuestion),
          content: Text(AppLocalizations.of(context).confirmSubmitAnswers),
          actions: [
            new TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(AppLocalizations.of(context).no.toUpperCase()),
            ),
            new TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(AppLocalizations.of(context).yes.toUpperCase()),
            ),
          ],
        ),
      ) ??
      false) {
    Navigator.pushNamed(context, routeTo, arguments: arguments);
  }
}

Future<bool> backPressed(BuildContext context, bool hasProgress) {
  if (hasProgress) {
    return showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(AppLocalizations.of(context).areYouSure),
            content: Text(AppLocalizations.of(context).confirmLoseProgress),
            actions: [
              new TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(AppLocalizations.of(context).no.toUpperCase()),
              ),
              new TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(AppLocalizations.of(context).yes.toUpperCase()),
              ),
            ],
          ),
        ) ??
        false;
  }

  return Future.value(true);
}

void backIconPressed(BuildContext context, bool hasProgress) async {
  if (await backPressed(context, hasProgress)) {
    Navigator.pop(context);
  }
}
