part of 'redux_ui.dart';

// typedef Observe<S, M extends Model> = dynamic Function(S, M);

class StoreObserver<S, M extends Model> extends StatelessWidget {
  final ViewModel<S, M> viewModel;
  // final Observe<S, M> observe;

  /// {@macro view_model_builder}
  final ViewModelBuilder<M> builder;

    /// {@macro view_model_condition}
  final ViewModelCondition<M> buildWhen;

  /// {@macro on_init_callback}
  final OnInitCallback<S> onInit;

  /// {@macro on_dispose_callback}
  final OnDisposeCallback<S> onDispose;

  /// {@macro rebuild_on_change}
  final bool rebuildOnChange;

  /// {@macro ignore_change_test}
  final IgnoreChangeTest<S> ignoreChange;

  /// {@macro on_will_change_callback}
  final OnWillChangeCallback<M> onWillChange;

  /// {@macro on_did_change_callback}
  final OnDidChangeCallback<M> onDidChange;

  /// {@macro on_initial_build_callback}
  final OnInitialBuildCallback<M> onInitialBuild;

  const StoreObserver({
    Key key,
    @required this.viewModel,
    // @required this.observe,
    @required this.builder,
    this.buildWhen,
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
      buildWhen: buildWhen,
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

// extension x on dynamic {
//   Type get ofType => this.runtimeType;
// }
