import 'package:CtkChurchConnect/widgets/green_button.dart';
import 'package:dart_date/src/dart_date.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:intl/intl.dart';

import '../../utils/color_scheme.dart';
import '../../widgets/listen_button_widget.dart';
import 'calendar_event_entity.dart';
import 'calendar_event_page.dart';

String getTimeFromDateAndTime(String date) {
  DateTime dateTime;
  try {
    dateTime = DateTime.parse(date).toLocal();
    return DateFormat.jm().format(dateTime).toString(); //5:08 PM
// String formattedTime = DateFormat.Hms().format(now);
// String formattedTime = DateFormat.Hm().format(now);   // //17:08  force 24 hour time
  } catch (e) {
    return date;
  }
}

class CalendarEventItem extends StatelessWidget {
  const CalendarEventItem({
    Key key,
    this.event,
  }) : super(key: key);

  final CalendarEventEntity event;

  String _date() {
    String end = getTimeFromDateAndTime(event.dtend.toIso8601String());

    String _startTime = getTimeFromDateAndTime(event.dtstart.toIso8601String());
    String _endTime = getTimeFromDateAndTime(event.dtend.toIso8601String());

    return _startTime + '-' + _endTime;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: MAIN1,
      child: Card(
        color: MAIN1,
        child: Container(
          height: 80.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(event.summary,
                      maxLines: 1,
                      style: GoogleFonts.nunito(
                          color: BODY2,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold)),
                  Text(_date(),
                      maxLines: 1,
                      style: GoogleFonts.nunito(
                          color: GREY3,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w400)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(
                          width: 300.0,
                          height: 20.0,
                          child: Text(event.location,
                              maxLines: 1,
                              style: GoogleFonts.nunito(
                                  color: GREY3,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w400))),
                    ],
                  ),
                ],
              )),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5.0, horizontal: 10.0),
                      child: GreenButton(
                        text: '',
                        icon: Icons.remove_red_eye,
                        onPressed: () {
                          Navigator.push(context, CalendarEventPage(event));
                        },
                      )),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
