import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


Future<List<BrcDay>> fetchBrcDays(http.Client client) async {
  final response =     
  await client.get('https://raw.githubusercontent.com/jeremib/basswood-brc/master/data/brc.json');

  // Use the compute function to run parseBrcDays in a separate isolate
  return compute(parseBrcDays, response.body);
}

// A function that will convert a response body into a List<BrcDay>
List<BrcDay> parseBrcDays(String responseBody) {
  final parsed = json.decode(responseBody);

  return parsed.map<BrcDay>((json) => new BrcDay.fromJson(json)).toList();
}

class BrcDay {
  final String date;
  final String friendlyDate;
  final String passage;

  BrcDay({this.date, this.friendlyDate, this.passage});

  factory BrcDay.fromJson(Map<String, dynamic> json) {
    return new BrcDay(
      date: json['date'] as String,
      friendlyDate: json['friendlyDate'] as String,
      passage: json['passage'] as String,
    );
  }
}

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;
  MyHomePage({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new FutureBuilder<List<BrcDay>>(
        future: fetchBrcDays(new http.Client()),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);

          return snapshot.hasData
              ? new BrcDaysList(BrcDays: snapshot.data)
              : new Center(child: new CircularProgressIndicator());
        },
      ),
    );
  }
}

class BrcDaysList extends StatelessWidget {
  final List<BrcDay> BrcDays;

  BrcDaysList({Key key, this.BrcDays}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new GridView.builder(
      gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      itemCount: BrcDays.length,
      itemBuilder: (context, index) {
        return Text(BrcDays[index].passage);
      },
    );
  }
}