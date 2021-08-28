import 'package:expert_diagnosis/Store/AdminStateModel.dart';
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
  // refreshing the form widget with unique time stamp key
  var uniquKey = DateTime.now().microsecondsSinceEpoch;

  // on save question data
  void _onSave(context) async {
    AdminStateModel adminStateModel =
        Provider.of<AdminStateModel>(context, listen: false);

// get currrent queston data
    var currentQuestionData = adminStateModel.currentQuestionData;

    if ((currentQuestionData["question"] as String).isEmpty ||
        (currentQuestionData["options"] as List).isEmpty ||
        (currentQuestionData["gender"] as String).isEmpty) {
      dialogService.createDiallog(
        context,
        ALERT_CHECK,
        backDropClose: true,
        alertext: "please fill form correctly !",
      );
      return;
    }
    // saving data on firebase
    await saveQuestionData(currentQuestionData, context);

// after saving succesfull
    dialogService.createDiallog(
      context,
      ALERT_CHECK,
      backDropClose: true,
      alertext: "Queestion created successfully",
    );

    // reset quesiton data
    adminStateModel.resetQuestionData();
    // after changing the  key form data will
    setState(() {
      uniquKey = DateTime.now().microsecondsSinceEpoch;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Enter Question"),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: QeustionForm(
          key: Key("$uniquKey"),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () => (this._onSave(context)),
        tooltip: 'Add Question',
        child: Icon(Icons.save),
      ), // This trailing comma makes auto-formatting nicer for build methods.
      // floatingActionButton: ,
    );
  }
}
