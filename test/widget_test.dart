// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:letsworkout/main.dart';

void main() {
  test('regexp', () {
    String text =
        "12d788934rc!*(3@&EROF3K:,235>F<?;s3vkz'x'cv2356()+-=0=./246,?><)  zws3fg2)";
    print(text.replaceAll(RegExp(r'[^0-9]'), ""));
  });

  test('error test', () {
    var encoded = jsonEncode('');
    print(encoded);

    var decoded = jsonDecode('');
    print(decoded);
  });

  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
