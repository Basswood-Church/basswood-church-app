import 'dart:async';
import 'dart:convert';
import 'dart:math';

import '../../widgets/listen_button_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import '../../utils/color_scheme.dart';

import 'package:google_fonts/google_fonts.dart';

import 'sermon_entity.dart';
import 'sermon_item.dart';
import 'sermon_service.dart';

class SermonList extends StatefulWidget {
  final void Function(String url) urlCallback;

  const SermonList({
    Key key,
    this.urlCallback,
  }) : super(key: key);
  @override
  _SermonListState createState() => _SermonListState();
}

class _SermonListState extends State<SermonList> {
  _SermonListState();
  List<SermonEntity> list = [];
  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();

  @override
  void initState() {
    super.initState();

    _initSermonList();
  }

  @override
  Widget build(BuildContext context) => Container(
      color: MAIN1,
      child: ScrollablePositionedList.builder(
        itemCount: list.length,
        itemBuilder: (context, index) {
          return SermonItem(
            key: UniqueKey(),
            sermon: list[index],
            urlCallback: widget.urlCallback,
          );
        },
        itemScrollController: itemScrollController,
        itemPositionsListener: itemPositionsListener,
      ));

  void _initSermonList() async {
    var _list = await SermonService.getSermonList();

    setState(() {
      list = _list;
    });
  }
}
