import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TestFirebase extends StatefulWidget {
  const TestFirebase({Key? key}) : super(key: key);

  @override
  _TestFirebaseState createState() => _TestFirebaseState();
}

class _TestFirebaseState extends State<TestFirebase> {
  late CollectionReference ED;

  @override
  void initState() {
    this.ED = FirebaseFirestore.instance.collection("ED");
    super.initState();
  }

  void onFirebase() async {
    print('cool clicked');
    try {
      await this.ED.add({'name': 'yo'});
    } catch (err) {
      print('error, $err');
    }
  }

  // on update data

  void onUpdateData() async {
    try {
      await this.ED.doc("Questions").update({
        "Q1": {"yes": 11}
      });
    } catch (err) {
      print('error, $err');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User x TestFirebase"),
      ),
      body: Column(
        children: [
          Text("Report Screen"),
          // on press
          // ElevatedButton(
          //   onPressed: onFirebase,
          //   child: Text('check firebase'),
          // ),

          // ElevatedButton(
          //   onPressed: onUpdateData,
          //   child: Text('update data'),
          // ),
          // FirebaseFuture(),
          FireBaseSreamData()
        ],
      ),
    );
  }
}

// to read from firestore with future one time

class FirebaseFuture extends StatelessWidget {
  const FirebaseFuture({Key? key}) : super(key: key);

  Future getData() async {
    // main doc ref
    var ED = FirebaseFirestore.instance.collection("ED").doc("Questions");

    DocumentSnapshot<Map<String, dynamic>> data = await ED.get();
    dynamic newData = "";

    var FilterEd = FirebaseFirestore.instance.collection("ED");
    var filteredData = await FilterEd.where("Gender", isEqualTo: "male").get();
    filteredData.docs.map((doc) {
      var data = doc.data();
      print('doc, $data');
      newData = data;
    }).toList();

    return newData;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // future: ED.get(),
      future: getData(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasError) {
          return Text("someting is wrong");
        }
        if (snapshot.hasData && snapshot.data.length == 0) {
          return Text("Document does not exist");
        }
        if (snapshot.connectionState == ConnectionState.done) {
          dynamic data = snapshot.data;
          print('users data, $data');
          return Text("with future  data is here ");
        }
        return Text("loading");
      },
    );
  }
}

// with stream builder realtime changed
class FireBaseSreamData extends StatefulWidget {
  FireBaseSreamData({Key? key}) : super(key: key);

  @override
  _FireBaseSreamDataState createState() => _FireBaseSreamDataState();
}

class _FireBaseSreamDataState extends State<FireBaseSreamData> {
// collection stream to read data
  final Stream collectionStream = FirebaseFirestore.instance
      .collection("ED")
      .where("Gender", isEqualTo: "male")
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: collectionStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasError) {
          return Container(
            child: Text("something  is worng"),
          );
        }

        // if (snapshot.connectionState == ConnectionState.waiting) {
        //   return Container(
        //     child: Text("loading please wait"),
        //   );
        // }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            child: Text("loading"),
          );
        }
        return ListView(
          shrinkWrap: true,
          children: snapshot.data!.docs.map<Widget>((document) {
            Map<String, dynamic> data =
                document.data()! as Map<String, dynamic>;
            print('data cool, $data');

            return ListTile(
              title: Text("cool with data  "),
              subtitle: Text("yo  "),
            );
          }).toList(),
        );
        // var data = snapshot.data!.docs as List;
        // data.forEach((element) {
        //   print('element, ${element["Q1"]}');
        // });
      },
    );
  }
}
