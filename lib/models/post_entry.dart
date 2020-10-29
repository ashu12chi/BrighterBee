class PostEntry {
  int time;
  String text;

  PostEntry({this.time, this.text});

  Map<String, dynamic> toMap() {
    return {'time': time, 'text': text};
  }
}
