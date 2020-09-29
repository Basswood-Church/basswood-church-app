import 'package:flutter/material.dart';

import 'home_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: Theme.of(context).copyWith(
          accentIconTheme:
          Theme.of(context).accentIconTheme.copyWith(color: Colors.white),
          accentColor: Colors.blueAccent,
          primaryColor: Colors.blueGrey,
          primaryIconTheme:
          Theme.of(context).primaryIconTheme.copyWith(color: Colors.white),
          primaryTextTheme: Theme.of(context)
              .primaryTextTheme
              .apply(bodyColor: Colors.white)),
      home: const HomePage(),
    );
  }
}
