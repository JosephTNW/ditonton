import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:core/utils/failure.dart';
import 'package:core/utils/state_enum.dart';
import 'package:movies/domain/entities/movie.dart';
import 'package:movies/domain/usecases/get_now_playing_movies.dart';
import 'package:movies/presentation/bloc/now_playing_movies_bloc.dart';
import 'package:movies/presentation/bloc/now_playing_movies_event.dart';
import 'package:movies/presentation/bloc/now_playing_movies_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'now_playing_movies_bloc_test.mocks.dart';

@GenerateMocks([GetNowPlayingMovies])
void main() {
  late NowPlayingMoviesBloc bloc;
  late MockGetNowPlayingMovies mockGetNowPlayingMovies;

  setUp(() {
    mockGetNowPlayingMovies = MockGetNowPlayingMovies();
    bloc = NowPlayingMoviesBloc(getNowPlayingMovies: mockGetNowPlayingMovies);
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

  group('FetchNowPlayingMovies', () {
    test('initial state should be empty', () {
      expect(bloc.state, const NowPlayingMoviesState());
    });

    blocTest<NowPlayingMoviesBloc, NowPlayingMoviesState>(
      'should emit [Loading, Loaded] when data is gotten successfully',
      build: () {
        when(
          mockGetNowPlayingMovies.execute(),
        ).thenAnswer((_) async => Right(tMovieList));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchNowPlayingMoviesEvent()),
      expect:
          () => [
            const NowPlayingMoviesState(state: RequestState.Loading),
            NowPlayingMoviesState(
              state: RequestState.Loaded,
              movies: tMovieList,
            ),
          ],
      verify: (bloc) {
        verify(mockGetNowPlayingMovies.execute());
      },
    );

    blocTest<NowPlayingMoviesBloc, NowPlayingMoviesState>(
      'should emit [Loading, Error] when get data is unsuccessful',
      build: () {
        when(
          mockGetNowPlayingMovies.execute(),
        ).thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchNowPlayingMoviesEvent()),
      expect:
          () => [
            const NowPlayingMoviesState(state: RequestState.Loading),
            const NowPlayingMoviesState(
              state: RequestState.Error,
              message: 'Server Failure',
            ),
          ],
      verify: (bloc) {
        verify(mockGetNowPlayingMovies.execute());
      },
    );

    blocTest<NowPlayingMoviesBloc, NowPlayingMoviesState>(
      'should emit [Loading, Error] when connection fails',
      build: () {
        when(mockGetNowPlayingMovies.execute()).thenAnswer(
          (_) async => const Left(ConnectionFailure('Failed to connect')),
        );
        return bloc;
      },
      act: (bloc) => bloc.add(FetchNowPlayingMoviesEvent()),
      expect:
          () => [
            const NowPlayingMoviesState(state: RequestState.Loading),
            const NowPlayingMoviesState(
              state: RequestState.Error,
              message: 'Failed to connect',
            ),
          ],
      verify: (bloc) {
        verify(mockGetNowPlayingMovies.execute());
      },
    );
  });

  group('Event Props', () {
    test('FetchNowPlayingMoviesEvent props should be empty', () {
      final event = FetchNowPlayingMoviesEvent();
      expect(event.props, []);
    });
  });

  group('State Props and CopyWith', () {
    test('NowPlayingMoviesState props should contain all fields', () {
      final state = NowPlayingMoviesState(
        movies: tMovieList,
        state: RequestState.Loaded,
        message: 'test',
      );

      expect(state.props, [tMovieList, RequestState.Loaded, 'test']);
    });

    test('copyWith should update only provided fields', () {
      const state1 = NowPlayingMoviesState(message: 'old message');
      final state2 = state1.copyWith(message: 'new message');

      expect(state2.message, 'new message');
      expect(state2.movies, state1.movies);
      expect(state2.state, state1.state);
    });
  });
}
