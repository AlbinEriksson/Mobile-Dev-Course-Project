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