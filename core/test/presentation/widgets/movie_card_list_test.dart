import 'package:movies/domain/entities/movie.dart';
import 'package:movies/presentation/widgets/movie_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final tMovie = Movie(
    adult: false,
    backdropPath: 'backdropPath',
    genreIds: [1, 2, 3],
    id: 1,
    originalTitle: 'originalTitle',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    releaseDate: 'releaseDate',
    title: 'title',
    video: false,
    voteAverage: 1,
    voteCount: 1,
  );

  Widget makeTestableWidget(Widget body) {
    return MaterialApp(home: Scaffold(body: body));
  }

  testWidgets('MovieCard should display movie title and overview', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(makeTestableWidget(MovieCard(tMovie)));

    expect(find.text('title'), findsOneWidget);
    expect(find.text('overview'), findsOneWidget);
  });

  testWidgets('MovieCard should display placeholder for null title', (
    WidgetTester tester,
  ) async {
    final movieWithNullTitle = Movie(
      adult: false,
      backdropPath: 'backdropPath',
      genreIds: [1, 2, 3],
      id: 1,
      originalTitle: 'originalTitle',
      overview: 'overview',
      popularity: 1,
      posterPath: 'posterPath',
      releaseDate: 'releaseDate',
      title: null,
      video: false,
      voteAverage: 1,
      voteCount: 1,
    );

    await tester.pumpWidget(makeTestableWidget(MovieCard(movieWithNullTitle)));

    expect(find.text('-'), findsOneWidget);
  });

  testWidgets('MovieCard should be tappable', (WidgetTester tester) async {
    await tester.pumpWidget(makeTestableWidget(MovieCard(tMovie)));

    final inkWellFinder = find.byType(InkWell);
    expect(inkWellFinder, findsOneWidget);
  });

  testWidgets('MovieCard should display ClipRRect', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(makeTestableWidget(MovieCard(tMovie)));

    expect(find.byType(ClipRRect), findsOneWidget);
  });

  testWidgets('MovieCard should display Container', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(makeTestableWidget(MovieCard(tMovie)));

    expect(find.byType(Container), findsWidgets);
  });
}
