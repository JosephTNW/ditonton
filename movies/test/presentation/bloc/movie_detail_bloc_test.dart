import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:core/utils/failure.dart';
import 'package:core/utils/state_enum.dart';
import 'package:movies/domain/entities/movie.dart';
import 'package:movies/domain/usecases/get_movie_detail.dart';
import 'package:movies/domain/usecases/get_movie_recommendations.dart';
import 'package:movies/domain/usecases/get_movie_watchlist_status.dart';
import 'package:movies/domain/usecases/remove_watchlist_movie.dart';
import 'package:movies/domain/usecases/save_watchlist_movie.dart';
import 'package:movies/presentation/bloc/movie_detail_bloc.dart';
import 'package:movies/presentation/bloc/movie_detail_event.dart';
import 'package:movies/presentation/bloc/movie_detail_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/movies/dummy_objects.dart';
import 'movie_detail_bloc_test.mocks.dart';

@GenerateMocks([
  GetMovieDetail,
  GetMovieRecommendations,
  GetWatchListStatus,
  SaveWatchlistMovie,
  RemoveWatchlistMovie,
])
void main() {
  late MovieDetailBloc bloc;
  late MockGetMovieDetail mockGetMovieDetail;
  late MockGetMovieRecommendations mockGetMovieRecommendations;
  late MockGetWatchListStatus mockGetWatchListStatus;
  late MockSaveWatchlistMovie mockSaveWatchlistMovie;
  late MockRemoveWatchlistMovie mockRemoveWatchlistMovie;

  setUp(() {
    mockGetMovieDetail = MockGetMovieDetail();
    mockGetMovieRecommendations = MockGetMovieRecommendations();
    mockGetWatchListStatus = MockGetWatchListStatus();
    mockSaveWatchlistMovie = MockSaveWatchlistMovie();
    mockRemoveWatchlistMovie = MockRemoveWatchlistMovie();
    bloc = MovieDetailBloc(
      getMovieDetail: mockGetMovieDetail,
      getMovieRecommendations: mockGetMovieRecommendations,
      getWatchListStatus: mockGetWatchListStatus,
      saveWatchlist: mockSaveWatchlistMovie,
      removeWatchlist: mockRemoveWatchlistMovie,
    );
  });

  const tId = 1;

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

  group('FetchMovieDetail', () {
    test('initial state should be empty', () {
      expect(bloc.state, const MovieDetailState());
    });

    blocTest<MovieDetailBloc, MovieDetailState>(
      'should emit [Loading, Loaded] when data is gotten successfully',
      build: () {
        when(
          mockGetMovieDetail.execute(tId),
        ).thenAnswer((_) async => Right(testMovieDetail));
        when(
          mockGetMovieRecommendations.execute(tId),
        ).thenAnswer((_) async => Right(tMovieList));
        return bloc;
      },
      act: (bloc) => bloc.add(const FetchMovieDetail(tId)),
      expect:
          () => [
            const MovieDetailState(movieState: RequestState.Loading),
            MovieDetailState(
              movieState: RequestState.Loaded,
              movie: testMovieDetail,
              recommendationState: RequestState.Loading,
            ),
            MovieDetailState(
              movieState: RequestState.Loaded,
              movie: testMovieDetail,
              recommendationState: RequestState.Loaded,
              movieRecommendations: tMovieList,
            ),
          ],
      verify: (_) {
        verify(mockGetMovieDetail.execute(tId));
        verify(mockGetMovieRecommendations.execute(tId));
      },
    );

    blocTest<MovieDetailBloc, MovieDetailState>(
      'should emit [Loading, Error] when get detail is unsuccessful',
      build: () {
        when(
          mockGetMovieDetail.execute(tId),
        ).thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
        when(
          mockGetMovieRecommendations.execute(tId),
        ).thenAnswer((_) async => Right(tMovieList));
        return bloc;
      },
      act: (bloc) => bloc.add(const FetchMovieDetail(tId)),
      expect:
          () => [
            const MovieDetailState(movieState: RequestState.Loading),
            const MovieDetailState(
              movieState: RequestState.Error,
              message: 'Server Failure',
            ),
          ],
      verify: (_) {
        verify(mockGetMovieDetail.execute(tId));
      },
    );

    blocTest<MovieDetailBloc, MovieDetailState>(
      'should emit [Loading, Loaded, Error] when get recommendations is unsuccessful',
      build: () {
        when(
          mockGetMovieDetail.execute(tId),
        ).thenAnswer((_) async => Right(testMovieDetail));
        when(
          mockGetMovieRecommendations.execute(tId),
        ).thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
        return bloc;
      },
      act: (bloc) => bloc.add(const FetchMovieDetail(tId)),
      expect:
          () => [
            const MovieDetailState(movieState: RequestState.Loading),
            MovieDetailState(
              movie: testMovieDetail,
              movieState: RequestState.Loaded,
              recommendationState: RequestState.Loading,
            ),
            MovieDetailState(
              movie: testMovieDetail,
              movieState: RequestState.Loaded,
              recommendationState: RequestState.Error,
              message: 'Server Failure',
            ),
          ],
      verify: (_) {
        verify(mockGetMovieDetail.execute(tId));
        verify(mockGetMovieRecommendations.execute(tId));
      },
    );
  });

  group('LoadMovieWatchlistStatus', () {
    blocTest<MovieDetailBloc, MovieDetailState>(
      'should emit watchlist status true when movie is in watchlist',
      build: () {
        when(mockGetWatchListStatus.execute(tId)).thenAnswer((_) async => true);
        return bloc;
      },
      act: (bloc) => bloc.add(const LoadMovieWatchlistStatus(tId)),
      expect: () => [const MovieDetailState(isAddedToWatchlist: true)],
      verify: (_) {
        verify(mockGetWatchListStatus.execute(tId));
      },
    );

    blocTest<MovieDetailBloc, MovieDetailState>(
      'should emit watchlist status false when movie is not in watchlist',
      build: () {
        when(
          mockGetWatchListStatus.execute(tId),
        ).thenAnswer((_) async => false);
        return bloc;
      },
      act: (bloc) => bloc.add(const LoadMovieWatchlistStatus(tId)),
      expect: () => [const MovieDetailState(isAddedToWatchlist: false)],
      verify: (_) {
        verify(mockGetWatchListStatus.execute(tId));
      },
    );
  });

  group('AddMovieToWatchlist', () {
    blocTest<MovieDetailBloc, MovieDetailState>(
      'should emit success message when movie is added to watchlist',
      build: () {
        when(
          mockSaveWatchlistMovie.execute(testMovieDetail),
        ).thenAnswer((_) async => const Right('Added to Watchlist'));
        when(
          mockGetWatchListStatus.execute(testMovieDetail.id),
        ).thenAnswer((_) async => true);
        return bloc;
      },
      act: (bloc) => bloc.add(AddMovieToWatchlist(testMovieDetail)),
      expect:
          () => [
            const MovieDetailState(
              watchlistMessage: 'Added to Watchlist',
              isAddedToWatchlist: true,
            ),
          ],
      verify: (_) {
        verify(mockSaveWatchlistMovie.execute(testMovieDetail));
        verify(mockGetWatchListStatus.execute(testMovieDetail.id));
      },
    );

    blocTest<MovieDetailBloc, MovieDetailState>(
      'should emit failure message when add to watchlist fails',
      build: () {
        when(
          mockSaveWatchlistMovie.execute(testMovieDetail),
        ).thenAnswer((_) async => const Left(DatabaseFailure('Failed to add')));
        when(
          mockGetWatchListStatus.execute(testMovieDetail.id),
        ).thenAnswer((_) async => false);
        return bloc;
      },
      act: (bloc) => bloc.add(AddMovieToWatchlist(testMovieDetail)),
      expect:
          () => [
            const MovieDetailState(
              watchlistMessage: 'Failed to add',
              isAddedToWatchlist: false,
            ),
          ],
      verify: (_) {
        verify(mockSaveWatchlistMovie.execute(testMovieDetail));
        verify(mockGetWatchListStatus.execute(testMovieDetail.id));
      },
    );
  });

  group('RemoveMovieFromWatchlist', () {
    blocTest<MovieDetailBloc, MovieDetailState>(
      'should emit success message when movie is removed from watchlist',
      build: () {
        when(
          mockRemoveWatchlistMovie.execute(testMovieDetail),
        ).thenAnswer((_) async => const Right('Removed from Watchlist'));
        when(
          mockGetWatchListStatus.execute(testMovieDetail.id),
        ).thenAnswer((_) async => false);
        return bloc;
      },
      act: (bloc) => bloc.add(RemoveMovieFromWatchlist(testMovieDetail)),
      expect:
          () => [
            const MovieDetailState(
              watchlistMessage: 'Removed from Watchlist',
              isAddedToWatchlist: false,
            ),
          ],
      verify: (_) {
        verify(mockRemoveWatchlistMovie.execute(testMovieDetail));
        verify(mockGetWatchListStatus.execute(testMovieDetail.id));
      },
    );

    blocTest<MovieDetailBloc, MovieDetailState>(
      'should emit failure message when remove from watchlist fails',
      build: () {
        when(mockRemoveWatchlistMovie.execute(testMovieDetail)).thenAnswer(
          (_) async => const Left(DatabaseFailure('Failed to remove')),
        );
        when(
          mockGetWatchListStatus.execute(testMovieDetail.id),
        ).thenAnswer((_) async => true);
        return bloc;
      },
      act: (bloc) => bloc.add(RemoveMovieFromWatchlist(testMovieDetail)),
      expect:
          () => [
            const MovieDetailState(
              watchlistMessage: 'Failed to remove',
              isAddedToWatchlist: true,
            ),
          ],
      verify: (_) {
        verify(mockRemoveWatchlistMovie.execute(testMovieDetail));
        verify(mockGetWatchListStatus.execute(testMovieDetail.id));
      },
    );
  });

  group('Event Props', () {
    test('FetchMovieDetail props should contain id', () {
      const event = FetchMovieDetail(1);
      expect(event.props, [1]);
    });

    test('AddMovieToWatchlist props should contain movie', () {
      final event = AddMovieToWatchlist(testMovieDetail);
      expect(event.props, [testMovieDetail]);
    });

    test('RemoveMovieFromWatchlist props should contain movie', () {
      final event = RemoveMovieFromWatchlist(testMovieDetail);
      expect(event.props, [testMovieDetail]);
    });

    test('LoadMovieWatchlistStatus props should contain id', () {
      const event = LoadMovieWatchlistStatus(1);
      expect(event.props, [1]);
    });
  });
}
