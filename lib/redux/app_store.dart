import 'package:redux/redux.dart';
import 'package:redux_ui/_lib/redux_ui.dart';
import 'package:redux_ui/redux/app_reducers.dart';
import 'package:redux_ui/redux/app_state.dart';

final reduxUIReducer = ReduxUI.createReducer<AppState>();
final reduxUIMiddleware = ReduxUI.createMiddleware<AppState>();

final Store<AppState> appStore = Store<AppState>(
  // reduxUIReducer,
  combineReducers([
    reduxUIReducer,
    // appReducers,
  ]),
  initialState: AppState(),
  middleware: [reduxUIMiddleware],
);
