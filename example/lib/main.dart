import 'package:flutter/material.dart';
import 'package:redux_ui/redux_ui.dart';

import 'package:example/redux/app_state.dart';
import 'package:example/redux/app_store.dart';
import 'package:example/screens/home_page.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: appStore,
      child: MaterialApp(
        home: App(),
      ),
    );
  }
}

class App extends StatelessWidget {
  const App({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HomePage();
  }
}
