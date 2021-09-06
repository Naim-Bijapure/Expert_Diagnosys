import 'package:expert_diagnosis/Store/UserStateMode.dart';
import 'package:expert_diagnosis/Store/user_state.dart';
import 'package:expert_diagnosis/constants/index.dart';
import 'package:expert_diagnosis/services/DialogService.dart';
import 'package:expert_diagnosis/utility/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';

import 'question_steps.dart';

class StepperForm extends StatefulWidget {
  const StepperForm({Key? key}) : super(key: key);

  @override
  _StepperFormState createState() => _StepperFormState();
}

class _StepperFormState extends State<StepperForm> {
  int currentStep = 0;
  bool complete = false;
  String genderType = "";

  late UserStateModel userState;
  late var disposeReaction;

  // Map<String, dynamic> userDetails = {};

  // FIXME:TEMP mock data
  Map<String, dynamic> userDetails = {
    "userName": "sdfsf",
    "userAge": 33,
    "genderType": "men"
  };
  // late Stream<QuerySnapshot> questionsStream;

  @override
  void initState() {
    super.initState();

    // invoking  a pop up
    WidgetsBinding.instance!.addPostFrameCallback(this.afterBuild);
  }

  void afterBuild(_) async {
    /// open input form
    // FIXME:TEMP STOPPED
    // await this.onInputForm(context);

    /// fetch question data and store in main user state
    // var questionData = await dbService.getQuestions(userDetails["genderType"]);
    // readStateOf<UserStateModel>(context).updateQuestionData(questionData);

    /// with mobx
    readStateOf<UserState>(context).loadQuestions(userDetails["genderType"]);

    // disposeReaction = autorun((_) {
    //   print('AUTORUN VALUE ');
    //   print(readStateOf<UserState>(context).selectedOptionData);
    // });
    var userState = readStateOf<UserState>(context);
    disposeReaction = when(
      (_) => (userState.totalRiskValue >= 15),
      () {
        print('WHEN RISK VALUE IS ABOVE 15: ${userState.totalRiskValue}');
        var Q = {
          "id": "EXTRA QUESTION",
          "ageRange": [20, 40],
          "question": "cool man",
          "gender": "men",
          "options": [
            {"TEXT": "yo option", "VALUE": 10}
          ]
        };
        var qustions = [...readStateOf<UserState>(context).questions, Q];

        // int riskVal = readStateOf<UserState>(context).totalRiskValue;
        // print('riskVal: $riskVal');
        // print('riskVal: $riskVal');
        // if (riskVal == 15) {
        readStateOf<UserState>(context).updateQuestion(qustions);
        // }
      },
    );
  }

  inputModelFormHandler(Map<String, Object> formData) {
    // update user details
    setState(() {
      userDetails = formData;
    });
  }

  // on dispose widget
  @override
  void dispose() {
    super.dispose();
    disposeReaction();
  }

  ///POP UP INPUT FORM ON SCREEN
  Future onInputForm(context) {
    return dialogService.createDiallog(
      context,
      STEPPER_FORM,
      submitHandler: inputModelFormHandler,
    );
  }

  @override
  Widget build(BuildContext context) {
    // userState = watchStateOf<UserStateModel>(this.context);
    // print('userState risk value: ${userState.totalRiskValue}');

    // var userStateMobx = readStateOf<UserState>(this.context);
    // var questionX = userStateMobx.questions?.result;
    // print(' MOBX questionX: $questionX');

    /// watching on questions
    // List questions = userState.questions;

    // if (userDetails.isEmpty == false) {
    //   if (questions.isNotEmpty) {
    //     /// question steps with steper
    //     return QuestionSteps(
    //       questionData: questions,
    //     );
    //   }

    //   if (questions.isEmpty) {
    //     return Center(
    //       child: Column(
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         crossAxisAlignment: CrossAxisAlignment.center,
    //         children: [
    //           CircularProgressIndicator(),
    //         ],
    //       ),
    //     );
    //   }
    // }

    return Observer(
      builder: (_) {
        print('STEPPER FORM ');
        var userState = readStateOf<UserState>(this.context);

        var questionsFuture = userState.questionsFuture;

        if (questionsFuture == null ||
            questionsFuture.status == FutureStatus.pending) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
              ],
            ),
          );
        }

        // print('userState: ${userState.questions}');
        if (userState.questions.length > 0) {
          return QuestionSteps();
        }

        return CircularProgressIndicator();
      },
    );
  }
}
