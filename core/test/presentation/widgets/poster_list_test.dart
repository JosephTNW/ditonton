import 'package:movies/domain/entities/movie.dart';
import 'package:core/presentation/widgets/poster_list.dart';
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
    posterPath: '/posterPath.jpg',
    releaseDate: 'releaseDate',
    title: 'title',
    video: false,
    voteAverage: 1,
    voteCount: 1,
  );

  final tMovieList = [tMovie];

  Widget makeTestableWidget(Widget body) {
    return MaterialApp(
      home: Scaffold(body: body),
      routes: {'/detail': (context) => Scaffold(body: Text('Detail Page'))},
    );
  }

  testWidgets('PosterList should display ListView with items', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      makeTestableWidget(PosterList(items: tMovieList, routeName: '/detail')),
    );

    expect(find.byType(ListView), findsOneWidget);
  });


  testWidgets('PosterList should display ClipRRect for poster', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      makeTestableWidget(PosterList(items: tMovieList, routeName: '/detail')),
    );

    expect(find.byType(ClipRRect), findsOneWidget);
  });

  testWidgets('PosterList should display InkWell for tap handling', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      makeTestableWidget(PosterList(items: tMovieList, routeName: '/detail')),
    );

    expect(find.byType(InkWell), findsOneWidget);
  });

  testWidgets('PosterList should navigate when item is tapped', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      makeTestableWidget(PosterList(items: tMovieList, routeName: '/detail')),
    );

    await tester.tap(find.byType(InkWell));
    await tester.pumpAndSettle();

    expect(find.text('Detail Page'), findsOneWidget);
  });

  testWidgets('PosterList should display multiple items', (
    WidgetTester tester,
  ) async {
    final multipleMovies = [
      tMovie,
      Movie(
        adult: false,
        backdropPath: 'backdropPath2',
        genreIds: [1, 2],
        id: 2,
        originalTitle: 'originalTitle2',
        overview: 'overview2',
        popularity: 2,
        posterPath: '/posterPath2.jpg',
        releaseDate: 'releaseDate2',
        title: 'title2',
        video: false,
        voteAverage: 2,
        voteCount: 2,
      ),
    ];

    await tester.pumpWidget(
      makeTestableWidget(
        PosterList(items: multipleMovies, routeName: '/detail'),
      ),
    );

    expect(find.byType(InkWell), findsNWidgets(2));
  });

  testWidgets('PosterList should display empty list correctly', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      makeTestableWidget(PosterList(items: [], routeName: '/detail')),
    );

    expect(find.byType(ListView), findsOneWidget);
    expect(find.byType(InkWell), findsNothing);
  });

  testWidgets('PosterList should scroll horizontally', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      makeTestableWidget(PosterList(items: tMovieList, routeName: '/detail')),
    );

    final listView = tester.widget<ListView>(find.byType(ListView));
    expect(listView.scrollDirection, Axis.horizontal);
  });
}
