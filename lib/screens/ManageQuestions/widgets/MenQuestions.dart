import 'package:expert_diagnosis/screens/ManageQuestions/widgets/AgeRangeDropDown.dart';
import 'package:flutter/material.dart';

import 'QuestionsList.dart';

class MenQuestions extends StatefulWidget {
  MenQuestions({Key? key}) : super(key: key);

  @override
  _MenQuestionsState createState() => _MenQuestionsState();
}

class _MenQuestionsState extends State<MenQuestions> {
  List<String> ageList = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AgeRangeDropDown(
          genderType: "men",
        ),
        Divider(),
        // __buildQuestionsList(context),
        QuestionsList()
      ],
    );
  }
}

// // questino list
// Widget __buildQuestionsList(BuildContext context) {
//   List<Map<String, dynamic>> questionsData =
//       context.watch<AdminStateModel>().questionsData;

//   bool isQuestionsEmpty = context.watch<AdminStateModel>().isQuestionsEmpty;

//   String currentSelectedAgeGroup =
//       context.watch<AdminStateModel>().currentSelectedAgeGroup;

//   if (questionsData.length > 0) {
//     return SingleChildScrollView(
//       key: Key("${currentSelectedAgeGroup}_${questionsData.length}"),
//       child: QuestionExpansionPanel(
//         key: Key("${currentSelectedAgeGroup}_${questionsData.length}"),
//         qustionsData: questionsData,
//       ),
//     );
//   }
//   // if no questions
//   if (isQuestionsEmpty) {
//     return Text("No questions added");
//   }

// // default loading
//   return Center(
//     // child: CircularProgressIndicator(),
//     child: Text("Select Age Group"),
//   );
// }

