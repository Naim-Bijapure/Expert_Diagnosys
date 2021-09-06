import 'package:expert_diagnosis/Store/AdminStateModel.dart';
import 'package:expert_diagnosis/utility/index.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

class CreateOptionInput extends StatefulWidget {
  const CreateOptionInput({
    Key? key,
  }) : super(key: key);

  @override
  _CreateOptionInputState createState() => _CreateOptionInputState();
}

class _CreateOptionInputState extends State<CreateOptionInput> {
  final TextEditingController _textInputControllers = TextEditingController();

  String optionText = '';
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
      final String text = _textInputControllers.text;
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
                        labelText: 'Enter Option',
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
                    'risk',
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
                // context
                //     .read<AdminStateModel>()
                //     .createOption(optionText, optionRiskValue);

                readStateOf<AdminStateModel>(context)
                    .createOption(optionText, optionRiskValue);

                setState(() {
                  _textInputControllers.text = '';
                  optionRiskValue = 0;
                });
              }
            },
            child: Text('Create Option'),
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
