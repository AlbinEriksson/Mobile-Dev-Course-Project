import 'package:auto_size_text/auto_size_text.dart';
import 'package:dva232_project/routes.dart';
import 'package:flutter/material.dart';

class ListeningTestIntro extends StatefulWidget {
  @override
  _ListeningTestIntroState createState() => _ListeningTestIntroState();
}

class _ListeningTestIntroState extends State<ListeningTestIntro> {
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
      body: Container(
        alignment: Alignment.topCenter,
        margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.05),
        child: ListView(
          scrollDirection: Axis.vertical,
          padding: EdgeInsets.all(20.5),
          children: [
            Container(
              padding: EdgeInsets.all(10.0),
              width: MediaQuery.of(context).size.width * 0.5,
              height: MediaQuery.of(context).size.height * 0.3,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.purple.shade400, width: 3.0),
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: AutoSizeText(
                'You will hear a radio programme about the life of the singer, Lena Horne.'
                ' For questions 1-8, complete the sentences.',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RaisedButton(
                      color: Colors.purple,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      child: Text("Back home",style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 21.0,
                      )),
                      onPressed: () => Navigator.popUntil(
                          context, ModalRoute.withName(Routes.home)),
                    ),
                    RaisedButton(
                        color: Colors.purple,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        child: Text("Questions", style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 21.0,
                        )),
                        onPressed: () => Navigator.pushNamed(
                            context, Routes.listeningTestQuestions,
                            arguments: null)),
                  ]),
            ),
            Container(
              child:Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RaisedButton(
                      color: Colors.purple,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      child: Text("Back home",style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 21.0,
                      )),
                      onPressed: () => Navigator.popUntil(
                          context, ModalRoute.withName(Routes.home)),
                    ),
                    RaisedButton(
                        color: Colors.purple,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        child: Text("Submit Answers", style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 21.0,
                        )),
                        onPressed: () => Navigator.pushNamed(
                            context, Routes.listeningResults,
                            arguments: null)),
                  ]

              )
            )
          ],
        ),
      ),
    );
  }
}
