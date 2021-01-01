class Items {
  final String text;
  //final List<Map<String, dynamic>> answers;
  final List<Choice> answers;

  Items({this.text, this.answers});

  factory Items.fromJson(Map<String, dynamic> json) {
    //var choices = json['choices'];
    //List<Map<String, dynamic>> choicesList = new List<Map<String, dynamic>>.from(choices);
    var list = json['choices'] as List;
    print(list.runtimeType); //returns List<dynamic>
    List<Choice> choiceList = list.map((i) => Choice.fromJson(i)).toList();
    return Items(
      text: json['text'],
      answers: choiceList,
    );
  }

}

class Choice{
  final String text;
  final bool correct;
  final String feedback;

  Choice({this.text, this.correct, this.feedback});

  factory Choice.fromJson(Map<String, dynamic> json){

    return Choice(
      text: json['text'],
      correct: json['correct'],
      feedback: json['feedback']
    );
  }
}