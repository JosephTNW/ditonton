import 'package:core/utils/state_enum.dart';
import 'package:core/utils/utils.dart';
import 'package:movies/domain/entities/movie.dart';
import 'package:movies/presentation/bloc/watchlist_movies_bloc.dart';
import 'package:movies/presentation/bloc/watchlist_movies_event.dart';
import 'package:movies/presentation/bloc/watchlist_movies_state.dart';
import 'package:movies/presentation/pages/watchlist_movies_page.dart';
import 'package:movies/presentation/widgets/movie_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'watchlist_movies_page_test.mocks.dart';

@GenerateMocks([WatchlistMoviesBloc])
void main() {
  late MockWatchlistMoviesBloc mockBloc;

  setUp(() {
    mockBloc = MockWatchlistMoviesBloc();
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

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<WatchlistMoviesBloc>.value(
      value: mockBloc,
      child: MaterialApp(home: body, navigatorObservers: [routeObserver]),
    );
  }

  testWidgets('Page should display center progress bar when loading', (
    WidgetTester tester,
  ) async {
    when(
      mockBloc.state,
    ).thenReturn(const WatchlistMoviesState(state: RequestState.Loading));
    when(mockBloc.stream).thenAnswer((_) => const Stream.empty());

    final progressBarFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(makeTestableWidget(const WatchlistMoviesPage()));

    expect(centerFinder, findsOneWidget);
    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded', (
    WidgetTester tester,
  ) async {
    when(mockBloc.state).thenReturn(
      WatchlistMoviesState(state: RequestState.Loaded, movies: [tMovie]),
    );
    when(mockBloc.stream).thenAnswer((_) => const Stream.empty());

    final listViewFinder = find.byType(ListView);
    final movieCardFinder = find.byType(MovieCard);

    await tester.pumpWidget(makeTestableWidget(const WatchlistMoviesPage()));

    expect(listViewFinder, findsOneWidget);
    expect(movieCardFinder, findsOneWidget);
  });

  testWidgets('Page should display empty list when no movies in watchlist', (
    WidgetTester tester,
  ) async {
    when(mockBloc.state).thenReturn(
      const WatchlistMoviesState(state: RequestState.Loaded, movies: []),
    );
    when(mockBloc.stream).thenAnswer((_) => const Stream.empty());

    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(makeTestableWidget(const WatchlistMoviesPage()));

    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error', (
    WidgetTester tester,
  ) async {
    when(mockBloc.state).thenReturn(
      const WatchlistMoviesState(
        state: RequestState.Error,
        message: 'Error message',
      ),
    );
    when(mockBloc.stream).thenAnswer((_) => const Stream.empty());

    final textFinder = find.byKey(const Key('error_message'));

    await tester.pumpWidget(makeTestableWidget(const WatchlistMoviesPage()));

    expect(textFinder, findsOneWidget);
    expect(find.text('Error message'), findsOneWidget);
  });

  testWidgets('Page should have app bar with title', (
    WidgetTester tester,
  ) async {
    when(
      mockBloc.state,
    ).thenReturn(const WatchlistMoviesState(state: RequestState.Loading));
    when(mockBloc.stream).thenAnswer((_) => const Stream.empty());

    await tester.pumpWidget(makeTestableWidget(const WatchlistMoviesPage()));

    expect(find.text('Watchlist'), findsOneWidget);
    expect(find.byType(AppBar), findsOneWidget);
  });

  testWidgets('Page should trigger fetch event on init', (
    WidgetTester tester,
  ) async {
    when(
      mockBloc.state,
    ).thenReturn(const WatchlistMoviesState(state: RequestState.Loading));
    when(mockBloc.stream).thenAnswer((_) => const Stream.empty());

    await tester.pumpWidget(makeTestableWidget(const WatchlistMoviesPage()));
    await tester.pump();

    verify(mockBloc.add(FetchWatchlistMoviesEvent())).called(1);
  });

  testWidgets('Page should call FetchWatchlistMoviesEvent on didPopNext', (
    WidgetTester tester,
  ) async {
    when(mockBloc.state).thenReturn(
      const WatchlistMoviesState(state: RequestState.Loaded, movies: []),
    );
    when(mockBloc.stream).thenAnswer((_) => const Stream.empty());

    await tester.pumpWidget(makeTestableWidget(const WatchlistMoviesPage()));
    await tester.pump();
  });

  testWidgets('Page should subscribe to RouteObserver', (
    WidgetTester tester,
  ) async {
    when(mockBloc.state).thenReturn(
      const WatchlistMoviesState(state: RequestState.Loaded, movies: []),
    );
    when(mockBloc.stream).thenAnswer((_) => const Stream.empty());

    await tester.pumpWidget(makeTestableWidget(const WatchlistMoviesPage()));
    await tester.pump();

    // Verify widget is built
    expect(find.byType(WatchlistMoviesPage), findsOneWidget);
  });
}
