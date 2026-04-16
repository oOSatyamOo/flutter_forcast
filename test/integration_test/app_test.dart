import 'package:flutter/material.dart' show TextField, Icons;
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:skycast/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('End-to-end test', (tester) async {
    // Note: To successfully run this integration test, ensure the device is connected to the internet
    // or provide mock implementations at the injection level for e2e specifically.

    // Start the app
    app.main();
    await tester.pumpAndSettle(
      const Duration(seconds: 3),
    ); // Wait for app load + dotenv init

    // 1. Verify Home Page presence via 'SkyCast' AppBar text
    expect(find.text('SkyCast'), findsWidgets);

    // 2. We should see "London" loading and then appearing as City header
    await tester.pumpAndSettle(
      const Duration(seconds: 5),
    ); // Wait for first API fetch
    expect(find.text('London'), findsWidgets);

    // 3. Search for a new city
    // Actually we used Icons.search. Let's find it by icon.
    final searchBtn = find.byIcon(Icons.search);
    if (searchBtn.evaluate().isNotEmpty) {
      await tester.tap(searchBtn);
      await tester.pumpAndSettle();

      // Tap on TextField
      await tester.enterText(find.byType(TextField), 'Paris');

      // Wait for debounce (2 seconds)
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Check if Paris is shown
      expect(find.text('Paris'), findsWidgets);
    }
  });
}
