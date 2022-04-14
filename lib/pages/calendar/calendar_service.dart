import 'package:dart_date/dart_date.dart';

import 'package:http/http.dart' as http;
import 'package:icalendar_parser/icalendar_parser.dart';

import 'calendar_event_entity.dart';

class CalendarService {
  CalendarService();
  static String icsUrl =
      'https://calendar.google.com/calendar/ical/7207uvevk4oogeqbv9fq2pebr4%40group.calendar.google.com/private-e596ffdcac5c16e5fb1b48d4ad70e9b2/basic.ics';

  static Future<List<CalendarEventEntity>> getCalendarEventList() async {
    // ignore: always_specify_types
    final List<CalendarEventEntity> list = [];
    final http.Response response = await http.get(Uri.parse(icsUrl));

    if (response.statusCode == 200) {
      final ICalendar iCalendar = ICalendar.fromString(response.body);
      final List<dynamic> arr = <dynamic>[...iCalendar.toJson()['data']];
      for (final dynamic item in arr) {
        if (item['type'].toString() == 'VEVENT') {
          final CalendarEventEntity calendarEventEntity =
              await parseCalendarEvent(item);
          print(calendarEventEntity.toString());
          list.add(calendarEventEntity);
        }
      }
    } else {
      throw Exception('Failed to load calendar');
    }

    return list;
  }

  static Future<CalendarEventEntity> parseCalendarEvent(dynamic item) async {
    print(item);
    final String _location = item['location'].toString();

    CalendarEventEntity entity = CalendarEventEntity(
      summary: item['summary'].toString(),
      description: item['description'].toString(),
      location: _location,
      dtstart: DateTime.parse(item['dtstart']['dt'].toString()),
      dtend: DateTime.parse(item['dtend']['dt'].toString()),
    );
    return entity;
  }

  static DateTime firstDay(List<CalendarEventEntity> list) {
    final CalendarEventEntity min = list.reduce(
        (CalendarEventEntity a, CalendarEventEntity b) =>
            a.dtstart.getMicrosecondsSinceEpoch <
                    b.dtstart.getMicrosecondsSinceEpoch
                ? a
                : b);
    return min.dtstart;
  }

  static DateTime lastDay(List<CalendarEventEntity> list) {
    final CalendarEventEntity max = list.reduce((CalendarEventEntity a,
            CalendarEventEntity b) =>
        a.dtend.getMicrosecondsSinceEpoch > b.dtend.getMicrosecondsSinceEpoch
            ? a
            : b);
    return max.dtend;
  }

  static List<CalendarEventEntity> getEventsForDay(
    DateTime day,
    List<CalendarEventEntity> list,
  ) {
    List<CalendarEventEntity> dayList = [];

    for (final CalendarEventEntity item in list) {
      if (day.isSameDay(item.dtend)) {
        dayList.add(item);
      }
    }

    return dayList;
  }
}
