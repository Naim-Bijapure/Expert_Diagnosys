import 'package:flutter/material.dart';

class CustomAlertDialog extends StatelessWidget {
  const CustomAlertDialog({Key? key, this.alertText}) : super(key: key);
  final alertText;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: Text('Alert'),
      content: Text('${alertText}'),
    );
  }
}
