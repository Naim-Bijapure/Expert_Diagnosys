import 'package:expert_diagnosis/Store/AdminStateModel.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/provider.dart';

import 'CreateOptionInput.dart';

class QeustionForm extends StatefulWidget {
  const QeustionForm({Key? key}) : super(key: key);

  @override
  _QeustionFormState createState() => _QeustionFormState();
}

class _QeustionFormState extends State<QeustionForm> {
  final _formKey = GlobalKey<FormState>();

  int minAgeNumber = 20;
  int maxAgeNumber = 20;
  bool toAllAgeGroup = false;
  final TextEditingController _questionTitleController =
      TextEditingController();

  String selectedGender = '';

  late AdminStateModel adminStateModel;
  // LIFE CYCLES
  @override
  void initState() {
    super.initState();
    adminStateModel = context.read<AdminStateModel>();

    // text controller listener
    _questionTitleController.addListener(() {
      final String text = _questionTitleController.text;
      onQuesitonTitle(text);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _questionTitleController.dispose();
  }

  // METHODS

  void onQuesitonTitle(value) {
    adminStateModel.onQuestionTitle(value);
  }

  void onMinAge(value) {
    setState(
      () => minAgeNumber = value,
    );
    adminStateModel.updateAgeRange(value, 0);
  }

  void onMaxAge(value) {
    setState(
      () => maxAgeNumber = value,
    );

    adminStateModel.updateAgeRange(value, 1);
  }

  void onGenderSelect(value) {
    setState(
      () => selectedGender = value.toString(),
    );

    adminStateModel.onGenderSelect(value);
  }

  void _onAllAgeGroup(value) {
    setState(() {
      toAllAgeGroup = value!;
      minAgeNumber = 20;
      maxAgeNumber = 100;
    });

    adminStateModel.onAllAgeGroup(toAllAgeGroup);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // question title
          TextFormField(
            controller: _questionTitleController,
            decoration: InputDecoration(
              labelText: 'Enter question ?',
            ),
            // onChanged: onQuesitonTitle,
          ),

          Divider(),

          // age gender select
          _buildAgeGenderSelect(),

          // to all age group
          Flexible(
            child: CheckboxListTile(
              title: Text('All Age Groups'),
              value: toAllAgeGroup,
              onChanged: _onAllAgeGroup,
            ),
          ),

          // CREATE OPTION INPUT
          CreateOptionInput(),
          Divider(
            thickness: 4,
          ),

          // OPTION LIST
          _buildOptionList(context),
        ],
      ),
    );
  }

  Row _buildAgeGenderSelect() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        IgnorePointer(
          ignoring: toAllAgeGroup,
          child: NumberPicker(
            axis: Axis.horizontal,

            itemHeight: 30,
            itemWidth: 30,
            minValue: 20,
            maxValue: 100,
            value: minAgeNumber,
            // value: adminStateModel.ageRangeGroup[0] as bool ? 20 : 0,
            onChanged: onMinAge,
          ),
        ),
        Container(
          width: 30,
          child: Chip(
            padding: EdgeInsets.zero,
            label: Text('<'),
          ),
        ),
        Container(
          child: DropdownButton(
            isExpanded: false,
            hint: Text('Select Gender'),
            value: selectedGender.isEmpty ? null : selectedGender,
            onChanged: onGenderSelect,
            items: [
              DropdownMenuItem<String>(
                value: 'men',
                child: Text('Men'),
              ),
              DropdownMenuItem<String>(
                value: 'women',
                child: Text('Women'),
              ),
            ].toList(),
          ),
        ),
        Container(
          width: 30,
          child: Chip(
            padding: EdgeInsets.zero,
            label: Text('>'),
          ),
        ),
        IgnorePointer(
          ignoring: toAllAgeGroup,
          child: NumberPicker(
            axis: Axis.horizontal,
            itemHeight: 30,
            itemWidth: 30,
            minValue: 20,
            maxValue: 100,
            value: maxAgeNumber,
            onChanged: onMaxAge,
          ),
        ),
      ],
    );
  }
}

Widget _buildOptionList(context) {
  final AdminStateModel userState =
      Provider.of<AdminStateModel>(context, listen: true);

  final List<Map> options = userState.options;

  return Container(
    child: ListView.separated(
      itemCount: options.length,
      padding: const EdgeInsets.all(8),
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          leading: Chip(
            label: Text("${options[index]['VALUE']}"),
          ),
          title: Text("${options[index]['TEXT']}"),
          trailing: IconButton(
            onPressed: () {
              final toDeleteIndex = options.indexOf(options[index]);
              userState.deleteOption(toDeleteIndex);
            },
            icon: Icon(Icons.delete),
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(),
    ),
  );
}
