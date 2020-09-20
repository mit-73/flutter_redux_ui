import 'package:redux_ui/_lib/redux_ui.dart';

class AppState {
  final ReduxUIStateModel stateModels;

  AppState({
    this.stateModels,
  });

  @override
  String toString() => 'AppState(stateModels: $stateModels)';
}
