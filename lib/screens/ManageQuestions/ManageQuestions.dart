import 'package:expert_diagnosis/Store/AdminStateModel.dart';
import 'package:expert_diagnosis/constants/index.dart';
import 'package:expert_diagnosis/screens/ManageQuestions/screens/EnterQuestion.dart';
import 'package:expert_diagnosis/screens/ManageQuestions/widgets/MenQuestions.dart';
import 'package:expert_diagnosis/screens/ManageQuestions/widgets/WomenQuestions.dart';
import 'package:expert_diagnosis/services/DialogService.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ManageQuestions extends StatefulWidget {
  ManageQuestions({Key? key}) : super(key: key);

  @override
  _ManageQuestionsState createState() => _ManageQuestionsState();
}

class _ManageQuestionsState extends State<ManageQuestions> {
  var uniqueKey = DateTime.now().microsecondsSinceEpoch;

  void _submitHandler(data) {
    print('data, $data');
  }

  Future onInputForm(context) {
    return dialogService.createDiallog(
      context,
      MANAGE_QUESTION_FORM,
      submitHandler: _submitHandler,
    );
  }

  void onAddQuesitonScreen(context) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => (EnterQuestion()),
      ),
    );
    print("on back screen");
    Provider.of<AdminStateModel>(context, listen: false).resetSelectedData();
    // updating the key to refresh the selected states
    this.setState(() {
      uniqueKey = DateTime.now().microsecondsSinceEpoch;
    });
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
            child: MenQuestions(
              key: Key("$uniqueKey"),
            ),
          ),
          Container(
            child: WomenQuestions(
              key: Key("$uniqueKey"),
            ),
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
