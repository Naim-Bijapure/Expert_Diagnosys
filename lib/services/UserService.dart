// to get age list from men
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expert_diagnosis/constants/index.dart';
import 'package:expert_diagnosis/services/DialogService.dart';

Future saveQuestionData(Map<String, dynamic> questiondData, context) async {
  try {
    print('questiondData, $questiondData');
    CollectionReference ED = FirebaseFirestore.instance
        .collection('ED')
        .doc("Questions")
        .collection("${questiondData['gender']}");
    var savedData = await ED.add({...questiondData});

    // dialogService.createDiallog(context, ALERT_CHECK,
    //     backDropClose: true, alertext: "Queestion created successfully");
    return savedData;
  } catch (err) {
    print('err, $err');
  }

  // return ageRangeList;
}
