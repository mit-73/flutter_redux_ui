import 'package:example/redux/action.dart';
import 'package:example/redux/app_state.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';

import 'package:redux_ui/redux_ui.dart';

class OtherPage extends StatefulWidget {
  const OtherPage({Key key}) : super(key: key);

  @override
  _OtherPageState createState() => _OtherPageState();
}

class _OtherPageState extends State<OtherPage> {
  _ViewModel viewModel;

  @override
  void initState() {
    viewModel = _ViewModel(context.read<AppState>());

    super.initState();
  }

  @override
  void dispose() {
    viewModel.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          StoreObserver<AppState, _Model>(
            viewModel: viewModel,
            observe: (model) => model.counter,
            builder: (context, model) {
              return Text(
                '${model.counter} (local)',
                style: Theme.of(context).textTheme.headline4,
              );
            },
          ),
          StoreObserver<AppState, _Model>(
            viewModel: viewModel,
            observe: (model) => model.counterStore,
            builder: (context, model) {
              return Text(
                '${model.counterStore} (store)',
                style: Theme.of(context).textTheme.headline4,
              );
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              RaisedButton(
                child: Text("+ (local)"),
                onPressed: viewModel.increment,
              ),
              RaisedButton(
                child: Text("- (local)"),
                onPressed: viewModel.decrement,
              ),
              RaisedButton(
                child: Text("+ (store)"),
                onPressed: viewModel.incrementStore,
              ),
              RaisedButton(
                child: Text("- (store)"),
                onPressed: viewModel.decrementStore,
              ),
            ],
          ),
          RaisedButton(
            child: Text("Go to Back"),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}

class _Model extends Model {
  final int counter;
  final int counterStore; // TODO update problem

  _Model({
    this.counter = 0,
    this.counterStore,
  });

  @override
  List<Object> get equals => [counter, counterStore];

  @override
  _Model copyWith({
    int counter,
    int counterStore,
  }) {
    return _Model(
      counter: counter ?? this.counter,
      counterStore: counterStore ?? this.counterStore,
    );
  }
}

class _ViewModel extends ViewModel<AppState, _Model> {
  final Store<AppState> store;
  _ViewModel(this.store)
      : super(
          store: store,
          model: _Model(counterStore: store.state.counter),
          supervisor: (state) => state.viewModelStates,
          unique: true,
        );

  void increment() => update(model.copyWith(counter: model.counter + 1));

  void decrement() => update(model.copyWith(counter: model.counter - 1));

  void incrementStore() => store.dispatch(CounterAction.increment);

  void decrementStore() => store.dispatch(CounterAction.decrement);
}
