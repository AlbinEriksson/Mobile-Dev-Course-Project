import 'dart:convert';

import 'package:flutter/services.dart';
import 'items.dart';

class QuestionData{
  final String title;
  final String instructions;
  final bool random;
  final bool randomiseChoices;
  final bool showQuestionNumbers;
  final bool sectionsOnSamePage;
  final List<Items> items;

  QuestionData({this.title, this.instructions, this.random, this.randomiseChoices, this.showQuestionNumbers, this.sectionsOnSamePage, this.items});

  factory QuestionData.fromJson(Map<String, dynamic> parsedJson) {
    var list = parsedJson['items'] as List;
    List<Items> itemsList = list.map((i) => Items.fromJson(i)).toList();

    return QuestionData(
      title: parsedJson['title'],
      instructions: parsedJson['instructions'],
      random: parsedJson['random'],
      randomiseChoices: parsedJson['randomiseChoices'],
      showQuestionNumbers: parsedJson['showQuestionNumbers'],
      sectionsOnSamePage: parsedJson['sectionsOnSamePage'],
      items: itemsList,
    );
  }

  Future<int> getListLength() async{
    int listLength=await getLength();
    return listLength;
  }

  Future getLength<int>() async{
    String jsonString = await getJson();
    final jsonResponse = json.decode(jsonString);
    QuestionData question = QuestionData.fromJson(jsonResponse);
    return question.items.length;

  }

  static Future<String> getJson() {
    return rootBundle.loadString('lib/jsonFiles/reading.json');
  }

  static Future<QuestionData> showData() async {
    String jsonString = await getJson();
    final jsonResponse = json.decode(jsonString);
    QuestionData question = QuestionData.fromJson(jsonResponse);

    return question;
  }
}