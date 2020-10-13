import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class BulletinPageWidget extends StatefulWidget{
  @override
  _BulletinPageWidgetState createState() => _BulletinPageWidgetState();
}

class _BulletinPageWidgetState extends State {
    
  @override 
  Widget build(BuildContext context) { 
    return const WebviewScaffold( 
      url: 'https://www.basswoodchurch.net/bulletin', 
      withZoom: true, 
      hidden: true
    ); 
  } 
}