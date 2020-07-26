import 'package:redux_ui/_lib/redux_ui.dart';
import 'package:redux_ui/redux/app_state.dart';

class CounterIncrementAction extends ReduxUIAction<AppState> {
  @override
  AppState reduce() {
    print("reduce: ${state.counter}");
    return state.copyWith(counter: state.counter + 1);
  }

  @override
  void before() {
    print("before: ${state.counter}");
    super.before();
  }

  @override
  void after() {
    print("after: ${state.counter}");
    super.after();
  }
}

class CounterDecrementAction extends ReduxUIAction<AppState> {
  @override
  AppState reduce() {
    print("reduce: ${state.counter}");
    return state.copyWith(counter: state.counter - 1);
  }

  @override
  void before() {
    print("before: ${state.counter}");
    super.before();
  }

  @override
  void after() {
    print("after: ${state.counter}");
    super.after();
  }
}
