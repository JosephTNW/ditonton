import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:core/utils/failure.dart';
import 'package:core/utils/state_enum.dart';
import 'package:movies/domain/entities/movie.dart';
import 'package:movies/domain/usecases/search_movies.dart';
import 'package:movies/presentation/bloc/movie_search_bloc.dart';
import 'package:movies/presentation/bloc/movie_search_event.dart';
import 'package:movies/presentation/bloc/movie_search_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'movie_search_bloc_test.mocks.dart';

@GenerateMocks([SearchMovies])
void main() {
  late MovieSearchBloc bloc;
  late MockSearchMovies mockSearchMovies;

  setUp(() {
    mockSearchMovies = MockSearchMovies();
    bloc = MovieSearchBloc(searchMovies: mockSearchMovies);
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
  const tQuery = 'spiderman';

  group('OnQueryChanged', () {
    test('initial state should be empty', () {
      expect(bloc.state, const MovieSearchState());
      expect(bloc.state.state, RequestState.Empty);
    });

    blocTest<MovieSearchBloc, MovieSearchState>(
      'should emit [Loading, Loaded] when data is gotten successfully',
      build: () {
        when(
          mockSearchMovies.execute(tQuery),
        ).thenAnswer((_) async => Right(tMovieList));
        return bloc;
      },
      act: (bloc) => bloc.add(const OnQueryChanged(tQuery)),
      wait: const Duration(milliseconds: 600),
      expect:
          () => [
            const MovieSearchState(state: RequestState.Loading),
            MovieSearchState(
              state: RequestState.Loaded,
              searchResult: tMovieList,
            ),
          ],
      verify: (_) {
        verify(mockSearchMovies.execute(tQuery));
      },
    );

    blocTest<MovieSearchBloc, MovieSearchState>(
      'should emit [Loading, Error] when get search is unsuccessful',
      build: () {
        when(
          mockSearchMovies.execute(tQuery),
        ).thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
        return bloc;
      },
      act: (bloc) => bloc.add(const OnQueryChanged(tQuery)),
      wait: const Duration(milliseconds: 600),
      expect:
          () => [
            const MovieSearchState(state: RequestState.Loading),
            const MovieSearchState(
              state: RequestState.Error,
              message: 'Server Failure',
            ),
          ],
      verify: (_) {
        verify(mockSearchMovies.execute(tQuery));
      },
    );
  });

  group('Event Props', () {
    test('OnQueryChanged props should contain query', () {
      const event = OnQueryChanged('spiderman');
      expect(event.props, ['spiderman']);
    });
  });

  group('State Props and CopyWith', () {
    test('MovieSearchState props should contain all fields', () {
      final movie = Movie(
        adult: false,
        backdropPath: 'backdropPath',
        genreIds: const [1],
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

      final state = MovieSearchState(
        searchResult: [movie],
        state: RequestState.Loaded,
        message: 'test',
      );

      expect(state.props, [
        [movie],
        RequestState.Loaded,
        'test',
      ]);
    });

    test('copyWith should update only provided fields', () {
      const state1 = MovieSearchState(message: 'old message');
      final state2 = state1.copyWith(message: 'new message');

      expect(state2.message, 'new message');
      expect(state2.searchResult, state1.searchResult);
      expect(state2.state, state1.state);
    });
  });
}
