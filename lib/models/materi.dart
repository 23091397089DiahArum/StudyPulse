class Materi {
  String text;
  bool isChecked;

  Materi({required this.text, this.isChecked = false});

  factory Materi.fromJson(Map<String, dynamic> json) => Materi(
    text: json['text'],
    isChecked: json['isChecked'],
  );

  Map<String, dynamic> toJson() => {
    'text': text,
    'isChecked': isChecked,
  };
}