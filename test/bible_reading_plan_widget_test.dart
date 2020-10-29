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
    await tester.pumpWidget(initBibleReadingPlan());

    // Verify that our widget starts with a loading indicator.
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
