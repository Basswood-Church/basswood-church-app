import 'dart:convert';

import '../lib/pages/bible_reading_plan.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('JSON should parse to BrcDay', () {
    final dynamic testJson = json.decode('''{
      "date": "2020-10-01",
      "friendlyDate": "Thursday, October 01, 2020",
      "passage": "Matthew 1-4; Psalm 1",
      "friendlyPassage": "Matthew 1-4; Psalm 1"
    }''');
    final DateTime testDate = DateTime(2020, 10, 1);
    const String testPassage = 'Matthew 1-4; Psalm 1';
    const String testFriendlyPassage = 'Matthew 1-4; Psalm 1';

    final BrcDay testDay = BrcDay.fromJson(testJson as Map<String, dynamic>);

    expect(testDay.date, testDate);
    expect(testDay.passage, testPassage);
    expect(testDay.friendlyPassage, testFriendlyPassage);
  });
}
