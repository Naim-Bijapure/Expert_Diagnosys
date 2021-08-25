// to get age list from men
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expert_diagnosis/constants/index.dart';
import 'package:expert_diagnosis/services/DialogService.dart';

// get age group list for men and women
Future getQuestionData(genderType) async {
  // if (this.ageList.length == 0) {
  CollectionReference menQuestionsData = FirebaseFirestore.instance
      .collection("ED")
      .doc("Questions")
      .collection("$genderType");

  var fetchedData = await menQuestionsData.get();
  // convert data into list
  List<Map<String, dynamic>> fetchedListData =
      fetchedData.docs.map((e) => e.data() as Map<String, dynamic>).toList();
  print('fetchedListData, $fetchedListData');

  // convert age range in unique string in list
  List<String> ageRangeList = fetchedListData
      .map((e) =>
          "${e['ageRange'][0].toString()}-${e['ageRange'][1].toString()}")
      .toSet()
      .toList();
  // return ageList;
  // print('ageRangeList, $ageRangeList');
  // }
  return ageRangeList;
}

Future saveQuestionData(Map<String, dynamic> questiondData, context) async {
  try {
    print('questiondData, $questiondData');
    CollectionReference ED = FirebaseFirestore.instance
        .collection('ED')
        .doc("Questions")
        .collection("${questiondData['gender']}");
    var savedData = await ED.add({...questiondData});

    dialogService.createDiallog(context, ALERT_CHECK,
        backDropClose: true, alertext: "Queestion created successfully");

    print('savedData, $savedData');
  } catch (err) {
    print('err, $err');
  }

  // return ageRangeList;
}
