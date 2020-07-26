import 'package:redux_ui/reducers/counter_reducer.dart';
import 'package:redux_ui/redux/app_state.dart';

AppState appReducers(AppState state, action) {
  return AppState(
    counter: counterReducer(state.counter, action),
  );
}
