import 'package:expert_diagnosis/constants/index.dart';
import 'package:expert_diagnosis/screens/ManageQuestions/screens/EnterQuestion.dart';
import 'package:expert_diagnosis/screens/ManageQuestions/widgets/MenQuestions.dart';
import 'package:expert_diagnosis/screens/ManageQuestions/widgets/WomenQuestions.dart';
import 'package:expert_diagnosis/services/DialogService.dart';
import 'package:flutter/material.dart';

class ManageQuestions extends StatelessWidget {
  const ManageQuestions({Key? key}) : super(key: key);

  void _submitHandler(data) {
    print('data, $data');
  }

  Future onInputForm(context) {
    // return dialogService.createDiallog(
    //   context,
    //   ALERT_CHECK,
    //   alertext: "cool man",
    //   backDropClose: true,
    // );

    return dialogService.createDiallog(
      context,
      MANAGE_QUESTION_FORM,
      submitHandler: _submitHandler,
    );
  }

  void onAddQuesitonScreen(context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => (EnterQuestion()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Manage Questions"),
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.male)),
              Tab(icon: Icon(Icons.female)),
            ],
          ),
        ),
        body: TabBarView(children: <Widget>[
          Container(
            child: MenQuestions(),
          ),
          Container(
            child: WomenQuestions(),
          ),
        ]),

        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // onInputForm(context);
            onAddQuesitonScreen(context);
          },
          tooltip: 'Add Question',
          child: Icon(Icons.add),
        ), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}
