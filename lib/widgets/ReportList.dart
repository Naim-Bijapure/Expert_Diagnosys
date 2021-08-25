import 'package:expert_diagnosis/screens/Report.dart';
import 'package:flutter/material.dart';

class ReportList extends StatefulWidget {
  const ReportList({Key? key}) : super(key: key);

  @override
  _ReportListState createState() => _ReportListState();
}

class _ReportListState extends State<ReportList> {
  void _openReport() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Report(),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.list),
            title: Text('user 1 report'),
            subtitle: Text('10-10-2021'),
            onTap: _openReport,
          ),
          ListTile(
            leading: Icon(Icons.list),
            title: Text('user 2 report'),
            subtitle: Text('11-10-2021'),
            onTap: _openReport,
          ),
          ListTile(
            leading: Icon(Icons.list),
            title: Text('user 3 report'),
            subtitle: Text('12-10-2021'),
            onTap: _openReport,
          ),
        ],
      ),
    );
  }
}
