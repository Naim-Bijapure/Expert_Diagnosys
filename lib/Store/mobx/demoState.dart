import 'package:mobx/mobx.dart';

// Include generated file
part 'demoState.g.dart';

// This is the class used by rest of your codebase
class MyState = _MyState with _$MyState;

// The store-class
abstract class _MyState with Store {
  @observable
  int value = 0;

  @action
  void increment() {
    value++;
  }
}
