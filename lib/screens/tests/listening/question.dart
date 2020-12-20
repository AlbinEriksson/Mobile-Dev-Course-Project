class Question {
  final String title;
  final String instructions;
  final String audio;
  final List<Items> items;

  Question({this.title, this.instructions, this.audio, this.items});

  factory Question.fromJson(Map<String, dynamic> parsedJson) {
    var list = parsedJson['items'] as List;
    List<Items> itemsList = list.map((i) => Items.fromJson(i)).toList();

    return Question(
      title: parsedJson['title'],
      instructions: parsedJson['instructions'],
      audio: parsedJson['audio'],
      items: itemsList,
    );
  }
}

class Items {
  final String text;
  final String gap;

  Items({this.text, this.gap});

  factory Items.fromJson(Map<String, dynamic> json) {
    return Items(
      text: json['text'],
      gap: json['gap'],
    );
  }
}
