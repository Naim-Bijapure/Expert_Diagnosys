import 'package:expert_diagnosis/Store/UserStateModel.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/provider.dart';

class QeustionForm extends StatefulWidget {
  QeustionForm({Key? key}) : super(key: key);

  @override
  _QeustionFormState createState() => _QeustionFormState();
}

class _QeustionFormState extends State<QeustionForm> {
  int minAgeNumber = 20;
  int maxAgeNumber = 20;
  final _formKey = GlobalKey<FormState>();

  String selectedGender = "men";

  late UserStateModel userStateModel;
  @override
  void initState() {
    super.initState();
    userStateModel = Provider.of<UserStateModel>(context, listen: false);
  }

  void onQuesitonTitle(value) {
    userStateModel.onQuestionTitle(value);
  }

  void onMinAge(value) {
    setState(
      () => minAgeNumber = value,
    );
    userStateModel.updateAgeRange(value, 0);
  }

  void onMaxAge(value) {
    setState(
      () => maxAgeNumber = value,
    );

    userStateModel.updateAgeRange(value, 1);
  }

  void onGenderSelect(value) {
    setState(
      () => selectedGender = value.toString(),
    );

    userStateModel.onGenderSelect(value);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            decoration: InputDecoration(
              labelText: "Enter question ?",
            ),
            onChanged: onQuesitonTitle,
          ),
          Divider(),
          // AGE SELECTOR
          // SELECT GENDER
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              NumberPicker(
                axis: Axis.horizontal,
                itemHeight: 30,
                itemWidth: 30,
                minValue: 20,
                maxValue: 100,
                value: minAgeNumber,
                onChanged: onMinAge,
              ),
              // Chip(
              //   label: Text("<"),
              // ),
              Text(
                "<",
                style: TextStyle(fontSize: 30),
              ),
              Container(
                child: DropdownButton(
                  isExpanded: false,
                  hint: Text("Select Gender"),
                  value: selectedGender,
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
              // Chip(
              //   label: Text(">"),
              // ),

              Text(
                ">",
                style: TextStyle(fontSize: 30),
              ),
              NumberPicker(
                axis: Axis.horizontal,
                itemHeight: 30,
                itemWidth: 30,
                minValue: 20,
                maxValue: 100,
                value: maxAgeNumber,
                onChanged: onMaxAge,
              ),
            ],
          ),
          CreateOptionInput(),
          Divider(
            thickness: 4,
          ),

          Expanded(
            child: optionList(context),
          ),
        ],
      ),
    );
  }
}

Widget optionList(context) {
  UserStateModel userState = Provider.of<UserStateModel>(context, listen: true);

  List<Map> options = userState.options;
  // Map<int, dynamic> optionRiskValue = userState.optionRiskValue;
  Map<String, dynamic> optionRiskValue = userState.optionTextValue;

  return ListView.separated(
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
                    .read<UserStateModel>()
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
