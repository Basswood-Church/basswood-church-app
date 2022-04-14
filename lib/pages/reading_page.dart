import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import '../utils/color_scheme.dart';
import 'package:google_fonts/google_fonts.dart';

class ReadingPage extends MaterialPageRoute<void> {
  ReadingPage(String passage)
      : super(builder: (BuildContext context) {
          return Scaffold(
            appBar: AppBar(
              actions: const <Widget>[],
              iconTheme: const IconThemeData(
                color: GREY3, //change your color here
              ),
              title: Text(
                passage,
                style: GoogleFonts.barlow(
                    color: GREY3, fontSize: 22, fontWeight: FontWeight.w500),
              ),
              backgroundColor: MAIN1,
            ),
            body: WebviewScaffold(
              hidden: true,
              url: 'https://ctk-app.jcb3.de/read.php?q=' +
                  Uri.encodeComponent(passage),
            ),
          );
        });
}
