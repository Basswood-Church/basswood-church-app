// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:BasswoodChurch/pages/bible_reading_plan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Bible reading plan opens with loading indicator', (WidgetTester tester) async {
    // Build our widget and trigger a frame.
    await tester.pumpWidget(const BibleReadingPlan(numRefocuses: 0));

    // Verify that our widget starts with a loading indicator.
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Bible reading plan scrolls to current day', (WidgetTester tester) async {
    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);
    const String past = 'past';
    const String friendlyPast = 'Past Passage';
    const String present = 'present';
    const String friendlyPresent = 'Present Passage';
    const String future = 'future';
    const String friendlyFuture = 'Future Passage';

    final List<BrcDay> testData = <BrcDay>[
      BrcDay(
          date: today.subtract(const Duration(days: 2)),
          passage: past,
          friendlyPassage: friendlyPast),
      BrcDay(
          date: today.subtract(const Duration(days: 1)),
          passage: past,
          friendlyPassage: friendlyPast),
      BrcDay(
          date: today,
          passage: present,
          friendlyPassage: friendlyPresent),
      BrcDay(
          date: today.add(const Duration(days: 1)),
          passage: future,
          friendlyPassage: friendlyFuture),
      BrcDay(
          date: today.add(const Duration(days: 2)),
          passage: future,
          friendlyPassage: friendlyFuture),
      BrcDay(
          date: today.add(const Duration(days: 3)),
          passage: future,
          friendlyPassage: friendlyFuture),
      BrcDay(
          date: today.add(const Duration(days: 4)),
          passage: future,
          friendlyPassage: friendlyFuture),
    ];

    // Need to wrap stateful list widget in app/builder to have build context
    await tester.pumpWidget(
        MaterialApp(
            home: Builder(
                builder: (BuildContext context) => BrcDaysList(brcDays: testData)
            )
        )
    );

    // Let the animation finish
    await tester.pumpAndSettle();

    expect(find.text(friendlyPast), findsNothing);
    expect(find.text(friendlyPresent), findsOneWidget);
    expect(find.text(friendlyFuture), findsWidgets);
  });
}
