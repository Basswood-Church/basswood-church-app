import 'dart:async';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:http/http.dart' as http;
import 'package:icalendar_parser/icalendar_parser.dart';
import 'dart:convert';
import 'package:dart_date/dart_date.dart';

import 'package:geocoding/geocoding.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../utils/color_scheme.dart';

import 'calendar_event_entity.dart';
import 'calendar_service.dart';
import './widgets/lat_lng_map.dart';

class CalendarPageWidget extends StatefulWidget {
  @override
  _CalendarPageWidgetState createState() => _CalendarPageWidgetState();
}

class _CalendarPageWidgetState extends State {
  // Instance of WebView plugin

  final String icsUrl =
      "https://calendar.google.com/calendar/ical/7207uvevk4oogeqbv9fq2pebr4%40group.calendar.google.com/private-e596ffdcac5c16e5fb1b48d4ad70e9b2/basic.ics";

  @override
  void initState() {
    super.initState();
    _parseIcs(icsUrl);
  }

  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          color: MAIN1,
          child: Column(
            children: [
              TableCalendar<dynamic>(
                firstDay: DateTime.utc(2022, 4, 6),
                lastDay: DateTime.utc(2022, 4, 28),
                focusedDay: _focusedDay,
                eventLoader: _getEventsForDay,
                calendarStyle: CalendarStyle(
                  defaultTextStyle: GoogleFonts.nunito(
                      color: GREY3,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w400),
                ),
                onDaySelected: _onDaySelected,
                selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
              ),
              const LatLngMap(
                latitude: 36.0263899,
                longitude: -84.1492908,
              ),
            ],
          )),
    );
  }

  Future<String> _parseIcs(String url) async {
    final response = await http.get(Uri.parse(url));
    List<Location> locations = await locationFromAddress(
        "Claxton Community Center, Edgemoor Rd, Clinton, TN 37716, USA,");

    print(locations.toString());

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      ///return Album.fromJson(jsonDecode(response.body));
      final iCalendar = ICalendar.fromString(response.body);

      List<dynamic> arr = <dynamic>[...iCalendar.toJson()["data"]];

      for (var item in arr) {
        print(item);
      }
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load calendar');
    }

    return 'String';
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
    });
  }

  List<CalendarEventEntity> _getEventsForDay(DateTime day) {
    var event = CalendarEventEntity(
        title: 'first event', datetime: DateTime(2022, 4, 12, 12, 30));
    if (day.isSameDay(event.datetime)) {
      return [event];
    }

    // Implementation example
    return [];
  }
}
