import 'package:ditonton/main.dart' as app;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end test', () {
    testWidgets('complete app flow test', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      expect(find.text('Ditonton'), findsOneWidget);

      final tvTab = find.text('TV Shows');
      await tester.tap(tvTab);
      await tester.pumpAndSettle();

      expect(find.byType(ListView), findsWidgets);

      final firstItem = find.byType(InkWell).first;
      await tester.tap(firstItem);
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.add), findsWidgets);

      await tester.pageBack();
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();

      final watchlistItem = find.text('Watchlist');
      await tester.tap(watchlistItem);
      await tester.pumpAndSettle();

      expect(find.text('Watchlist'), findsWidgets);
    });

    testWidgets('search functionality test', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'Spider');
      await tester.pumpAndSettle();

      await tester.pumpAndSettle(Duration(seconds: 2));

      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('watchlist functionality test', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      final firstItem = find.byType(InkWell).first;
      await tester.tap(firstItem);
      await tester.pumpAndSettle();

      final addButton = find.byIcon(Icons.add);
      if (addButton.evaluate().isNotEmpty) {
        await tester.tap(addButton);
        await tester.pumpAndSettle();

        expect(find.byType(SnackBar), findsOneWidget);
      }

      await tester.pageBack();
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Watchlist'));
      await tester.pumpAndSettle();

      expect(find.byType(ListView), findsOneWidget);
    });
  });
}
