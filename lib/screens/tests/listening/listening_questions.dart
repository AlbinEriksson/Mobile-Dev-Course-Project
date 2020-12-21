import 'package:audioplayers/audioplayers.dart';
import 'package:dva232_project/screens/tests/listening/question.dart';
import 'package:dva232_project/widgets/languide_navbar.dart';
import 'package:dva232_project/widgets/languide_textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../routes.dart';
import '../shared.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'dart:io';
import 'package:path_provider/path_provider.dart';


class ListeningTestQuestions extends StatefulWidget {
  @override
  _ListeningTestQuestionsState createState() => _ListeningTestQuestionsState();
}

class _ListeningTestQuestionsState extends State<ListeningTestQuestions> {


  List<String> wordsToCheck = [
    "______",
    "______",
    "______",
    "______",
    "______",
    "______",
    "______"
  ];

  int _click=0;
  List<String> filledWords;
  String currentEdit = "";
  int currentWordIndex = -1;
  bool anythingChanged = false;
  String questionText;
  String mp3Uri='';

  Icon _sound=Icon(Icons.play_arrow, size: 70.0, color:Colors.white);


  AudioPlayer player = AudioPlayer();
  final FocusNode _inputFocusNode = FocusNode();
  TextEditingController _textController = TextEditingController();
  ScrollController _scrollController = null;

  _ListeningTestQuestionsState() {
    filledWords = List.from(wordsToCheck);
  }

  Future<String> getJson() {
    return rootBundle.loadString('lib/jsonFiles/listening.json');
  }

  Future _showData() async {
    String jsonString = await getJson();
    final jsonResponse = json.decode(jsonString);
    Question question = new Question.fromJson(jsonResponse);

    return question;
  }

  void _loadSound() async{
    final ByteData data = await rootBundle.load('assets/sneeze.mp3');
    Directory tempDir =await getTemporaryDirectory();
    File tempFile=File('${tempDir.path}/sneeze.mp3}');
    await tempFile.writeAsBytes(data.buffer.asUint8List(), flush:true);
    mp3Uri=tempFile.uri.toString();
  }

  _playSound() {

    if(_click==0) {
      player.play(mp3Uri);
      _click++;
    }else{
      player.stop();
      _click=0;
    }

  }

  @override
  void initState() {
    super.initState();
    _showData();
    _loadSound();
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
                      isAlwaysShown: _scrollController!=null,
                      controller: _scrollController,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: FutureBuilder(
                            future: _showData(),
                            builder: (BuildContext context,
                                AsyncSnapshot<dynamic> snapshot) {
                              if (snapshot.hasData) {
                                _scrollController=new ScrollController();
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
                onPressed: ()=>_playSound(),
                elevation: 5.0,
                fillColor: Colors.purple,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  _sound,
                  ],
                ),
                shape: CircleBorder(),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text("00:00 / 00:32",
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    )),
              ),
            ),
            Container(
              height: 50.0,
              child:                RaisedButton(
                  color: Colors.purple,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  child: Text("Submit Answers", style: TextStyle(
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

  String _editString(String text){
    String newText;
    newText=text.replaceAll(new RegExp(r'<br><br>'), '');
    newText=newText.replaceFirst(new RegExp(r'\.'), '');
    newText=newText.replaceFirst(new RegExp(r','), '');

    return newText;
  }

}
