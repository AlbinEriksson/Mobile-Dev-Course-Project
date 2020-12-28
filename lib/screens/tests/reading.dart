import 'package:dva232_project/routes.dart';
import 'package:dva232_project/screens/tests/shared.dart';
import 'package:dva232_project/widgets/bordered_container.dart';
import 'package:dva232_project/widgets/languide_button.dart';
import 'package:flutter/material.dart';
import 'package:dva232_project/widgets/languide_navbar.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
                AppLocalizations.of(context).whatGrammaticalError,
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
            Column(
              children: [
                _optionShouldBe(0, "Your", "You're"),
                _optionShouldBe(1, "a", "an"),
                _optionShouldBe(2, "person", "people"),
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
                      text: AppLocalizations.of(context).previous,
                      enabled: currentQuestionIndex > 0,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: LanGuideButton(
                      onPressed: () {},
                      text: AppLocalizations.of(context).next,
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
              text: AppLocalizations.of(context).submitAnswers,
              enabled: anyAnswerSelected,
            ),
          ],
        ),
      ),
    );
  }

  Widget _optionShouldBe(int value, String original, String suggestion) {
    final String shouldBe = AppLocalizations.of(context).shouldBe;
    return _option(value, '"$original" $shouldBe "$suggestion"');
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
