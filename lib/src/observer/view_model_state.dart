part of 'observer.dart';

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
