import 'package:flutter/material.dart';
import 'dart:developer';

class UserStateModel extends ChangeNotifier {
// properties
  Map<String, List<String>> ageRangeGroup = {
    "men": <String>[],
    "women": <String>[]
  };

  Map<String, dynamic> currentQuestionData = {
    "gender": "men",
    "question": "",
    "ageRange": [20, 100],
    "options": []
  };

  List<Map<String, dynamic>> options = [];
  Map<String, dynamic> optionTextValue = {};

// methods
  void updateQuestionData(List<String> ageRangeList, genderType) {
    // ageRange = [...ageRangeList];
    ageRangeGroup[genderType] = [...ageRangeList];
    print('ageRangeGroup, $ageRangeGroup');
    notifyListeners();
  }

  void onQuestionTitle(title) {
    currentQuestionData["question"] = title;
    notifyListeners();
  }

  void updateAgeRange(value, index) {
    currentQuestionData["ageRange"][index] = value;
    notifyListeners();
  }

  void onGenderSelect(value) {
    currentQuestionData["gender"] = value;
    print('currentQuestionData, $currentQuestionData');
    notifyListeners();
  }

  void deleteOption(deleteIndex) {
    options.removeAt(deleteIndex);
    notifyListeners();
  }

  void createOption(optionText, optionRisk) {
    options.add({"TEXT": optionText, "VALUE": optionRisk});
    currentQuestionData["options"] = [...options];
    notifyListeners();
  }

  void resetQuestionData() {
    currentQuestionData = {
      "gender": "men",
      "question": "",
      "ageRange": [20, 100],
      "options": []
    };
    notifyListeners();
  }
}
