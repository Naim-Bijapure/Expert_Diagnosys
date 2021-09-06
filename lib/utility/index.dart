import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// to goto a screen
Future gotoScreen(context, screen) async {
  return await Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => screen,
    ),
  );
}

// to read provider state
T readStateOf<T>(BuildContext context) {
  return Provider.of<T>(context, listen: false);
}

// to watch provider state
T watchStateOf<T>(BuildContext context) {
  return Provider.of<T>(context, listen: true);
}
