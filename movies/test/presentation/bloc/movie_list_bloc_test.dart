import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:core/utils/failure.dart';
import 'package:core/utils/state_enum.dart';
import 'package:movies/domain/entities/movie.dart';
import 'package:movies/domain/usecases/get_now_playing_movies.dart';
import 'package:movies/domain/usecases/get_popular_movies.dart';
import 'package:movies/domain/usecases/get_top_rated_movies.dart';
import 'package:movies/presentation/bloc/movie_list_bloc.dart';
import 'package:movies/presentation/bloc/movie_list_event.dart';
import 'package:movies/presentation/bloc/movie_list_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'movie_list_bloc_test.mocks.dart';

@GenerateMocks([GetNowPlayingMovies, GetPopularMovies, GetTopRatedMovies])
void main() {
  late MovieListBloc bloc;
  late MockGetNowPlayingMovies mockGetNowPlayingMovies;
  late MockGetPopularMovies mockGetPopularMovies;
  late MockGetTopRatedMovies mockGetTopRatedMovies;

  setUp(() {
    mockGetNowPlayingMovies = MockGetNowPlayingMovies();
    mockGetPopularMovies = MockGetPopularMovies();
    mockGetTopRatedMovies = MockGetTopRatedMovies();
    bloc = MovieListBloc(
      getNowPlayingMovies: mockGetNowPlayingMovies,
      getPopularMovies: mockGetPopularMovies,
      getTopRatedMovies: mockGetTopRatedMovies,
    );
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
      expect(bloc.state, const MovieListState());
      expect(bloc.state.nowPlayingState, RequestState.Empty);
    });

    blocTest<MovieListBloc, MovieListState>(
      'should emit [Loading, Loaded] when data is gotten successfully',
      build: () {
        when(
          mockGetNowPlayingMovies.execute(),
        ).thenAnswer((_) async => Right(tMovieList));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchNowPlayingMovies()),
      expect:
          () => [
            const MovieListState(nowPlayingState: RequestState.Loading),
            MovieListState(
              nowPlayingState: RequestState.Loaded,
              nowPlayingMovies: tMovieList,
            ),
          ],
      verify: (_) {
        verify(mockGetNowPlayingMovies.execute());
      },
    );

    blocTest<MovieListBloc, MovieListState>(
      'should emit [Loading, Error] when get data is unsuccessful',
      build: () {
        when(
          mockGetNowPlayingMovies.execute(),
        ).thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchNowPlayingMovies()),
      expect:
          () => [
            const MovieListState(nowPlayingState: RequestState.Loading),
            const MovieListState(
              nowPlayingState: RequestState.Error,
              message: 'Server Failure',
            ),
          ],
      verify: (_) {
        verify(mockGetNowPlayingMovies.execute());
      },
    );
  });

  group('FetchPopularMovies', () {
    blocTest<MovieListBloc, MovieListState>(
      'should emit [Loading, Loaded] when data is gotten successfully',
      build: () {
        when(
          mockGetPopularMovies.execute(),
        ).thenAnswer((_) async => Right(tMovieList));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchPopularMovies()),
      expect:
          () => [
            const MovieListState(popularMoviesState: RequestState.Loading),
            MovieListState(
              popularMoviesState: RequestState.Loaded,
              popularMovies: tMovieList,
            ),
          ],
      verify: (_) {
        verify(mockGetPopularMovies.execute());
      },
    );

    blocTest<MovieListBloc, MovieListState>(
      'should emit [Loading, Error] when get data is unsuccessful',
      build: () {
        when(
          mockGetPopularMovies.execute(),
        ).thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchPopularMovies()),
      expect:
          () => [
            const MovieListState(popularMoviesState: RequestState.Loading),
            const MovieListState(
              popularMoviesState: RequestState.Error,
              message: 'Server Failure',
            ),
          ],
      verify: (_) {
        verify(mockGetPopularMovies.execute());
      },
    );
  });

  group('FetchTopRatedMovies', () {
    blocTest<MovieListBloc, MovieListState>(
      'should emit [Loading, Loaded] when data is gotten successfully',
      build: () {
        when(
          mockGetTopRatedMovies.execute(),
        ).thenAnswer((_) async => Right(tMovieList));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchTopRatedMovies()),
      expect:
          () => [
            const MovieListState(topRatedMoviesState: RequestState.Loading),
            MovieListState(
              topRatedMoviesState: RequestState.Loaded,
              topRatedMovies: tMovieList,
            ),
          ],
      verify: (_) {
        verify(mockGetTopRatedMovies.execute());
      },
    );

    blocTest<MovieListBloc, MovieListState>(
      'should emit [Loading, Error] when get data is unsuccessful',
      build: () {
        when(
          mockGetTopRatedMovies.execute(),
        ).thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchTopRatedMovies()),
      expect:
          () => [
            const MovieListState(topRatedMoviesState: RequestState.Loading),
            const MovieListState(
              topRatedMoviesState: RequestState.Error,
              message: 'Server Failure',
            ),
          ],
      verify: (_) {
        verify(mockGetTopRatedMovies.execute());
      },
    );
  });

  group('Event Props', () {
    test('FetchNowPlayingMovies props should be empty', () {
      final event = FetchNowPlayingMovies();
      expect(event.props, []);
    });

    test('FetchPopularMovies props should be empty', () {
      final event = FetchPopularMovies();
      expect(event.props, []);
    });

    test('FetchTopRatedMovies props should be empty', () {
      final event = FetchTopRatedMovies();
      expect(event.props, []);
    });
  });
}
