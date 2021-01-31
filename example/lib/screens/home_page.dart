import 'package:example/redux/app_state.dart';
import 'package:example/screens/other_page.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';

import 'package:redux_ui/redux_ui.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  _ViewModel viewModel;
  _ViewModel viewModel2;

  @override
  void initState() {
    viewModel = _ViewModel(context.read<Store<AppState>>());
    viewModel2 = _ViewModel(context.readStore<AppState>());

    super.initState();
  }

  @override
  void dispose() {
    viewModel.dispose();
    viewModel2.dispose();

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
            // observe: (model, _) => model.counter,
            builder: (context, model) {
              print("rebuild 1");
              return Text(
                '${model.counter} (VM 1)',
                style: Theme.of(context).textTheme.headline4,
              );
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              RaisedButton(
                child: Text("+"),
                onPressed: viewModel.increment,
              ),
              RaisedButton(
                child: Text("-"),
                onPressed: viewModel.decrement,
              ),
            ],
          ),
          Divider(),
          StoreObserver<AppState, _Model>(
            viewModel: viewModel2,
            // observe: (model, _) => model.counter,
            builder: (context, model) {
              print("rebuild 2");
              return Text(
                '${model.counter} (VM 2)',
                style: Theme.of(context).textTheme.headline4,
              );
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              RaisedButton(
                child: Text("+"),
                onPressed: viewModel2.increment,
              ),
              RaisedButton(
                child: Text("-"),
                onPressed: viewModel2.decrement,
              ),
            ],
          ),
          Divider(),
          RaisedButton(
            child: Text("Go to OtherPage"),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) => OtherPage(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Model extends Model {
  final int counter;

  _Model({
    this.counter = 0,
  });

  @override
  List<Object> get equals => [counter];

  @override
  _Model copyWith({
    int counter,
  }) {
    return _Model(
      counter: counter ?? this.counter,
    );
  }
}

class _ViewModel extends ViewModel<AppState, _Model> {
  _ViewModel(Store<AppState> store)
      : super(
          _Model(),
          store: store,
          supervisor: (state) => state.viewModelStates,
          unique: true,
        );

  void increment() => update(model.copyWith(counter: model.counter + 1));

  void decrement() => update(model.copyWith(counter: model.counter - 1));
}
