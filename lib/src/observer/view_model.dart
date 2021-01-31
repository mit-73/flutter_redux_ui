part of 'observer.dart';

typedef Supervisor<State> = ViewModelStates Function(State);

mixin ViewModelMixin<S, M extends Model> on ViewModel<S, M> {}

class ViewModel<S, M extends Model> {
  final int _id;
  final Model _model;
  final Supervisor<S> _supervisor;
  final Store<S> _store;

  ViewModel(
    Model model, {
    @required Store<S> store,
    @required Supervisor<S> supervisor,
    bool unique = false,
  })  : assert(store != null),
        assert(model != null),
        assert(supervisor != null),
        _store = store,
        _model = model,
        _id = unique ? model.hashCode ^ fastRand : model.hashCode,
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
