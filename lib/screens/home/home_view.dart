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
                _takeTestButton(Routes.readingTest, Colors.purple[100],
                    Icons.remove_red_eye_outlined, "Reading"),
                _takeTestButton(Routes.speakingTest, Colors.cyan[100],
                    Icons.mic_outlined, "Speaking"),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _takeTestButton(Routes.listeningTest, Colors.green[100],
                    Icons.hearing_outlined, "Listening"),
                _takeTestButton(Routes.writingTest, Colors.orange[100],
                    Icons.create_outlined, "Writing"),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _takeTestButton(Routes.vocabularyTest, Colors.red[100],
                    Icons.spellcheck_outlined, "Vocabulary"),
              ],
            ),
          ],
        ),
      );

  Widget _takeTestButton(
          String routeTo, Color color, IconData icon, String text) =>
      CircularButton(
        onPressed: () => _chooseDifficulty(routeTo),
        color: color,
        icon: Icon(icon, size: 60.0),
        text: text,
        size: 150,
      );

  void _chooseDifficulty(String routeTo) {}
}
