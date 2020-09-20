import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

Future<List<BrcDay>> fetchBrcDays(http.Client client) async {
  final response = await client.get(
      'https://www.basswoodchurch.net/app/brc.json');

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
  final String friendlyDate;
  final String passage;
  final String friendlyPassage;

  BrcDay({this.date, this.friendlyDate, this.passage, this.friendlyPassage});

  factory BrcDay.fromJson(Map<String, dynamic> json) {
    return new BrcDay(
        date: (DateTime.parse(json['date'].toString())),
        friendlyDate: json['friendlyDate'] as String,
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
    } else if (index == 2) {
      _launchURL('https://www.basswoodchurch.net/give');
    } else if (index == 3) {
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
                ? new BrcDaysList(BrcDays: snapshot.data)
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
          BottomNavigationBarItem(
            icon: Icon(Icons.card_giftcard),
            title: Text('Giving'),
          ),
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

class BrcDaysList extends StatelessWidget {
  final List<BrcDay> BrcDays;

  BrcDaysList({Key key, this.BrcDays}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ItemScrollController itemScrollController = ItemScrollController();
    final ItemPositionsListener itemPositionsListener =
        ItemPositionsListener.create();

    return new ScrollablePositionedList.builder(
      itemCount: this.BrcDays.length,
      itemBuilder: (BuildContext context, int index) =>
          buildBrcDay(context, index),
      itemScrollController: itemScrollController,
      itemPositionsListener: itemPositionsListener,
    );
  }

  Widget buildBrcDay(BuildContext context, int index) {
    return Container(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Icon(
                  (BrcDays[index].passage).isEmpty ? Icons.mood : Icons.book),
              title: Text(
                  "${DateFormat('EEEE, MMMM d, y').format(BrcDays[index].date).toString()}"),
              subtitle: Text(BrcDays[index].friendlyPassage),
            ),
            ButtonBar(
              children: <Widget>[
                FlatButton.icon(
                  color: Colors.blueGrey,
                  icon: Icon(Icons.remove_red_eye),
                  label: const Text('READ'),
                  onPressed: () {
                    Navigator.push(
                        context, ReaderPage(BrcDays[index].passage));
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
                                BrcDays[index].passage.toString()));
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

Future<Passage> fetchPassage(http.Client client) async {
  final response = await client.get(
    'https://api.esv.org/v3/passage/html/?q=Gen+1:1&include-footnotes=false&include-footnote-body=false&include-short-copyright=false&include-copyright=false',
    headers: {
      HttpHeaders.authorizationHeader:
          "Token 5ccfbffc6812ebe3b6f436330e3ce15daabac8d9"
    },
  );

  // Use the compute function to run parseBrcDays in a separate isolate
  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Passage.fromJson(json.decode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

class Passage {
  final List<String> passages;

  Passage({this.passages});

  factory Passage.fromJson(Map<String, dynamic> json) {
    return new Passage(passages: json['passages'].cast<String>());
  }
}

class ReaderPage extends MaterialPageRoute<Null> {
  ReaderPage(String passage)
      : super(builder: (BuildContext context) {
          return Scaffold(
              appBar: AppBar(actions: [], title: Text(passage)),
              body: WebviewScaffold(
                url: 'https://basswoodchurch.net/app/read.php?q=' + Uri.encodeComponent(passage),
              ),
              // body: new FutureBuilder(
              //     future: fetchPassage(new http.Client()),
              //     builder: (context, snapshot) {
              //       if (snapshot.hasData) {
              //         Passage p = snapshot.data;

              //         // debugPrint('Step 3, build widget: ${snapshot.data}');
              //         // Build the widget with data.
              //         // return WebviewScaffold(
              //         //   url: new Uri.dataFromString(p.passages.first.replaceAll("\’", "&#39"),
              //         //           mimeType: 'text/html')
              //         //       .toString(),
              //         // );
              //                               return WebviewScaffold(
              //           url: 'https://basswoodchurch.net/app/read.php',
              //         );
              //         // return Center(
              //         //     child: Container(
              //         //         child: Text('hasData: ${snapshot.data}')));
              //       } else {
              //         // We can show the loading view until the data comes back.
              //         // debugPrint('Step 1, build loading widget');
              //         return CircularProgressIndicator();
              //       }
              //     })
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
