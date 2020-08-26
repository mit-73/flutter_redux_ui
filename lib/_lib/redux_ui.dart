import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

@immutable
class ReduxUI<State> {
  static Reducer<List<ReduxUIStateModel>> createStateModelsReducer() {
    return combineReducers<List<ReduxUIStateModel>>([
      TypedReducer<List<ReduxUIStateModel>, _AddModelAction>(
        (models, action) => [...models, action.stateModel],
      ),
      TypedReducer<List<ReduxUIStateModel>, _UpdateModelAction>(
        (models, action) {
          return [...models]
            ..removeWhere((model) => model.id == action.stateModel.id)
            ..add(action.stateModel);
        },
      ),
      TypedReducer<List<ReduxUIStateModel>, _RemoveModelAction>(
        (models, action) => [...models]
          ..removeWhere((model) => model.id == action.stateModel.id),
      ),
      TypedReducer<List<ReduxUIStateModel>, _ClearModelsAction>(
        (models, action) => [],
      ),
    ]);
  }
}

// -------------------------------------------- //

@immutable
abstract class ReduxUIModel {}

@immutable
class ReduxUIViewModel<State, Model extends ReduxUIModel> {
  final List<ReduxUIStateModel> Function(State) _supervisor;
  final ReduxUIStateModel _stateModel;
  final Store<State> store;

  ReduxUIViewModel({
    @required BuildContext context,
    @required ReduxUIModel model,
    @required List<ReduxUIStateModel> Function(State) supervisor,
  })  : assert(context != null),
        assert(model != null),
        assert(supervisor != null),
        _supervisor = supervisor,
        _stateModel = ReduxUIStateModel(id: model.hashCode, model: model),
        store = StoreProvider.of<State>(context, listen: false) {
    _init();
  }

  @nonVirtual
  Model get model {
    return _supervisor(store.state)
        .firstWhere((m) => m.id == _stateModel.id, orElse: () => null)
        .model;
  }

  void _init() {
    store.dispatch(_AddModelAction(_stateModel));
  }

  @nonVirtual
  void dispose() {
    store.dispatch(_RemoveModelAction(_stateModel));
  }

  @protected
  @nonVirtual
  void update(Model model) {
    store.dispatch(_UpdateModelAction(_stateModel.copyWith(model: model)));
  }
}

// -------------------------------------------- //

@immutable
class ReduxUIStateModel {
  final int id;
  final ReduxUIModel model;

  ReduxUIStateModel({
    this.id,
    this.model,
  });

  ReduxUIStateModel copyWith({
    int id,
    ReduxUIModel model,
  }) {
    return ReduxUIStateModel(
      id: id ?? this.id,
      model: model ?? this.model,
    );
  }

  @override
  String toString() => 'ReduxUIStateModel(id: $id, model: $model)';
}

class _AddModelAction {
  final ReduxUIStateModel stateModel;

  _AddModelAction(this.stateModel);
}

class _UpdateModelAction {
  final ReduxUIStateModel stateModel;

  _UpdateModelAction(this.stateModel);
}

class _RemoveModelAction {
  final ReduxUIStateModel stateModel;

  _RemoveModelAction(this.stateModel);
}

class _ClearModelsAction {}

// -------------------------------------------- //

class StoreObserver<State, Model extends ReduxUIModel> extends StatelessWidget {
  final ReduxUIViewModel<State, Model> viewModel;
  final ViewModelBuilder<Model> builder;
  final OnInitCallback<State> onInit;
  final OnDisposeCallback<State> onDispose;
  final bool rebuildOnChange;
  final IgnoreChangeTest<State> ignoreChange;
  final OnWillChangeCallback<Model> onWillChange;
  final OnDidChangeCallback<Model> onDidChange;
  final OnInitialBuildCallback<Model> onInitialBuild;

  const StoreObserver({
    Key key,
    @required this.viewModel,
    @required this.builder,
    this.onInit,
    this.onDispose,
    this.rebuildOnChange = true,
    this.ignoreChange,
    this.onWillChange,
    this.onDidChange,
    this.onInitialBuild,
  })  : assert(builder != null),
        assert(viewModel != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<State, Model>(
      builder: builder,
      converter: (_) => viewModel.model,
      distinct: true,
      onInit: onInit,
      onDispose: onDispose,
      rebuildOnChange: rebuildOnChange,
      ignoreChange: ignoreChange,
      onWillChange: onWillChange,
      onDidChange: onDidChange,
      onInitialBuild: onInitialBuild,
    );
  }
}
