import 'package:flutter/widgets.dart';

import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:redux_ui/redux/app_state.dart';

class BaseViewModel {
  final BuildContext _context;
  final Store<AppState> store;
  BaseViewModel(
    this._context,
  ) : store = StoreProvider.of<AppState>(_context);
}
