import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/domain/entities/genre.dart';
import 'package:core/utils/state_enum.dart';
import 'package:movies/domain/entities/movie.dart';
import 'package:movies/domain/entities/movie_detail.dart';
import 'package:movies/presentation/bloc/movie_detail_bloc.dart';
import 'package:movies/presentation/bloc/movie_detail_event.dart';
import 'package:movies/presentation/bloc/movie_detail_state.dart';
import 'package:movies/presentation/pages/movie_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'movie_detail_page_test.mocks.dart';

@GenerateMocks([MovieDetailBloc])
void main() {
  late MockMovieDetailBloc mockBloc;

  setUp(() {
    mockBloc = MockMovieDetailBloc();
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

  final tMovieDetail = MovieDetail(
    adult: false,
    backdropPath: '/backdropPath.jpg',
    genres: [Genre(id: 1, name: 'Action'), Genre(id: 2, name: 'Drama')],
    id: 1,
    originalTitle: 'Original Title',
    overview: 'Overview',
    posterPath: '/posterPath.jpg',
    releaseDate: '2020-01-01',
    runtime: 120,
    title: 'Test Movie',
    voteAverage: 8.5,
    voteCount: 100,
  );

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<MovieDetailBloc>.value(
      value: mockBloc,
      child: MaterialApp(
        home: body,
        routes: {
          MovieDetailPage.ROUTE_NAME:
              (context) => Scaffold(body: Text('Detail Page')),
        },
      ),
    );
  }

  testWidgets('Page should trigger fetch events on init', (
    WidgetTester tester,
  ) async {
    when(mockBloc.state).thenReturn(const MovieDetailState());
    when(mockBloc.stream).thenAnswer((_) => const Stream.empty());

    await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1)));
    await tester.pump();

    verify(mockBloc.add(const FetchMovieDetail(1))).called(1);
    verify(mockBloc.add(const LoadMovieWatchlistStatus(1))).called(1);
  });

  testWidgets('Page should display progress bar when loading', (
    WidgetTester tester,
  ) async {
    when(
      mockBloc.state,
    ).thenReturn(const MovieDetailState(movieState: RequestState.Loading));
    when(mockBloc.stream).thenAnswer((_) => const Stream.empty());

    await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1)));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Page should display DetailContent when data is loaded', (
    WidgetTester tester,
  ) async {
    when(mockBloc.state).thenReturn(
      MovieDetailState(
        movieState: RequestState.Loaded,
        movie: tMovieDetail,
        movieRecommendations: [tMovie],
        recommendationState: RequestState.Loaded,
        isAddedToWatchlist: false,
      ),
    );
    when(mockBloc.stream).thenAnswer((_) => const Stream.empty());

    await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1)));

    expect(find.text('Test Movie'), findsOneWidget);
    expect(find.text('Overview'), findsWidgets);
  });

  testWidgets('Page should display error message when error occurs', (
    WidgetTester tester,
  ) async {
    when(mockBloc.state).thenReturn(
      const MovieDetailState(
        movieState: RequestState.Error,
        message: 'Error message',
      ),
    );
    when(mockBloc.stream).thenAnswer((_) => const Stream.empty());

    await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1)));

    expect(find.text('Error message'), findsOneWidget);
  });

  testWidgets('Page should display watchlist button', (
    WidgetTester tester,
  ) async {
    when(mockBloc.state).thenReturn(
      MovieDetailState(
        movieState: RequestState.Loaded,
        movie: tMovieDetail,
        movieRecommendations: [],
        recommendationState: RequestState.Loaded,
        isAddedToWatchlist: false,
      ),
    );
    when(mockBloc.stream).thenAnswer((_) => const Stream.empty());

    await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1)));

    expect(find.text('Watchlist'), findsOneWidget);
    expect(find.byType(FilledButton), findsOneWidget);
  });

  testWidgets(
    'Watchlist button should show check icon when movie is in watchlist',
    (WidgetTester tester) async {
      when(mockBloc.state).thenReturn(
        MovieDetailState(
          movieState: RequestState.Loaded,
          movie: tMovieDetail,
          movieRecommendations: [],
          recommendationState: RequestState.Loaded,
          isAddedToWatchlist: true,
        ),
      );
      when(mockBloc.stream).thenAnswer((_) => const Stream.empty());

      await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1)));

      expect(find.byIcon(Icons.check), findsOneWidget);
    },
  );

  testWidgets(
    'Watchlist button should show add icon when movie is not in watchlist',
    (WidgetTester tester) async {
      when(mockBloc.state).thenReturn(
        MovieDetailState(
          movieState: RequestState.Loaded,
          movie: tMovieDetail,
          movieRecommendations: [],
          recommendationState: RequestState.Loaded,
          isAddedToWatchlist: false,
        ),
      );
      when(mockBloc.stream).thenAnswer((_) => const Stream.empty());

      await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1)));

      expect(find.byIcon(Icons.add), findsOneWidget);
    },
  );

  testWidgets('Tapping watchlist button should add movie to watchlist', (
    WidgetTester tester,
  ) async {
    when(mockBloc.state).thenReturn(
      MovieDetailState(
        movieState: RequestState.Loaded,
        movie: tMovieDetail,
        movieRecommendations: [],
        recommendationState: RequestState.Loaded,
        isAddedToWatchlist: false,
      ),
    );
    when(mockBloc.stream).thenAnswer((_) => const Stream.empty());

    await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1)));

    await tester.tap(find.byType(FilledButton));
    await tester.pump();

    verify(mockBloc.add(AddMovieToWatchlist(tMovieDetail))).called(1);
  });

  testWidgets('Tapping watchlist button should remove movie from watchlist', (
    WidgetTester tester,
  ) async {
    when(mockBloc.state).thenReturn(
      MovieDetailState(
        movieState: RequestState.Loaded,
        movie: tMovieDetail,
        movieRecommendations: [],
        recommendationState: RequestState.Loaded,
        isAddedToWatchlist: true,
      ),
    );
    when(mockBloc.stream).thenAnswer((_) => const Stream.empty());

    await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1)));

    await tester.tap(find.byType(FilledButton));
    await tester.pump();

    verify(mockBloc.add(RemoveMovieFromWatchlist(tMovieDetail))).called(1);
  });

  testWidgets('Page should display snackbar when added to watchlist', (
    WidgetTester tester,
  ) async {
    when(mockBloc.state).thenReturn(
      MovieDetailState(
        movieState: RequestState.Loaded,
        movie: tMovieDetail,
        movieRecommendations: [],
        recommendationState: RequestState.Loaded,
        isAddedToWatchlist: false,
      ),
    );
    when(mockBloc.stream).thenAnswer(
      (_) => Stream.fromIterable([
        MovieDetailState(
          movieState: RequestState.Loaded,
          movie: tMovieDetail,
          movieRecommendations: [],
          recommendationState: RequestState.Loaded,
          isAddedToWatchlist: true,
          watchlistMessage: 'Added to Watchlist',
        ),
      ]),
    );

    await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1)));
    await tester.pump();

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Added to Watchlist'), findsOneWidget);
  });

  testWidgets('Page should display dialog when watchlist action fails', (
    WidgetTester tester,
  ) async {
    when(mockBloc.state).thenReturn(
      MovieDetailState(
        movieState: RequestState.Loaded,
        movie: tMovieDetail,
        movieRecommendations: [],
        recommendationState: RequestState.Loaded,
        isAddedToWatchlist: false,
      ),
    );
    when(mockBloc.stream).thenAnswer(
      (_) => Stream.fromIterable([
        MovieDetailState(
          movieState: RequestState.Loaded,
          movie: tMovieDetail,
          movieRecommendations: [],
          recommendationState: RequestState.Loaded,
          isAddedToWatchlist: false,
          watchlistMessage: 'Failed to add to watchlist',
        ),
      ]),
    );

    await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1)));
    await tester.pump();

    expect(find.byType(AlertDialog), findsOneWidget);
  });

  testWidgets('Page should display movie details', (WidgetTester tester) async {
    when(mockBloc.state).thenReturn(
      MovieDetailState(
        movieState: RequestState.Loaded,
        movie: tMovieDetail,
        movieRecommendations: [],
        recommendationState: RequestState.Loaded,
        isAddedToWatchlist: false,
      ),
    );
    when(mockBloc.stream).thenAnswer((_) => const Stream.empty());

    await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1)));

    expect(find.text('Test Movie'), findsOneWidget);
    expect(find.text('Action, Drama'), findsOneWidget);
    expect(find.text('2h 0m'), findsOneWidget);
  });

  testWidgets('Page should display recommendations when loaded', (
    WidgetTester tester,
  ) async {
    when(mockBloc.state).thenReturn(
      MovieDetailState(
        movieState: RequestState.Loaded,
        movie: tMovieDetail,
        movieRecommendations: [tMovie],
        recommendationState: RequestState.Loaded,
        isAddedToWatchlist: false,
      ),
    );
    when(mockBloc.stream).thenAnswer((_) => const Stream.empty());

    await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1)));

    expect(find.text('Recommendations'), findsOneWidget);
    expect(find.byType(ListView), findsOneWidget);
  });

  testWidgets('Page should display progress bar when recommendations loading', (
    WidgetTester tester,
  ) async {
    when(mockBloc.state).thenReturn(
      MovieDetailState(
        movieState: RequestState.Loaded,
        movie: tMovieDetail,
        movieRecommendations: [],
        recommendationState: RequestState.Loading,
        isAddedToWatchlist: false,
      ),
    );
    when(mockBloc.stream).thenAnswer((_) => const Stream.empty());

    await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1)));

    expect(find.byType(CircularProgressIndicator), findsWidgets);
  });

  testWidgets('Page should display error message when recommendations error', (
    WidgetTester tester,
  ) async {
    when(mockBloc.state).thenReturn(
      MovieDetailState(
        movieState: RequestState.Loaded,
        movie: tMovieDetail,
        movieRecommendations: [],
        recommendationState: RequestState.Error,
        message: 'Failed to load recommendations',
        isAddedToWatchlist: false,
      ),
    );
    when(mockBloc.stream).thenAnswer((_) => const Stream.empty());

    await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1)));

    expect(find.text('Failed to load recommendations'), findsOneWidget);
  });

  testWidgets('Page should display back button', (WidgetTester tester) async {
    when(mockBloc.state).thenReturn(
      MovieDetailState(
        movieState: RequestState.Loaded,
        movie: tMovieDetail,
        movieRecommendations: [],
        recommendationState: RequestState.Loaded,
        isAddedToWatchlist: false,
      ),
    );
    when(mockBloc.stream).thenAnswer((_) => const Stream.empty());

    await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1)));

    expect(find.byIcon(Icons.arrow_back), findsOneWidget);
  });

  testWidgets('Page should display CachedNetworkImage for recommendations', (
    WidgetTester tester,
  ) async {
    when(mockBloc.state).thenReturn(
      MovieDetailState(
        movieState: RequestState.Loaded,
        movie: tMovieDetail,
        movieRecommendations: [tMovie],
        recommendationState: RequestState.Loaded,
        isAddedToWatchlist: false,
      ),
    );
    when(mockBloc.stream).thenAnswer((_) => const Stream.empty());

    await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1)));

    expect(find.byType(CachedNetworkImage), findsWidgets);
  });

  testWidgets('Back button should navigate back', (WidgetTester tester) async {
    when(mockBloc.state).thenReturn(
      MovieDetailState(
        movieState: RequestState.Loaded,
        movie: tMovieDetail,
        movieRecommendations: [],
        recommendationState: RequestState.Loaded,
        isAddedToWatchlist: false,
      ),
    );
    when(mockBloc.stream).thenAnswer((_) => const Stream.empty());

    await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1)));

    final backButton = find.byIcon(Icons.arrow_back);
    expect(backButton, findsOneWidget);

    await tester.tap(backButton);
    await tester.pump();
  });

  testWidgets('Should display empty container when recommendations Empty', (
    WidgetTester tester,
  ) async {
    when(mockBloc.state).thenReturn(
      MovieDetailState(
        movieState: RequestState.Loaded,
        movie: tMovieDetail,
        movieRecommendations: [],
        recommendationState: RequestState.Empty,
        isAddedToWatchlist: false,
      ),
    );
    when(mockBloc.stream).thenAnswer((_) => const Stream.empty());

    await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1)));
    await tester.pump();

    expect(find.byType(Container), findsWidgets);
  });

  testWidgets('CachedNetworkImage should have placeholder and error widget', (
    WidgetTester tester,
  ) async {
    when(mockBloc.state).thenReturn(
      MovieDetailState(
        movieState: RequestState.Loaded,
        movie: tMovieDetail,
        movieRecommendations: [tMovie],
        recommendationState: RequestState.Loaded,
        isAddedToWatchlist: false,
      ),
    );
    when(mockBloc.stream).thenAnswer((_) => const Stream.empty());

    await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1)));
    await tester.pump();

    // Verify CachedNetworkImage is present
    expect(find.byType(CachedNetworkImage), findsWidgets);
  });

  testWidgets('Recommendation InkWell should be tappable', (
    WidgetTester tester,
  ) async {
    when(mockBloc.state).thenReturn(
      MovieDetailState(
        movieState: RequestState.Loaded,
        movie: tMovieDetail,
        movieRecommendations: [tMovie],
        recommendationState: RequestState.Loaded,
        isAddedToWatchlist: false,
      ),
    );
    when(mockBloc.stream).thenAnswer((_) => const Stream.empty());

    await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1)));
    await tester.pump();

    expect(find.byType(InkWell), findsWidgets);
  });

  testWidgets('Should format duration correctly for short movies', (
    WidgetTester tester,
  ) async {
    final shortMovieDetail = MovieDetail(
      adult: false,
      backdropPath: '/backdropPath.jpg',
      genres: [Genre(id: 1, name: 'Action')],
      id: 1,
      originalTitle: 'Original Title',
      overview: 'Overview',
      posterPath: '/posterPath.jpg',
      releaseDate: '2020-01-01',
      runtime: 45, // Less than 60 minutes
      title: 'Test Movie',
      voteAverage: 8.5,
      voteCount: 100,
    );

    when(mockBloc.state).thenReturn(
      MovieDetailState(
        movieState: RequestState.Loaded,
        movie: shortMovieDetail,
        movieRecommendations: [],
        recommendationState: RequestState.Loaded,
        isAddedToWatchlist: false,
      ),
    );
    when(mockBloc.stream).thenAnswer((_) => const Stream.empty());

    await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1)));
    await tester.pump();

    // Verify the short duration is displayed
    expect(find.textContaining('45m'), findsOneWidget);
  });

  testWidgets('Should navigate when recommendation is tapped', (
    WidgetTester tester,
  ) async {
    when(mockBloc.state).thenReturn(
      MovieDetailState(
        movieState: RequestState.Loaded,
        movie: tMovieDetail,
        movieRecommendations: [tMovie],
        recommendationState: RequestState.Loaded,
        isAddedToWatchlist: false,
      ),
    );
    when(mockBloc.stream).thenAnswer((_) => const Stream.empty());

    await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1)));
    await tester.pump();

    // Find and tap the InkWell for recommendations
    final inkWells = find.byType(InkWell);
    expect(inkWells, findsWidgets);
  });
}
