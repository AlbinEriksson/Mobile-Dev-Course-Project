import 'package:dva232_project/widgets/languide_navbar.dart';
import 'package:dva232_project/widgets/languide_textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../shared.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class ListeningTestQuestions extends StatefulWidget {
  @override
  _ListeningTestQuestionsState createState() => _ListeningTestQuestionsState();
}

class _ListeningTestQuestionsState extends State<ListeningTestQuestions> {
  Future<String> getJson() {
    return rootBundle.loadString('lib/jsonFiles/listening.json');
  }

  Future _showData() async {
    my_data = json.decode(await getJson());
    setState(() {
      userData = my_data["items"];

      debugPrint(userData[0]["gap"]);
    });
  }

  final List<String> wordsToCheck = [
    "______",
    "______",
    "______",
    "______",
    "______",
    "______",
    "______"
  ];

  Map my_data;
  List userData;

  List<String> filledWords;
  String currentEdit = "";
  int currentWordIndex = -1;
  bool anythingChanged = false;

  final FocusNode _inputFocusNode = FocusNode();
  TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  _ListeningTestQuestionsState() {
    filledWords = List.from(wordsToCheck);
  }

  @override
  void initState() {
    super.initState();
    _showData();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // This will execute after the "build" method is finished
      _inputFocusNode.requestFocus();
    });

    String currentWord = "";

    if (currentWordIndex >= 0) {
      currentWord = wordsToCheck[currentWordIndex];
    }

    _textController.text = "";

    return Scaffold(
      appBar: LanGuideNavBar(
          onBackIconPressed: () => backIconPressed(context, true)),
      body: Container(
        alignment: Alignment.topCenter,
        child: ListView(
          scrollDirection: Axis.vertical,
          padding: EdgeInsets.only(
              right: MediaQuery
                  .of(context)
                  .size
                  .width * 0.05,
              left: MediaQuery
                  .of(context)
                  .size
                  .width * 0.05),
          children: [
            Container(
              height: MediaQuery
                  .of(context)
                  .size
                  .height * 0.53,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.purple.shade400, width: 3.0),
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: Scrollbar(
                      isAlwaysShown: true,
                      controller: _scrollController,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListView.builder(
                            controller: _scrollController,
                            itemCount: userData == null ? 0 : userData.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Wrap(
                                children: [
                                  GestureDetector(
                                    onTap: () =>
                                        setState(() {
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
                                            text: "\nQuestion ${index + 1} ",
                                            style: TextStyle(
                                              fontSize: 20.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          TextSpan(
                                            text: "${userData[index]["text"]} ",
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
                          width: MediaQuery
                              .of(context)
                              .size
                              .width * 0.83,
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
              padding: const EdgeInsets.only(bottom: 16.0, top: 16.0),
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
              padding: const EdgeInsets.only(bottom: 10.0),
              child: RawMaterialButton(
                onPressed: _playSound(),
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
            Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Text("00:00 / 00:32",
                    style: TextStyle(
                      fontSize: 32.0,
                      fontWeight: FontWeight.bold,
                    )),
              ),
            ),
          ],
        ),
      ),
    );
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
      style: TextStyle(fontSize: 20.0,
          decoration: TextDecoration.underline,
          fontStyle: FontStyle.italic,
          fontWeight: FontWeight.w400,
      ),
    );
  }

  _playSound() {}
}
