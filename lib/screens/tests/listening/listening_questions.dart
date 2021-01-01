import 'package:audioplayers/audioplayers.dart';
import 'package:dva232_project/theme.dart';
import 'package:dva232_project/widgets/bordered_container.dart';
import 'package:dva232_project/widgets/circular_button.dart';
import 'package:dva232_project/widgets/languide_button.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import 'question_data.dart';
import 'package:dva232_project/widgets/languide_navbar.dart';
import 'package:dva232_project/widgets/languide_textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../routes.dart';
import '../shared.dart';

class ListeningTestQuestions extends StatefulWidget {
  final String difficulty;

  ListeningTestQuestions(this.difficulty);

  @override
  _ListeningTestQuestionsState createState() =>
      _ListeningTestQuestionsState(difficulty);
}

class _ListeningTestQuestionsState extends State<ListeningTestQuestions> {


  bool isPlaying = false;
  final String difficulty;
  List<String> wordsToCheck = ["______"];
  List<String> filledWords, correctedWordsList = [""];
  List<String> rightAnswers = [""];
  String currentEdit = "";
  int currentWordIndex = -1;
  bool anythingChanged = false;
  String questionText;
  int score = 0;

  Icon _playIcon = Icon(Icons.play_arrow, size: 70.0, color: Colors.white);
  QuestionData listeningData = QuestionData();
  AudioPlayer player = AudioPlayer();
  Duration duration = new Duration();
  Duration position = new Duration();
  final FocusNode _inputFocusNode = FocusNode();
  TextEditingController _textController = TextEditingController();
  ItemScrollController _scrollController = ItemScrollController();

  _ListeningTestQuestionsState(this.difficulty) {
    filledWords = List.from(wordsToCheck);
  }

  @override
  void initState() {
    super.initState();
    listeningData.showData();
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
            onBackIconPressed: () => onTapBack(context, anythingChanged)),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(
                child: BorderedContainer(
                  child: Column(
                    children: [
                      Expanded(
                        child: Center(
                          child: FutureBuilder(
                            future: listeningData.showData(),
                            builder: (BuildContext context,
                                AsyncSnapshot<dynamic> snapshot) {
                              if (snapshot.hasData) {
                                return createListView(snapshot.data, context);
                              } else {
                                return CircularProgressIndicator();
                              }
                            },
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
              Column(
                children: [
                  InkWell(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0, top:8.0),
                      child: CircularButton(
                        onPressed: () {
                          _getAudio();
                        },
                        color: LanGuideTheme.primaryColor(context),
                        icon: _playIcon,
                        size: 70.0,
                      ),
                    ),
                  ),
                  slider(),
                ],
              ),
              Container(
                height: 50.0,
                child: LanGuideButton(
                  text: "Submit Answers",
                  onPressed: () => submitAnswer(),
                  enabled: anythingChanged,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget slider() {
    return Slider.adaptive(
      value: position.inSeconds.toDouble(),
      max: duration.inSeconds.toDouble(),
      onChanged: (double value) {
        setState(() {
          player.seek(new Duration(seconds: value.toInt()));
        });
      },
    );
  }

  void _getAudio() async {
    if(currentWordIndex == -1) {
      String _url = "https://luan.xyz/files/audio/ambient_c_motion.mp3";
      if (isPlaying == true) {
        var res = await player.pause();
        if (res == 1) {
          setState(() {
            isPlaying = false;
          });
        }
      } else {
        var res = await player.play(_url, isLocal: true);
        if (res == 1) {
          setState(() {
            isPlaying = true;
          });
        }
      }

      player.onDurationChanged.listen((Duration dur) {
        setState(() {
          duration = dur;
        });
      });
      player.onAudioPositionChanged.listen((Duration pos) {
        setState(() {
          position = pos;
        });
      });
      setState(() {
        _changePlayIcon();
      });
    }
    else{

    }
  }

  onTapBack(var context, bool anythingChanged) {
    if (isPlaying == true) {
      _getAudio();
    }
    return backIconPressed(context, anythingChanged);
  }

  submitAnswer() {
    if (isPlaying == true) {
      _getAudio();
    }
    return submitPressed(
      context,
      Routes.listeningResults,
      {
        "rightAnswers": rightAnswers,
        "correctedWordsList": correctedWordsList,
        "score": score,
        "difficulty": difficulty,
      },
    );
  }
  _changePlayIcon() {
    if (isPlaying == true && currentWordIndex == -1)
      _playIcon = Icon(Icons.pause, size: 70.0, color: Colors.white);
    else if(!isPlaying)
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

  TextSpan _changedWord(int index, var correctAnswer) {
    if (rightAnswers[0] == "") {
      rightAnswers[0] = correctAnswer.toString();
    }
    if (index > 0) {
      if (wordsToCheck.length <= index) {
        wordsToCheck.add("______");
      }
      if (filledWords.length <= index) {
        filledWords.add(wordsToCheck[index]);
        correctedWordsList.add("");
        rightAnswers.add(correctAnswer.toString());
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

  TextSpan _editedTextField(int index, var correctAnswer) {
    if (filledWords[index] == correctAnswer.toString() &&
        correctedWordsList[index] != filledWords[index]) {
      correctedWordsList[index] = filledWords[index];
      score++;
    }else if(filledWords[index]!=correctAnswer.toString()){
      correctedWordsList[index] = filledWords[index];
    }
    return TextSpan(
      text: filledWords[index],
      style: LanGuideTheme.writingTestOption(context),
    );
  }

  Future adjustScrollPosition(int index) async {
    await _scrollController.scrollTo(
        index: 0, duration: Duration(milliseconds: 200));
    await _scrollController.scrollTo(
        index: index, duration: Duration(seconds: 1));
  }

  Widget createListView(data, BuildContext context) {
    return ScrollablePositionedList.builder(
      itemCount: data.items == null ? 0 : data.items.length,
      itemScrollController: _scrollController,
      itemBuilder: (context, int index) {
        return Wrap(
          children: [
            GestureDetector(
              onTap: () => setState(() {
                if(isPlaying==true) {
                  _getAudio();
                }
                currentWordIndex = index;
                currentEdit = filledWords[index];
                Future.delayed(Duration(milliseconds: 500)).whenComplete(() =>
                    _scrollController.scrollTo(
                        index: index, duration: Duration(milliseconds: 1000)));
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
                    _changedWord(index, data.items[index].gap),
                    _editedTextField(index, data.items[index].gap),
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
