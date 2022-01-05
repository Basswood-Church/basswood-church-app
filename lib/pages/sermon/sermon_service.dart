import 'sermon_entity.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:webfeed/domain/rss_feed.dart';
import 'package:intl/intl.dart';

/// https://app.dropwave.io/feed/show/christ-the-king-church-sermons
class SermonService {
  SermonService();
  static Future<List<SermonEntity>> getSermonList() async {
    final _response = await http.get(
        'https://app.dropwave.io/feed/show/christ-the-king-church-sermons');

    print(_response.statusCode);

    if (_response.statusCode == 200) {
      var _decoded = new RssFeed.parse(_response.body);
      return _decoded.items
          .map((item) => SermonEntity(
                title: item.title,
                author: item.author,
                time: DateFormat('HH:MM').format(item.pubDate).toString(),
                date: DateFormat('EEEE, MMMM d   ')
                    .format(item.pubDate)
                    .toString(),
                link: item.enclosure.url,
              ))
          .toList();
    } else {
      throw Exception('Failed to fetch RSS data');
    }
  }

  static String removeAllHtmlTags(String htmlText) {
    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);

    return htmlText.replaceAll(exp, '');
  }
}
