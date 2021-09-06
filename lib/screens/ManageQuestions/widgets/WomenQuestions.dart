import 'package:expert_diagnosis/screens/ManageQuestions/widgets/AgeRangeDropDown.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'QuestionsList.dart';

class WomenQuestions extends StatefulWidget {
  const WomenQuestions({Key? key}) : super(key: key);

  @override
  _WomenQuestionsState createState() => _WomenQuestionsState();
}

class _WomenQuestionsState extends State<WomenQuestions> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // update current gender
    // Provider.of(context, listen: false);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AgeRangeDropDown(
          genderType: 'women',
        ),
        Divider(),
        QuestionsList()
      ],
    );
  }
}
