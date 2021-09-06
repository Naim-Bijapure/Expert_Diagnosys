import 'package:expert_diagnosis/services/DbService.dart';
import 'package:flutter/material.dart';

class AdminStateModel extends ChangeNotifier {
// PROPERTIES

  // CREATE QUESTION STATES
  Map<String, List<String>> ageRangeGroup = {
    'men': <String>[],
    'women': <String>[]
  };

  Map<String, dynamic> currentQuestionData = {
    'gender': '',
    'question': '',
    'ageRange': [20, 100],
    'options': [],
    'toAllAgeGroup': false
  };
  List<Map<String, dynamic>> options = [];
  Map<String, dynamic> optionTextValue = {};

  //LIST QUESTION STATES
  List<Map<String, dynamic>> questionsData = [];
  bool isQuestionsEmpty = false;
  String currentSelectedAgeGroup = '';
  String currentSelectedGender = '';

// methods

  // CREATE QUESTIONS METHODS
  void updateAgeRangeList(List<String> ageRangeList, genderType) {
    // ageRange = [...ageRangeList];
    ageRangeGroup[genderType] = [...ageRangeList];
    print('ADMINSTATE => AGERANGEGROUP, $ageRangeGroup');
    notifyListeners();
  }

  void onQuestionTitle(title) {
    currentQuestionData['question'] = title;
    notifyListeners();
  }

  void updateAgeRange(value, index) {
    currentQuestionData['ageRange'][index] = value;
    notifyListeners();
  }

  void onGenderSelect(value) {
    currentQuestionData['gender'] = value;
    notifyListeners();
  }

  void onAllAgeGroup(bool value) {
    print('value, $value');
    currentQuestionData['toAllAgeGroup'] = value;
    print('currentQuestionData, $currentQuestionData');
    notifyListeners();
  }

  void deleteOption(deleteIndex) {
    options.removeAt(deleteIndex);
    notifyListeners();
  }

  void createOption(optionText, optionRisk) {
    options.add({'TEXT': optionText, 'VALUE': optionRisk});
    currentQuestionData['options'] = [...options];
    notifyListeners();
  }

  void resetQuestionData() {
    currentQuestionData = {
      'gender': 'men',
      'question': '',
      'ageRange': [20, 100],
      'options': []
    };
    options = [];
    notifyListeners();
  }

  //  LIST QUESTION MEHTODS
  // update quesiton list from db
  void updateQuestionsList(List data) {
    questionsData = [...data];

    if (data.isEmpty) {
      isQuestionsEmpty = true;
    }
    notifyListeners();
  }

  // delete a question
  Future deleteQuesiton(Map questionData, gender) async {
    // print('DELETE QUESTION DATA, $questionData');
    questionsData.remove(questionData);

    if (questionsData.isEmpty) {
      isQuestionsEmpty = true;
    }

    await dbService.deleteQuestion(questionData['id'], gender);
    await selectQuestionByAge(currentSelectedAgeGroup, gender);
    notifyListeners();
  }

  // select  a question age wise
  Future selectQuestionByAge(String ageGroup, gender) async {
    currentSelectedAgeGroup = ageGroup;
    currentSelectedGender = gender;

    final List<Map> questionData = await dbService.getQuestions(gender);

    final List filterdQuestionData = questionData.where((dynamic element) {
      return (element['ageRange'] as List).join('-') == ageGroup ||
          element['toAllAgeGroup'] == true;
    }).toList();

    // sorting by question number
    filterdQuestionData.sort((a, b) => (a["qNo"].compareTo(b["qNo"])));

    questionsData = [...filterdQuestionData];

    if (questionsData.isNotEmpty) {
      isQuestionsEmpty = false;
    }

    if (questionsData.isEmpty) {
      isQuestionsEmpty = true;
    }
    // questionsData.where((element) => false)
    notifyListeners();
  }

  void resetSelectedData() {
    currentSelectedAgeGroup = '';
    currentSelectedGender = '';
    questionsData = [];
  }

  // select  a question by id
  // Future deleteQuestion(String id) async {
  //   dbService.deleteQuestion(id);

  //   // questionsData.where((element) => false)
  //   notifyListeners();
  // }

  // delete a question
  Future orderQuestions(newIndex, oldIndex) async {
    // finding the ids of question
    var oldQId = this.questionsData[oldIndex]['qNo'];
    var newQId = this.questionsData[newIndex]['qNo'];

    // replacing the old new index ids
    this.questionsData[newIndex]['qNo'] = oldQId;
    this.questionsData[oldIndex]['qNo'] = newQId;

    // sorting the questions id wise
    this.questionsData.sort(
          (a, b) => (a["qNo"].compareTo(
            b["qNo"],
          )),
        );

    List<Map<String, dynamic>> questionIdValue = [
      {
        "docId": questionsData[newIndex]["id"],
        "replaceValue": newQId,
      },
      {
        "docId": questionsData[oldIndex]["id"],
        "replaceValue": oldQId,
      }
    ];
    dbService.updateQuestionOrder(questionIdValue, this.currentSelectedGender);

    notifyListeners();
  }
}
