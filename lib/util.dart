import 'package:url_launcher/url_launcher.dart';

Future<void> launchURL(String url, bool forceWebView) async {
  if (await canLaunch(url)) {
    launch(url, forceSafariVC: forceWebView, forceWebView: forceWebView);
  } else {
    throw 'Could not launch $url';
  }
}
