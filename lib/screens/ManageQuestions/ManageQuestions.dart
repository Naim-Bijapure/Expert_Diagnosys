import 'package:expert_diagnosis/Store/AdminStateModel.dart';
import 'package:expert_diagnosis/screens/ManageQuestions/screens/EnterQuestion.dart';
import 'package:expert_diagnosis/screens/ManageQuestions/widgets/MenQuestions.dart';
import 'package:expert_diagnosis/screens/ManageQuestions/widgets/WomenQuestions.dart';
import 'package:expert_diagnosis/utility/index.dart';
import 'package:flutter/material.dart';

class ManageQuestions extends StatefulWidget {
  const ManageQuestions({Key? key}) : super(key: key);

  @override
  _ManageQuestionsState createState() => _ManageQuestionsState();
}

class _ManageQuestionsState extends State<ManageQuestions> {
  // unique key to reset form
  int uniqueKey = DateTime.now().microsecondsSinceEpoch;

  ///  GO TO CREATE QUESTION FORM SCREEN
  void onAddQuesitonScreen(context) async {
    await gotoScreen(context, EnterQuestion());
    // resetting the selected drop down option and questions when going back
    // Provider.of<AdminStateModel>(context, listen: false).resetSelectedData();

    AdminStateModel adminState = readStateOf<AdminStateModel>(context);
    adminState.resetSelectedData();

    /// changing the key to refresh the data when user come back on question list screen
    setState(() {
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
          title: const Text('Manage Questions'),
          bottom: _buildTabBar(),
        ),
        body: _buildTabBarView(),

        floatingActionButton: _openFormFloatActionButton(
          context,
        ), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }

  FloatingActionButton _openFormFloatActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => (onAddQuesitonScreen(context)),
      tooltip: 'Add Question',
      child: Icon(Icons.add),
    );
  }

  TabBarView _buildTabBarView() {
    return TabBarView(children: <Widget>[
      // MEN QUESTION TAB SCREEN
      Container(
        child: MenQuestions(
          key: Key('$uniqueKey'),
        ),
      ),
      // WOMEN QUESTION TAB SCREEN
      Container(
        child: WomenQuestions(
          key: Key('$uniqueKey'),
        ),
      ),
    ]);
  }

  TabBar _buildTabBar() {
    return const TabBar(
      tabs: [
        Tab(icon: Icon(Icons.male)),
        Tab(icon: Icon(Icons.female)),
      ],
    );
  }
}
