import 'package:core/presentation/widgets/sub_heading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget makeTestableWidget(Widget body) {
    return MaterialApp(home: Scaffold(body: body));
  }

  testWidgets('SubHeading should display title', (WidgetTester tester) async {
    await tester.pumpWidget(
      makeTestableWidget(SubHeading(title: 'Test Title', onTap: () {})),
    );

    expect(find.text('Test Title'), findsOneWidget);
  });

  testWidgets('SubHeading should display See More text', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      makeTestableWidget(SubHeading(title: 'Test Title', onTap: () {})),
    );

    expect(find.text('See More'), findsOneWidget);
  });

  testWidgets('SubHeading should display arrow icon', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      makeTestableWidget(SubHeading(title: 'Test Title', onTap: () {})),
    );

    expect(find.byIcon(Icons.arrow_forward_ios), findsOneWidget);
  });

  testWidgets('SubHeading should trigger onTap callback', (
    WidgetTester tester,
  ) async {
    bool tapped = false;
    await tester.pumpWidget(
      makeTestableWidget(
        SubHeading(
          title: 'Test Title',
          onTap: () {
            tapped = true;
          },
        ),
      ),
    );

    await tester.tap(find.byType(InkWell));
    expect(tapped, true);
  });

  testWidgets('SubHeading should have Row widget', (WidgetTester tester) async {
    await tester.pumpWidget(
      makeTestableWidget(SubHeading(title: 'Test Title', onTap: () {})),
    );

    expect(find.byType(Row), findsWidgets);
  });

  testWidgets('SubHeading should have InkWell widget', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      makeTestableWidget(SubHeading(title: 'Test Title', onTap: () {})),
    );

    expect(find.byType(InkWell), findsOneWidget);
  });
}
