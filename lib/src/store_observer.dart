part of 'redux_ui.dart';

// typedef Observe<S, M extends Model> = dynamic Function(S, M);

class StoreObserver<S, M extends Model> extends StatelessWidget {
  final ViewModel<S, M> viewModel;
  // final Observe<S, M> observe;
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
    // @required this.observe,
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
      converter: (store) => viewModel.model, // observe(store.state, viewModel.model)
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

extension x on dynamic {
  Type get ofType => this.runtimeType;
}
