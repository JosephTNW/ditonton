import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/utils/state_enum.dart';
import 'package:movies/domain/entities/movie.dart';
import 'package:movies/presentation/bloc/movie_list_bloc.dart';
import 'package:movies/presentation/bloc/movie_list_event.dart';
import 'package:movies/presentation/bloc/movie_list_state.dart';
import 'package:movies/presentation/pages/home_movie_page.dart';
import 'package:movies/presentation/pages/movie_detail_page.dart';
import 'package:movies/presentation/pages/now_playing_movies_page.dart';
import 'package:movies/presentation/pages/popular_movies_page.dart';
import 'package:movies/presentation/pages/search_page.dart';
import 'package:movies/presentation/pages/top_rated_movies_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'home_movie_page_test.mocks.dart';

@GenerateMocks([MovieListBloc])
void main() {
  late MockMovieListBloc mockBloc;

  setUp(() {
    mockBloc = MockMovieListBloc();
  });

  final tMovie = Movie(
    adult: false,
    backdropPath: '/backdropPath.jpg',
    genreIds: const [1, 2, 3],
    id: 1,
    originalTitle: 'Original Title',
    overview: 'Overview',
    popularity: 7.8,
    posterPath: '/posterPath.jpg',
    releaseDate: '2020-01-01',
    title: 'Test Movie',
    video: false,
    voteAverage: 8.5,
    voteCount: 100,
  );

  final tMovieList = [tMovie];

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<MovieListBloc>.value(
      value: mockBloc,
      child: MaterialApp(
        home: body,
        routes: {
          SearchPage.ROUTE_NAME:
              (context) => Scaffold(body: Text('Search Page')),
          NowPlayingMoviesPage.ROUTE_NAME:
              (context) => Scaffold(body: Text('Now Playing Page')),
          PopularMoviesPage.ROUTE_NAME:
              (context) => Scaffold(body: Text('Popular Page')),
          TopRatedMoviesPage.ROUTE_NAME:
              (context) => Scaffold(body: Text('Top Rated Page')),
          MovieDetailPage.ROUTE_NAME:
              (context) => Scaffold(body: Text('Detail Page')),
        },
      ),
    );
  }

  testWidgets('Page should trigger fetch events on init', (
    WidgetTester tester,
  ) async {
    when(mockBloc.state).thenReturn(const MovieListState());
    when(mockBloc.stream).thenAnswer((_) => const Stream.empty());

    await tester.pumpWidget(makeTestableWidget(const HomeMoviePage()));
    await tester.pump();

    verify(mockBloc.add(FetchNowPlayingMovies())).called(1);
    verify(mockBloc.add(FetchPopularMovies())).called(1);
    verify(mockBloc.add(FetchTopRatedMovies())).called(1);
  });

  testWidgets('Page should display progress bars when loading', (
    WidgetTester tester,
  ) async {
    when(mockBloc.state).thenReturn(
      const MovieListState(
        nowPlayingState: RequestState.Loading,
        popularMoviesState: RequestState.Loading,
        topRatedMoviesState: RequestState.Loading,
      ),
    );
    when(mockBloc.stream).thenAnswer((_) => const Stream.empty());

    await tester.pumpWidget(makeTestableWidget(const HomeMoviePage()));

    expect(find.byType(CircularProgressIndicator), findsNWidgets(3));
  });

  testWidgets('Page should display movie lists when data is loaded', (
    WidgetTester tester,
  ) async {
    when(mockBloc.state).thenReturn(
      MovieListState(
        nowPlayingState: RequestState.Loaded,
        nowPlayingMovies: tMovieList,
        popularMoviesState: RequestState.Loaded,
        popularMovies: tMovieList,
        topRatedMoviesState: RequestState.Loaded,
        topRatedMovies: tMovieList,
      ),
    );
    when(mockBloc.stream).thenAnswer((_) => const Stream.empty());

    await tester.pumpWidget(makeTestableWidget(const HomeMoviePage()));

    expect(find.byType(ListView), findsNWidgets(3));
    expect(find.byType(CachedNetworkImage), findsWidgets);
  });

  testWidgets('Page should display error text when error occurs', (
    WidgetTester tester,
  ) async {
    when(mockBloc.state).thenReturn(
      const MovieListState(
        nowPlayingState: RequestState.Error,
        popularMoviesState: RequestState.Error,
        topRatedMoviesState: RequestState.Error,
      ),
    );
    when(mockBloc.stream).thenAnswer((_) => const Stream.empty());

    await tester.pumpWidget(makeTestableWidget(const HomeMoviePage()));

    expect(find.text('Failed'), findsNWidgets(3));
  });

  testWidgets('Page should have app bar with title and search icon', (
    WidgetTester tester,
  ) async {
    when(mockBloc.state).thenReturn(const MovieListState());
    when(mockBloc.stream).thenAnswer((_) => const Stream.empty());

    await tester.pumpWidget(makeTestableWidget(const HomeMoviePage()));

    expect(find.text('Ditonton'), findsOneWidget);
    expect(find.byIcon(Icons.search), findsOneWidget);
    expect(find.byType(AppBar), findsOneWidget);
  });

  testWidgets('Page should navigate to search page when search icon tapped', (
    WidgetTester tester,
  ) async {
    when(mockBloc.state).thenReturn(const MovieListState());
    when(mockBloc.stream).thenAnswer((_) => const Stream.empty());

    await tester.pumpWidget(makeTestableWidget(const HomeMoviePage()));

    await tester.tap(find.byIcon(Icons.search));
    await tester.pumpAndSettle();

    expect(find.text('Search Page'), findsOneWidget);
  });

  testWidgets('Page should display "See More" buttons', (
    WidgetTester tester,
  ) async {
    when(mockBloc.state).thenReturn(const MovieListState());
    when(mockBloc.stream).thenAnswer((_) => const Stream.empty());

    await tester.pumpWidget(makeTestableWidget(const HomeMoviePage()));

    expect(find.text('See More'), findsNWidgets(3));
    expect(find.byIcon(Icons.arrow_forward_ios), findsNWidgets(3));
  });

  testWidgets('Page should navigate to now playing page when See More tapped', (
    WidgetTester tester,
  ) async {
    when(mockBloc.state).thenReturn(const MovieListState());
    when(mockBloc.stream).thenAnswer((_) => const Stream.empty());

    await tester.pumpWidget(makeTestableWidget(const HomeMoviePage()));

    final seeMoreButtons = find.text('See More');
    await tester.tap(seeMoreButtons.first);
    await tester.pumpAndSettle();

    expect(find.text('Now Playing Page'), findsOneWidget);
  });

  testWidgets('Page should navigate to popular page when See More tapped', (
    WidgetTester tester,
  ) async {
    when(mockBloc.state).thenReturn(const MovieListState());
    when(mockBloc.stream).thenAnswer((_) => const Stream.empty());

    await tester.pumpWidget(makeTestableWidget(const HomeMoviePage()));

    final seeMoreButtons = find.text('See More');
    await tester.tap(seeMoreButtons.at(1));
    await tester.pumpAndSettle();

    expect(find.text('Popular Page'), findsOneWidget);
  });

  testWidgets('Page should navigate to top rated page when See More tapped', (
    WidgetTester tester,
  ) async {
    when(mockBloc.state).thenReturn(const MovieListState());
    when(mockBloc.stream).thenAnswer((_) => const Stream.empty());

    await tester.pumpWidget(makeTestableWidget(const HomeMoviePage()));

    final seeMoreButtons = find.text('See More');
    await tester.tap(seeMoreButtons.at(2));
    await tester.pumpAndSettle();

    expect(find.text('Top Rated Page'), findsOneWidget);
  });

  testWidgets('MovieList should display movies horizontally', (
    WidgetTester tester,
  ) async {
    when(mockBloc.state).thenReturn(
      MovieListState(
        nowPlayingState: RequestState.Loaded,
        nowPlayingMovies: tMovieList,
      ),
    );
    when(mockBloc.stream).thenAnswer((_) => const Stream.empty());

    await tester.pumpWidget(makeTestableWidget(const HomeMoviePage()));

    final listView = tester.widget<ListView>(find.byType(ListView).first);
    expect(listView.scrollDirection, Axis.horizontal);
  });

  testWidgets('MovieList should navigate to detail page when movie tapped', (
    WidgetTester tester,
  ) async {
    when(mockBloc.state).thenReturn(
      MovieListState(
        nowPlayingState: RequestState.Loaded,
        nowPlayingMovies: tMovieList,
        popularMoviesState: RequestState.Loaded,
        popularMovies: [],
        topRatedMoviesState: RequestState.Loaded,
        topRatedMovies: [],
      ),
    );
    when(mockBloc.stream).thenAnswer((_) => const Stream.empty());

    await tester.pumpWidget(makeTestableWidget(const HomeMoviePage()));

    // Find InkWell inside the horizontal ListView (MovieList widget)
    final movieListInkWell = find.descendant(
      of: find.byType(ListView).first,
      matching: find.byType(InkWell),
    );
    await tester.tap(movieListInkWell.first);
    await tester.pumpAndSettle();

    expect(find.text('Detail Page'), findsOneWidget);
  });

  testWidgets('Page should display section titles', (
    WidgetTester tester,
  ) async {
    when(mockBloc.state).thenReturn(const MovieListState());
    when(mockBloc.stream).thenAnswer((_) => const Stream.empty());

    await tester.pumpWidget(makeTestableWidget(const HomeMoviePage()));

    expect(find.text('Now Playing'), findsOneWidget);
    expect(find.text('Popular'), findsOneWidget);
    expect(find.text('Top Rated'), findsOneWidget);
  });
}
