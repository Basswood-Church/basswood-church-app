import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:BasswoodChurch/widgets/listen_button_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import 'reading_page.dart';

Widget initBibleReadingPlan(int numRefreshes) {
  return FutureBuilder<List<BrcDay>>(
      future: fetchBrcDays(http.Client()),
      builder: (BuildContext context, AsyncSnapshot<List<BrcDay>> snapshot) {
        if (snapshot.hasError) {
          print(snapshot.error);
        }

        return snapshot.hasData
            ? BrcDaysList(
                brcDays: snapshot.data,
                numRefreshes: numRefreshes,
              )
            : const Center(child: CircularProgressIndicator());
      });
}

Future<List<BrcDay>> fetchBrcDays(http.Client client) async {
  final Response response =
      await client.get('https://www.basswoodchurch.net/app/brc.json');

  // Use the compute function to run parseBrcDays in a separate isolate
  return compute(parseBrcDays, response.body);
}

// A function that will convert a response body into a List<BrcDay>
List<BrcDay> parseBrcDays(String responseBody) {
  final List<dynamic> parsed = json.decode(responseBody) as List<dynamic>;

  return parsed
      .map<BrcDay>(
          (dynamic json) => BrcDay.fromJson(json as Map<String, dynamic>))
      .toList();
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

class BrcDaysList extends StatefulWidget {
  const BrcDaysList({Key key, this.brcDays, this.numRefreshes})
      : super(key: key);
  final List<BrcDay> brcDays;
  final int numRefreshes;

  @override
  _BrcDaysListState createState() =>
      _BrcDaysListState(brcDays: brcDays);
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
    final int index =
        max(brcDays.indexWhere((BrcDay element) => element.date == today), 0);

    Future<void>.delayed(const Duration(milliseconds: 0),
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
              title: Text(DateFormat('EEEE, MMMM d, y')
                  .format(brcDays[index].date)
                  .toString()),
              subtitle: Text(brcDays[index].friendlyPassage),
            ),
            ButtonBar(
              children: <Widget>[
                FlatButton.icon(
                  color: Colors.blueGrey,
                  icon: const Icon(Icons.remove_red_eye),
                  label: const Text('READ'),
                  onPressed: () {
                    Navigator.push(
                        context, ReadingPage(brcDays[index].passage));
                  },
                ),
                ListenButtonWidget(title: brcDays[index].passage.toString(), description: 'Welcome to the Feast', url:'https://www.basswoodchurch.net/' +
                                Uri.encodeComponent(
                                    brcDays[index].passage.toString() + '.mp3')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
