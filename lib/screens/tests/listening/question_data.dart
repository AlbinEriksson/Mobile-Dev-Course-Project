import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'items.dart';

class QuestionData {


  final String title;
  final String instructions;
  final String audio;
  final List<Items> items;

  QuestionData({this.title, this.instructions, this.audio, this.items});

  factory QuestionData.fromJson(Map<String, dynamic> parsedJson) {
    var list = parsedJson['items'] as List;
    List<Items> itemsList = list.map((i) => Items.fromJson(i)).toList();

    return QuestionData(
      title: parsedJson['title'],
      instructions: parsedJson['instructions'],
      audio: parsedJson['audio'],
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
    return rootBundle.loadString('lib/jsonFiles/listening.json');
  }

  Future showData() async {
    String jsonString = await getJson();
    final jsonResponse = json.decode(jsonString);
    QuestionData question = QuestionData.fromJson(jsonResponse);

    return question;
  }

}

class Network {
  final String url; //final here means we have to invoke a constructor
  //anytime we instantiate our Network we need to pass a URL
  Network(this.url);

  Future<QuestionData> loadPosts() async {
    final Response response = await get(Uri.encodeFull(url));

    if (response.statusCode == 200) {
      //OK

      //return jsonDecode(response.body); // gets json object.. but we want a object including a list of items
      //So now we want to return what is expected from this method: a QuestionData object
      return QuestionData.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to get posts");
    }
  }
}


