import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class SermonsPageWidget extends StatefulWidget{
  @override
  _SermonsPageWidgetState createState() => _SermonsPageWidgetState();
}

class _SermonsPageWidgetState extends State {
    
  @override 
  Widget build(BuildContext context) { 
    return const WebviewScaffold( 
      url: 'https://www.basswoodchurch.net/sermons', 
      withZoom: true, 
      hidden: true
    ); 
  } 
}