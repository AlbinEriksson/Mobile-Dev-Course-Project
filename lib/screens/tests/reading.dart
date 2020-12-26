import 'package:dva232_project/routes.dart';
import 'package:dva232_project/screens/tests/shared.dart';
import 'package:dva232_project/widgets/bordered_container.dart';
import 'package:dva232_project/widgets/languide_button.dart';
import 'package:flutter/material.dart';
import 'package:dva232_project/widgets/languide_navbar.dart';
import 'package:auto_size_text/auto_size_text.dart';

class ReadingTest extends StatefulWidget {
  @override
  _ReadingTestState createState() {
    return _ReadingTestState();
  }
}

class _ReadingTestState extends State<ReadingTest> {
  int currentQuestionIndex = 0;
  List<int> answers = [-1];
  bool anyAnswerSelected = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => backPressed(context, anyAnswerSelected),
      child: Scaffold(
        appBar: LanGuideNavBar(
          onBackIconPressed: () => backIconPressed(context, anyAnswerSelected),
        ),
        body: ListView(
          scrollDirection: Axis.vertical,
          padding: EdgeInsets.all(20.0),
          children: [
            BorderedContainer(
              child: Center(
                child: AutoSizeText(
                  'Your a good person',
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "What is the grammatical error?",
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
            Column(
              children: [
                _option(0, "Your should be you're"),
                _option(1, "A should be an"),
                _option(2, "Person should be people"),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: LanGuideButton(
                      onPressed: () {},
                      text: "Previous",
                      enabled: currentQuestionIndex > 0,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: LanGuideButton(
                      onPressed: () {},
                      text: "Next",
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            LanGuideButton(
              onPressed: () {
                int scoreToSend = 60;
                submitPressed(
                    context, Routes.readingResults, {"score": scoreToSend});
              },
              text: "Submit answers",
            ),
          ],
        ),
      ),
    );
  }

  Widget _option(int value, String text) {
    return ListTile(
      title: Text(text),
      leading: Radio(
        value: value,
        groupValue: answers[currentQuestionIndex],
        onChanged: (value) {
          setState(() {
            answers[currentQuestionIndex] = value;
            anyAnswerSelected = true;
          });
        },
      ),
    );
  }
}
