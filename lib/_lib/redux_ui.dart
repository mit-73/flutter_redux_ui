import 'package:flutter/foundation.dart'
    show immutable, listEquals, required, nonVirtual, protected, Key;
import 'package:flutter/widgets.dart'
    show hashList, Widget, BuildContext, StatelessWidget;
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

@immutable
class ReduxUI<State> {
  static Reducer<Iterable<ReduxUIStateModel>> createStateModelsReducer() {
    return combineReducers<Iterable<ReduxUIStateModel>>([
      TypedReducer<Iterable<ReduxUIStateModel>, _AddModelAction>(
        (models, action) {
          if (models is Set<ReduxUIStateModel>) {
            return {...models, action.stateModel};
          } else if (models is List<ReduxUIStateModel>) {
            return [...models, action.stateModel];
          } else {
            throw Exception("Type Exception");
          }
        },
      ),
      TypedReducer<Iterable<ReduxUIStateModel>, _UpdateModelAction>(
        (models, action) {
          if (models is Set<ReduxUIStateModel>) {
            return {...models}
              ..removeWhere((model) => model.id == action.stateModel.id)
              ..add(action.stateModel);
          } else if (models is List<ReduxUIStateModel>) {
            return [...models]
              ..removeWhere((model) => model.id == action.stateModel.id)
              ..add(action.stateModel);
          } else {
            throw Exception("Type Exception");
          }
        },
      ),
      TypedReducer<Iterable<ReduxUIStateModel>, _RemoveModelAction>(
        (models, action) {
          if (models is Set<ReduxUIStateModel>) {
            return {...models}
              ..removeWhere((model) => model.id == action.stateModel.id);
          } else if (models is List<ReduxUIStateModel>) {
            return [...models]
              ..removeWhere((model) => model.id == action.stateModel.id);
          } else {
            throw Exception("Type Exception");
          }
        },
      ),
      TypedReducer<Iterable<ReduxUIStateModel>, _ClearModelsAction>(
        (models, action) {
          if (models is Set<ReduxUIStateModel>) {
            return {};
          } else if (models is List<ReduxUIStateModel>) {
            return [];
          } else {
            throw Exception("Type Exception");
          }
        },
      ),
    ]);
  }
}

// -------------------------------------------- //

@immutable
abstract class ReduxUIModel {
  final Iterable<Object> equals;

  ReduxUIModel({this.equals = const []})
      : assert(_onlyContainFieldsOfAllowedTypes(equals));

  static bool _onlyContainFieldsOfAllowedTypes(Iterable<Object> objects) {
    objects.forEach((Object object) {
      if (object is Function) {
        throw Exception(
            "ReduxUIModel equals has an invalid field of type ${object.runtimeType}.");
      }
    });

    return true;
  }

  @override
  int get hashCode => runtimeType.hashCode ^ hashList(equals);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ReduxUIModel &&
        runtimeType == other.runtimeType &&
        listEquals(other.equals, equals);
  }

  @override
  String toString() => "RuntimeType: $runtimeType\nEqual Objects: $equals\n";
}

class ReduxUIViewModel<State, Model extends ReduxUIModel> {
  final ReduxUIStateModel _stateModel;
  final Iterable<ReduxUIStateModel> Function(State) _supervisor;
  final Store<State> store;

  ReduxUIViewModel({
    @required BuildContext context,
    @required ReduxUIModel model,
    @required Iterable<ReduxUIStateModel> Function(State) supervisor,
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

typedef Func0<R> = R Function();

Func0<R> memo0<R>(Func0<R> func) {
  R prevResult;
  bool isInitial = true;

  return (() {
    if (!isInitial) {
      print("cached");
      return prevResult;
    } else {
      print("no cached");
      prevResult = func();
      isInitial = false;

      return prevResult;
    }
  });
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
