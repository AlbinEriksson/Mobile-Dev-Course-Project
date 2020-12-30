import 'package:dva232_project/routes.dart';
import 'package:dva232_project/widgets/bordered_container.dart';
import 'package:dva232_project/widgets/languide_navbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class WritingTest extends StatefulWidget {
  final String difficulty;

  WritingTest(this.difficulty);

  @override
  _WritingTestState createState() => _WritingTestState(difficulty);
}

class _WritingTestState extends State<WritingTest> {
  final String difficulty;

  _WritingTestState(this.difficulty);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: LanGuideNavBar(),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Cambridge English: CAE Writing 1',
                style: Theme.of(context).textTheme.headline4,
              ),
            ),
            BorderedContainer(
              child: Text(AppLocalizations.of(context).writingTestInstructions),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context)
                    .popAndPushNamed(Routes.writingQuestions, arguments: {
                  "difficulty": difficulty,
                });
              },
              child: Text(AppLocalizations.of(context).start),
            ),
          ],
        ),
      ),
    );
  }
}
