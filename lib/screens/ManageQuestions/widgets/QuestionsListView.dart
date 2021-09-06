import 'package:expert_diagnosis/Store/AdminStateModel.dart';
import 'package:expert_diagnosis/constants/index.dart';
import 'package:expert_diagnosis/services/DialogService.dart';
import 'package:expert_diagnosis/utility/index.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

class QuestionListView extends StatefulWidget {
  QuestionListView({Key? key, required this.questionsList}) : super(key: key);
  final List questionsList;

  @override
  _QuestionListViewState createState() => _QuestionListViewState();
}

class _QuestionListViewState extends State<QuestionListView> {
  @override
  Widget build(BuildContext context) {
    return ReorderableListView.builder(
      shrinkWrap: true,
      itemCount: widget.questionsList.length,
      itemBuilder: (BuildContext context, int index) {
        List questions = widget.questionsList;
        return ListTile(
          key: Key("${questions[index]["id"]}"),
          title: Text(
            "${questions[index]['question']}",
          ),
          trailing: IconButton(
            onPressed: () {
              final AdminStateModel adminStateModel =
                  readStateOf<AdminStateModel>(context);

              final String currentGenderType =
                  adminStateModel.currentSelectedGender;

              adminStateModel.deleteQuesiton(
                  questions[index], currentGenderType);
            },
            icon: Icon(Icons.delete),
            color: Colors.red,
          ),
          onTap: () async {
            print('onTap: ');
            return _optionLIstDialog(
              context,
              questions[index]["id"],
              widget.questionsList,
            );
          },
        );
      },
      onReorder: (int oldIndex, int newIndex) {
        if (oldIndex < newIndex) {
          newIndex -= 1;
        }
        // ordering in state
        readStateOf<AdminStateModel>(context)
            .orderQuestions(newIndex, oldIndex);
      },
    );
  }

  Future<void> _optionLIstDialog(
    BuildContext context,
    String qId,
    List questions,
  ) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        Map selectedQuestion =
            questions.firstWhereOrNull((element) => element["id"] == qId);
        print('selectedQuestion: $selectedQuestion');

        List<dynamic> options = selectedQuestion["options"];

        return SimpleDialog(
          title: Text("Options"),
          // children: [
          //   SimpleDialogOption(
          //     onPressed: () {
          //       Navigator.pop(context);
          //     },
          //     child: const Text('Treasury department'),
          //   ),
          // ],
          children: options.map((e) {
            return SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context);
              },
              child: ListTile(
                leading: Chip(
                  label: Text("${e["VALUE"]}"),
                ),
                title: Text(e["TEXT"]),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
