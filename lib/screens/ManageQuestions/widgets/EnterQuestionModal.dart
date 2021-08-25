import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

class EnterQuestionModal extends StatefulWidget {
  EnterQuestionModal({Key? key, required this.submitHandler}) : super(key: key);
  final submitHandler;

  @override
  _EnterQuestionModalState createState() => _EnterQuestionModalState();
}

class _EnterQuestionModalState extends State<EnterQuestionModal> {
  final _formKey = GlobalKey<FormState>();

  int minAgeNumber = 20;
  int maxAgeNumber = 20;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: Text("Enter Quesiton"),
      content: Container(
        child: Form(

          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Enter question ?",
                ),
              ),
              Divider(),
              // AGE SELECTOR
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Chip(
                          label: Text("min Age"),
                          backgroundColor:
                              Theme.of(context).secondaryHeaderColor,
                        ),
                        Chip(
                          label: Text("max Age"),
                          backgroundColor:
                              Theme.of(context).secondaryHeaderColor,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        NumberPicker(
                          minValue: 20,
                          maxValue: 100,
                          value: minAgeNumber,
                          onChanged: (value) =>
                              setState(() => minAgeNumber = value),
                        ),
                        NumberPicker(
                          minValue: 20,
                          maxValue: 100,
                          value: maxAgeNumber,
                          onChanged: (value) =>
                              setState(() => maxAgeNumber = value),
                        ),
                      ],
                    ),
                  ],
                ),
              ), // age selecter

              Row(
                children: [
                  Container(
                    width: 50,
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: "Risk",
                      ),
                    ),
                  ),
                  Container(
                    width: 200,
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: "Risk",
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
