import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:expert_diagnosis/Store/UserStateModel.dart';
import 'package:expert_diagnosis/constants/index.dart';

class AgeRangeDropDown extends StatefulWidget {
  AgeRangeDropDown({Key? key, required this.genderType}) : super(key: key);
  String genderType = "";

  @override
  _AgeRangeDropDownState createState() => _AgeRangeDropDownState();
}

class _AgeRangeDropDownState extends State<AgeRangeDropDown> {
  String dropdownValue = SELECT_AGE_GROUP;
  @override
  Widget build(BuildContext context) {
    // get the age range list from provider state
    dynamic ageRange =
        context.watch<UserStateModel>().ageRangeGroup["${widget.genderType}"];

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          child: DropdownButton<String>(
            value: dropdownValue,
            onChanged: (String? newValue) {
              setState(() {
                dropdownValue = newValue!;
              });
            },
            items: <String>[SELECT_AGE_GROUP, ...ageRange]
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
  }
}
