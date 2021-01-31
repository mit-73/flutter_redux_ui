part of 'redux_ui.dart';

/// {@template view_model_builder}
/// Build a Widget using the [BuildContext] and [ViewModel]. The [ViewModel]
/// is created by the [converter] function.
/// {@endtemplate}
typedef ViewModelBuilder<ViewModel> = Widget Function(
  BuildContext context,
  ViewModel vm,
);

/// {@template view_model_condition}
/// Signature for the `buildWhen` function which takes the previous [ViewModel] and
/// the current [ViewModel] and is responsible for returning a [bool] which
/// determines whether to rebuild Widget with the current [ViewModel].
/// {@endtemplate}
typedef ViewModelCondition<ViewModel> = bool Function(ViewModel previous, ViewModel current);

/// {@template store_converter}
/// Convert the entire [Store] into a [ViewModel]. The [ViewModel] will be used
/// to build a Widget using the [ViewModelBuilder].
/// {@endtemplate}
typedef StoreConverter<S, ViewModel> = ViewModel Function(
  Store<S> store,
);

/// {@template on_init_callback}
/// A function that will be run when the Widget is initialized (using
/// the [State.initState] method). This can be useful for dispatching actions
/// that fetch data for your Widget when it is first displayed.
/// {@endtemplate}
typedef OnInitCallback<S> = void Function(
  Store<S> store,
);

/// {@template on_dispose_callback}
/// A function that will be run when the Widget is removed from the
/// Widget Tree.
///
/// It is run in the [State.dispose] method.
///
/// This can be useful for dispatching actions that remove stale data from
/// your State tree.
/// {@endtemplate}
typedef OnDisposeCallback<S> = void Function(
  Store<S> store,
);

/// {@template ignore_change_test}
/// A test of whether or not your `converter` function should run in response
/// to a State change. For advanced use only.
///
/// Some changes to the State of your application will mean your `converter`
/// function can't produce a useful ViewModel. In these cases, such as when
/// performing exit animations on data that has been removed from your Store,
/// it can be best to ignore the State change while your animation completes.
///
/// To ignore a change, provide a function that returns true or false. If the
/// returned value is true, the change will be ignored.
///
/// If you ignore a change, and the framework needs to rebuild the Widget, the
/// `builder` function will be called with the latest `ViewModel` produced by
/// your `converter` function.
/// {@endtemplate}
typedef IgnoreChangeTest<S> = bool Function(S state);

/// {@template on_will_change_callback}
/// A function that will be run on State change, before the build method.
///
/// This function is passed the `ViewModel`, and if `distinct` is `true`,
/// it will only be called if the `ViewModel` changes.
///
/// This is useful for making calls to other classes, such as a
/// `Navigator` or `TabController`, in response to state changes.
/// It can also be used to trigger an action based on the previous
/// state.
/// {@endtemplate}
typedef OnWillChangeCallback<ViewModel> = void Function(
  ViewModel previousViewModel,
  ViewModel newViewModel,
);

/// {@template on_did_change_callback}
/// A function that will be run on State change, after the build method.
///
/// This function is passed the `ViewModel`, and if `distinct` is `true`,
/// it will only be called if the `ViewModel` changes.
///
/// This can be useful for running certain animations after the build is
/// complete.
///
/// Note: Using a [BuildContext] inside this callback can cause problems if
/// the callback performs navigation. For navigation purposes, please use
/// an [OnWillChangeCallback].
/// {@endtemplate}
typedef OnDidChangeCallback<ViewModel> = void Function(ViewModel viewModel);

/// {@template on_initial_build_callback}
/// A function that will be run after the Widget is built the first time.
///
/// This function is passed the initial `ViewModel` created by the `converter`
/// function.
///
/// This can be useful for starting certain animations, such as showing
/// Snackbars, after the Widget is built the first time.
/// {@endtemplate}
typedef OnInitialBuildCallback<ViewModel> = void Function(ViewModel viewModel);

/// Listens to the [Store] and calls [builder] whenever [store] changes.
class _StoreListener<S, ViewModel> extends StatefulWidget {
  /// {@macro view_model_builder}
  final ViewModelBuilder<ViewModel> builder;

  /// {@macro view_model_condition}
  final ViewModelCondition<ViewModel> buildWhen;

  /// {@macro store_converter}
  final StoreConverter<S, ViewModel> converter;

  final Store<S> store;

  /// {@template rebuild_on_change}
  /// Determines whether the Widget should be rebuilt when the Store emits an
  /// onChange event.
  /// {@endtemplate}
  final bool rebuildOnChange;

  /// {@template distinct}
  /// As a performance optimization, the Widget can be rebuilt only when the
  /// [ViewModel] changes. In order for this to work correctly, you must
  /// implement [==] and [hashCode] for the [ViewModel], and set the [distinct]
  /// option to true when creating your StoreConnector.
  /// {@endtemplate}
  final bool distinct;

