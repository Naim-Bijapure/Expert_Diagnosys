import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expert_diagnosis/services/DbService.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:expert_diagnosis/Store/AdminStateModel.dart';
import 'package:expert_diagnosis/constants/index.dart';

class AgeRangeDropDown extends StatefulWidget {
  AgeRangeDropDown({Key? key, required this.genderType}) : super(key: key);
  String genderType = "";

  @override
  _AgeRangeDropDownState createState() => _AgeRangeDropDownState();
}

class _AgeRangeDropDownState extends State<AgeRangeDropDown> {
  // String dropdownValue = SELECT_AGE_GROUP;
  dynamic dropdownValue = null;

  void _onAgeSelect(String? newValue) {
    setState(() {
      dropdownValue = newValue!;
    });
    // select quesiton by age and gender
    context
        .read<AdminStateModel>()
        .selectQuestionByAge(dropdownValue, widget.genderType);
  }

  @override
  void initState() {
    super.initState();
    // dbService.getAgeRangeStream("${widget.genderType}", context);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: dbService.getAgeRangeStream("${widget.genderType}", context),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("");
        }

        List<dynamic> fetchedListData =
            snapshot.data!.docs.map((e) => e.data()).toList();

        // sorting with age
        fetchedListData.sort(
          (a, b) => (a["ageRange"][0].compareTo(b["ageRange"][0])),
        );

        // convert age range in unique string in list
        List<String> ageRangeList = fetchedListData
            .map((e) =>
                "${e['ageRange'][0].toString()}-${e['ageRange'][1].toString()}")
            .toSet()
            .toList();

        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              child: DropdownButton<String>(
                key: Key("${ageRangeList.length}"),
                // value: dropdownValue,
                value:
                    ageRangeList.contains(dropdownValue) ? dropdownValue : null,
                onChanged: _onAgeSelect,
                hint: Text(SELECT_AGE_GROUP),
                // items: <String>[...ageRange].toSet()
                items: <String>[...ageRangeList]
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
          ],
        );
      },
    );
  }
}
