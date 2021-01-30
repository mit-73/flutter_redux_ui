import 'package:redux/redux.dart';

import 'package:example/redux/app_reducers.dart';
import 'package:example/redux/app_state.dart';


final Store<AppState> appStore = Store<AppState>(
  combineReducers([
    appReducers,
  ]),
  initialState: AppState(),
);
