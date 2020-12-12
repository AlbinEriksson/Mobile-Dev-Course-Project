import 'package:auto_size_text/auto_size_text.dart';
import 'package:dva232_project/screens/tests/listening/question.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ListeningTestQuestions extends StatefulWidget {
  @override
  _ListeningTestQuestionsState createState() => _ListeningTestQuestionsState();
}

class _ListeningTestQuestionsState extends State<ListeningTestQuestions> {


  List questionBank = [
    Question.name(
        "The 'talented tenth' was a label given to those African Americans who had good social positions and were", true),
    Question.name("The supreme law of the land is the Constitution", true),
    Question.name(
        "The two rights in the Declaration of Independence are:"
            " \n Life "
            " \n Pursuit of hapiness",
        true),
    Question.name("The (U.S.) Constitution has 26 Amendments", false),
    Question.name("Freedom of religion means:\nYou can practice any religion, "
        "or not practice a religtion.",
        true),
    Question.name("Journalist is one branch or part of the government.", false),
    Question.name("The Congress does not make federal laws.", false),
    Question.name("There are 100 U.S. Senators", true),
    Question.name("We elect a U.S. Senator for 4 years", false),
    Question.name("We elect a U.S. Representatice for 2 years", true),
    Question.name("A U.S. Senator represents all people of the United States", false),
    Question.name("We vote for president in January", false),
    Question.name("Who vetoes bills is the President", true),
    Question.name("The Constitution was written in 1787", true),
    Question.name('George Bush is the \ " Father of Our Country"\.', false)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AutoSizeText(
          'Cambridge English: CAE Listening2',
          style: TextStyle(fontSize: 20),
          maxLines: 1,
        ),
      ),
    );
  }
}
