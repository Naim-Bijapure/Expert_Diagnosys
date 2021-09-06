import 'package:expert_diagnosis/Store/UserStateMode.dart';
import 'package:expert_diagnosis/Store/user_state.dart';
import 'package:expert_diagnosis/screens/Report/user_report.dart';
import 'package:expert_diagnosis/utility/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

/// import 'package:collection/collection.dart';

class QuestionSteps extends StatefulWidget {
  QuestionSteps({Key? key}) : super(key: key);

  // late final List<Map<dynamic, dynamic>> questionData;

  @override
  _QuestionStepsState createState() => _QuestionStepsState();
}

class _QuestionStepsState extends State<QuestionSteps> {
  // late List<Step> questionSteps = [];
  int currentStep = 0;
  bool complete = false;
  Map selectedOptionData = {};

  List<Map<String, dynamic>> answeredQuestion = [];

  late UserState userState;

  @override
  void initState() {
    super.initState();
  }

  void updateTotalRiskValue() {
    /// calculating risk value
    var listToMapData = [];
    selectedOptionData.forEach((key, value) {
      listToMapData.add({"id": key, ...value});
    });

    int riskValue = listToMapData.fold(0, (previousValue, element) {
      return element["selectedRiskValue"] + previousValue;
    });

    readStateOf<UserStateModel>(context).updateTotalRiskValue(riskValue);
  }

  // void onSelectOption(id, question, selectedOptionValue) {}

  goTo(int step) {
    setState(() => currentStep = step);
  }

  // next() {
  next(questions) {
    currentStep + 1 != questions.length
        ? goTo(currentStep + 1)
        : setState(() {
            complete = true;
          });

    // widget.questionData.add({
    //   "qId": "asdfasdfsdf",
    //   "ageRange": [20, 40],
    //   "question": "cool man",
    //   "gender": "men",
    //   "options": [
    //     {"TEXT": "yo option", "VALUE": 10}
    //   ]
    // });

    // var Q = {
    //   "id": "asdfasdfsdf",
    //   "ageRange": [20, 40],
    //   "question": "cool man",
    //   "gender": "men",
    //   "options": [
    //     {"TEXT": "yo option", "VALUE": 10}
    //   ]
    // };
    // var qustions = [...readStateOf<UserState>(context).questions, Q];

    // int riskVal = readStateOf<UserState>(context).totalRiskValue;
    // print('riskVal: $riskVal');
    // // print('riskVal: $riskVal');
    // if (riskVal == 15) {
    //   print('qustions: $qustions');
    //   readStateOf<UserState>(context).updateQuestion(qustions);
    // }

    // // print('riskVal: $riskVal');

    // print('on next $selectedOptionData');
  }

  cancel() {
    if (currentStep > 0) {
      goTo(currentStep - 1);
    }
  }

  // Widget __nextComplteAction(onStepContinue) {
  Widget __nextComplteAction(onStepContinue, questions, selectedOptionData) {
    List selectedOptionList = selectedOptionData.entries.map((e) => e).toList();

    void onComplete() {
      onStepContinue!();
      if (currentStep == questions.length - 1) {
        print('completed $selectedOptionData');

        // update to main state
        readStateOf<UserStateModel>(context)
            .updateSelectedOptionData(selectedOptionData);

        ///on complte open user report screen
        gotoScreen(context, UserReport());
      }
    }

    return ElevatedButton(
      onPressed: selectedOptionList.length == questions.length
          ? onComplete
          : currentStep == questions.length - 1
              ? null
              : onStepContinue,
      child:
          currentStep == questions.length - 1 ? Text('Complete') : Text('Next'),
    );
  }

  @override
  Widget build(BuildContext context) {
    print('QUESTION STEPS   ');
    return Column(
      children: [
        Expanded(
          child: Observer(builder: (_) {
            print('QUESTION STEPS  > OBSERVER ');
            var userState = readStateOf<UserState>(this.context);
            var questions = userState.questions;
            var selectedOptionData = userState.selectedOptionData;
            var updateSelectedOptionData = userState.updateSelectedOptionData;

            return Stepper(
              // key: Key("${widget.questionData.length}"),
              key: Key("${questions.length}"),
              // steps: _steps,
              steps: _getQuetionSteps(
                questions,
                selectedOptionData,
                updateSelectedOptionData,
              ),
              currentStep: currentStep,
              onStepContinue: () => (next(questions)),
              onStepTapped: (step) => goTo(step),
              onStepCancel: cancel,
              controlsBuilder: (
                BuildContext context, {
                VoidCallback? onStepContinue,
                VoidCallback? onStepCancel,
              }) {
                return Row(
                  children: <Widget>[
                    // __nextComplteAction(onStepContinue),
                    __nextComplteAction(
                      onStepContinue,
                      questions,
                      selectedOptionData,
                    ),
                    SizedBox(
                      width: 50,
                    ),
                    TextButton(
                      onPressed: onStepCancel,
                      child: const Text('Cancle'),
                    ),
                  ],
                );
              },
            );
          }),
        ),
      ],
    );
  }

  /// QUESTION LIST STEPS
  // List<Step> _getQuetionSteps() {
  List<Step> _getQuetionSteps(
    questionData,
    selectedOptionData,
    updateSelectedOptionData,
  ) {
    return questionData.map<Step>((questionObj) {
      return Step(
        isActive: selectedOptionData.containsKey(questionObj['id']),
        state: selectedOptionData.containsKey(questionObj['id'])
            ? StepState.complete
            : StepState.disabled,

        // state: ,
        title: Text(questionObj['question']),
        content: Container(
          // alignment: Alignment.centerLeft,
          child: _buildRadioOptions(
            questionObj['options'],
            questionObj['id'],
            questionObj['question'],
            updateSelectedOptionData,
            selectedOptionData,
          ),
        ),
      );
    }).toList();
  }

  Widget _buildRadioOptions(
    List option,
    String id,
    String question,
    Function onSelectOption,
    Map optionSelectedGroup,
  ) {
    return Column(
      children: [
        if (id == "EXTRA QUESTION") __buildExtraQuestion(),
        if (id != "EXTRA QUESTION")
          ...option.map<Widget>((item) {
            return Row(
              children: <Widget>[
                Radio<int>(
                  value: item['VALUE'],
                  groupValue: optionSelectedGroup[id]?['selectedRiskValue'],
                  onChanged: (value) {
                    onSelectOption(id, question, value);
                  },
                ),
                Flexible(child: Text(item['TEXT'])),
              ],
            );
          }).toList()
      ],
    );
  }

  Widget __buildExtraQuestion() {
    return Column(
      children: [
        Text("cool extra question"),
      ],
    );
  }
}
