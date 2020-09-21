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

Future<List<BrcDay>> fetchBrcDays(http.Client client) async {
  final response =
      await client.get('https://www.basswoodchurch.net/app/brc.json');

  // Use the compute function to run parseBrcDays in a separate isolate
  return compute(parseBrcDays, response.body);
}

// A function that will convert a response body into a List<BrcDay>
List<BrcDay> parseBrcDays(String responseBody) {
  final parsed = json.decode(responseBody);

  return parsed.map<BrcDay>((json) => new BrcDay.fromJson(json)).toList();
}

class BrcDay {
  final DateTime date;
  final String passage;
  final String friendlyPassage;

  BrcDay({this.date, this.passage, this.friendlyPassage});

  factory BrcDay.fromJson(Map<String, dynamic> json) {
    return new BrcDay(
        date: (DateTime.parse(json['date'].toString())),
        passage: json['passage'] as String,
        friendlyPassage: json['friendlyPassage'] as String);
  }
}

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
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
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;
  MyHomePage({Key key, this.title}) : super(key: key);

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
    return new Scaffold(
      appBar: AppBar(
        title: const Text('Basswood Church'),
      ),
      body: new FutureBuilder<List<BrcDay>>(
          future: fetchBrcDays(new http.Client()),
          builder: (context, snapshot) {
            if (snapshot.hasError) print(snapshot.error);

            return snapshot.hasData
                ? new BrcDaysList(brcDays: snapshot.data)
                : new Center(child: new CircularProgressIndicator());
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
  final List<BrcDay> brcDays;

  BrcDaysList({Key key, this.brcDays}) : super(key: key);

  @override
  _BrcDaysListState createState() => _BrcDaysListState(brcDays: this.brcDays);
}

class _BrcDaysListState extends State<BrcDaysList> {
  final List<BrcDay> brcDays;
  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();

  _BrcDaysListState({this.brcDays});

  @override
  void initState() {
    super.initState();

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // Get index of current day, or 0 if no match
    final index =
        max(this.brcDays.indexWhere((element) => element.date == today), 0);

    // Need to delay some until list state is initialized, else scroll breaks
    Future.delayed(
        Duration(milliseconds: 0),
        () => this
            .itemScrollController
            .scrollTo(index: index, duration: Duration(seconds: 2)));
  }

  @override
  Widget build(BuildContext context) => new ScrollablePositionedList.builder(
        itemCount: this.brcDays.length,
        itemBuilder: (BuildContext context, int index) =>
            buildBrcDay(context, index),
        itemScrollController: this.itemScrollController,
        itemPositionsListener: this.itemPositionsListener,
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
                  "${DateFormat('EEEE, MMMM d, y').format(brcDays[index].date).toString()}"),
              subtitle: Text(brcDays[index].friendlyPassage),
            ),
            ButtonBar(
              children: <Widget>[
                FlatButton.icon(
                  color: Colors.blueGrey,
                  icon: Icon(Icons.remove_red_eye),
                  label: const Text('READ'),
                  onPressed: () {
                    Navigator.push(context, ReaderPage(brcDays[index].passage));
                  },
                ),
                FlatButton.icon(
                  color: Colors.blueGrey,
                  icon: Icon(Icons.headset),
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

class ReaderPage extends MaterialPageRoute<Null> {
  ReaderPage(String passage)
      : super(builder: (BuildContext context) {
          return Scaffold(
            appBar: AppBar(actions: [], title: Text(passage)),
            body: WebviewScaffold(
              hidden: true ,
              url: 'https://basswoodchurch.net/app/read.php?q=' +
                  Uri.encodeComponent(passage),
            ),
          );
        });
}

_launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
