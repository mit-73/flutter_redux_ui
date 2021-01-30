part of 'redux_ui.dart';

/// {@template store_connector}
/// Create a [StoreConnector] by passing in the required [converter] and
/// [builder] functions.
///
/// Before the [builder] is run, the [converter] will convert the store into a
/// more specific `ViewModel` tailored to the Widget being built.
///
/// Every time the store changes, the Widget will be rebuilt. As a performance
/// optimization, the Widget can be rebuilt only when the [ViewModel] changes.
/// In order for this to work correctly, you must implement [==] and [hashCode]
/// for the [ViewModel], and set the [distinct] option to true when creating
/// your StoreConnector.
///
/// You can also specify a number of additional parameters that allow you to
/// modify the behavior of the StoreConnector. Please see the documentation
/// for each option for more info.
/// {@endtemplate}
class StoreConnector<S, ViewModel> extends StatelessWidget {
  /// Build a Widget using the [BuildContext] and [ViewModel]. The [ViewModel]
  /// is created by the [converter] function.
  final ViewModelBuilder<ViewModel> builder;

  /// Convert the [Store] into a [ViewModel]. The resulting [ViewModel] will be
  /// passed to the [builder] function.
  final StoreConverter<S, ViewModel> converter;

  /// As a performance optimization, the Widget can be rebuilt only when the
  /// [ViewModel] changes. In order for this to work correctly, you must
  /// implement [==] and [hashCode] for the [ViewModel], and set the [distinct]
  /// option to true when creating your StoreConnector.
  final bool distinct;

  /// A function that will be run when the StoreConnector is initially created.
  /// It is run in the [State.initState] method.
  ///
  /// This can be useful for dispatching actions that fetch data for your Widget
  /// when it is first displayed.
  final OnInitCallback<S> onInit;

  /// A function that will be run when the StoreConnector is removed from the
  /// Widget Tree.
  ///
  /// It is run in the [State.dispose] method.
  ///
  /// This can be useful for dispatching actions that remove stale data from
  /// your State tree.
  final OnDisposeCallback<S> onDispose;

  /// Determines whether the Widget should be rebuilt when the Store emits an
  /// onChange event.
  final bool rebuildOnChange;

  /// A test of whether or not your [converter] function should run in response
  /// to a State change. For advanced use only.
  ///
  /// Some changes to the State of your application will mean your [converter]
  /// function can't produce a useful ViewModel. In these cases, such as when
  /// performing exit animations on data that has been removed from your Store,
  /// it can be best to ignore the State change while your animation completes.
  ///
  /// To ignore a change, provide a function that returns true or false. If the
  /// returned value is true, the change will be ignored.
  ///
  /// If you ignore a change, and the framework needs to rebuild the Widget, the
  /// [builder] function will be called with the latest [ViewModel] produced by
  /// your [converter] function.
  final IgnoreChangeTest<S> ignoreChange;

  /// A function that will be run on State change, before the Widget is built.
  ///
  /// This function is passed the `ViewModel`, and if `distinct` is `true`,
  /// it will only be called if the `ViewModel` changes.
  ///
  /// This can be useful for imperative calls to things like Navigator,
  /// TabController, etc. This can also be useful for triggering actions
  /// based on the previous state.
  final OnWillChangeCallback<ViewModel> onWillChange;

  /// A function that will be run on State change, after the Widget is built.
  ///
  /// This function is passed the `ViewModel`, and if `distinct` is `true`,
  /// it will only be called if the `ViewModel` changes.
  ///
  /// This can be useful for running certain animations after the build is
  /// complete.
  ///
  /// Note: Using a [BuildContext] inside this callback can cause problems if
  /// the callback performs navigation. For navigation purposes, please use
  /// [onWillChange].
  final OnDidChangeCallback<ViewModel> onDidChange;

  /// A function that will be run after the Widget is built the first time.
  ///
  /// This function is passed the initial `ViewModel` created by the [converter]
  /// function.
  ///
  /// This can be useful for starting certain animations, such as showing
  /// Snackbars, after the Widget is built the first time.
  final OnInitialBuildCallback<ViewModel> onInitialBuild;

  /// {@macro store_connector}
  const StoreConnector({
    Key key,
    @required this.builder,
    @required this.converter,
    this.distinct = false,
    this.onInit,
    this.onDispose,
    this.rebuildOnChange = true,
    this.ignoreChange,
    this.onWillChange,
    this.onDidChange,
    this.onInitialBuild,
  })  : assert(builder != null),
        assert(converter != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return _StoreStreamListener<S, ViewModel>(
      store: context.watch<S>(),
      builder: builder,
      converter: converter,
      distinct: distinct,
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
