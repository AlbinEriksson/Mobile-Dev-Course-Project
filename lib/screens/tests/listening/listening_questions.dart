import 'package:auto_size_text/auto_size_text.dart';
import 'package:dva232_project/screens/tests/listening/question.dart';
import 'package:dva232_project/widgets/languide_navbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../shared.dart';

class ListeningTestQuestions extends StatefulWidget {
  @override
  _ListeningTestQuestionsState createState() => _ListeningTestQuestionsState();
}

class _ListeningTestQuestionsState extends State<ListeningTestQuestions> {
  int _currentQuestionIndex = 0;

  List questionBank = [
    Question.name(
        "The 'talented tenth' was a label given to those African Americans who had good social positions and were",
        true),
    Question.name(
        ".<br><br>She left school and began her singing career at the well-known",
        true),
    Question.name(
        ".<br><br>Her mother was keen that Lena's singing career would bring about the collapse of",
        true),
    Question.name(
        ".<br><br>Lena refused to sing for audiences of service men and prisoners which were",
        false),
    Question.name(
        ".<br><br>When Lena entered Hollywood, black actors were generally only hired to act in the roles of",
        true),
    Question.name(
        ".<br><br>While she was working for Hollywood,Lena found that, during the",
        false),
    Question.name(
        ",much of her spoken work was removed from the film.<br><br>Lena spent a lot of the 1950s working in",
        false),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: LanGuideNavBar(
          onBackIconPressed: () => backIconPressed(context, true)),
      body: Container(
        alignment: Alignment.topCenter,
        child: ListView(
          scrollDirection: Axis.vertical,
          padding: EdgeInsets.all(20.5),
          children: [
            Center(
              child: Text(
                "Question ${_currentQuestionIndex + 1}",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.5,
              height: MediaQuery.of(context).size.height * 0.3,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.purple.shade400, width: 3.0),
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Column(
                children: [
                  Expanded(child:Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: AutoSizeText(
                        "${questionBank[_currentQuestionIndex].questionText} _________",
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Fill in the blank: ",
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          width: 150,
                          height: 40,
                          child: TextFormField(
                            style: TextStyle(fontSize: 20.0),
                            onChanged: (value) {
                              //Do something with the user input.
                            },
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                BorderSide(color: Colors.purple, width: 1.0),
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                BorderSide(color: Colors.purple, width: 3.0),
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RaisedButton(
                  color: Colors.purple,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  child: Text(
                    "Previous",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 21.0,
                    ),
                  ),
                  onPressed: () => _previousQuestion(),
                ),

                //Functionality:
                // Next Question button changes to 'Submit Answer' On the last question from the list
                //Submit Answer question is commented out down below
                RaisedButton(
                  color: Colors.purple,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  child: Text(
                    "Next Question",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 21.0,
                    ),
                  ),
                  onPressed: () => _nextQuestion(),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 32.0),
              child: RawMaterialButton(
                onPressed: _playMusic(),
                elevation: 5.0,
                fillColor: Colors.purple,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.play_arrow,
                      size: 100,
                      color: Colors.white,
                    )
                  ],
                ),
                shape: CircleBorder(),
              ),
            ),
            //Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //  children: [
            //   RaisedButton(
            //      color: Colors.purple,
            //     shape: RoundedRectangleBorder(
            //        borderRadius: BorderRadius.circular(5)),
            //   child: Text("Submit Answers", style: TextStyle(
            //    fontWeight: FontWeight.bold,
            //   color: Colors.white,
            //  fontSize: 21.0,
            //)),
            //onPressed: () => Navigator.pushNamed(
            //   context, Routes.listeningResults,
            //  arguments: null)),
            //]
            //)
          ],
        ),
      ),
    );
  }

  _checkAnswer(bool userChoice, BuildContext context) {}

  _nextQuestion() {
    setState(() {
      _currentQuestionIndex = (_currentQuestionIndex + 1) % questionBank.length;
    });
  }

  _previousQuestion() {
    setState(() {
      _currentQuestionIndex = (_currentQuestionIndex - 1) % questionBank.length;
    });
  }

  _playMusic() {}
}
