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

  /// Builds a Widget using the [BuildContext] and your [Store].
  final ViewModelBuilder<Store<S>> builder;

  /// Indicates whether or not the Widget should rebuild when the [Store] emits
  /// an `onChange` event.
  final bool rebuildOnChange;

  /// A function that will be run when the StoreConnector is initially created.
  /// It is run in the [State.initState] method.
  ///
  /// This can be useful for dispatching actions that fetch data for your Widget
  /// when it is first displayed.
  final OnInitCallback<S> onInit;

  /// A function that will be run when the StoreBuilder is removed from the
  /// Widget Tree.
  ///
  /// It is run in the [State.dispose] method.
  ///
  /// This can be useful for dispatching actions that remove stale data from
  /// your State tree.
  final OnDisposeCallback<S> onDispose;

  /// A function that will be run on State change, before the Widget is built.
  ///
  /// This can be useful for imperative calls to things like Navigator,
  /// TabController, etc. This can also be useful for triggering actions
  /// based on the previous state.
  final OnWillChangeCallback<Store<S>> onWillChange;

  /// A function that will be run on State change, after the Widget is built.
  ///
  /// This can be useful for running certain animations after the build is
  /// complete
  ///
  /// Note: Using a [BuildContext] inside this callback can cause problems if
  /// the callback performs navigation. For navigation purposes, please use
  /// [onWillChange].
  final OnDidChangeCallback<Store<S>> onDidChange;

  /// A function that will be run after the Widget is built the first time.
  ///
  /// This can be useful for starting certain animations, such as showing
  /// Snackbars, after the Widget is built the first time.
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
