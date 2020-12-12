import 'package:dva232_project/routes.dart';
import 'package:dva232_project/widgets/circular_button.dart';
import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _takeTestButton(context, Routes.readingTest, Colors.purple[100],
                    Icons.remove_red_eye_outlined, "Reading"),
                _takeTestButton(context, Routes.speakingTest, Colors.cyan[100],
                    Icons.mic_outlined, "Speaking"),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _takeTestButton(context, Routes.listeningTestIntro,
                    Colors.green[100], Icons.hearing_outlined, "Listening"),
                _takeTestButton(context, Routes.writingTest, Colors.orange[100],
                    Icons.create_outlined, "Writing"),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _takeTestButton(context, Routes.vocabularyTest, Colors.red[100],
                    Icons.spellcheck_outlined, "Vocabulary"),
              ],
            ),
          ],
        ),
      );

  Widget _takeTestButton(BuildContext context, String routeTo, Color color,
          IconData icon, String text) =>
      CircularButton(
        onPressed: () => _chooseDifficulty(context, routeTo),
        color: color,
        icon: Icon(icon, size: 60.0),
        text: text,
        size: 150,
      );

  void _chooseDifficulty(BuildContext context, String routeTo) {
    Navigator.pushNamed(context, routeTo);
  }
}
