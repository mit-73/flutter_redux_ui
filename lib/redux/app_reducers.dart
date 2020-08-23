import 'package:redux_ui/_lib/redux_ui.dart';
import 'package:redux_ui/redux/app_state.dart';

final stateModelsReducer = ReduxUI.createStateModelsReducer();

AppState appReducers(AppState state, action) {
  return AppState(
    stateModels: stateModelsReducer(state.stateModels, action),
  );
}
