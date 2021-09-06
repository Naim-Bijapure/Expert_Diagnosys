import 'package:expert_diagnosis/Store/UserStateMode.dart';
import 'package:expert_diagnosis/utility/index.dart';
import 'package:flutter/material.dart';

class UserReport extends StatelessWidget {
  const UserReport({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map selectedOptionData =
        readStateOf<UserStateModel>(context).selectedOptionData;

    List tableData = [];
    selectedOptionData.forEach(
      (k, v) => tableData.add(v),
    );

    print('tableData: $tableData');

    return Scaffold(
      appBar: AppBar(
        title: Text("User Report"),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          // Text("cool report"),
          // ElevatedButton(
          //     onPressed: () {
          //       // Navigator.popUntil(
          //       //     context, (Route<dynamic> route) => route.isFirst);
          //     },
          //     child: Text("go to home"))
          __buildReportTable(tableData),
          Divider(
            thickness: 3,
          ),
          ListTile(
            leading: Text("Total Risk"),
            trailing: Chip(
              label: Text("33"),
            ),
          ),

          Divider(
            thickness: 3,
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        onTap: (index) {
          print('index: $index');
          // if (index == 1) {
          Navigator.popUntil(context, (Route<dynamic> route) => route.isFirst);
          // }
        },
        items: [
          BottomNavigationBarItem(
            label: "Save",
            icon: Icon(Icons.save),
          ),
          BottomNavigationBarItem(
            label: "Home",
            icon: Icon(Icons.home),
          ),
        ],
      ),
    );
  }

  Widget __buildReportTable(List tableData) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        // horizontalMargin: 0,
        // columnSpacing: 0,
        columns: [
          DataColumn(
            label: Text(
              "Question",
              style: TextStyle(
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          DataColumn(
            label: Text(
              "Risk value",
              style: TextStyle(
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          DataColumn(
            label: Text(
              "Suggestion",
              style: TextStyle(
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
        rows: <DataRow>[
          ...tableData
              .map((e) => DataRow(cells: [
                    DataCell(
                      Text(e["question"].trim()),
                    ),
                    DataCell(
                      Text(e["selectedRiskValue"].toString()),
                    ),
                    DataCell(
                      Text("some suggestion"),
                    ),
                  ]))
              .toList()
        ],
      ),
    );
  }
}
