import 'package:auto_size_text/auto_size_text.dart';
import 'package:dva232_project/routes.dart';
import 'package:dva232_project/screens/tests/shared.dart';
import 'package:dva232_project/widgets/bordered_container.dart';
import 'package:dva232_project/widgets/languide_button.dart';
import 'package:dva232_project/widgets/languide_navbar.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:highlight_text/highlight_text.dart';
//import 'package:avatar_glow/avatar_glow.dart';

class SpeakingTest extends StatefulWidget {
  final String difficulty;

  SpeakingTest(this.difficulty);

  @override
  _SpeakingTestState createState() => _SpeakingTestState(difficulty);
}

class _SpeakingTestState extends State<SpeakingTest> {
  stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = ' ';
  bool finished = false;

  final String difficulty;
  String sentence = "I can walk";

  final Map<String, HighlightedWord> _highlights = {
    'I': HighlightedWord(
        onTap: () => print('I'),
        textStyle: const TextStyle(
          fontSize: 32.0,
          color: Colors.green,
          fontWeight: FontWeight.bold,
        )),
    'can': HighlightedWord(
        onTap: () => print('can'),
        textStyle: const TextStyle(
          fontSize: 32.0,
          color: Colors.green,
          fontWeight: FontWeight.bold,
        )),
    'walk': HighlightedWord(
        onTap: () => print('walk'),
        textStyle: const TextStyle(
          fontSize: 32.0,
          color: Colors.green,
          fontWeight: FontWeight.bold,
        )),
  };

  int _clickCount = 0;
  String _tapToSpeakText = null;

  Icon _mic = Icon(
    Icons.mic_outlined,
    size: 30.0,
  );

  _SpeakingTestState(this.difficulty);

  _affectTheIcon() {
    if (_clickCount == 0) {
      _mic = Icon(
        Icons.mic_outlined,
        size: 30.0,
      );
    } else if (_clickCount == 1) {
      _mic = Icon(
        null,
        size: 30.0,
      );
    }
    if (_clickCount > 1) _clickCount = 0;
  }

  @override
  void initState() {
    _speech = stt.SpeechToText();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_tapToSpeakText == null) {
      _tapToSpeakText = AppLocalizations.of(context).tapToSpeak.toUpperCase();
    }

    return WillPopScope(
      onWillPop: () => backPressed(context, _clickCount > 0),
      child: Scaffold(
        appBar: LanGuideNavBar(
            onBackIconPressed: () => backIconPressed(context, _clickCount > 0)),
        body: Container(
          alignment: Alignment.topCenter,
          child: ListView(
            scrollDirection: Axis.vertical,
            padding: EdgeInsets.all(20.5),
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Text(
                    AppLocalizations.of(context).sayThisSentence,
                    style: Theme.of(context).textTheme.headline4,
                  ),
                ),
              ),
              BorderedContainer(
                child: Center(
                  child: AutoSizeText(
                    '$sentence',
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _clickCount++;
                      _tapToSpeakText = ' ';
                      _affectTheIcon();
                      _listen();
                      if (finished == true) {
                        _clickCount = 0;
                        _affectTheIcon();
                      }
                    });
                  },
                  child: BorderedContainer(
                    child: Center(
                      child: Column(
                        children: [
                          _mic,
                          AutoSizeText(
                            '$_tapToSpeakText',
                            style: Theme.of(context).textTheme.overline,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: LanGuideButton(
                  text: AppLocalizations.of(context).submitAnswers,
                  onPressed: () => _sendDataToResults(context),
                  enabled: _text != ' ',
                ),
              ),
              SingleChildScrollView(
                reverse: true,
                child: Column(
                  children: [
                    Text(
                      'Result: ',
                      style: Theme.of(context).textTheme.overline,
                    ),
                    getHighlight(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getHighlight() {
    if (_text == null) {
      return Text("processing..");
    }
    return TextHighlight(
      text: _text,
      words: _highlights,
      textStyle: const TextStyle(
        fontSize: 32.0,
        color: Colors.black,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('OnStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) => setState(() {
            _text = val.recognizedWords;
          }),
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
      finished = true;
    }
  }

  void _sendDataToResults(BuildContext context) {
    submitPressed(context, Routes.speakingResults, {
      "score": 1,
      "difficulty": difficulty,
    });
  }
}
