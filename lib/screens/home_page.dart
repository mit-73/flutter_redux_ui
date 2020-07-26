import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux_ui/actions/counter_actions.dart';
import 'package:redux_ui/redux/app_state.dart';
import 'package:redux_ui/redux/base_view_model.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      distinct: true,
      converter: (store) => _ViewModel(context),
      builder: (context, vm) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              '${vm.counter}',
              style: Theme.of(context).textTheme.headline4,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                RaisedButton(
                  child: Text("+"),
                  onPressed: vm.increment,
                ),
                RaisedButton(
                  child: Text("-"),
                  onPressed: vm.decrement,
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _ViewModel extends BaseViewModel {
  _ViewModel(BuildContext context) : super(context);

  int get counter => store.state.counter;

  void increment() => store.dispatch(CounterIncrementAction());

  void decrement() => store.dispatch(CounterDecrementAction());

  @override
  int get hashCode => store.state.counter;

  @override
  bool operator ==(Object other) =>
      identical(other, this) &&
      other is _ViewModel &&
      other.counter == counter &&
      other.runtimeType == runtimeType;
}
