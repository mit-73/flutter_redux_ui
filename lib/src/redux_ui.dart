import 'dart:collection';

import 'package:flutter/foundation.dart' show immutable, required, nonVirtual, protected, Key;
import 'package:flutter/widgets.dart' show Widget, BuildContext, StatelessWidget;

import 'package:redux/redux.dart';
import 'package:redux_ui/src/comparer.dart';
import 'package:redux_ui/src/store.dart';

final viewModelsReducer = _createViewModelsReducer();
Reducer<ViewModelStates> _createViewModelsReducer() {
  return combineReducers<ViewModelStates>([
    TypedReducer<ViewModelStates, _AddModelAction>(
      (models, action) {
        return ViewModelStates(models ?? {})..addAll({action.id: action.stateModel});
      },
    ),
    TypedReducer<ViewModelStates, _UpdateModelAction>(
      (models, action) {
        return ViewModelStates(models ?? {})..update(action.id, (v) => action.stateModel);
      },
    ),
    TypedReducer<ViewModelStates, _RemoveModelAction>(
      (models, action) {
        return ViewModelStates(models ?? {})..remove(action.stateModel);
      },
    ),
    TypedReducer<ViewModelStates, _ClearModelsAction>(
      (models, action) {
        return ViewModelStates(models)..clear();
      },
    ),
  ]);
}

// -------------------------------------------- //

@immutable
abstract class Model extends ComparerList {
  Model copyWith();

  @override
  List<Object> get equals => [];
}

typedef _Supervisor<State> = ViewModelStates Function(State);

class ViewModel<S, M extends Model> {
  final int _id;
  final Model _model;
  final _Supervisor<S> _supervisor;
  final Store<S> _store;

  ViewModel({
    @required Store<S> store,
    @required Model model,
    @required _Supervisor<S> supervisor,
    bool unique = true,
  })  : assert(store != null),
        assert(model != null),
        assert(supervisor != null),
        _store = store,
        _model = model,
        _id = unique ? model.hashCode : model.hashCode ^ DateTime.now().millisecondsSinceEpoch,
        _supervisor = supervisor {
    _init();
  }

  @nonVirtual
  M get model {
    return _supervisor(_store.state)[_id];
  }

  void _init() {
    _store.dispatch(_AddModelAction(_id, _model));
  }

  @nonVirtual
  void dispose() {
    _store.dispatch(_RemoveModelAction(_id, _model));
  }

  @protected
  @nonVirtual
  void update(M model) {
    _store.dispatch(_UpdateModelAction(_id, model));
  }
}

// -------------------------------------------- //

@immutable
class ViewModelStates with MapMixin<int, Model> implements MapView<int, Model> {
  final Map<int, Model> _map;

  const ViewModelStates(Map<int, Model> map) : _map = map;

  factory ViewModelStates.from(Map other) => ViewModelStates(Map.from(other));

  factory ViewModelStates.empty() => ViewModelStates({});

  @override
  Model operator [](Object key) => _map[key];

  @override
  void operator []=(int key, Model value) => _map[key] = value;

  @override
  void clear() => _map.clear();

  @override
  Iterable<int> get keys => _map.keys;

  @override
  Model remove(Object key) => _map.remove(key);

  @override
  String toString() {
    return _map.toString();
  }
}

@immutable
class _AddModelAction {
  final int id;
  final Model stateModel;

  _AddModelAction(this.id, this.stateModel);
}

@immutable
class _UpdateModelAction {
  final int id;
  final Model stateModel;

  _UpdateModelAction(this.id, this.stateModel);
}

@immutable
class _RemoveModelAction {
  final int id;
  final Model stateModel;

  _RemoveModelAction(this.id, this.stateModel);
}

@immutable
class _ClearModelsAction {}

// -------------------------------------------- //

typedef _Observe<M extends Model> = dynamic Function(M);

@immutable
class StoreObserver<S, M extends Model> extends StatelessWidget {
  final ViewModel<S, M> viewModel;
  final _Observe<M> observe;
  final ViewModelBuilder<M> builder;
  final OnInitCallback<S> onInit;
  final OnDisposeCallback<S> onDispose;
  final bool rebuildOnChange;
  final IgnoreChangeTest<S> ignoreChange;
  final OnWillChangeCallback<M> onWillChange;
  final OnDidChangeCallback<M> onDidChange;
  final OnInitialBuildCallback<M> onInitialBuild;

  const StoreObserver({
    Key key,
    @required this.viewModel,
    @required this.observe,
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
    return StoreConnector<S, M>(
      builder: builder,
      converter: (_) => viewModel.model, // TODO use observe
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
