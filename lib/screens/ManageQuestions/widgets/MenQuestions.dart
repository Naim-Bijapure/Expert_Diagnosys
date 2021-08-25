import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expert_diagnosis/Store/UserStateModel.dart';
import 'package:expert_diagnosis/services/UserService.dart';
import 'package:expert_diagnosis/screens/ManageQuestions/widgets/AgeRangeDropDown.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MenQuestions extends StatefulWidget {
  MenQuestions({Key? key}) : super(key: key);

  @override
  _MenQuestionsState createState() => _MenQuestionsState();
}

class _MenQuestionsState extends State<MenQuestions> {
  List<String> ageList = [];

  // to get age list from men
  Future _getAgeGroupList() async {
    // if (this.ageList.length == 0) {
    CollectionReference menQuestionsData = FirebaseFirestore.instance
        .collection("ED")
        .doc("Questions")
        .collection("men");

    var fetchedData = await menQuestionsData.get();
    // convert data into list
    List<Map<String, dynamic>> fetchedListData =
        fetchedData.docs.map((e) => e.data() as Map<String, dynamic>).toList();

    // convert age range in unique string in list
    List<String> ageRangeList = fetchedListData
        .map((e) =>
            "${e['ageRange'][0].toString()}-${e['ageRange'][1].toString()}")
        .toSet()
        .toList();
    return ageRangeList;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      var userState = Provider.of<UserStateModel>(context, listen: false);

      // update if no age range data
      if (userState.ageRangeGroup["men"]!.length == 0) {
        var ageRangeList = await getQuestionData("men");

        userState.updateQuestionData(ageRangeList, "men");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AgeRangeDropDown(
          genderType: "men",
        ),
        Divider()
      ],
    );
  }
}
