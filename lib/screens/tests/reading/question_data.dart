import 'dart:convert';

import 'package:flutter/services.dart';
import 'items.dart';

class QuestionData{
  final String title;
  final String instructions;
  final List<Items> items;

  QuestionData({this.title, this.instructions, this.items});

  factory QuestionData.fromJson(Map<String, dynamic> parsedJson) {
    var list = parsedJson['items'] as List;
    List<Items> itemsList = list.map((i) => Items.fromJson(i)).toList();

    return QuestionData(
      title: parsedJson['title'],
      instructions: parsedJson['instructions'],
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

  Future<String> getJson() {
    return rootBundle.loadString('lib/jsonFiles/reading.json');
  }

  Future showData() async {
    String jsonString = await getJson();
    final jsonResponse = json.decode(jsonString);
    QuestionData question = QuestionData.fromJson(jsonResponse);

    return question;
  }
}