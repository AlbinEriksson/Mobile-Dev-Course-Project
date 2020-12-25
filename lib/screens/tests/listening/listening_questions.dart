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
  Future getPosition()async{
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

    return Scaffold(
      appBar: LanGuideNavBar(
          onBackIconPressed: () => backIconPressed(context, true)),
      body: Container(
        alignment: Alignment.topCenter,
        child: ListView(
          scrollDirection: Axis.vertical,
          padding: EdgeInsets.only(
              right: MediaQuery.of(context).size.width * 0.05,
              left: MediaQuery.of(context).size.width * 0.05),
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.53,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.purple.shade400, width: 3.0),
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: Scrollbar(
                      isAlwaysShown: _scrollController != null,
                      controller: _scrollController,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
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
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 8.0, right: 8.0, bottom: 10.0),
                    child: Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.83,
                          height: 60,
                          child: LanGuideTextField(
                            hintText: "Tap a question to fill the missing word",
                            onChanged: (value) => currentEdit = value,
                            onEditingComplete: _onEditComplete,
                            focusNode: _inputFocusNode,
                            controller: _textController,
                            enabled: currentWordIndex != -1,
                            enableSuggestions: false,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0, top: 8.0),
              child: Column(
                children: [
                  Text("Play Sound",
                      style: TextStyle(
                        fontSize: 32.0,
                        fontWeight: FontWeight.bold,
                      )),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: RawMaterialButton(
                onPressed: () {
                  _playSound();
                },
                elevation: 5.0,
                fillColor: Colors.purple,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _playIcon,
                  ],
                ),
                shape: CircleBorder(),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text("${_reformat(_position)} / ${_reformat(_duration)}",
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    )),
              ),
            ),
            Container(
              height: 50.0,
              child: RaisedButton(
                  color: Colors.purple,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  child: Text("Submit Answers",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 21.0,
                      )),
                  onPressed: () => Navigator.pushNamed(
                      context, Routes.listeningResults,
                      arguments: null)),
            ),
          ],
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
      style: TextStyle(
        fontSize: 20.0,
        decoration: TextDecoration.underline,
        fontStyle: FontStyle.italic,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  Widget createListView(data, BuildContext context) {
    return Container(
      child: ListView.builder(
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
                      fontSize: 16.0,
                      color: Colors.black,
                    ),
                    children: [
                      TextSpan(
                        text: "\nQuestion ${index + 1}: ",
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: "${_editString(data.items[index].text)} ",
                        style: TextStyle(
                          fontSize: 19.0,
                          fontWeight: FontWeight.normal,
                        ),
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
      ),
    );
  }
}
