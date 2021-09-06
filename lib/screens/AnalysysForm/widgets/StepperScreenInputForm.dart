import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class StepperScreenInputForm extends StatefulWidget {
  const StepperScreenInputForm({Key? key, @required this.submitHandler})
      : super(key: key);

  final submitHandler;

  @override
  _StepperScreenInputFormState createState() => _StepperScreenInputFormState();
}

class _StepperScreenInputFormState extends State<StepperScreenInputForm> {
  final _formKey = GlobalKey<FormState>();

  String userName = '';
  int userAge = 0;
  String genderType = '';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: Text('User Details'),
      content: Padding(
        padding: const EdgeInsets.all(0.8),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // user name
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Enter User Name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter user name';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    userName = value.toString();
                  });
                },
              ),

              // gender
              Row(
                children: [
                  Radio(
                      value: 'men',
                      groupValue: genderType,
                      onChanged: (value) {
                        print('value, $value');
                        setState(() {
                          genderType = value.toString();
                        });
                      }),
                  Text('Male'),
                  Radio(
                      value: 'women',
                      groupValue: genderType,
                      onChanged: (value) {
                        print('value, $value');
                        setState(() {
                          genderType = value.toString();
                        });
                      }),
                  Text('Female'),
                ],
              ),

              // age
              TextFormField(
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                ],
                decoration: InputDecoration(
                  labelText: 'Enter Age',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Age';
                  }

                  if (int.parse(value) < 20 || int.parse(value) > 100) {
                    return 'Age should between 20 to 100 !!';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    userAge = int.tryParse(value) ?? 0;
                  });
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              widget.submitHandler({
                'userName': userName,
                'userAge': userAge,
                'genderType': genderType
              });

              // ScaffoldMessenger.of(context).showSnackBar(
              //   SnackBar(
              //     duration: Duration(seconds: 2),
              //     content: Row(
              //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //       children: [
              //         Text('Fetching Questions..'),
              //         CircularProgressIndicator(),
              //       ],
              //     ),
              //   ),
              // );

              Navigator.pop(context);
            }
          },
          child: Text('submit'),
        )
      ],
    );
  }
}
