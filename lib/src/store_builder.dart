part of 'redux_ui.dart';

/// {@template store_builder}
/// Build a Widget by passing the [Store] directly to the build function.
///
/// Generally, it's considered best practice to use the [StoreConnector] and to
/// build a `ViewModel` specifically for your Widget rather than passing through
/// the entire [Store], but this is provided for convenience when that isn't
/// necessary.
/// {@endtemplate}
class StoreBuilder<S> extends StatelessWidget {
  static Store<S> _identity<S>(Store<S> store) => store;

  /// {@macro view_model_builder}
  final ViewModelBuilder<Store<S>> builder;

  /// {@macro on_init_callback}
  final OnInitCallback<S> onInit;

  /// {@macro on_dispose_callback}
  final OnDisposeCallback<S> onDispose;

  /// {@macro rebuild_on_change}
  final bool rebuildOnChange;

  /// {@macro on_will_change_callback}
  final OnWillChangeCallback<Store<S>> onWillChange;

  /// {@macro on_did_change_callback}
  final OnDidChangeCallback<Store<S>> onDidChange;

  /// {@macro on_initial_build_callback}
  final OnInitialBuildCallback<Store<S>> onInitialBuild;

  /// {@macro store_builder}
  const StoreBuilder({
    Key key,
    @required this.builder,
    this.onInit,
    this.onDispose,
    this.rebuildOnChange = true,
    this.onWillChange,
    this.onDidChange,
    this.onInitialBuild,
  })  : assert(builder != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<S, Store<S>>(
      builder: builder,
      converter: _identity,
      rebuildOnChange: rebuildOnChange,
      onInit: onInit,
      onDispose: onDispose,
      onWillChange: onWillChange,
      onDidChange: onDidChange,
      onInitialBuild: onInitialBuild,
    );
  }
}
