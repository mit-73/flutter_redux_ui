import 'package:redux_ui/_lib/redux_ui.dart';

class AppState {
  final List<ReduxUIStateModel> stateModels;

  AppState({
    this.stateModels = const <ReduxUIStateModel>[],
  });

  @override
  String toString() => 'AppState(stateModels: $stateModels)';
}
