import 'package:dva232_project/screens/tests/reading/items.dart';
import 'package:dva232_project/screens/tests/reading/question_data.dart';
import 'package:dva232_project/screens/tests/shared.dart';
import 'package:dva232_project/theme.dart';
import 'package:dva232_project/widgets/languide_button.dart';
import 'package:dva232_project/widgets/languide_navbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dva232_project/routes.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ReadingTestQuestions extends StatefulWidget {
  final String difficulty;

  ReadingTestQuestions(this.difficulty);

  @override
  _ReadingTestQuestionsState createState() =>
      _ReadingTestQuestionsState(difficulty);
}

class _ReadingTestQuestionsState extends State<ReadingTestQuestions> {
  final String difficulty;
  ScrollController _scrollController;
  int currentQuestionIndex = 0;
  List<int> answers = [-1];
  bool anyAnswerSelected = false;
  int maxPoints = 0;

  Future<QuestionData> questionsFuture = QuestionData.showData();
  QuestionData questions;

  _ReadingTestQuestionsState(this.difficulty);

  @override
  void initState() {
    super.initState();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => backPressed(context, anyAnswerSelected),
      child: Scaffold(
        appBar: LanGuideNavBar(
            onBackIconPressed: () =>
                backIconPressed(context, anyAnswerSelected)),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Scrollbar(
                    isAlwaysShown: _scrollController != null,
                    controller: _scrollController,
                    child: Center(
                      child: FutureBuilder(
                        future: questionsFuture,
                        builder: (BuildContext context,
                            AsyncSnapshot<QuestionData> snapshot) {
                          if (snapshot.hasData) {
                            _scrollController = new ScrollController();
                            questions = snapshot.data;
                            return createListView(context);
                          } else {
                            return CircularProgressIndicator();
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ),
              LanGuideButton(
                text: AppLocalizations.of(context).submitAnswers,
                onPressed: () => submitPressed(
                  context,
                  Routes.readingResults,
                  {
                    "score": _countCorrectAnswers(),
                    "difficulty": difficulty,
                    "editedWords": _editedWords(),
                    "correctWords": _correctWords(),
                  },
                ),
                enabled: anyAnswerSelected,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget createListView(BuildContext context) {
    maxPoints = questions.items.length;
    return ListView.builder(
      controller: _scrollController,
      itemCount: questions.items == null ? 0 : questions.items.length,
      itemBuilder: (context, int index) {
        List<Widget> radioButtons =
            answersRadioButtons(index, questions.items[index].answers, context);
        if (questions.randomiseChoices) {
          radioButtons.shuffle();
        }
        return Wrap(
          children: [
            ExpansionTile(
              title: RichText(
                text: TextSpan(
                  style: Theme.of(context).textTheme.bodyText2,
                  children: [
                    if (questions.showQuestionNumbers)
                      TextSpan(
                        text: AppLocalizations.of(context).questionNum.replaceAll("\$1", "${index + 1}"),
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    _createFormattedText(questions.items[index].text),
                    TextSpan(text: " "),
                    TextSpan(text: "        ", style: LanGuideTheme.writingTestOption(context)),
                  ],
                ),
              ),
              children: radioButtons,
            ),
          ],
        );
      },
    );
  }

  TextSpan _createFormattedText(String source, [TextStyle style]) {
    List<TextSpan> spans = [];

    int i = 0;
    while (i < source.length) {
      int textUntil = source.indexOf("<", i);
      if (textUntil == -1) {
        textUntil = source.length;
      }

      String text = source.substring(i, textUntil).trim();
      if (text.isNotEmpty) {
        spans.add(TextSpan(text: text, style: style));
        if(style != null) {
          spans.add(TextSpan(text: "\n"));
        }
      }

      i = textUntil;

      if (i >= source.length) {
        break;
      }

      int start = i + 1;
      int end = source.indexOf(">", start);
      String tag = source.substring(start, end);

      int closeTagPos = source.indexOf("</$tag>", end);
      String tagContents = source.substring(end + 1, closeTagPos);

      spans.add(_createFormattedText(tagContents, _htmlTagToTheme(tag)));

      i = closeTagPos + end - start + 3;
    }

    return TextSpan(children: spans);
  }

  TextStyle _htmlTagToTheme(String tag) {
    switch (tag) {
      case "h2":
        return Theme.of(context).textTheme.headline5;
    }

    return null;
  }

  List<Widget> answersRadioButtons(
      int index, List<Choice> choices, BuildContext context) {
    List<Widget> radioButtons = [];
    for (int i = 0; i < choices.length; i++) {
      var choice = choices[i];
      radioButtons.add(ListTile(
          title:
              Text(choice.text, style: Theme.of(context).textTheme.bodyText2),
          leading: Radio(
            value: i,
            groupValue: answers[index],
            onChanged: (value) {
              setState(() {
                answers[index] = value;
                anyAnswerSelected = true;
              });
            },
          )));
    }
    return radioButtons;
  }

  int _countCorrectAnswers() {
    int points = 0;
    for(int i = 0; i < questions.items.length; i++) {
      Items question = questions.items[i];
      int selectedAnswer = answers[i];
      if(question.answers[selectedAnswer].correct) {
        points++;
      }
    }
    return points;
  }

  List<String> _editedWords() {
    return answers.asMap().entries.map((entry) {
      int questionIndex = entry.key;
      int answerIndex = entry.value;
      return questions.items[questionIndex].answers[answerIndex].text;
    }).toList();
  }

  List<String> _correctWords() {
    return questions.items.map((question) {
      return question.answers.firstWhere((answer) => answer.correct).text;
    }).toList();
  }
}
