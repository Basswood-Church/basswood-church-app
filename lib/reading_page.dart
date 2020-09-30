import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class ReadingPage extends MaterialPageRoute<void> {
  ReadingPage(String passage)
      : super(builder: (BuildContext context) {
          return Scaffold(
            appBar: AppBar(actions: const <Widget>[], title: Text(passage)),
            body: WebviewScaffold(
              hidden: true,
              url: 'https://basswoodchurch.net/app/read.php?q=' +
                  Uri.encodeComponent(passage),
            ),
          );
        });
}
