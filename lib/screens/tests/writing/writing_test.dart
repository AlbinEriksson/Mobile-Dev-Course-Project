import 'package:dva232_project/routes.dart';
import 'package:dva232_project/widgets/bordered_container.dart';
import 'package:dva232_project/widgets/languide_navbar.dart';
import 'package:flutter/material.dart';

class WritingTest extends StatefulWidget {
  @override
  _WritingTestState createState() => _WritingTestState();
}

class _WritingTestState extends State<WritingTest> {
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
              child: Text(
                'You will now get a text and in the text, there will be gaps. Choose the most likely linking word/phrase to fill each gap. Scroll to see the alternatives.\nPress start to begin the test.',
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).popAndPushNamed(Routes.writingQuestions);
              },
              child: Text('Start'),
            ),
          ],
        ),
      ),
    );
  }
}
