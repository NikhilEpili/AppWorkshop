// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

import 'package:whycollege/main.dart';

void main() {
  testWidgets('AppSprint app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const AppSprintApp());

    // Verify that the app title is displayed.
    expect(find.text('AppSprint'), findsOneWidget);

    // Verify that the floating action button is present.
    expect(find.byIcon(Icons.add), findsOneWidget);

    // Verify that the curved navigation bar is present.
    expect(find.byType(CurvedNavigationBar), findsOneWidget);
  });
}
