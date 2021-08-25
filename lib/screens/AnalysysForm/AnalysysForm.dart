import 'package:expert_diagnosis/screens/AnalysysForm/widgets/StepperForm.dart';
import 'package:flutter/material.dart';

class AnalysisForm extends StatelessWidget {
  const AnalysisForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Analysis form"),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StepperForm(),
          ],
        ),
      ),
    );
  }
}
