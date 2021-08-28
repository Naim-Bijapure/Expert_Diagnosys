import 'package:expert_diagnosis/services/DbService.dart';
import 'package:flutter/material.dart';
import 'dart:developer';

class AdminStateModel extends ChangeNotifier {
// PROPERTIES

  // CREATE QUESTION STATES
  Map<String, List<String>> ageRangeGroup = {
    "men": <String>[],
    "women": <String>[]
  };

  Map<String, dynamic> currentQuestionData = {
    "gender": "",
    "question": "",
    "ageRange": [20, 100],
    "options": [],
    "toAllAgeGroup": false
  };
  List<Map<String, dynamic>> options = [];
  Map<String, dynamic> optionTextValue = {};

  //LIST QUESTION STATES
  List<Map<String, dynamic>> questionsData = [];
  bool isQuestionsEmpty = false;
  String currentSelectedAgeGroup = "";
  String currentSelectedGender = "";

// methods

  // CREATE QUESTIONS METHODS
  void updateAgeRangeList(List<String> ageRangeList, genderType) {
    // ageRange = [...ageRangeList];
    ageRangeGroup[genderType] = [...ageRangeList];
    print('ADMINSTATE => AGERANGEGROUP, $ageRangeGroup');
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
    notifyListeners();
  }

  void onAllAgeGroup(bool value) {
    print('value, $value');
    currentQuestionData["toAllAgeGroup"] = value;
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
    options = [];
    notifyListeners();
  }

  //  LIST QUESTION MEHTODS
  // update quesiton list from db
  void updateQuestionsList(List data) {
    questionsData = [...data];

    if (data.length == 0) {
      isQuestionsEmpty = true;
    }
    notifyListeners();
  }

  // delete a question
  Future deleteQuesiton(Map questionData, gender) async {
    print('DELETE QUESTION DATA, $questionData');
    questionsData.remove(questionData);

    if (questionsData.length == 0) {
      isQuestionsEmpty = true;
    }

    await dbService.deleteQuestion(questionData["id"], gender);
    await this.selectQuestionByAge(this.currentSelectedAgeGroup, gender);
    notifyListeners();
  }

  // select  a question age wise
  Future selectQuestionByAge(String ageGroup, gender) async {
    currentSelectedAgeGroup = ageGroup;
    currentSelectedGender = gender;

    List<Map> questionData = await dbService.getQuestions(gender);

    List filterdQuestionData = questionData.where((dynamic element) {
      return (element["ageRange"] as List).join("-") == ageGroup ||
          element["toAllAgeGroup"] == true;
    }).toList();
    print('filterdQuestionData: $filterdQuestionData');

    questionsData = [...filterdQuestionData];

    if (questionsData.length != 0) {
      isQuestionsEmpty = false;
    }

    if (questionsData.length == 0) {
      isQuestionsEmpty = true;
    }
    // questionsData.where((element) => false)
    notifyListeners();
  }

  void resetSelectedData() {
    this.currentSelectedAgeGroup = "";
    this.currentSelectedGender = "";
    this.questionsData = [];
  }

  // select  a question by id
  // Future deleteQuestion(String id) async {
  //   dbService.deleteQuestion(id);

  //   // questionsData.where((element) => false)
  //   notifyListeners();
  // }
}
