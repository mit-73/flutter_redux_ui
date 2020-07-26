import 'package:redux/redux.dart';
import 'package:redux_ui/redux/app_state.dart';
import 'package:redux_ui/redux/app_reducers.dart';

final Store<AppState> appStore = Store<AppState>(
  appReducers,
  initialState: AppState(),
  // middleware: [],
);
