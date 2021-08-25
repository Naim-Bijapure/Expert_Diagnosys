import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expert_diagnosis/Store/UserStateModel.dart';
import 'package:expert_diagnosis/services/UserService.dart';
import 'package:expert_diagnosis/screens/ManageQuestions/widgets/AgeRangeDropDown.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WomenQuestions extends StatefulWidget {
  WomenQuestions({Key? key}) : super(key: key);

  @override
  _WomenQuestionsState createState() => _WomenQuestionsState();
}

class _WomenQuestionsState extends State<WomenQuestions> {
  List<String> ageList = [];

  // to get age list from men
  Future _getAgeGroupList() async {
    // if (this.ageList.length == 0) {
    CollectionReference menQuestionsData = FirebaseFirestore.instance
        .collection("ED")
        .doc("Questions")
        .collection("women");

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
      if (userState.ageRangeGroup["women"]!.length == 0) {
        var ageRangeList = await getQuestionData("women");

        userState.updateQuestionData(ageRangeList, "women");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AgeRangeDropDown(
          genderType: "women",
        ),
        Divider()
      ],
    );
  }
}
