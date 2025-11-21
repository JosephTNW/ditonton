import 'package:cached_network_image/cached_network_image.dart';
import 'package:movies/domain/entities/movie.dart';
import 'package:movies/presentation/pages/movie_detail_page.dart';
import 'package:movies/presentation/widgets/movie_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final tMovie = Movie(
    adult: false,
    backdropPath: '/backdropPath.jpg',
    genreIds: const [1, 2, 3],
    id: 1,
    originalTitle: 'Original Title',
    overview: 'Overview of the movie that is long enough to test overflow',
    popularity: 7.8,
    posterPath: '/posterPath.jpg',
    releaseDate: '2020-01-01',
    title: 'Test Movie Title',
    video: false,
    voteAverage: 8.5,
    voteCount: 100,
  );

  Widget makeTestableWidget(Widget body) {
    return MaterialApp(
      home: Scaffold(body: body),
      routes: {
        MovieDetailPage.ROUTE_NAME:
            (context) => Scaffold(body: Text('Detail Page')),
      },
    );
  }

  testWidgets('MovieCard should display movie information', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(makeTestableWidget(MovieCard(tMovie)));

    expect(find.text('Test Movie Title'), findsOneWidget);
    expect(
      find.text('Overview of the movie that is long enough to test overflow'),
      findsOneWidget,
    );
    expect(find.byType(CachedNetworkImage), findsOneWidget);
  });

  testWidgets('MovieCard should navigate to detail page when tapped', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(makeTestableWidget(MovieCard(tMovie)));

    final inkWellFinder = find.byType(InkWell);
    expect(inkWellFinder, findsOneWidget);

    await tester.tap(inkWellFinder);
    await tester.pumpAndSettle();

    expect(find.text('Detail Page'), findsOneWidget);
  });

  testWidgets('MovieCard should display placeholder while loading image', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(makeTestableWidget(MovieCard(tMovie)));

    // The CachedNetworkImage should be present
    expect(find.byType(CachedNetworkImage), findsOneWidget);
  });

  testWidgets('MovieCard should handle null title gracefully', (
    WidgetTester tester,
  ) async {
    final movieWithNullTitle = Movie(
      adult: false,
      backdropPath: '/backdropPath.jpg',
      genreIds: const [1, 2, 3],
      id: 1,
      originalTitle: 'Original Title',
      overview: 'Overview',
      popularity: 7.8,
      posterPath: '/posterPath.jpg',
      releaseDate: '2020-01-01',
      title: null,
      video: false,
      voteAverage: 8.5,
      voteCount: 100,
    );

    await tester.pumpWidget(makeTestableWidget(MovieCard(movieWithNullTitle)));

    expect(find.text('-'), findsOneWidget);
  });

  testWidgets('MovieCard should handle null overview gracefully', (
    WidgetTester tester,
  ) async {
    final movieWithNullOverview = Movie(
      adult: false,
      backdropPath: '/backdropPath.jpg',
      genreIds: const [1, 2, 3],
      id: 1,
      originalTitle: 'Original Title',
      overview: null,
      popularity: 7.8,
      posterPath: '/posterPath.jpg',
      releaseDate: '2020-01-01',
      title: 'Test Movie',
      video: false,
      voteAverage: 8.5,
      voteCount: 100,
    );

    await tester.pumpWidget(
      makeTestableWidget(MovieCard(movieWithNullOverview)),
    );

    expect(find.text('-'), findsOneWidget);
  });

  testWidgets('MovieCard should display with correct layout structure', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(makeTestableWidget(MovieCard(tMovie)));

    expect(find.byType(Container), findsWidgets);
    expect(find.byType(Card), findsOneWidget);
    expect(find.byType(Stack), findsWidgets);
    expect(find.byType(ClipRRect), findsOneWidget);
  });
}
