import 'package:redux_ui/redux_ui.dart';

class AppState {
  final ViewModelStates viewModelStates;
  final int counter;

  AppState({
    this.viewModelStates,
    this.counter = 0,
  });

  @override
  String toString() => 'AppState(viewModelStates: $viewModelStates)';
}
