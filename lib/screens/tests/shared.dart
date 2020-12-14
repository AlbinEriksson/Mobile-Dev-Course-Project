import 'package:flutter/material.dart';

Future<bool> backPressed(BuildContext context, bool hasProgress) {
  if(hasProgress) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Are you sure?"),
        content: Text("You will lose your progress if you go back!"),
        actions: [
          new TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text("NO"),
          ),
          new TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text("YES"),
          ),
        ],
      ),
    ) ?? false;
  }

  return Future.value(true);
}

void backIconPressed(BuildContext context, bool hasProgress) async {
  if(await backPressed(context, hasProgress)) {
    Navigator.pop(context);
  }
}
