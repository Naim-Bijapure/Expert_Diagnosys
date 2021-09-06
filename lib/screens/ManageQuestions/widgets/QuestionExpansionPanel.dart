// EXPANSION PANEL
import 'package:expert_diagnosis/Store/AdminStateModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class QuestionExpansionPanel extends StatefulWidget {
  const QuestionExpansionPanel({Key? key, required this.qustionsData})
      : super(key: key);

  final List<Map<String, dynamic>> qustionsData;

  @override
  _QuestionExpansionPanelState createState() => _QuestionExpansionPanelState();
}

class _QuestionExpansionPanelState extends State<QuestionExpansionPanel> {
  late List<Map<String, dynamic>> _questions;

  @override
  void initState() {
    super.initState();
    _questions = widget.qustionsData.map(
      (element) {
        element['isExpaned'] = false;
        return element;
      },
    ).toList();
  }

  @override
  Widget build(BuildContext context) {
    if (_questions.isNotEmpty) {
      return ExpansionPanelList(
        key: Key('${_questions.length}'),
        expansionCallback: (int index, bool isExpaned) {
          setState(() {
            _questions[index]['isExpanded'] = !isExpaned;
          });
        },
        children: _questions.map<ExpansionPanel>((Map item) {
          return ExpansionPanel(
              headerBuilder: (BuildContext context, bool isExpaned) {
                return _questionTitleRow(item);
              },
              body: optionListView(item['options'] ?? []),
              isExpanded: item['isExpanded'] ?? false);
        }).toList(),
      );
    }
    return Text('wait');
  }

  Widget optionListView(List options) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: options.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          leading: Chip(
            label: Text(
              "${options[index]['VALUE']}",
            ),
          ),
          title: Text(
            options[index]['TEXT'],
          ),
        );
      },
    );
  }

  Row _questionTitleRow(Map<dynamic, dynamic> item) {
    return Row(
      key: Key("${item['id']}"),
      children: [
        Flexible(
          child: ListTile(
            title: Text(item['question']),
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.edit),
          color: Colors.blue,
        ),
        IconButton(
          onPressed: () {
            final AdminStateModel adminStateModel =
                context.read<AdminStateModel>();
            final String currentGenderType =
                adminStateModel.currentSelectedGender;
            adminStateModel.deleteQuesiton(item, currentGenderType);
          },
          icon: Icon(Icons.delete),
          color: Colors.red,
        ),
      ],
    );
  }
}
