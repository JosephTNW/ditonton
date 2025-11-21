import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:core/utils/failure.dart';
import 'package:core/utils/state_enum.dart';
import 'package:movies/domain/entities/movie.dart';
import 'package:movies/domain/usecases/get_watchlist_movies.dart';
import 'package:movies/presentation/bloc/watchlist_movies_bloc.dart';
import 'package:movies/presentation/bloc/watchlist_movies_event.dart';
import 'package:movies/presentation/bloc/watchlist_movies_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'watchlist_movies_bloc_test.mocks.dart';

@GenerateMocks([GetWatchlistMovies])
void main() {
  late WatchlistMoviesBloc bloc;
  late MockGetWatchlistMovies mockGetWatchlistMovies;

  setUp(() {
    mockGetWatchlistMovies = MockGetWatchlistMovies();
    bloc = WatchlistMoviesBloc(getWatchlistMovies: mockGetWatchlistMovies);
  });

  final tMovie = Movie(
    adult: false,
    backdropPath: 'backdropPath',
    genreIds: const [1, 2, 3],
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
  final tMovieList = <Movie>[tMovie];

  group('FetchWatchlistMovies', () {
    test('initial state should be empty', () {
      expect(bloc.state, const WatchlistMoviesState());
    });

    blocTest<WatchlistMoviesBloc, WatchlistMoviesState>(
      'should emit [Loading, Loaded] when data is gotten successfully',
      build: () {
        when(
          mockGetWatchlistMovies.execute(),
        ).thenAnswer((_) async => Right(tMovieList));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchWatchlistMoviesEvent()),
      expect:
          () => [
            const WatchlistMoviesState(state: RequestState.Loading),
            WatchlistMoviesState(
              state: RequestState.Loaded,
              movies: tMovieList,
            ),
          ],
      verify: (bloc) {
        verify(mockGetWatchlistMovies.execute());
      },
    );

    blocTest<WatchlistMoviesBloc, WatchlistMoviesState>(
      'should emit [Loading, Error] when get data is unsuccessful',
      build: () {
        when(mockGetWatchlistMovies.execute()).thenAnswer(
          (_) async => const Left(DatabaseFailure('Database Failure')),
        );
        return bloc;
      },
      act: (bloc) => bloc.add(FetchWatchlistMoviesEvent()),
      expect:
          () => [
            const WatchlistMoviesState(state: RequestState.Loading),
            const WatchlistMoviesState(
              state: RequestState.Error,
              message: 'Database Failure',
            ),
          ],
      verify: (bloc) {
        verify(mockGetWatchlistMovies.execute());
      },
    );

    blocTest<WatchlistMoviesBloc, WatchlistMoviesState>(
      'should emit [Loading, Loaded] with empty list when watchlist is empty',
      build: () {
        when(
          mockGetWatchlistMovies.execute(),
        ).thenAnswer((_) async => const Right([]));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchWatchlistMoviesEvent()),
      expect:
          () => [
            const WatchlistMoviesState(state: RequestState.Loading),
            const WatchlistMoviesState(state: RequestState.Loaded, movies: []),
          ],
      verify: (bloc) {
        verify(mockGetWatchlistMovies.execute());
      },
    );
  });

  group('Event Props', () {
    test('FetchWatchlistMoviesEvent props should be empty', () {
      final event = FetchWatchlistMoviesEvent();
      expect(event.props, []);
    });
  });

  group('State Props and CopyWith', () {
    test('WatchlistMoviesState props should contain all fields', () {
      final state = WatchlistMoviesState(
        movies: tMovieList,
        state: RequestState.Loaded,
        message: 'test',
      );

      expect(state.props, [tMovieList, RequestState.Loaded, 'test']);
    });

    test('copyWith should update only provided fields', () {
      const state1 = WatchlistMoviesState(message: 'old message');
      final state2 = state1.copyWith(message: 'new message');

      expect(state2.message, 'new message');
      expect(state2.movies, state1.movies);
      expect(state2.state, state1.state);
    });
  });
}
