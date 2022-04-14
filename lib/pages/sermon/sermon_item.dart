import 'package:flutter/material.dart';
import 'sermon_entity.dart';
import '../../utils/color_scheme.dart';

import 'package:google_fonts/google_fonts.dart';
import '../../widgets/listen_button_widget.dart';

class SermonItem extends StatelessWidget {
  final void Function(String url) urlCallback;

  const SermonItem({
    Key key,
    this.sermon,
    this.urlCallback,
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
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  child: Image.network(
                    sermon.image,
                    height: 50,
                  ),
                ),
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
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold)),
                  Text(sermon.date,
                      maxLines: 1,
                      style: GoogleFonts.nunito(
                          color: GREY3,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w400)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(sermon.author,
                          maxLines: 1,
                          style: GoogleFonts.nunito(
                              color: GREY3,
                              fontSize: 16.0,
                              fontWeight: FontWeight.w400)),
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
                      child: ListenButtonWidget(
                          title: sermon.title,
                          description: 'Welcome to the Feast',
                          urlCallback: urlCallback,
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
