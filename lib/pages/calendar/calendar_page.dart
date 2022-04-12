import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:table_calendar/table_calendar.dart';

import './widgets/lat_lng_map.dart';
import '../../utils/color_scheme.dart';
import 'calendar_event_entity.dart';
import 'calendar_service.dart';

class CalendarPageWidget extends StatefulWidget {
  @override
  _CalendarPageWidgetState createState() => _CalendarPageWidgetState();
}

class _CalendarPageWidgetState extends State {
  // Instance of WebView plugin

  List<CalendarEventEntity> list;
  bool isLoad = false;

  @override
  void initState() {
    super.initState();
    CalendarService.getCalendarEventList()
        .then((List<CalendarEventEntity> value) {
      setState(() {
        list = value;
        isLoad = true;
      });
    });
  }

  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      color: MAIN1,
      child: isLoad
          ? _column(context)
          : const Center(
              child: CircularProgressIndicator(
                color: SECOND1,
              ),
            ),
    ));
  }

  Widget _column(BuildContext context) {
    return Column(
      children: [
        if (list != null && list.isNotEmpty)
          TableCalendar<dynamic>(
            firstDay: CalendarService.firstDay(list),
            lastDay: CalendarService.lastDay(list),
            focusedDay: _focusedDay,
            eventLoader: _getEventsForDay,
            calendarStyle: CalendarStyle(
              defaultTextStyle: GoogleFonts.nunito(
                  color: GREY3, fontSize: 16.0, fontWeight: FontWeight.w400),
            ),
            onDaySelected: _onDaySelected,
            selectedDayPredicate: (DateTime day) =>
                isSameDay(day, _selectedDay),
          ),

        // const LatLngMap(
        //   latitude: 36.0263899,
        //   longitude: -84.1492908,
        // ),
      ],
    );
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
    });
  }

  List<CalendarEventEntity> _getEventsForDay(DateTime day) {
    return CalendarService.getEventsForDay(day, list);
  }
}
