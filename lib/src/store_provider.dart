part of 'redux_ui.dart';

/// {@template store_provider}
/// Create a [StoreProvider] by passing in the required [store] and [child]
/// parameters.
/// 
/// Provides a Redux [Store] to all descendants of this Widget. This should
/// generally be a root widget in your App. Connect to the Store provided
/// by this Widget using a [StoreConnector] or [StoreBuilder].
/// {@endtemplate}
class StoreProvider<S> extends StatelessWidget {
  /// {@macro store_provider}
  StoreProvider({
    Key key,
    @required Store<S> store,
    @required Widget child,
    bool lazy,
  }) : this._(
          key: key,
          store: store,
          child: child,
          create: (_) => store,
          dispose: (_, store) => store.teardown,
          lazy: lazy,
        );

  /// Internal constructor responsible for creating the [StoreProvider].
  /// Used by the [StoreProvider] default and value constructors.
  StoreProvider._({
    Key key,
    this.child,
    @required Store<S> store,
    Create<Store<S>> create,
    Dispose<Store<S>> dispose,
    this.lazy,
  })  : _create = create,
        _dispose = dispose,
        super(key: key);

  final Widget child;

  /// Whether the [Store] should be created lazily.
  /// Defaults to `true`.
  final bool lazy;

  final Dispose<Store<S>> _dispose;

  final Create<Store<S>> _create;

  /// A method that can be called by descendant Widgets to retrieve the Store
  /// from the StoreProvider.
  ///
  /// Important: When using this method, pass through complete type information
  /// or Flutter will be unable to find the correct StoreProvider!
  ///
  /// {@template store_provider_watch_example}
  ///
  /// ### Example
  ///
  /// ```
  /// class MyWidget extends StatelessWidget {
  ///   @override
  ///   Widget build(BuildContext context) {
  ///     final store = StoreProvider.of<int>(context);
  ///
  ///     return Text('${store.state}');
  ///   }
  /// }
  /// ```
  /// 
  /// {@endtemplate}
  ///
  /// If you need to use the [Store] from the `initState` function, set the
  /// [listen] option to false.
  /// 
  /// {@template store_provider_read_example}
  ///
  /// ### Example
  ///
  /// ```
  /// class MyWidget extends StatefulWidget {
  ///   static GlobalKey<_MyWidgetState> captorKey = GlobalKey<_MyWidgetState>();
  ///
  ///   MyWidget() : super(key: captorKey);
  ///
  ///   _MyWidgetState createState() => _MyWidgetState();
  /// }
  ///
  /// class _MyWidgetState extends State<MyWidget> {
  ///   Store<String> store;
  ///
  ///   @override
  ///   void initState() {
  ///     super.initState();
  ///     store = StoreProvider.of<String>(context, listen: false);
  ///   }
  ///
  ///   @override
  ///  Widget build(BuildContext context) {
  ///     return Container();
  ///   }
  /// }
  /// ```
  /// {@endtemplate}
  static Store<S> of<S>(
    BuildContext context, {
    bool listen = true,
  }) {
    try {
      return Provider.of<Store<S>>(context, listen: listen);
    } on ProviderNotFoundException catch (e) {
      if (e.valueType != S) rethrow;
      throw FlutterError(
        '''Error: No $S found. To fix, please try:
          
  * Wrapping your MaterialApp with the StoreProvider<State>, 
  rather than an individual Route
  * Providing full type information to your Store<State>, 
  StoreProvider<State> and StoreConnector<State, ViewModel>
  * Ensure you are using consistent and complete imports. 
  E.g. always use `import 'package:my_app/app_state.dart';
      ''',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return InheritedProvider<Store<S>>(
      create: _create,
      dispose: _dispose,
      startListening: _startListening,
      child: child,
      lazy: lazy,
    );
  }

  static VoidCallback _startListening(
    InheritedContext<Store> e,
    Store value,
  ) {
    if (value == null) return () {};
    final subscription = value.onChange.listen(
      (Object _) => e.markNeedsNotifyDependents(),
    );
    if (subscription == null) return () {};
    return subscription.cancel;
  }
}

/// Extends the `StoreProvider` class with the ability
/// to perform a lookup based on a `Store` type.
extension StoreProviderExtension on BuildContext {
  /// Performs a lookup using the `BuildContext` to obtain
  /// the nearest ancestor `State` of type [S].
  ///
  /// Calling this method is equivalent to calling:
  ///
  /// ```dart
  /// StoreProvider.of<S>(context)
  /// ```
  /// 
  /// {@macro store_provider_watch_example}
  Store<S> watch<S>() => StoreProvider.of<S>(this);

  /// Performs a lookup using the `BuildContext` to obtain
  /// the nearest ancestor `State` of type [S].
  ///
  /// Calling this method is equivalent to calling:
  ///
  /// ```dart
  /// StoreProvider.of<S>(context, listen: false)
  /// ```
  /// 
  /// {@macro store_provider_read_example}
  Store<S> read<S>() => StoreProvider.of<S>(this, listen: false);
}
