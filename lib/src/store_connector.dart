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
  /// {@macro view_model_builder}
  final ViewModelBuilder<ViewModel> builder;

  /// {@macro store_converter}
  final StoreConverter<S, ViewModel> converter;

  /// {@macro view_model_condition}
  final ViewModelCondition<ViewModel> buildWhen;

  /// {@macro distinct}
  final bool distinct;

  /// {@macro on_init_callback}
  final OnInitCallback<S> onInit;

  /// {@macro on_dispose_callback}
  final OnDisposeCallback<S> onDispose;

  /// {@macro rebuild_on_change}
  final bool rebuildOnChange;

  /// {@macro ignore_change_test}
  final IgnoreChangeTest<S> ignoreChange;

  /// {@macro on_will_change_callback}
  final OnWillChangeCallback<ViewModel> onWillChange;

  /// {@macro on_did_change_callback}
  final OnDidChangeCallback<ViewModel> onDidChange;

  /// {@macro on_initial_build_callback}
  final OnInitialBuildCallback<ViewModel> onInitialBuild;

  /// {@macro store_connector}
  const StoreConnector({
    Key key,
    @required this.builder,
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
  })  : assert(builder != null),
        assert(converter != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return _StoreListener<S, ViewModel>(
      store: context.readStore<S>(),
      builder: builder,
      buildWhen: buildWhen,
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
