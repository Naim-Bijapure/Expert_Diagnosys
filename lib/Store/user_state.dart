import 'package:expert_diagnosis/services/DbService.dart';
import 'package:mobx/mobx.dart';

// Include generated file
part 'user_state.g.dart';

class UserState = _UserState with _$UserState;

abstract class _UserState with Store {
  // List<Map<dynamic, dynamic>> questions = [];
  @observable
  ObservableFuture<List<Map<dynamic, dynamic>>>? questionsFuture;

  @observable
  List<Map<dynamic, dynamic>> questions = [];

  // @observable
  // int totalRiskValue = 0;

  @observable
  ObservableMap selectedOptionData = ObservableMap();

  @computed
  int get totalRiskValue {
    List selectedOptionList = this.selectedOptionData.entries.map((element) {
      return element.value;
    }).toList();

    int riskValue = selectedOptionList.fold(0, (previousValue, element) {
      print('element: $element');
      return element["selectedRiskValue"] + previousValue;
    });

    return riskValue;
  }

  // ///update questions data from stream
  @action
  Future loadQuestions(gender) async {
    /// creating a future to track states
    questionsFuture = ObservableFuture<List<Map<dynamic, dynamic>>>(
        dbService.getQuestions("$gender"));

    /// assinging fetched questions
    questions = await ObservableFuture<List<Map<dynamic, dynamic>>>(
        dbService.getQuestions("$gender"));
  }

  @action
  void updateQuestion(questionData) {
    questions = [...questionData];
  }

  @action
  void updateSelectedOptionData(id, question, selectedOptionValue) {
    // this.selectedOptionData = value;

    this.selectedOptionData[id] = {
      'question': question,
      'selectedRiskValue': selectedOptionValue
    };
  }

  @action
  bool isActiveStep(id) {
    print('isActiveStep: ');
    return this.selectedOptionData.containsKey('id');
  }
}
