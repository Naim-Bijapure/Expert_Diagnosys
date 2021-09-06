import 'package:expert_diagnosis/constants/index.dart';
import 'package:expert_diagnosis/screens/AnalysysForm/widgets/StepperScreenInputForm.dart';
import 'package:expert_diagnosis/widgets/CustomAlertDialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputModal extends StatelessWidget {
  const InputModal({
    Key? key,
    @required this.fromScreen,
    @required this.submitHandler,
    this.alertText,
  }) : super(key: key);

  final fromScreen;
  final submitHandler;
  final alertText;

  @override
  Widget build(BuildContext context) {
    // on question step form
    if (fromScreen == STEPPER_FORM) {
      return StepperScreenInputForm(
        submitHandler: submitHandler,
      );
    }

    // if (fromScreen == MANAGE_QUESTION_FORM) {
    //   return EnterQuestionModal(
    //     submitHandler: this.submitHandler,
    //   );
    // }

    // custom dialog to print
    if (fromScreen == ALERT_CHECK) {
      return CustomAlertDialog(alertText: alertText);
    }

    return Text('no form defined !!');
  }
}
