import 'package:tv/presentation/widgets/tv_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../dummy_data/tv/dummy_tv_objects.dart';

void main() {
  Widget makeTestableWidget(Widget body) {
    return MaterialApp(home: Scaffold(body: body));
  }

  testWidgets('TvCard should display tv information correctly', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(makeTestableWidget(TvCard(testTv)));

    expect(find.text('Test TV Show'), findsOneWidget);
    expect(find.text('Test overview'), findsOneWidget);
    expect(find.byType(Image), findsOneWidget);
  });

  testWidgets('TvCard should be tappable', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: TvCard(testTv)),
        routes: {
          '/detail-tv': (context) => Scaffold(body: Text('Detail Page')),
        },
      ),
    );

    await tester.tap(find.byType(InkWell));
    await tester.pumpAndSettle();

    expect(find.text('Detail Page'), findsOneWidget);
  });
}
