import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:core/utils/failure.dart';
import 'package:core/utils/state_enum.dart';
import 'package:movies/domain/entities/movie.dart';
import 'package:movies/domain/usecases/get_top_rated_movies.dart';
import 'package:movies/presentation/bloc/top_rated_movies_bloc.dart';
import 'package:movies/presentation/bloc/top_rated_movies_event.dart';
import 'package:movies/presentation/bloc/top_rated_movies_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'top_rated_movies_bloc_test.mocks.dart';

@GenerateMocks([GetTopRatedMovies])
void main() {
  late TopRatedMoviesBloc bloc;
  late MockGetTopRatedMovies mockGetTopRatedMovies;

  setUp(() {
    mockGetTopRatedMovies = MockGetTopRatedMovies();
    bloc = TopRatedMoviesBloc(getTopRatedMovies: mockGetTopRatedMovies);
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

  group('FetchTopRatedMovies', () {
    test('initial state should be empty', () {
      expect(bloc.state, const TopRatedMoviesState());
    });

    blocTest<TopRatedMoviesBloc, TopRatedMoviesState>(
      'should emit [Loading, Loaded] when data is gotten successfully',
      build: () {
        when(
          mockGetTopRatedMovies.execute(),
        ).thenAnswer((_) async => Right(tMovieList));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchTopRatedMoviesEvent()),
      expect:
          () => [
            const TopRatedMoviesState(state: RequestState.Loading),
            TopRatedMoviesState(state: RequestState.Loaded, movies: tMovieList),
          ],
      verify: (bloc) {
        verify(mockGetTopRatedMovies.execute());
      },
    );

    blocTest<TopRatedMoviesBloc, TopRatedMoviesState>(
      'should emit [Loading, Error] when get data is unsuccessful',
      build: () {
        when(
          mockGetTopRatedMovies.execute(),
        ).thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchTopRatedMoviesEvent()),
      expect:
          () => [
            const TopRatedMoviesState(state: RequestState.Loading),
            const TopRatedMoviesState(
              state: RequestState.Error,
              message: 'Server Failure',
            ),
          ],
      verify: (bloc) {
        verify(mockGetTopRatedMovies.execute());
      },
    );

    blocTest<TopRatedMoviesBloc, TopRatedMoviesState>(
      'should emit [Loading, Error] when connection fails',
      build: () {
        when(mockGetTopRatedMovies.execute()).thenAnswer(
          (_) async => const Left(ConnectionFailure('Failed to connect')),
        );
        return bloc;
      },
      act: (bloc) => bloc.add(FetchTopRatedMoviesEvent()),
      expect:
          () => [
            const TopRatedMoviesState(state: RequestState.Loading),
            const TopRatedMoviesState(
              state: RequestState.Error,
              message: 'Failed to connect',
            ),
          ],
      verify: (bloc) {
        verify(mockGetTopRatedMovies.execute());
      },
    );
  });

  group('Event Props', () {
    test('FetchTopRatedMoviesEvent props should be empty', () {
      final event = FetchTopRatedMoviesEvent();
      expect(event.props, []);
    });
  });

  group('State Props and CopyWith', () {
    test('TopRatedMoviesState props should contain all fields', () {
      final state = TopRatedMoviesState(
        movies: tMovieList,
        state: RequestState.Loaded,
        message: 'test',
      );

      expect(state.props, [tMovieList, RequestState.Loaded, 'test']);
    });

    test('copyWith should update only provided fields', () {
      const state1 = TopRatedMoviesState(message: 'old message');
      final state2 = state1.copyWith(message: 'new message');

      expect(state2.message, 'new message');
      expect(state2.movies, state1.movies);
      expect(state2.state, state1.state);
    });
  });
}
