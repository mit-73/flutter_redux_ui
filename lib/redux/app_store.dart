import 'package:redux/redux.dart';

import 'package:redux_ui/redux/app_reducers.dart';
import 'package:redux_ui/redux/app_state.dart';

final Store<AppState> appStore = Store<AppState>(
  combineReducers([
    appReducers,
  ]),
  initialState: AppState(),
);
