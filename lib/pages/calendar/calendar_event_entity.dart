// ignore: implementation_imports
import 'package:dart_date/src/dart_date.dart';

class CalendarEventEntity {
  const CalendarEventEntity({
    this.summary,
    this.description,
    this.location,
    this.dtstart,
    this.dtend,
    this.latitude,
    this.longitude,
  });

  final String summary;
  final String description;
  final DateTime dtstart;
  final DateTime dtend;
  final String location;
  final double latitude;
  final double longitude;

  @override
  String toString() => summary;
}
