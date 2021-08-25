import 'package:expert_diagnosis/Store/UserStateModel.dart';
import 'package:expert_diagnosis/constants/index.dart';
import 'package:expert_diagnosis/screens/ManageQuestions/screens/widgets/QuestionForm.dart';
import 'package:expert_diagnosis/services/DialogService.dart';
import 'package:expert_diagnosis/services/UserService.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EnterQuestion extends StatefulWidget {
  EnterQuestion({Key? key}) : super(key: key);

  @override
  _EnterQuestionState createState() => _EnterQuestionState();
}

class _EnterQuestionState extends State<EnterQuestion> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Enter Question"),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: QeustionForm(),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // get currrent queston data
          var currentQuestionData =
              context.read<UserStateModel>().currentQuestionData;

          if ((currentQuestionData["question"] as String).isEmpty ||
              (currentQuestionData["options"] as List).isEmpty) {
            dialogService.createDiallog(context, ALERT_CHECK,
                backDropClose: true, alertext: "please fill form correctly !");
            return;
          }
          // saving data on firebase
          await saveQuestionData(currentQuestionData, context);

          // reset quesiton data
          context.read<UserStateModel>().resetQuestionData();
        },
        tooltip: 'Add Question',
        child: Icon(Icons.save),
      ), // This trailing comma makes auto-formatting nicer for build methods.
      // floatingActionButton: ,
    );
  }
}
