import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:table_calendar/table_calendar.dart';

import './widgets/lat_lng_map.dart';
import '../../utils/color_scheme.dart';
import 'calendar_event_entity.dart';
import 'calendar_event_item.dart';
import 'calendar_service.dart';

class CalendarPageWidget extends StatefulWidget {
  @override
  _CalendarPageWidgetState createState() => _CalendarPageWidgetState();
}

class _CalendarPageWidgetState extends State {
  // Instance of WebView plugin

  List<CalendarEventEntity> _list;
  List<CalendarEventEntity> _selectedEvents;
  bool isLoad = false;

  Widget mapWidget;

  @override
  void initState() {
    super.initState();
    CalendarService.getCalendarEventList()
        .then((List<CalendarEventEntity> value) {
      setState(() {
        _list = value;
        isLoad = true;
        _selectedEvents = _getEventsForDay(_focusedDay);
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
    return Center(
        child: SingleChildScrollView(
            child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_list != null && _list.isNotEmpty)
          Card(
              color: SECOND1,
              child: TableCalendar<dynamic>(
                firstDay: CalendarService.firstDay(_list),
                lastDay: CalendarService.lastDay(_list),
                focusedDay: _focusedDay,
                eventLoader: _getEventsForDay,
                calendarStyle: CalendarStyle(
                  markerDecoration:
                      const BoxDecoration(color: BODY2, shape: BoxShape.circle),
                  todayDecoration: const BoxDecoration(
                      color: LIGHT_GREY, shape: BoxShape.rectangle),
                  todayTextStyle: GoogleFonts.nunito(
                      color: MAIN1,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w400),
                  selectedDecoration: const BoxDecoration(
                      color: LIGHT_GREY, shape: BoxShape.rectangle),
                  selectedTextStyle: GoogleFonts.nunito(
                      color: MAIN1,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w400),
                  weekendTextStyle: GoogleFonts.nunito(
                      color: MAIN1,
                      fontSize: 17.0,
                      fontWeight: FontWeight.w600),
                  defaultTextStyle: GoogleFonts.nunito(
                      color: BODY3,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w400),
                ),
                onDaySelected: _onDaySelected,
                selectedDayPredicate: (DateTime day) =>
                    isSameDay(day, _selectedDay),
              )),
        if (_selectedEvents != null) _eventList(context),
      ],
    )));
  }

  Widget _eventList(BuildContext context) {
    return Column(
      children: [
        for (CalendarEventEntity i in _selectedEvents)
          CalendarEventItem(
            key: UniqueKey(),
            event: i,
          )
      ],
    );
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
      _selectedEvents = _getEventsForDay(selectedDay);
      mapWidget = LatLngMap(
        latitude: _selectedEvents.first.latitude,
        longitude: _selectedEvents.first.longitude,
      );
    });
  }

  List<CalendarEventEntity> _getEventsForDay(DateTime day) {
    return CalendarService.getEventsForDay(day, _list);
  }
}
