import 'package:redux/redux.dart';

class ReduxUI<S> {
  static Middleware<S> createMiddleware<S>() => _createCompactMiddleware();

  static Reducer<S> createReducer<S>() => _ReduxUIReducer<S>().createReducer();
}

abstract class ReduxUIAction<S> {
  Store<S> _store;

  Store<S> get store => _store;

  S get state => _store.state;

  /// The action reducer
  S reduce();

  /// Runs before `reduce()`.
  void before() {}

  /// Runs after `reduce()`.
  void after() {}

  void _setStore(Store store) => _store = (store as Store<S>);
}

class _ReduxUIReducer<S> {
  Reducer<S> createReducer() => combineReducers<S>([
        TypedReducer<S, ReduxUIAction>(_handleAction),
      ]);

  S _handleAction(S state, ReduxUIAction action) => action.reduce();
}

Middleware<S> _createCompactMiddleware<S>() {
  return (Store<S> store, dynamic action, NextDispatcher next) async {
    if (action is ReduxUIAction) {
      action._setStore(store);

      action.before();

      next(action);

      action.after();
    } else {
      next(action);
    }
  };
}
