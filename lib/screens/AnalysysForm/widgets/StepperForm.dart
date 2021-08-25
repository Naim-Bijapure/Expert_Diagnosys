import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expert_diagnosis/widgets/InputModal.dart';
import 'package:flutter/material.dart';

class StepperForm extends StatefulWidget {
  StepperForm({Key? key}) : super(key: key);

  @override
  _StepperFormState createState() => _StepperFormState();
}

enum RadioSmoking { yes, no }

class _StepperFormState extends State<StepperForm> {
  RadioSmoking? _character;

  int currentStep = 0;
  String DropDownValue = "Select";
  bool complete = false;

  Map<String, Object> userDetails = {};
  late Stream<QuerySnapshot> questionsStream;

  @override
  void initState() {
    _character = RadioSmoking.yes;
    super.initState();

    // invoking  a pop up
    // WidgetsBinding.instance!.addPostFrameCallback((_) async {
    //   await this.onInputForm(context);
    // });
    Timer.run(() async {
      await this.onInputForm(context);
    });
    // Timer(Duration(seconds: 1), () async {
    // await this.onInputForm(context);
    // });
  }

  inputModelFormHandler(Map<String, Object> formData) {
    // update user details
    setState(() {
      userDetails = formData;
    });

    // final Stream<QuerySnapshot> qStream = FirebaseFirestore.instance
    //     .collection("ED")
    //     .where("Gender", isEqualTo: "male")
    //     .snapshots();

    var genderType = formData["genderType"];
    final Stream<QuerySnapshot> qStream = FirebaseFirestore.instance
        .collection("ED")
        .doc("Questions")
        .collection("$genderType")
        .snapshots();

    setState(() {
      questionsStream = qStream;
    });
  }

  Future onInputForm(context) {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return InputModal(
            fromScreen: "StepForm",
            submitHandler: inputModelFormHandler,
          );
        });
  }

  // List<Step> get _steps => <Step>[..._questionSteps()];

  /// todo steps
  /// 1. connecte with firebase get data with hard core
  /// 2. make a dynamic component
  @override
  Widget build(BuildContext context) {
    if (userDetails.isEmpty == false) {
      return StreamBuilder<QuerySnapshot>(
          stream: this.questionsStream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            // snapshot.data?.docs.map((DocumentSnapshot document) {
            //   var data = document.data();
            //   print('data, $data');
            // }).toList();

            // on error
            if (snapshot.hasError) {
              return Text("something went wrong");
            }

            // on loading
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
              // return Text("loading");
            }
            // preparing the questiong data from db
            List<Map<dynamic, dynamic>> questionsData = snapshot.data!.docs
                .map<Map<dynamic, dynamic>>(
                  (DocumentSnapshot doccument) {
                    var elementData = doccument.data() as Map<dynamic, dynamic>;

                    // filtering with age date range
                    if (elementData["ageRange"][0] <= userDetails["userAge"] &&
                        elementData["ageRange"][1] >= userDetails["userAge"]) {
                      return {...elementData, "qId": doccument.id};
                    }
                    return {};
                  },
                )
                .where((element) => element.isEmpty == false)
                .toList();

            // if data is empty
            if (questionsData.isEmpty) {
              return Text("Sorry no questions available :(");
            }

            // sending the question data to question widget
            return QuestionSteps(questionData: questionsData);
          });
    }

    return Text("");
  }
}

// dynamic question step widget
class QuestionSteps extends StatefulWidget {
  QuestionSteps({Key? key, required this.questionData}) : super(key: key);

  List questionData;

  @override
  _QuestionStepsState createState() => _QuestionStepsState();
}

class _QuestionStepsState extends State<QuestionSteps> {
  late List<Step> questionSteps = [];
  int currentStep = 0;
  bool complete = false;
  Map optionSelectedGroup = {};

  @override
  void initState() {
    super.initState();
// [{
//  ageRange: [20, 34],
//  question: Are you smoke ?,
//  options: [{TEXT: yes, VALUE: 2},  {TEXT: no, VALUE: 0}]
//  },
// {ageRange: [20, 34],
//  question: Chest pain ? ,
//  options: [{TEXT: yes, VALUE: 5}, {TEXT: no, VALUE: 0}]
// }
// ]

    setState(() {
      questionSteps = this._getQuetionSteps();
    });
  }

  void onSelectOption(qId, question, selectedOptionValue) {
    // print('selectedOption, $selectedOptionValue, question $qId');
    setState(() {
      // optionSelectedGroup[qId] = selectedOptionValue;
      optionSelectedGroup[qId] = {
        "question": question,
        "selectedRiskValue": selectedOptionValue
      };
    });
  }

  List<Step> get _steps => <Step>[..._getQuetionSteps()];

  Widget _buildOption(List option, String qId, String question,
      Function onSelectOption, Map optionSelectedGroup) {
    // print('optionSelectedGroup, $optionSelectedGroup');
    return Column(
      children: option.map<Widget>((item) {
        return Row(
          children: <Widget>[
            Radio<int>(
              value: item["VALUE"],
              groupValue: optionSelectedGroup[qId]?["selectedRiskValue"],
              onChanged: (value) {
                print('value, $value');
                onSelectOption(qId, question, value);
              },
            ),
            Text(item["TEXT"]),
          ],
        );
      }).toList(),
      // [
      //   Radio(
      //       value: int.parse(item["VALUE"]),
      //       groupValue: 2,
      //       onChanged: (value) {
      //         print('value, $value');
      //       }),
      //   Text(item["TEXT"]),
      // ]
    );
  }

  List<Step> _getQuetionSteps() {
    return widget.questionData.map((questionObj) {
      return Step(
        isActive: true,
        // state: ,
        title: Text(questionObj["question"]),
        content: Container(
          alignment: Alignment.centerLeft,
          // child: Text(questionObj["question"] +
          //     " is this last step ${currentStep} and total steps ${questionSteps.length}"),
          child: _buildOption(questionObj["options"], questionObj["qId"],
              questionObj["question"], onSelectOption, optionSelectedGroup),
        ),
      );
    }).toList();
  }

  goTo(int step) {
    setState(() => currentStep = step);
  }

  next() {
    currentStep + 1 != questionSteps.length
        ? goTo(currentStep + 1)
        : setState(() {
            complete = true;
          });
  }

  cancel() {
    if (currentStep > 0) {
      goTo(currentStep - 1);
    }
  }

  Widget __nextComplteAction(onStepContinue) {
    // on step complte action
    return ElevatedButton(
      onPressed: () {
        onStepContinue!();
        if (currentStep == _steps.length - 1) {
          print('completed $optionSelectedGroup');
        }
      },
      child: currentStep == _steps.length - 1 ? Text('Complete') : Text('Next'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stepper(
          steps: _steps,
          currentStep: currentStep,
          onStepContinue: next,
          onStepTapped: (step) => goTo(step),
          onStepCancel: cancel,
          controlsBuilder: (BuildContext context,
              {VoidCallback? onStepContinue, VoidCallback? onStepCancel}) {
            return Row(
              children: <Widget>[
                __nextComplteAction(onStepContinue),
                SizedBox(width: 50),
                TextButton(
                  onPressed: onStepCancel,
                  child: const Text('Cancle'),
                ),
              ],
            );
          }),
    );
  }
}
