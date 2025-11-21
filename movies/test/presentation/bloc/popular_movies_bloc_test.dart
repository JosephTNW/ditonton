import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:core/utils/failure.dart';
import 'package:core/utils/state_enum.dart';
import 'package:movies/domain/entities/movie.dart';
import 'package:movies/domain/usecases/get_popular_movies.dart';
import 'package:movies/presentation/bloc/popular_movies_bloc.dart';
import 'package:movies/presentation/bloc/popular_movies_event.dart';
import 'package:movies/presentation/bloc/popular_movies_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'popular_movies_bloc_test.mocks.dart';

@GenerateMocks([GetPopularMovies])
void main() {
  late PopularMoviesBloc bloc;
  late MockGetPopularMovies mockGetPopularMovies;

  setUp(() {
    mockGetPopularMovies = MockGetPopularMovies();
    bloc = PopularMoviesBloc(getPopularMovies: mockGetPopularMovies);
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

  group('FetchPopularMoviesEvent', () {
    test('initial state should be empty', () {
      expect(bloc.state, const PopularMoviesState());
      expect(bloc.state.state, RequestState.Empty);
    });

    blocTest<PopularMoviesBloc, PopularMoviesState>(
      'should emit [Loading, Loaded] when data is gotten successfully',
      build: () {
        when(
          mockGetPopularMovies.execute(),
        ).thenAnswer((_) async => Right(tMovieList));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchPopularMoviesEvent()),
      expect:
          () => [
            const PopularMoviesState(state: RequestState.Loading),
            PopularMoviesState(state: RequestState.Loaded, movies: tMovieList),
          ],
      verify: (_) {
        verify(mockGetPopularMovies.execute());
      },
    );

    blocTest<PopularMoviesBloc, PopularMoviesState>(
      'should emit [Loading, Error] when get data is unsuccessful',
      build: () {
        when(
          mockGetPopularMovies.execute(),
        ).thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchPopularMoviesEvent()),
      expect:
          () => [
            const PopularMoviesState(state: RequestState.Loading),
            const PopularMoviesState(
              state: RequestState.Error,
              message: 'Server Failure',
            ),
          ],
      verify: (_) {
        verify(mockGetPopularMovies.execute());
      },
    );
  });

  group('Event Props', () {
    test('FetchPopularMoviesEvent props should be empty', () {
      final event = FetchPopularMoviesEvent();
      expect(event.props, []);
    });
  });

  group('State Props and CopyWith', () {
    test('PopularMoviesState props should contain all fields', () {
      final state = PopularMoviesState(
        movies: tMovieList,
        state: RequestState.Loaded,
        message: 'test',
      );

      expect(state.props, [tMovieList, RequestState.Loaded, 'test']);
    });

    test('copyWith should update only provided fields', () {
      const state1 = PopularMoviesState(message: 'old message');
      final state2 = state1.copyWith(message: 'new message');

      expect(state2.message, 'new message');
      expect(state2.movies, state1.movies);
      expect(state2.state, state1.state);
    });
  });
}
