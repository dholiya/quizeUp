class model_todayquize {
  List<String> answers;
  int correctIndex;
  String question;

  model_todayquize({this.answers, this.correctIndex, this.question});

  model_todayquize.fromJson(Map<String, dynamic> json) {
    answers = json['answers'].cast<String>();
    correctIndex = json['correctIndex'];
    question = json['question'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['answers'] = this.answers;
    data['correctIndex'] = this.correctIndex;
    data['question'] = this.question;
    return data;
  }
}