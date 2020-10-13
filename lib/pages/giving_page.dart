import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class GivingPageWidget extends StatefulWidget{
  @override
  _GivingPageWidgetState createState() => _GivingPageWidgetState();
}

class _GivingPageWidgetState extends State {
    
  @override 
  Widget build(BuildContext context) { 
    return const WebviewScaffold( 
      url: 'https://www.basswoodchurch.net/give', 
      withZoom: true, 
      hidden: true
    ); 
  } 
}