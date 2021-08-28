import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expert_diagnosis/Store/AdminStateModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class DbService {
  late final CollectionReference ED;
  DbService() {
    ED = FirebaseFirestore.instance.collection("ED");
  }

  Future getQuestions(gender) async {
// fetch the data
    CollectionReference questionsData = FirebaseFirestore.instance
        .collection("ED")
        .doc("Questions")
        .collection("$gender");

    var fetchedData = await questionsData.get();
    var listData = fetchedData.docs.map((e) {
      // inserting question id in data
      var data = e.data() as Map;
      data["id"] = e.id;
      return data;
    }).toList();
    return listData;
  }

  Future getAgeRange(gender) async {
    List<dynamic> fetchedListData = await this.getQuestions(gender);

    // sorting with age
    fetchedListData.sort(
      (a, b) => (a["ageRange"][0].compareTo(b["ageRange"][0])),
    );

    // convert age range in unique string in list
    List<dynamic> ageRangeList = fetchedListData
        .map((e) =>
            "${e['ageRange'][0].toString()}-${e['ageRange'][1].toString()}")
        .toSet()
        .toList();
    return ageRangeList;
  }

// listening age range on realtime changes
  Stream<QuerySnapshot> getAgeRangeStream(gender, BuildContext context) {
    Stream<QuerySnapshot> questionStream =
        this.ED.doc("Questions").collection("$gender").snapshots();

    return questionStream;
  }

  Future deleteQuestion(id, gender) async {
    print('id, $id');
    try {
      CollectionReference questions =
          this.ED.doc("Questions").collection("$gender");

      await questions.doc("$id").delete();
      print("Question Deleted");
    } catch (err) {
      print('err: $err');
    }
  }
}

DbService dbService = DbService();
