part of 'redux_ui.dart';

class ViewModelLifecycle<VM extends ViewModel> extends StatefulWidget {
  ViewModelLifecycle({
    Key key,
    @required Create<VM> create,
    @required Dispose<VM> dispose,
    @required ViewModelBuilder<VM> builder,
    bool lazy,
  }) : this._(
          key: key,
          builder: builder,
          create: create,
          dispose: dispose,
        );

  ViewModelLifecycle.value({
    Key key,
    @required VM value,
    @required ViewModelBuilder<VM> builder,
  }) : this._(
          key: key,
          create: (_) => value,
          dispose: (_, vm) => vm.dispose(),
          builder: builder,
        );

  ViewModelLifecycle._({
    Key key,
    this.builder,
    Create<VM> create,
    Dispose<VM> dispose,
  })  : _create = create,
        _dispose = dispose,
        super(key: key);

  final ViewModelBuilder<VM> builder;
  final Dispose<VM> _dispose;
  final Create<VM> _create;

  @override
  _ViewModelLifecycleState<VM> createState() => _ViewModelLifecycleState<VM>();
}

class _ViewModelLifecycleState<VM extends ViewModel> extends State<ViewModelLifecycle<VM>> {
  VM vm;

  @override
  void didChangeDependencies() {
    if (vm == null) {
      vm = widget._create(context);
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    widget._dispose(context, vm);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, vm);
  }
}
