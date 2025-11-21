import 'package:core/presentation/pages/about_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget makeTestableWidget(Widget body) {
    return MaterialApp(home: body);
  }

  testWidgets('AboutPage should display about text', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(makeTestableWidget(AboutPage()));

    expect(
      find.text(
        'Ditonton merupakan sebuah aplikasi katalog film yang dikembangkan oleh Dicoding Indonesia sebagai contoh proyek aplikasi untuk kelas Menjadi Flutter Developer Expert.',
      ),
      findsOneWidget,
    );
  });

  testWidgets('AboutPage should have back button', (WidgetTester tester) async {
    await tester.pumpWidget(makeTestableWidget(AboutPage()));

    expect(find.byIcon(Icons.arrow_back), findsOneWidget);
  });

  testWidgets('AboutPage should display image', (WidgetTester tester) async {
    await tester.pumpWidget(makeTestableWidget(AboutPage()));

    expect(find.byType(Image), findsOneWidget);
  });

  testWidgets('AboutPage should have SafeArea', (WidgetTester tester) async {
    await tester.pumpWidget(makeTestableWidget(AboutPage()));

    expect(find.byType(SafeArea), findsOneWidget);
  });

  testWidgets('AboutPage back button should be in IconButton', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(makeTestableWidget(AboutPage()));

    expect(find.byType(IconButton), findsOneWidget);
  });
}
