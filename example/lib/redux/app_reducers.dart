import 'package:redux/redux.dart';
import 'package:redux_ui/redux_ui.dart';

import 'package:example/redux/app_state.dart';
import 'package:example/redux/action.dart';

AppState appReducers(AppState state, action) {
  return AppState(
    viewModelStates: viewModelsReducer(state.viewModelStates, action),
    counter: counterReducer(state.counter, action),
  );
}

final counterReducer = TypedReducer<int, CounterAction>((models, action) {
  if (action == CounterAction.increment) {
    return models + 1;
  } else {
    return models - 1;
  }
});
