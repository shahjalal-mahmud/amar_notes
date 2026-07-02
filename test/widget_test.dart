// Smoke test for the Amar Notes app.
//
// The default `MyApp` requires Firebase initialization at runtime, which
// can't happen in a unit test environment. Instead we pump a minimal
// `MaterialApp` using our custom themes and verify the theme structure
// is well-formed. This guards against regressions in the theme files
// without needing a Firebase mock.

import 'package:amar_notes/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Light theme builds without error', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: const Scaffold(body: Text('hello')),
      ),
    );
    expect(find.text('hello'), findsOneWidget);
  });

  testWidgets('Dark theme builds without error', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.darkTheme,
        home: const Scaffold(body: Text('dark')),
      ),
    );
    expect(find.text('dark'), findsOneWidget);
  });
}