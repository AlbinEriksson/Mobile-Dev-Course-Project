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
    Question.name(".<br><br>She left school and began her singing career at the well-known", true),
    Question.name(
        ".<br><br>Her mother was keen that Lena's singing career would bring about the collapse of",
        true),
    Question.name(".<br><br>Lena refused to sing for audiences of service men and prisoners which were", false),
    Question.name(".<br><br>When Lena entered Hollywood, black actors were generally only hired to act in the roles of",
        true),
    Question.name(".<br><br>While she was working for Hollywood,Lena found that, during the", false),
    Question.name(",much of her spoken work was removed from the film.<br><br>Lena spent a lot of the 1950s working in", false),
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
