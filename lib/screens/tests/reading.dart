import 'package:dva232_project/routes.dart';
import 'package:dva232_project/screens/tests/shared.dart';
import 'package:dva232_project/widgets/back_icon_button.dart';
import 'package:dva232_project/widgets/back_nav_button.dart';
import 'package:dva232_project/widgets/nav_button.dart';
import 'package:flutter/material.dart';
import 'package:dva232_project/widgets/languide_navbar.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'shared.dart';
import 'package:dva232_project/screens/results/reading.dart';


class ReadingTest extends StatefulWidget{
  @override
  _ReadingTestState createState() {
    return _ReadingTestState();
  }
}

class _ReadingTestState extends State<ReadingTest> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => backPressed(context, false),
      child: Scaffold(
        appBar: LanGuideNavBar(
          onBackIconPressed: () => backIconPressed(context, true),
        ),
        body: Container(
          alignment: Alignment.topCenter,
          child: ListView(
            scrollDirection: Axis.vertical,
            padding: EdgeInsets.all(20.0),
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
                child: Center( child: AutoSizeText(
                  'Your a good person',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),

                )),
              ),
              Text("What is the grammatical error?", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
              RaisedButton(
                onPressed: () {},
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
                child: const Text("Your should be you're"),
              ),
              RaisedButton(
                onPressed: () {},
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
                child: const Text("A should be an."),
              ),
              RaisedButton(
                onPressed: () {},
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
                child: const Text("Person should be people."),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MaterialButton(
                    onPressed: () {},
                    minWidth: 160,
                    color: Colors.purple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: const Text(
                        "Previous question.",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 17.0,
                        ),
                    ),
                  ),
                  MaterialButton(
                    onPressed: () {},
                    minWidth: 160,
                    color: Colors.purple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: const Text(
                        "Next question",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 17.0,
                        ),
                    ),
                  ),
                ],
              ),
              MaterialButton(
                  onPressed: () {
                    _sendDataToResults(context);
                  },
                  minWidth: 160,
                  color: Colors.purple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: const Text(
                      "Submit answers",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 17.0,
                      )
                  ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  void _sendDataToResults(BuildContext context){
    int scoreToSend = 60;
    Navigator.pushNamed(context, Routes.readingResults, arguments: {"score": scoreToSend});
  }
}
