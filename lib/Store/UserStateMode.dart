import 'package:flutter/material.dart';

class UserStateModel extends ChangeNotifier {
  List<Map<dynamic, dynamic>> questions = [];
  int totalRiskValue = 0;

  Map selectedOptionData = {};

  ///update questions data from stream
  void updateQuestionData(List<Map<dynamic, dynamic>> questions) {
    print('questions: $questions');
    this.questions = [...questions];
    notifyListeners();
  }

  void updateTotalRiskValue(value) {
    this.totalRiskValue = value;
    notifyListeners();
  }

  void updateSelectedOptionData(value) {
    this.selectedOptionData = value;
    notifyListeners();
  }
}
