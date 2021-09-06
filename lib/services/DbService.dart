import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class DbService {
  late final CollectionReference ED;
  DbService() {
    ED = FirebaseFirestore.instance.collection('ED');
  }

  ///ADMIN METHOD
// SAVE QUESITON DATA ON FIREBASE
  Future saveQuestionData(Map<String, dynamic> questiondData) async {
    try {
      final CollectionReference ED =
          this.ED.doc('Questions').collection("${questiondData['gender']}");

      Stream<QuerySnapshot> readColSize = ED.snapshots();
      var readSizeListener;
      readSizeListener = readColSize.listen((QuerySnapshot event) async {
        /// cancle subscription after reading
        readSizeListener.cancel();

        int qNo = event.size + 1;

        // after reading add this to db with increased size by 1
        final savedData = await ED.add({...questiondData, "qNo": qNo});
      });

      return "saved";
    } catch (err) {
      print('err, $err');
    }

    // return ageRangeList;
  }

  Future<List<Map<dynamic, dynamic>>> getQuestions(gender) async {
// fetch the data
    final CollectionReference questionsData = FirebaseFirestore.instance
        .collection('ED')
        .doc('Questions')
        .collection('$gender');

    final fetchedData = await questionsData.get();
    List<Map<dynamic, dynamic>> listData = fetchedData.docs.map((e) {
      // inserting question id in data
      final data = e.data() as Map;
      data['id'] = e.id;
      return data;
    }).toList();
    return listData;
  }

  Future getAgeRange(gender) async {
    final List<dynamic> fetchedListData = await getQuestions(gender);

    // sorting with age
    fetchedListData.sort(
      (a, b) => a['ageRange'][0].compareTo(b['ageRange'][0]),
    );

    // convert age range in unique string in list
    final List<dynamic> ageRangeList = fetchedListData
        .map((e) =>
            "${e['ageRange'][0].toString()}-${e['ageRange'][1].toString()}")
        .toSet()
        .toList();
    return ageRangeList;
  }

// listening age range on realtime changes
  Stream<QuerySnapshot> questionsStream(gender, BuildContext context) {
    final Stream<QuerySnapshot> questionStream =
        this.ED.doc('Questions').collection('$gender').snapshots();

    return questionStream;
  }

  Future deleteQuestion(id, gender) async {
    print('id, $id');
    try {
      final CollectionReference questions =
          ED.doc('Questions').collection('$gender');

      await questions.doc('$id').delete();
      print('Question Deleted');
    } catch (err) {
      print('err: $err');
    }
  }

  // updating the order of question  document

  Future updateQuestionOrder(
    List<Map<String, dynamic>> questionIdValue,
    String currentSelectedGender,
  ) async {
    try {
      /// pseudo code
      /// 1. get the question id and its values to update (recive as list in arguments)
      /// 2. iterate orver list  and send request to update the value with doc id

      questionIdValue.forEach((element) {
        this
            .ED
            .doc("Questions")
            .collection("$currentSelectedGender")
            .doc("${element['docId']}")
            .update(
          {"qNo": element['replaceValue']},
        );
      });
    } catch (err) {
      print('err: $err');
    }
  }
}

DbService dbService = DbService();
