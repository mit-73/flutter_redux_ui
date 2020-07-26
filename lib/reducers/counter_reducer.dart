import 'package:redux/redux.dart';
import 'package:redux_ui/actions/counter_actions.dart';

final Reducer<int> counterReducer = combineReducers([
  TypedReducer<int, CounterIncrementAction>(_increment),
  TypedReducer<int, CounterDecrementAction>(_decrement),
]);

int _increment(int counter, CounterIncrementAction action) {
  print("_increment: $counter");
  return ++counter;
}

int _decrement(int counter, CounterDecrementAction action) {
  print("_decrement: $counter");
  return --counter;
}
