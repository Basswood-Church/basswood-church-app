import 'package:flutter/material.dart';
import 'sermon_entity.dart';
import '../../utils/color_scheme.dart';

import 'package:google_fonts/google_fonts.dart';
import '../../widgets/listen_button_widget.dart';

class SermonItem extends StatelessWidget {
  const SermonItem({
    Key key,
    this.sermon,
  }) : super(key: key);

  final SermonEntity sermon;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: MAIN1,
      child: Card(
        color: MAIN1,
        child: Container(
          height: 100.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const SizedBox(
                width: 11.0,
              ),
              Expanded(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(sermon.title,
                      maxLines: 1,
                      style: GoogleFonts.nunito(
                          color: BODY2,
                          fontSize: 19.0,
                          fontWeight: FontWeight.bold)),
                  Text(sermon.author,
                      maxLines: 1,
                      style: GoogleFonts.nunito(
                          color: GREY3,
                          fontSize: 17.0,
                          fontWeight: FontWeight.w400)),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(sermon.date,
                            maxLines: 1,
                            style: GoogleFonts.nunito(
                                color: GREY3,
                                fontSize: 17.0,
                                fontWeight: FontWeight.w400)),
                        Text(' ' + sermon.time,
                            maxLines: 1,
                            style: GoogleFonts.nunito(
                                color: GREY3,
                                fontSize: 17.0,
                                fontWeight: FontWeight.w400)),
                      ]),
                ],
              )),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5.0, horizontal: 10.0),
                      child: ListenButtonWidget(
                          title: sermon.title,
                          description: 'Welcome to the Feast',
                          url: sermon.link)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
