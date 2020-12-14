import 'package:auto_size_text/auto_size_text.dart';
import 'package:dva232_project/routes.dart';
import 'package:dva232_project/screens/tests/shared.dart';
import 'package:dva232_project/widgets/languide_navbar.dart';
import 'package:dva232_project/widgets/nav_button.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

//NavButton("Submit answers", Routes.speakingResults),

class SpeakingTest extends StatefulWidget {
  @override
  _SpeakingTestState createState() => _SpeakingTestState();
}

class _SpeakingTestState extends State<SpeakingTest> {
  int _clickCount=0;
  String _tapToSpeakText = "TAP TO SPEAK";

  Icon _mic=Icon(Icons.mic_outlined, size: 30.0,);

  _affectTheIcon() {
    if (_clickCount == 0) {
        _mic = Icon(
        Icons.mic_outlined,
        size: 30.0,
      );
    }
    else if(_clickCount==1){
        _mic = Icon(
        null,
        size: 30.0,
      );
    }
    if(_clickCount>1)
      _clickCount=0;
  }

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
                "Speak this sentence",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30.0,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.purple.shade400, width: 3.0),
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: AutoSizeText(
                'How much wood would a woodchuck chuck if a woodchuck could chuck wood?',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  _clickCount++;
                  _tapToSpeakText = '';
                  _affectTheIcon();
                });
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Container(
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    border:
                        Border.all(color: Colors.purple.shade400, width: 3.0),
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          _mic,
                          AutoSizeText(
                            '$_tapToSpeakText',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SpeechScreen extends StatefulWidget {
  @override
  _SpeechScreenState createState() => _SpeechScreenState();
}

class _SpeechScreenState extends State<SpeechScreen> {
  stt.SpeechToText _speech;
  bool _isListening=false;
  String _text='press the button and start speaking';
  double confidence=1.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _speech=stt.SpeechToText();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

