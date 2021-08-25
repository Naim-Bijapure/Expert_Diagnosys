import 'package:expert_diagnosis/widgets/InputModal.dart';
import 'package:flutter/material.dart';

// generic dialog model service
// Future createDiallog(
//     context, dialogType, submitHandler, alertext, bool backDropClose) {
//   return showDialog(
//       barrierDismissible: backDropClose,
//       context: context,
//       builder: (BuildContext context) {
//         return InputModal(
//           fromScreen: dialogType,
//           submitHandler: submitHandler,
//           alertText: alertext,
//         );
//       });
// }

class DialogService {
  Future createDiallog(context, dialogType,
      {alertext = "Default Text",
      bool backDropClose = false,
      submitHandler: false}) {
    return showDialog(
        barrierDismissible: backDropClose,
        context: context,
        builder: (BuildContext context) {
          return InputModal(
            fromScreen: dialogType,
            submitHandler: submitHandler,
            alertText: alertext,
          );
        });
  }
}

var dialogService = DialogService();
