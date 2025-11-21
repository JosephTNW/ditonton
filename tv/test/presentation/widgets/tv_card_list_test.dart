import 'package:tv/domain/entities/tv.dart';
import 'package:tv/presentation/widgets/tv_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final tTv = Tv(
    adult: false,
    backdropPath: 'backdropPath',
    genreIds: [1, 2, 3],
    id: 1,
    originCountry: ['US'],
    originalLanguage: 'en',
    originalName: 'originalName',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    firstAirDate: 'firstAirDate',
    name: 'name',
    voteAverage: 1,
    voteCount: 1,
  );

  Widget makeTestableWidget(Widget body) {
    return MaterialApp(home: Scaffold(body: body));
  }

  testWidgets('TvCard should display TV name and overview', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(makeTestableWidget(TvCard(tTv)));

    expect(find.text('name'), findsOneWidget);
    expect(find.text('overview'), findsOneWidget);
  });

  testWidgets('TvCard should display placeholder for null name', (
    WidgetTester tester,
  ) async {
    final tvWithNullName = Tv(
      adult: false,
      backdropPath: 'backdropPath',
      genreIds: [1, 2, 3],
      id: 1,
      originCountry: ['US'],
      originalLanguage: 'en',
      originalName: 'originalName',
      overview: 'overview',
      popularity: 1,
      posterPath: 'posterPath',
      firstAirDate: 'firstAirDate',
      name: null,
      voteAverage: 1,
      voteCount: 1,
    );

    await tester.pumpWidget(makeTestableWidget(TvCard(tvWithNullName)));

    expect(find.text('-'), findsOneWidget);
  });

  testWidgets('TvCard should be tappable', (WidgetTester tester) async {
    await tester.pumpWidget(makeTestableWidget(TvCard(tTv)));

    final inkWellFinder = find.byType(InkWell);
    expect(inkWellFinder, findsOneWidget);
  });

  testWidgets('TvCard should display ClipRRect', (WidgetTester tester) async {
    await tester.pumpWidget(makeTestableWidget(TvCard(tTv)));

    expect(find.byType(ClipRRect), findsOneWidget);
  });
}
