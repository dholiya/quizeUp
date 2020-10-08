import 'package:quizup/Util/util.dart';

class homeModel {
  String id;
  String lastQuizScore;
  String total;

  homeModel({this.id, this.lastQuizScore, this.total});

  homeModel.fromJson(Map<String, dynamic> parsedJSON)
      : lastQuizScore = parsedJSON[UtilData.lastQuizScore],
        total = parsedJSON[UtilData.total];
}
