import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModel = _ViewModel(context);
    });

    super.initState();
  }

  @override
  void dispose() {
    viewModel.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _Model>(
      distinct: true,
      converter: (store) => viewModel.model,
      builder: (context, model) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              '${model.counter}',
              style: Theme.of(context).textTheme.headline4,
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
      },
    );
  }
}

class _Model extends ReduxUIModel {
  final int counter;

  _Model({
    this.counter = 0,
  });

  _Model copyWith({
    int counter,
  }) {
    return _Model(
      counter: counter ?? this.counter,
    );
  }

  @override
  String toString() => '_Model(counter: $counter)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is _Model && o.counter == counter;
  }

  @override
  int get hashCode => counter.hashCode;
}

class _ViewModel extends ReduxUIViewModel<AppState, _Model> {
  _ViewModel(BuildContext context)
      : super(
          context: context,
          model: _Model(),
          supervisor: (state) => state.stateModels,
        );

  void increment() => update(model.copyWith(counter: model.counter + 1));

  void decrement() => update(model.copyWith(counter: model.counter - 1));
}
