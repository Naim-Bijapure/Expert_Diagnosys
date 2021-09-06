import 'package:expert_diagnosis/screens/ManageQuestions/widgets/AgeRangeDropDown.dart';
import 'package:flutter/material.dart';

import 'QuestionsList.dart';

class MenQuestions extends StatefulWidget {
  const MenQuestions({Key? key}) : super(key: key);

  @override
  _MenQuestionsState createState() => _MenQuestionsState();
}

class _MenQuestionsState extends State<MenQuestions> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AgeRangeDropDown(
          genderType: 'men',
        ),
        Divider(),
        // __buildQuestionsList(context),
        QuestionsList()
      ],
    );
  }
}
