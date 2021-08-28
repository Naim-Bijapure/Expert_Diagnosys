import 'package:expert_diagnosis/Store/AdminStateModel.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'HomePage.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(ChangeNotifierProvider(
    create: (context) => (AdminStateModel()),
    child: MainApp(),
  ));
}

class MainApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  // firebase initilize
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        // for any error
        if (snapshot.hasError) {
          // TODO:  MAKE A WIDGET TO SHOW PROPER LOADING
          return Text("someting is wrong", textDirection: TextDirection.ltr);
        }

        // if state is done
        if (snapshot.connectionState == ConnectionState.done) {
          return Home();
        }

        return Text("loading...", textDirection: TextDirection.ltr);
      },
    );
  }
}

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expert system for diagnosis',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: HomePage(title: 'Expert system for diagnosis'),
    );
  }
}
