import 'package:flutter/material.dart';

import 'package:redux_ui/_lib/redux_ui.dart';
import 'package:redux_ui/redux/app_state.dart';

import 'home_page.dart';

class OtherPage extends StatefulWidget {
  const OtherPage({Key key}) : super(key: key);

  @override
  _OtherPageState createState() => _OtherPageState();
}

class _OtherPageState extends State<OtherPage> {
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
          RaisedButton(
            child: Text("Go to HomePage"),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) => HomePage(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Model extends ReduxUIModel {
  final int counter;

  _Model({
    this.counter = 222,
  }) : super(equals: [counter]);
}

class _ViewModel extends ReduxUIViewModel<AppState, _Model> {
  _ViewModel(BuildContext context)
      : super(
          context: context,
          model: _Model(),
          supervisor: (state) => state.stateModels,
          unique: false,
        );

  void increment() => update(_Model(counter: model.counter + 1));

  void decrement() => update(_Model(counter: model.counter - 1));
}