  /// {@macro on_init_callback}
  final OnInitCallback<S> onInit;

  /// {@macro on_dispose_callback}
  final OnDisposeCallback<S> onDispose;

  /// {@macro ignore_change_test}
  final IgnoreChangeTest<S> ignoreChange;

  /// {@macro on_will_change_callback}
  final OnWillChangeCallback<ViewModel> onWillChange;

  /// {@macro on_did_change_callback}
  final OnDidChangeCallback<ViewModel> onDidChange;

  /// {@macro on_initial_build_callback}
  final OnInitialBuildCallback<ViewModel> onInitialBuild;

  const _StoreListener({
    Key key,
    @required this.builder,
    @required this.store,
    @required this.converter,
    this.buildWhen,
    this.distinct = false,
    this.onInit,
    this.onDispose,
    this.rebuildOnChange = true,
    this.ignoreChange,
    this.onWillChange,
    this.onDidChange,
    this.onInitialBuild,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _StoreListenerState<S, ViewModel>();
  }
}

class _StoreListenerState<S, ViewModel> extends State<_StoreListener<S, ViewModel>> {
  Stream<ViewModel> _stream;
  S _lastConvertedState;
  ViewModel _latestViewModel;
  ConverterError _latestError;

  @override
  void initState() {
    if (widget.onInit != null) {
      widget.onInit(widget.store);
    }

    _computeLatestValue();

    if (widget.onInitialBuild != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onInitialBuild(_latestViewModel);
      });
    }

    _createStream();

    super.initState();
  }

  @override
  void didUpdateWidget(_StoreListener<S, ViewModel> oldWidget) {
    _computeLatestValue();

    if (widget.store != oldWidget.store) {
      _createStream();
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    if (widget.onDispose != null) {
      widget.onDispose(widget.store);
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.rebuildOnChange
        ? StreamBuilder<ViewModel>(
            stream: _stream,
            builder: (context, snapshot) {
              if (_latestError != null) throw _latestError;

              return widget.builder(
                context,
                _latestViewModel,
              );
            },
          )
        : _latestError != null
            ? throw _latestError
            : widget.builder(context, _latestViewModel);
  }

  void _computeLatestValue() {
    try {
      _latestError = null;
      _latestViewModel = widget.converter(widget.store);
    } catch (e, s) {
      _latestViewModel = null;
      _latestError = ConverterError(e, s);
    }
  }

  void _createStream() {
    _stream = widget.store.onChange
        .where(_stateChanged)
        .where(_ignoreChange)
        .map(_mapConverter)
        .where(_buildWhen)
        // Don't use `Stream.distinct` because it cannot capture the initial
        // ViewModel produced by the `converter`.
        .where(_whereDistinct)
        // After each ViewModel is emitted from the Stream, we update the
        // latestValue. Important: This must be done after all other optional
        // transformations, such as ignoreChange.
        .transform(StreamTransformer.fromHandlers(handleData: _handleData, handleError: _handleError));
  }

  bool _stateChanged(S state) {
    var ifStateChanged = !identical(_lastConvertedState, widget.store.state);
    _lastConvertedState = widget.store.state;
    return ifStateChanged;
  }

  bool _ignoreChange(S state) {
    if (widget.ignoreChange != null) {
      return !widget.ignoreChange(widget.store.state);
    }

    return true;
  }

  ViewModel _mapConverter(S state) {
    return widget.converter(widget.store);
  }

  bool _buildWhen(ViewModel vm) {
    if (widget.buildWhen != null) {
      return widget.buildWhen(_latestViewModel, vm);
    }

    return true;
  }

  bool _whereDistinct(ViewModel vm) {
    if (widget.distinct) {
      return vm != _latestViewModel;
    }

    return true;
  }

  void _handleData(ViewModel vm, EventSink<ViewModel> sink) {
    _latestError = null;

    if (widget.onWillChange != null) {
      widget.onWillChange(_latestViewModel, vm);
    }

    _latestViewModel = vm;

    if (widget.onDidChange != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onDidChange(_latestViewModel);
      });
    }

    sink.add(vm);
  }

  void _handleError(
    Object error,
    StackTrace stackTrace,
    EventSink<ViewModel> sink,
  ) {
    _latestViewModel = null;
    _latestError = ConverterError(error, stackTrace);
    sink.addError(error, stackTrace);
  }
}

/// If the Widget throws an error,
class ConverterError extends Error {
  /// The error thrown while running the [StoreConverter] function
  final Object error;

  /// The stacktrace that accompanies the [error]
  final StackTrace stackTrace;

  /// Creates a ConverterError with the relevant error and stacktrace
  ConverterError(this.error, this.stackTrace);

  @override
  String toString() {
    return '''Converter Function Error: $error
    
$stackTrace;
''';
  }
}
