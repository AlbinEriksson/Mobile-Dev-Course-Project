import 'package:dva232_project/theme.dart';
import 'package:dva232_project/widgets/bordered_container.dart';
import 'package:dva232_project/widgets/circular_button.dart';
import 'package:dva232_project/widgets/languide_button.dart';
import 'package:flutter/services.dart';
import 'question_data.dart';
import 'package:dva232_project/widgets/languide_dropdown.dart';
import 'package:dva232_project/widgets/languide_navbar.dart';
import 'package:dva232_project/widgets/languide_textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dva232_project/routes.dart';
import '../shared.dart';
import 'items.dart';
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
  QuestionData readingData = QuestionData();
  ScrollController _scrollController;
  int currentQuestionIndex = 0;
  List<int> answers = [-1];
  bool anyAnswerSelected = false;
  int points = 0;
  int maxPoints = 0;

  _ReadingTestQuestionsState(this.difficulty);

  @override
  void initState() {
    super.initState();
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () => backPressed(context, anyAnswerSelected),
      child: Scaffold(
        appBar: LanGuideNavBar(
            onBackIconPressed: () => backIconPressed(context, anyAnswerSelected)),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(
                child: BorderedContainer(
                  child: Column(
                    children: [
                      Expanded(
                        child: Scrollbar(
                          isAlwaysShown: _scrollController != null,
                          controller: _scrollController,
                          child: Center(
                            child: FutureBuilder(
                              future: readingData.showData(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<dynamic> snapshot) {
                                if (snapshot.hasData) {
                                  _scrollController = new ScrollController();
                                  return createListView(snapshot.data, context);
                                } else {
                                  return CircularProgressIndicator();
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: 50.0,
                child: LanGuideButton(
                  text: "Submit Answers",
                  onPressed: () => submitPressed(
                    context,
                    Routes.readingResults,
                    {
                      "score": points,
                      "difficulty": difficulty,
                      "maxScore": maxPoints,
                    },
                  ),
                  enabled: anyAnswerSelected,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _editString(String text) {
    String newText;
    newText = text.replaceFirst(RegExp(r'\.'), '');
    newText = newText.replaceFirst(RegExp(r'\,'), '');
    newText = newText.replaceAll(RegExp(r'<br><br>'), '');

    return newText;
  }

  Widget createListView(data, BuildContext context) {
    maxPoints = data.items.length;
    return ListView.builder(
      controller: _scrollController,
      itemCount: data.items == null ? 0 : data.items.length,
      itemBuilder: (context, int index) {
        return Wrap(
          children: [
            ExpansionTile(
              title:
                RichText(
                text: TextSpan(
                  style: TextStyle(
                    color: Colors.black,
                  ),
                  children: [
                    TextSpan(
                      text: "\nQuestion ${index + 1}: ",
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    TextSpan(
                      text: "${_editString(data.items[index].text)} ",
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  ],
                ),
              ),
              children: answersRadioButtons(index, data.items[index].answers, context),
            ),
          ],
        );
      },
    );
  }

  List<Widget> answersRadioButtons(int index, List<Choice> choices, BuildContext context){
    List<Widget> radioButtons = [];
    for (int i = 0; i < choices.length; i++){
      var choice = choices[i];
      radioButtons.add(
        ListTile(
          title: Text(choice.text, style: Theme.of(context).textTheme.bodyText2),
          leading: Radio(
            value: i,
            groupValue: answers[index],
            onChanged: (value) {
              setState(() {
                answers[index] = value;
                anyAnswerSelected = true;
                if(choices[i].correct == true){
                  points++;
                }
              });
            },
          )
        )
      );
    }
    return radioButtons;
  }
}
