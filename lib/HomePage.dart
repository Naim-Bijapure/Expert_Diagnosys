import 'package:expert_diagnosis/screens/AnalysysForm/AnalysysForm.dart';
import 'package:expert_diagnosis/screens/ManageQuestions/ManageQuestions.dart';
import 'package:expert_diagnosis/widgets/ReportList.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // opens main analysi form
  void _openForm() {
    Navigator.push(
        context,
        MaterialPageRoute(
          // builder: (context) => AnalysisForm(),

          builder: (context) => ManageQuestions(),
        ));
  }

  void _onMangeQuestion() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ManageQuestions(),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ReportList(),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _openForm,
        tooltip: 'Create Report',
        child: GestureDetector(
          child: Icon(Icons.health_and_safety),
          onLongPress: _onMangeQuestion,
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
