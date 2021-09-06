// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_state.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$UserState on _UserState, Store {
  Computed<int>? _$totalRiskValueComputed;

  @override
  int get totalRiskValue =>
      (_$totalRiskValueComputed ??= Computed<int>(() => super.totalRiskValue,
              name: '_UserState.totalRiskValue'))
          .value;

  final _$questionsFutureAtom = Atom(name: '_UserState.questionsFuture');

  @override
  ObservableFuture<List<Map<dynamic, dynamic>>>? get questionsFuture {
    _$questionsFutureAtom.reportRead();
    return super.questionsFuture;
  }

  @override
  set questionsFuture(ObservableFuture<List<Map<dynamic, dynamic>>>? value) {
    _$questionsFutureAtom.reportWrite(value, super.questionsFuture, () {
      super.questionsFuture = value;
    });
  }

  final _$questionsAtom = Atom(name: '_UserState.questions');

  @override
  List<Map<dynamic, dynamic>> get questions {
    _$questionsAtom.reportRead();
    return super.questions;
  }

  @override
  set questions(List<Map<dynamic, dynamic>> value) {
    _$questionsAtom.reportWrite(value, super.questions, () {
      super.questions = value;
    });
  }

  final _$selectedOptionDataAtom = Atom(name: '_UserState.selectedOptionData');

  @override
  ObservableMap<dynamic, dynamic> get selectedOptionData {
    _$selectedOptionDataAtom.reportRead();
    return super.selectedOptionData;
  }

  @override
  set selectedOptionData(ObservableMap<dynamic, dynamic> value) {
    _$selectedOptionDataAtom.reportWrite(value, super.selectedOptionData, () {
      super.selectedOptionData = value;
    });
  }

  final _$loadQuestionsAsyncAction = AsyncAction('_UserState.loadQuestions');

  @override
  Future<dynamic> loadQuestions(dynamic gender) {
    return _$loadQuestionsAsyncAction.run(() => super.loadQuestions(gender));
  }

  final _$_UserStateActionController = ActionController(name: '_UserState');

  @override
  void updateQuestion(dynamic questionData) {
    final _$actionInfo = _$_UserStateActionController.startAction(
        name: '_UserState.updateQuestion');
    try {
      return super.updateQuestion(questionData);
    } finally {
      _$_UserStateActionController.endAction(_$actionInfo);
    }
  }

  @override
  void updateSelectedOptionData(
      dynamic id, dynamic question, dynamic selectedOptionValue) {
    final _$actionInfo = _$_UserStateActionController.startAction(
        name: '_UserState.updateSelectedOptionData');
    try {
      return super.updateSelectedOptionData(id, question, selectedOptionValue);
    } finally {
      _$_UserStateActionController.endAction(_$actionInfo);
    }
  }

  @override
  bool isActiveStep(dynamic id) {
    final _$actionInfo = _$_UserStateActionController.startAction(
        name: '_UserState.isActiveStep');
    try {
      return super.isActiveStep(id);
    } finally {
      _$_UserStateActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
questionsFuture: ${questionsFuture},
questions: ${questions},
selectedOptionData: ${selectedOptionData},
totalRiskValue: ${totalRiskValue}
    ''';
  }
}
