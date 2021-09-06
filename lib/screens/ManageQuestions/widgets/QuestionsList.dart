import 'package:expert_diagnosis/Store/AdminStateModel.dart';
import 'package:expert_diagnosis/screens/ManageQuestions/widgets/QuestionsListView.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'QuestionExpansionPanel.dart';

class QuestionsList extends StatefulWidget {
  const QuestionsList({Key? key}) : super(key: key);

  @override
  _QuestionsListState createState() => _QuestionsListState();
}

class _QuestionsListState extends State<QuestionsList> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // resetting the question data state before showing the list
    Provider.of<AdminStateModel>(context, listen: false).resetSelectedData();
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> questionsData =
        context.watch<AdminStateModel>().questionsData;

    final bool isQuestionsEmpty =
        context.watch<AdminStateModel>().isQuestionsEmpty;

    final String currentSelectedAgeGroup =
        context.watch<AdminStateModel>().currentSelectedAgeGroup;

    if (questionsData.isNotEmpty) {
      // return SingleChildScrollView(
      //   child: QuestionExpansionPanel(
      //     key: Key('${currentSelectedAgeGroup}_${questionsData.length}'),
      //     qustionsData: questionsData,
      //   ),
      // );

      // print('questionsData: $questionsData');
      return QuestionListView(
        key: Key('${currentSelectedAgeGroup}_${questionsData.length}'),
        questionsList: questionsData,
      );
    }
    // if no questions
    if (isQuestionsEmpty) {
      return Text('No questions added');
    }

// default loading
    return Center(
      // child: CircularProgressIndicator(),
      child: Text('Select Age Group'),
    );
  }
}
