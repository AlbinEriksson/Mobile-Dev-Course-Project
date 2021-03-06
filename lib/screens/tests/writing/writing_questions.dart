import 'package:dva232_project/routes.dart';
import 'package:dva232_project/theme.dart';
import 'package:dva232_project/widgets/languide_button.dart';
import 'package:dva232_project/widgets/languide_navbar.dart';
import 'package:flutter/material.dart';
import 'package:dva232_project/screens/tests/shared.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class WritingQuestion extends StatefulWidget {
  final String difficulty;

  WritingQuestion(this.difficulty);

  @override
  _WritingQuestionState createState() => _WritingQuestionState(difficulty);
}

class _WritingQuestionState extends State<WritingQuestion> {
  final String difficulty;

  List<String> optionFields = List.generate(5, (_) => null);

  final List<List<String>> questionOptions = [
    ['Secondly', 'Second', 'Previously'],
    ['It should be noted', 'Obviously', 'Finally'],
    ['absolutely', 'first and foremost', 'however'],
    ['Unlike', 'Despite', 'In particular'],
    ['besides', 'therefore', 'whereas'],
  ];

  final List<int> correctAnswerIndices = [0, 2, 2, 1, 1];

  final List<String> textSpans = [
    '''His paper integrates elements from the theory of agency, the theory of property rights and the theory of finance to develop a theory of the ownership structure of the firm. Firstly, we define the concept of agency costs and show its relationship to the ‘separation and control’ issue. ''',
    ''', we investigate the nature of the agency costs generated by the existence of debt and outside equity, demonstrate who bears these costs and why, and investigate the Pareto optimality of their existence. \n''',
    ''', we provide a new definition of the firm, and show how our analysis of the factors influencing the creation and issuance of debt and equity claims is a special case of the supply side of the completeness of markets problem.The directors of such companies, ''',
    ''', being the managers rather of other people's money than of their own, it cannot well be expected, that they should watch over it with the same anxious vigilance with which the partners in a private copartnery frequently watch over their own. \n''',
    ''' the stewards of a rich man, they are not apt to consider attention to small matters as not for their master's honour, and very easily give themselves a dispensation from having it. Negligence and profusion, ''',
    ''', must always prevail, more or less, in the management of the affairs of such a company.''',
  ];

  bool anyOptionSelected = false;

  _WritingQuestionState(this.difficulty);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => backPressed(context, anyOptionSelected),
      child: Scaffold(
        appBar: LanGuideNavBar(
            onBackIconPressed: () =>
                backIconPressed(context, anyOptionSelected)),
        body: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(
                flex: 3,
                child: ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        AppLocalizations.of(context).text,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headline3,
                      ),
                    ),
                    _textContent(),
                  ],
                ),
              ),
              Divider(),
              Expanded(
                flex: 2,
                child: ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        AppLocalizations.of(context).options,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headline3,
                      ),
                    ),
                    _questions(),
                    LanGuideButton(
                      text: AppLocalizations.of(context).submitAnswers,
                      onPressed: () => submitPressed(
                        context,
                        Routes.writingResults,
                        {
                          "score": _countCorrectAnswers(),
                          "difficulty": difficulty,
                          "editedWords": optionFields.map((e) => e ?? "").toList(),
                          "correctWords": _correctWords(),
                        },
                      ),
                      enabled: anyOptionSelected,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  RichText _textContent() {
    List<TextSpan> children = [];
    for(int i = 0; i < textSpans.length; i++) {
      children.addAll(_textPart(i));
    }

    return RichText(
      textAlign: TextAlign.justify,
      text: TextSpan(
        style: Theme.of(context).textTheme.bodyText2,
        children: children,
      ),
    );
  }

  List<TextSpan> _textPart(int index) {
    return [
      TextSpan(text: textSpans[index]),
      if(index < optionFields.length) TextSpan(
        text: optionFields[index] ?? (index + 1).toString().padLeft(11).padRight(21),
        style: LanGuideTheme.writingTestOption(context),
      ),
    ];
  }

  Widget _questions() {
    final String number = AppLocalizations.of(context).number;

    List<Widget> questionWidgets = [];
    for (int i = 0; i < 5; i++) {
      questionWidgets.add(
        Text(
          "$number ${i + 1}",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headline5,
        ),
      );

      questionWidgets.add(_questionOptions(i));
    }

    return Column(children: questionWidgets);
  }

  Widget _questionOptions(int questionIndex) {
    List<Widget> optionWidgets = [];
    for (int i = 0; i < 3; i++) {
      String option = questionOptions[questionIndex][i];
      optionWidgets.add(ListTile(
        title: Text(
          option,
          style: Theme.of(context).textTheme.bodyText2,
        ),
        leading: Radio(
          value: option,
          groupValue: optionFields[questionIndex],
          onChanged: (value) {
            setState(() {
              optionFields[questionIndex] = option;
              anyOptionSelected = true;
            });
          },
        ),
        dense: true,
      ));
    }

    return Column(
      children: optionWidgets,
    );
  }

  List<String> _correctWords() {
    return questionOptions.asMap().entries.map((entry) {
      int questionIndex = entry.key;
      List<String> options = entry.value;
      return options[correctAnswerIndices[questionIndex]];
    }).toList();
  }

  int _countCorrectAnswers() {
    int points = 0;
    for(int i = 0; i < optionFields.length; i++) {
      String correctAnswer = questionOptions[i][correctAnswerIndices[i]];
      if(optionFields[i] != null && optionFields[i] == correctAnswer) {
        points++;
      }
    }
    return points;
  }
}
