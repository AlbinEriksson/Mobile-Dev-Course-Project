import 'package:dva232_project/theme.dart';
import 'package:dva232_project/widgets/bordered_container.dart';
import 'package:dva232_project/widgets/circular_button.dart';
import 'package:dva232_project/widgets/languide_button.dart';

import 'listening_audio.dart';
import 'question_data.dart';
import 'package:dva232_project/widgets/languide_navbar.dart';
import 'package:dva232_project/widgets/languide_textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../routes.dart';
import '../shared.dart';

class ListeningTestQuestions extends StatefulWidget {
  @override
  _ListeningTestQuestionsState createState() => _ListeningTestQuestionsState();
}

class _ListeningTestQuestionsState extends State<ListeningTestQuestions> {
  List<String> wordsToCheck = ["______"];

  int _click = 0;
  List<String> filledWords;
  String currentEdit = "";
  int currentWordIndex = -1;
  bool anythingChanged = false;
  String questionText;

  Icon _playIcon = Icon(Icons.play_arrow, size: 70.0, color: Colors.white);

  Duration _duration = Duration();
  Duration _position = Duration();
  QuestionData listeningData = QuestionData();
  ListeningAudio player2 = ListeningAudio();
  final FocusNode _inputFocusNode = FocusNode();
  TextEditingController _textController = TextEditingController();
  ScrollController _scrollController = null;

  _ListeningTestQuestionsState() {
    filledWords = List.from(wordsToCheck);
  }

  @override
  void initState() {
    super.initState();
    listeningData.showData();
    player2.initPlayer();
    setState(() {
      getDuration();
      getPosition();
    });

    //initPlayer();
  }

  Future getDuration() async {
    player2.onDurationChanged.listen((Duration dur) async {
      //print('Max duration: $d');
      //setState(() => _duration = d);
      setState(() {
        return _duration = dur;
      });
    });
  }

  Future getPosition() async {
    player2.onAudioPositionChanged.listen((Duration pos) async {
      //print('Current position: $p');
      // setState(() => _position = pos);
      // });
      setState(() {
        return _position = pos;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // This will execute after the "build" method is finished
      _inputFocusNode.requestFocus();
    });

    _textController.text = "";

    return WillPopScope(
      onWillPop: () => backPressed(context, anythingChanged),
      child: Scaffold(
        appBar: LanGuideNavBar(
            onBackIconPressed: () => backIconPressed(context, anythingChanged)),
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
                              future: listeningData.showData(),
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
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            LanGuideTextField(
                              hintText:
                                  "Tap a question to fill the missing word",
                              onChanged: (value) => currentEdit = value,
                              onEditingComplete: _onEditComplete,
                              focusNode: _inputFocusNode,
                              controller: _textController,
                              enabled: currentWordIndex != -1,
                              enableSuggestions: false,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0, top: 8.0),
                child: Column(
                  children: [
                    Text(
                      "Play Sound",
                      style: Theme.of(context).textTheme.headline4,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: CircularButton(
                  onPressed: () {
                    _playSound();
                  },
                  color: Colors.purple,
                  icon: _playIcon,
                  size: 70.0,
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    "${_reformat(_position)} / ${_reformat(_duration)}",
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ),
              ),
              Container(
                height: 50.0,
                child: LanGuideButton(
                  text: "Submit Answers",
                  onPressed: () =>
                      submitPressed(context, Routes.listeningResults, {}),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _playSound() {
    if (_click == 0) {
      player2.play(player2.mp3Uri);
      _click++;
    } else if (_click == 1) {
      player2.pause();
      _click = 0;
    }
    setState(() {
      _changePlayIcon();
    });
  }

  String _reformat(Duration _duration) {
    String twoNum(int n) => n.toString().padLeft(2, "0");
    String twoNumInMinutes = twoNum(_duration.inMinutes.remainder(60));
    String twoNumInSeconds = twoNum(_duration.inSeconds.remainder(60));
    return "$twoNumInMinutes:$twoNumInSeconds";
  }

  _changePlayIcon() {
    if (_click == 1)
      _playIcon = Icon(Icons.pause, size: 70.0, color: Colors.white);
    else
      _playIcon = Icon(Icons.play_arrow, size: 70.0, color: Colors.white);
  }

  String _editString(String text) {
    String newText;
    newText = text.replaceFirst(RegExp(r'\.'), '');
    newText = newText.replaceFirst(RegExp(r'\,'), '');
    newText = newText.replaceAll(RegExp(r'<br><br>'), '');

    return newText;
  }

  void _onEditComplete() {
    setState(() {
      filledWords[currentWordIndex] = currentEdit;
      currentWordIndex = -1;
      currentEdit = "";
      anythingChanged = true;
    });
  }

  TextSpan _changedWord(int index) {
    if (index > 0) {
      wordsToCheck.add("______");
      if (filledWords.length <= index) {
        filledWords.add(wordsToCheck[index]);
      }
    }
    String editedWord = filledWords[index];
    String original = wordsToCheck[index];

    if (original != editedWord) {
      return TextSpan(
        children: [
          TextSpan(text: ""),
        ],
      );
    }

    return TextSpan();
  }

  TextSpan _spellCheckField(int index) {
    return TextSpan(
      text: filledWords[index],
      style: LanGuideTheme.writingTestOption(),
    );
  }

  Widget createListView(data, BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: data.items == null ? 0 : data.items.length,
      itemBuilder: (context, int index) {
        return Wrap(
          children: [
            GestureDetector(
              onTap: () => setState(() {
                currentWordIndex = index;
                currentEdit = filledWords[index];
              }),
              child: RichText(
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
                    _changedWord(index),
                    _spellCheckField(index),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
