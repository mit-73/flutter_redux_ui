import 'package:flutter/material.dart';

import 'package:redux_ui/_lib/redux_ui.dart';
import 'package:redux_ui/main.dart';
import 'package:redux_ui/redux/app_state.dart';

import 'other_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  _ViewModel viewModel;

  @override
  void initState() {
    viewModel = _ViewModel(context);

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
            observe: (model) => model.counter1,
            builder: (context, model) {
              print("rebuild 1");
              return Text(
                '${model.counter1} (1)',
                style: Theme.of(context).textTheme.headline4,
              );
            },
          ),
          StoreObserver<AppState, _Model>(
            viewModel: viewModel,
            observe: (model) => model.counter2,
            builder: (context, model) {
              print("rebuild 2");
              return Text(
                '${model.counter2} (2)',
                style: Theme.of(context).textTheme.headline4,
              );
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              RaisedButton(
                child: Text("+ (1)"),
                onPressed: viewModel.increment1,
              ),
              RaisedButton(
                child: Text("- (1)"),
                onPressed: viewModel.decrement1,
              ),
              RaisedButton(
                child: Text("+ (2)"),
                onPressed: viewModel.increment2,
              ),
              RaisedButton(
                child: Text("- (2)"),
                onPressed: viewModel.decrement2,
              ),
            ],
          ),
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

class _Model extends ReduxUIModel {
  final int counter1;
  final int counter2;

  _Model({
    this.counter1 = 0,
    this.counter2 = 0,
  }) : super(equals: [counter1, counter2]);
}

class _ViewModel extends ReduxUIViewModel<AppState, _Model> {
  _ViewModel(BuildContext context)
      : super(
          context: context,
          model: _Model(),
          supervisor: (state) => state.stateModels,
          unique: false,
        );

  void increment1() => update(_Model(counter1: model.counter1 + 1));

  void decrement1() => update(_Model(counter1: model.counter1 - 1));

  void increment2() => update(_Model(counter2: model.counter2 + 1));

  void decrement2() => update(_Model(counter2: model.counter2 - 1));
}
