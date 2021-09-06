import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class FireStreamModel extends ChangeNotifier {
// listening age range on realtime changes
  Stream<QuerySnapshot> questionsStream(gender, BuildContext context) {
    final Stream<QuerySnapshot> questionStream = FirebaseFirestore.instance
        .collection('ED')
        .doc('Questions')
        .collection('$gender')
        .snapshots();

    return questionStream;
  }
}
