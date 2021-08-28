import 'package:expert_diagnosis/Store/AdminStateModel.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/provider.dart';

class QeustionForm extends StatefulWidget {
  QeustionForm({Key? key}) : super(key: key);

  @override
  _QeustionFormState createState() => _QeustionFormState();
}

class _QeustionFormState extends State<QeustionForm> {
  final _formKey = GlobalKey<FormState>();

  int minAgeNumber = 20;
  int maxAgeNumber = 20;
  bool toAllAgeGroup = false;
  TextEditingController _questionTitleController = TextEditingController();

  String selectedGender = "";

  late AdminStateModel adminStateModel;
  // LIFE CYCLES
  @override
  void initState() {
    super.initState();
    adminStateModel = context.read<AdminStateModel>();

    // text controller listener
    _questionTitleController.addListener(() {
      String text = _questionTitleController.text;
      this.onQuesitonTitle(text);
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
              labelText: "Enter question ?",
            ),
            // onChanged: onQuesitonTitle,
          ),

          Divider(),

          // age gender select
          _buildAgeGenderSelect(),

          // to all age group
          Flexible(
            child: CheckboxListTile(
              title: Text("All Age Groups"),
              value: toAllAgeGroup,
              onChanged: _onAllAgeGroup,
            ),
          ),

          // create option input
          CreateOptionInput(),
          Divider(
            thickness: 4,
          ),

          // option list
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
            label: Text("<"),
          ),
        ),
        Container(
          child: DropdownButton(
            isExpanded: false,
            hint: Text("Select Gender"),
            value: selectedGender.isEmpty ? null : selectedGender,
            onChanged: onGenderSelect,
            items: [
              DropdownMenuItem<String>(
                value: "men",
                child: Text("Men"),
              ),
              DropdownMenuItem<String>(
                value: "women",
                child: Text("Women"),
              ),
            ].toList(),
          ),
        ),
        Container(
          width: 30,
          child: Chip(
            padding: EdgeInsets.zero,
            label: Text(">"),
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
  AdminStateModel userState =
      Provider.of<AdminStateModel>(context, listen: true);

  List<Map> options = userState.options;

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
              var toDeleteIndex = options.indexOf(options[index]);
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

class CreateOptionInput extends StatefulWidget {
  const CreateOptionInput({
    Key? key,
  }) : super(key: key);

  @override
  _CreateOptionInputState createState() => _CreateOptionInputState();
}

class _CreateOptionInputState extends State<CreateOptionInput> {
  final TextEditingController _textInputControllers = TextEditingController();

  String optionText = "";
  int optionRiskValue = 0;

  void optionRiskHandler(value) {
    setState(() {
      optionRiskValue = value;
    });
  }

  @override
  void initState() {
    super.initState();
    _textInputControllers.addListener(() {
      String text = _textInputControllers.text;
      setState(() {
        optionText = text;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _textInputControllers.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  children: [
                    TextFormField(
                      controller: _textInputControllers,
                      autofocus: true,
                      keyboardType: TextInputType.multiline,
                      maxLines: 5,
                      minLines: 1,
                      decoration: InputDecoration(
                        labelText: "Enter Option",
                        border: OutlineInputBorder(),
                      ),
                      // onChanged: (value) {
                      //   setState(() {
                      //     optionText = value.toString();
                      //   });
                      // },
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: NumberPicker(
                      // axis: Axis.horizontal,
                      itemHeight: 30,
                      itemWidth: 30,
                      minValue: 0,
                      maxValue: 100,
                      value: optionRiskValue,
                      onChanged: optionRiskHandler,
                    ),
                  ),
                  Text(
                    "risk",
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          OutlinedButton(
            onPressed: () {
              if (optionText.isNotEmpty) {
                context
                    .read<AdminStateModel>()
                    .createOption(optionText, optionRiskValue);

                setState(() {
                  _textInputControllers.text = "";
                  optionRiskValue = 0;
                });
              }
            },
            child: Text("Create Option"),
            style: OutlinedButton.styleFrom(
              primary: Theme.of(context).primaryColor,
              side: BorderSide(
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
