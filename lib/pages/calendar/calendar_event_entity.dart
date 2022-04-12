class CalendarEventEntity {
  final String title;
  final DateTime datetime;

  const CalendarEventEntity({
    this.title,
    this.datetime,
    // {
    //   type: VEVENT,
    //   dtstart: {dt: 20211120T150000Z},
    //   dtend: {dt: 20211120T180000Z},
    //   dtstamp: {dt: 20220408T170254Z},
    //   uid: 1ulr45p2dbfg9oj3gj3q8tb81l@google.com,
    //   description: ,
    //   lastModified: {dt: 20211118T144911Z},
    //   location: https://goo.gl/maps/AEj9DHaisJi5HK749,
    //   sequence: 0,
    //   status: CONFIRMED,
    //   summary: Future Men Hike,
    //   transp: OPAQUE
    // }
  });

  @override
  String toString() => title;
}
