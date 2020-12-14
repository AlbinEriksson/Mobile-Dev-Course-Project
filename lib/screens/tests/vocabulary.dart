import 'package:dva232_project/routes.dart';
import 'package:dva232_project/screens/tests/shared.dart';
import 'package:dva232_project/widgets/languide_button.dart';
import 'package:dva232_project/widgets/languide_navbar.dart';
import 'package:dva232_project/widgets/languide_textfield.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class VocabularyTest extends StatefulWidget {
  @override
  _VocabularyTestState createState() => _VocabularyTestState();
}

class _VocabularyTestState extends State<VocabularyTest> {
  final List<String> wordsToCheck = [
    "budget",
    "redduction",
    "economic",
    "alocated",
    "reccurent",
    "resorses",
    "avarded",
    "transperrency",
    "Agrement",
    "maintained",
    "foresen"
  ];

  List<String> editedWords;
  String currentEdit = "";

  int currentWordIndex = -1;

  final FocusNode _inputFocusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  TextEditingController _textController = TextEditingController();

  _VocabularyTestState() {
    editedWords = List.from(wordsToCheck);
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

    _textController.text = currentEdit;

    return WillPopScope(
      onWillPop: () => backPressed(context, true),
      child: Scaffold(
        appBar: LanGuideNavBar(
            onBackIconPressed: () => backIconPressed(context, true)),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 1,
              child: Padding(
                padding: EdgeInsets.all(4.0),
                child: Scrollbar(
                  isAlwaysShown: true,
                  controller: _scrollController,
                  child: ListView(
                    controller: _scrollController,
                    padding: EdgeInsets.all(16.0),
                    children: [
                      RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.black,
                          ),
                          children: [
                            TextSpan(
                                text:
                                    "The European Union (EU) has been providing "),
                            _changedWord(0),
                            _spellCheckField(0),
                            TextSpan(
                                text:
                                    " support to Cambodia in the education sector since 2003 on the basis of sound and comprehensive plans to improve performance in the sector and to gradually implement public finance management (PFM) reforms, as well as continued improvements in both areas. Over the same period Cambodia has made steady progress in poverty "),
                            _changedWord(1),
                            _spellCheckField(1),
                            TextSpan(
                                text:
                                    " in the last decade underpinned by high "),
                            _changedWord(2),
                            _spellCheckField(2),
                            TextSpan(
                                text:
                                    " growth. However important challenges remain in the education sector, such as the need to increase enrolment and retention at secondary level, to improve quality at all levels and to reduce regional and social disparities. Addressing these requires Government to increase its resources "),
                            _changedWord(3),
                            _spellCheckField(3),
                            TextSpan(
                                text:
                                    " to the sector. The further scaling up of budget support provided by the EU to the sector, as proposed, building on a recently agreed programme, will enhance the support to Government's efforts to reverse the fall in the share of Government "),
                            _changedWord(4),
                            _spellCheckField(4),
                            TextSpan(
                                text:
                                    " funds provided to the Ministry of Education, Youth and Sports (MoEYS) by supporting an increase of Government "),
                            _changedWord(5),
                            _spellCheckField(5),
                            TextSpan(text: " "),
                            _changedWord(6),
                            _spellCheckField(6),
                            TextSpan(
                                text:
                                    " to specific interventions aimed at improving key service delivery indicators related to access, equity and quality in the sector. It will also encourage Government to continue strengthening its PFM systems and increase budget "),
                            _changedWord(7),
                            _spellCheckField(7),
                            TextSpan(
                                text:
                                    ". The proposed amount is a top up to a recently signed programme covering the period 2014-2016. An Addendum to the ongoing Financing "),
                            _changedWord(8),
                            _spellCheckField(8),
                            TextSpan(
                                text:
                                    " will be signed. This additional amount should cover one additional year and in effect lead to more than a doubling of the yearly amount for the period 2014-2016. This increased level will be possibly "),
                            _changedWord(9),
                            _spellCheckField(9),
                            TextSpan(
                                text:
                                    " in 2017 with the additional financing "),
                            _changedWord(10),
                            _spellCheckField(10),
                            TextSpan(text: " under the MIP 2014-2020. "),
                            TextSpan(text: " (European Comission, 2014)"),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(currentWord.isNotEmpty ? "Is '$currentWord' wrong? You can change it below:" : ""),
                  LanGuideTextField(
                    hintText: "Tap a highlighted word to change it!",
                    onChanged: (value) => currentEdit = value,
                    onEditingComplete: _onEditComplete,
                    focusNode: _inputFocusNode,
                    controller: _textController,
                    enabled: currentWordIndex != -1,
                  ),
                  LanGuideButton(
                    text: "Submit answers",
                    onPressed: () => submitPressed(context, Routes.vocabularyResults, {
                      "checkedWords": editedWords
                    }),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onEditComplete() {
    setState(() {
      editedWords[currentWordIndex] = currentEdit;
      currentWordIndex = -1;
      currentEdit = "";
    });
  }

  TextSpan _changedWord(int index) {
    String editedWord = editedWords[index];
    String original = wordsToCheck[index];

    if(original != editedWord) {
      return TextSpan(
        children: [
          TextSpan(
            text: original,
            style: TextStyle(
              color: Colors.red,
              decoration: TextDecoration.lineThrough,
            ),
          ),
          TextSpan(text: " "),
        ],
      );
    }

    return TextSpan();
  }

  TextSpan _spellCheckField(int index) {
    Color backgroundColor = Colors.green[200];
    if (index == currentWordIndex) {
      backgroundColor = Colors.blue[200];
    }

    return TextSpan(
      text: editedWords[index],
      style: TextStyle(backgroundColor: backgroundColor, fontSize: 20.0),
      recognizer: TapGestureRecognizer()
        ..onTap = () => setState(() {
              currentWordIndex = index;
              currentEdit = editedWords[index];
            }),
    );
  }
}
