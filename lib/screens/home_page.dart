import 'package:flutter/material.dart';

import 'package:redux_ui/_lib/redux_ui.dart';
import 'package:redux_ui/redux/app_state.dart';

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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        StoreObserver(
          viewModel: viewModel,
          builder: (BuildContext context, _Model model) => Text(
            '${model.counter}',
            style: Theme.of(context).textTheme.headline4,
          ),
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
      ],
    );
  }
}

class _Model extends ReduxUIModel {
  final int counter;
  final int counter2;

  _Model({
    this.counter = 0,
    this.counter2,
  }) : super(equals: [counter, counter2]);
}

class _ViewModel extends ReduxUIViewModel<AppState, _Model> {
  _ViewModel(BuildContext context)
      : super(
          context: context,
          model: _Model(),
          supervisor: (state) => state.stateModels,
        );

  void increment() => update(_Model(counter: model.counter + 1));

  void decrement() => update(_Model(counter: model.counter - 1));
}
