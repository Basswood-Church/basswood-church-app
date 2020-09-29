import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:http/http.dart';

Future<List<BrcDay>> fetchBrcDays(http.Client client) async {
  final Response response =
      await client.get('https://www.basswoodchurch.net/app/brc.json');

  // Use the compute function to run parseBrcDays in a separate isolate
  return compute(parseBrcDays, response.body);
}

// A function that will convert a response body into a List<BrcDay>
List<BrcDay> parseBrcDays(String responseBody) {
  final List<Map<String, dynamic>> parsed = json.decode(responseBody) as List<Map<String, dynamic>>;

  return parsed.map<BrcDay>((Map<String, dynamic> json) =>
      BrcDay.fromJson(json)).toList();
}

class BrcDay {
  BrcDay({this.date, this.passage, this.friendlyPassage});

  factory BrcDay.fromJson(Map<String, dynamic> json) {
    return BrcDay(
        date: DateTime.parse(json['date'].toString()),
        passage: json['passage'] as String,
        friendlyPassage: json['friendlyPassage'] as String);
  }

  final DateTime date;
  final String passage;
  final String friendlyPassage;
}

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
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  void _onItemTapped(int index) {
    if (index == 1) {
      _launchURL('https://www.basswoodchurch.net/sermons/');
    // } else if (index == 2) {
    //   _launchURL('https://www.basswoodchurch.net/give');
    } else if (index == 2) {
      _launchURL('https://www.basswoodchurch.net/bulletin');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Basswood Church'),
      ),
      body: FutureBuilder<List<BrcDay>>(
          future: fetchBrcDays(http.Client()),
          builder: (BuildContext context, AsyncSnapshot<List<BrcDay>> snapshot) {
            if (snapshot.hasError) {
              print(snapshot.error);
            }

            return snapshot.hasData
                ? BrcDaysList(brcDays: snapshot.data)
                : const Center(child: CircularProgressIndicator());
          }),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            title: Text('Reading'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.headset),
            title: Text('Sermons'),
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.card_giftcard),
          //   title: Text('Giving'),
          // ),
          BottomNavigationBarItem(
            icon: Icon(Icons.picture_as_pdf),
            title: Text('Bulletin'),
          ),
        ],
        currentIndex: 0,
        selectedItemColor: Colors.blueGrey,
        onTap: _onItemTapped,
      ),
    );
  }
}

class BrcDaysList extends StatefulWidget {
  const BrcDaysList({Key key, this.brcDays}) : super(key: key);

  final List<BrcDay> brcDays;

  @override
  _BrcDaysListState createState() => _BrcDaysListState(brcDays: brcDays);
}

class _BrcDaysListState extends State<BrcDaysList> {
  _BrcDaysListState({this.brcDays});

  final List<BrcDay> brcDays;
  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();

  @override
  void initState() {
    super.initState();

    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);

    // Get index of current day, or 0 if no match
    final int index = max(brcDays.indexWhere((BrcDay element) => element.date == today), 0);

    Future<void>.delayed(
        const Duration(milliseconds: 0),
        () => itemScrollController.jumpTo(index: index));
  }

  @override
  Widget build(BuildContext context) => ScrollablePositionedList.builder(
        itemCount: brcDays.length,
        itemBuilder: (BuildContext context, int index) =>
            buildBrcDay(context, index),
        itemScrollController: itemScrollController,
        itemPositionsListener: itemPositionsListener,
      );

  Widget buildBrcDay(BuildContext context, int index) {
    return Container(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Icon(
                  (brcDays[index].passage).isEmpty ? Icons.mood : Icons.book),
              title: Text(
                  DateFormat('EEEE, MMMM d, y').format(brcDays[index].date).toString()),
              subtitle: Text(brcDays[index].friendlyPassage),
            ),
            ButtonBar(
              children: <Widget>[
                FlatButton.icon(
                  color: Colors.blueGrey,
                  icon: const Icon(Icons.remove_red_eye),
                  label: const Text('READ'),
                  onPressed: () {
                    Navigator.push(context, ReaderPage(brcDays[index].passage));
                  },
                ),
                FlatButton.icon(
                  color: Colors.blueGrey,
                  icon: const Icon(Icons.headset),
                  label: const Text('LISTEN'),
                  onPressed: () {
                    _launchURL(
                        'http://www.esvapi.org/v2/rest/passageQuery?key=IP&output-format=mp3&passage=' +
                            Uri.encodeComponent(
                                brcDays[index].passage.toString()));
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ReaderPage extends MaterialPageRoute<void> {
  ReaderPage(String passage)
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

Future<void> _launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
