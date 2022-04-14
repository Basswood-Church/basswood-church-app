import 'package:dart_date/src/dart_date.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import './widgets/lat_lng_map.dart';
import '../../utils/color_scheme.dart';
import 'calendar_event_entity.dart';

class CalendarEventPage extends MaterialPageRoute<void> {
  CalendarEventPage(this.event)
      : super(builder: (BuildContext context) {
          return Scaffold(
            appBar: AppBar(
              actions: const <Widget>[],
              iconTheme: const IconThemeData(
                color: GREY3, //change your color here
              ),
              title: Text(event.summary,
                  maxLines: 1,
                  style: GoogleFonts.nunito(
                      color: BODY2,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold)),
              backgroundColor: MAIN1,
            ),
            body: CalendarEventPageWidget(
              event: event,
            ),
          );
        });
  final CalendarEventEntity event;
}

class CalendarEventPageWidget extends StatefulWidget {
  const CalendarEventPageWidget({
    Key key,
    this.event,
  }) : super(key: key);
  final CalendarEventEntity event;
  @override
  _CalendarEventPageWidgetState createState() =>
      _CalendarEventPageWidgetState();
}

class _CalendarEventPageWidgetState extends State<CalendarEventPageWidget> {
  _CalendarEventPageWidgetState();

  bool isCoordsLoaded = false;

  double _zoom = 13;

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  Widget build(BuildContext context) => Container(
      color: MAIN1,
      child: Container(
        color: MAIN1,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _info(context),
            if (isCoordsLoaded) _map(context),
          ],
        ),
      ));

  Widget _info(BuildContext context) {
    return Container(
        color: MAIN1,
        child: SizedBox(
            width: MediaQuery.of(context).size.width, // set this
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _line(widget.event.description),
                    _line(widget.event.dtstart.toHumanString()),
                    _line(widget.event.dtend.toHumanString()),
                    _line(widget.event.location),
                  ],
                ))));
  }

  Widget _map(BuildContext context) {
    return Column(
      // ignore: always_specify_types
      children: [
        LatLngMap(
          latitude: widget.event.latitude,
          longitude: widget.event.longitude,
        ),
      ],
    );
  }

  // ignore: avoid_void_async
  void _init() async {
    final bool da = await widget.event.loadCoords();
    setState(() {
      isCoordsLoaded = da;
    });
  }

  Widget _line(String line) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 7),
        child: Text(line,
            maxLines: 1,
            style: GoogleFonts.nunito(
                color: GREY3, fontSize: 16.0, fontWeight: FontWeight.w400)));
  }
}
