import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:core/data/models/genre_model.dart';
import 'package:movies/data/models/movie_detail_model.dart';
import 'package:movies/data/models/movie_model.dart';
import 'package:movies/data/repositories/movie_repository_impl.dart';
import 'package:core/utils/exception.dart';
import 'package:core/utils/failure.dart';
import 'package:movies/domain/entities/movie.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../../test/helpers/test_helper.mocks.dart';

void main() {
  late MovieRepositoryImpl repository;
  late MockMovieRemoteDataSource mockRemoteDataSource;
  late MockMovieLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockMovieRemoteDataSource();
    mockLocalDataSource = MockMovieLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = MovieRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  final tMovieModel = MovieModel(
    adult: false,
    backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
    genreIds: [14, 28],
    id: 557,
    originalTitle: 'Spider-Man',
    overview:
        'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
    popularity: 60.441,
    posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
    releaseDate: '2002-05-01',
    title: 'Spider-Man',
    video: false,
    voteAverage: 7.2,
    voteCount: 13507,
  );

  final tMovie = Movie(
    adult: false,
    backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
    genreIds: [14, 28],
    id: 557,
    originalTitle: 'Spider-Man',
    overview:
        'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
    popularity: 60.441,
    posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
    releaseDate: '2002-05-01',
    title: 'Spider-Man',
    video: false,
    voteAverage: 7.2,
    voteCount: 13507,
  );

  final testMovieCacheMap = {
    'id': 557,
    'overview':
        'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
    'posterPath': '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
    'title': 'Spider-Man',
  };

  final tMovieModelList = <MovieModel>[tMovieModel];
  final tMovieList = <Movie>[tMovie];

  group('Now Playing Movies', () {
    setUp(() {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
    });
    test('should check if the device is online', () async {
      when(
        mockRemoteDataSource.getNowPlayingMovies(),
      ).thenAnswer((_) async => []);

      await repository.getNowPlayingMovies();

      verify(mockNetworkInfo.isConnected);
    });

    group('when device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        test(
          'should return remote data when the call to remote data source is successful',
          () async {
            when(
              mockRemoteDataSource.getNowPlayingMovies(),
            ).thenAnswer((_) async => tMovieModelList);

            final result = await repository.getNowPlayingMovies();

            verify(mockRemoteDataSource.getNowPlayingMovies());
            /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
            final resultList = result.getOrElse(() => []);
            expect(resultList, tMovieList);
          },
        );

        test(
          'should cache data locally when the call to remote data source is successful',
          () async {
            when(
              mockRemoteDataSource.getNowPlayingMovies(),
            ).thenAnswer((_) async => tMovieModelList);

            await repository.getNowPlayingMovies();

            verify(mockRemoteDataSource.getNowPlayingMovies());
            verify(mockLocalDataSource.cacheNowPlayingMovies([testMovieCache]));
          },
        );

        test(
          'should return server failure when the call to remote data source is unsuccessful',
          () async {
            when(
              mockRemoteDataSource.getNowPlayingMovies(),
            ).thenThrow(ServerException());

            final result = await repository.getNowPlayingMovies();

            verify(mockRemoteDataSource.getNowPlayingMovies());
            expect(result, equals(Left(ServerFailure(''))));
          },
        );

        test(
          'should return connection failure when device has no internet connection',
          () async {
            when(
              mockRemoteDataSource.getNowPlayingMovies(),
            ).thenThrow(SocketException('Failed to connect to the network'));

            final result = await repository.getNowPlayingMovies();

            verify(mockRemoteDataSource.getNowPlayingMovies());
            expect(
              result,
              equals(
                Left(ConnectionFailure('Failed to connect to the network')),
              ),
            );
          },
        );
      });
    });

    group('when device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      test('should return cached data when device is offline', () async {
        when(
          mockLocalDataSource.getCachedNowPlayingMovies(),
        ).thenAnswer((_) async => [testMovieCache]);

        final result = await repository.getNowPlayingMovies();

        verify(mockLocalDataSource.getCachedNowPlayingMovies());
        final resultList = result.getOrElse(() => []);
        expect(resultList, [testMovieCache.toEntity()]);
      });
      test(
        'should return connection failure when the device is not connected to internet',
        () async {
          when(
            mockLocalDataSource.getCachedNowPlayingMovies(),
          ).thenThrow(CacheException('No Cache'));

          final result = await repository.getNowPlayingMovies();

          verify(mockLocalDataSource.getCachedNowPlayingMovies());
          expect(result, equals(Left(CacheFailure('No Cache'))));
        },
      );

      test('should return CacheFailure when app has no cache', () async {
        when(
          mockLocalDataSource.getCachedNowPlayingMovies(),
        ).thenThrow(CacheException('No Cache'));

        final result = await repository.getNowPlayingMovies();

        verify(mockLocalDataSource.getCachedNowPlayingMovies());
        expect(result, Left(CacheFailure('No Cache')));
      });
    });
  });

  group('Popular Movies', () {
    test(
      'should return movie list when call to data source is success',
      () async {
        when(
          mockRemoteDataSource.getPopularMovies(),
        ).thenAnswer((_) async => tMovieModelList);

        final result = await repository.getPopularMovies();

        /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
        final resultList = result.getOrElse(() => []);
        expect(resultList, tMovieList);
      },
    );

    test(
      'should return server failure when call to data source is unsuccessful',
      () async {
        when(
          mockRemoteDataSource.getPopularMovies(),
        ).thenThrow(ServerException());

        final result = await repository.getPopularMovies();

        expect(result, Left(ServerFailure('')));
      },
    );

    test(
      'should return connection failure when device is not connected to the internet',
      () async {
        when(
          mockRemoteDataSource.getPopularMovies(),
        ).thenThrow(SocketException('Failed to connect to the network'));

        final result = await repository.getPopularMovies();

        expect(
          result,
          Left(ConnectionFailure('Failed to connect to the network')),
        );
      },
    );
  });

  group('Top Rated Movies', () {
    test(
      'should return movie list when call to data source is successful',
      () async {
        when(
          mockRemoteDataSource.getTopRatedMovies(),
        ).thenAnswer((_) async => tMovieModelList);

        final result = await repository.getTopRatedMovies();

        /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
        final resultList = result.getOrElse(() => []);
        expect(resultList, tMovieList);
      },
    );

    test(
      'should return ServerFailure when call to data source is unsuccessful',
      () async {
        when(
          mockRemoteDataSource.getTopRatedMovies(),
        ).thenThrow(ServerException());

        final result = await repository.getTopRatedMovies();

        expect(result, Left(ServerFailure('')));
      },
    );

    test(
      'should return ConnectionFailure when device is not connected to the internet',
      () async {
        when(
          mockRemoteDataSource.getTopRatedMovies(),
        ).thenThrow(SocketException('Failed to connect to the network'));

        final result = await repository.getTopRatedMovies();

        expect(
          result,
          Left(ConnectionFailure('Failed to connect to the network')),
        );
      },
    );
  });

  group('Get Movie Detail', () {
    final tId = 1;
    final tMovieResponse = MovieDetailResponse(
      adult: false,
      backdropPath: 'backdropPath',
      budget: 100,
      genres: [GenreModel(id: 1, name: 'Action')],
      homepage: "https://google.com",
      id: 1,
      imdbId: 'imdb1',
      originalLanguage: 'en',
      originalTitle: 'originalTitle',
      overview: 'overview',
      popularity: 1,
      posterPath: 'posterPath',
      releaseDate: 'releaseDate',
      revenue: 12000,
      runtime: 120,
      status: 'Status',
      tagline: 'Tagline',
      title: 'title',
      video: false,
      voteAverage: 1,
      voteCount: 1,
    );

    test(
      'should return Movie data when the call to remote data source is successful',
      () async {
        when(
          mockRemoteDataSource.getMovieDetail(tId),
        ).thenAnswer((_) async => tMovieResponse);

        final result = await repository.getMovieDetail(tId);

        verify(mockRemoteDataSource.getMovieDetail(tId));
        expect(result, equals(Right(testMovieDetail)));
      },
    );

    test(
      'should return Server Failure when the call to remote data source is unsuccessful',
      () async {
        when(
          mockRemoteDataSource.getMovieDetail(tId),
        ).thenThrow(ServerException());

        final result = await repository.getMovieDetail(tId);

        verify(mockRemoteDataSource.getMovieDetail(tId));
        expect(result, equals(Left(ServerFailure(''))));
      },
    );

    test(
      'should return connection failure when the device is not connected to internet',
      () async {
        when(
          mockRemoteDataSource.getMovieDetail(tId),
        ).thenThrow(SocketException('Failed to connect to the network'));

        final result = await repository.getMovieDetail(tId);

        verify(mockRemoteDataSource.getMovieDetail(tId));
        expect(
          result,
          equals(Left(ConnectionFailure('Failed to connect to the network'))),
        );
      },
    );
  });

  group('Get Movie Recommendations', () {
    final tMovieList = <MovieModel>[];
    final tId = 1;

    test('should return data (movie list) when the call is successful', () async {
      when(
        mockRemoteDataSource.getMovieRecommendations(tId),
      ).thenAnswer((_) async => tMovieList);

      final result = await repository.getMovieRecommendations(tId);

      verify(mockRemoteDataSource.getMovieRecommendations(tId));
      /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
      final resultList = result.getOrElse(() => []);
      expect(resultList, equals(tMovieList));
    });

    test(
      'should return server failure when call to remote data source is unsuccessful',
      () async {
        when(
          mockRemoteDataSource.getMovieRecommendations(tId),
        ).thenThrow(ServerException());

        final result = await repository.getMovieRecommendations(tId);

        verify(mockRemoteDataSource.getMovieRecommendations(tId));
        expect(result, equals(Left(ServerFailure(''))));
      },
    );

    test(
      'should return connection failure when the device is not connected to the internet',
      () async {
        when(
          mockRemoteDataSource.getMovieRecommendations(tId),
        ).thenThrow(SocketException('Failed to connect to the network'));

        final result = await repository.getMovieRecommendations(tId);

        verify(mockRemoteDataSource.getMovieRecommendations(tId));
        expect(
          result,
          equals(Left(ConnectionFailure('Failed to connect to the network'))),
        );
      },
    );
  });

  group('Seach Movies', () {
    final tQuery = 'spiderman';

    test(
      'should return movie list when call to data source is successful',
      () async {
        when(
          mockRemoteDataSource.searchMovies(tQuery),
        ).thenAnswer((_) async => tMovieModelList);

        final result = await repository.searchMovies(tQuery);

        /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
        final resultList = result.getOrElse(() => []);
        expect(resultList, tMovieList);
      },
    );

    test(
      'should return ServerFailure when call to data source is unsuccessful',
      () async {
        when(
          mockRemoteDataSource.searchMovies(tQuery),
        ).thenThrow(ServerException());

        final result = await repository.searchMovies(tQuery);

        expect(result, Left(ServerFailure('')));
      },
    );

    test(
      'should return ConnectionFailure when device is not connected to the internet',
      () async {
        when(
          mockRemoteDataSource.searchMovies(tQuery),
        ).thenThrow(SocketException('Failed to connect to the network'));

        final result = await repository.searchMovies(tQuery);

        expect(
          result,
          Left(ConnectionFailure('Failed to connect to the network')),
        );
      },
    );
  });

  group('save watchlist', () {
    test('should return success message when saving successful', () async {
      when(
        mockLocalDataSource.insertWatchlist(testMovieTable),
      ).thenAnswer((_) async => 'Added to Watchlist');

      final result = await repository.saveWatchlist(testMovieDetail);

      expect(result, Right('Added to Watchlist'));
    });

    test('should return DatabaseFailure when saving unsuccessful', () async {
      when(
        mockLocalDataSource.insertWatchlist(testMovieTable),
      ).thenThrow(DatabaseException('Failed to add watchlist'));

      final result = await repository.saveWatchlist(testMovieDetail);

      expect(result, Left(DatabaseFailure('Failed to add watchlist')));
    });
  });

  group('remove watchlist', () {
    test('should return success message when remove successful', () async {
      when(
        mockLocalDataSource.removeWatchlist(testMovieTable),
      ).thenAnswer((_) async => 'Removed from watchlist');

      final result = await repository.removeWatchlist(testMovieDetail);

      expect(result, Right('Removed from watchlist'));
    });

    test('should return DatabaseFailure when remove unsuccessful', () async {
      when(
        mockLocalDataSource.removeWatchlist(testMovieTable),
      ).thenThrow(DatabaseException('Failed to remove watchlist'));

      final result = await repository.removeWatchlist(testMovieDetail);

      expect(result, Left(DatabaseFailure('Failed to remove watchlist')));
    });
  });

  group('get watchlist status', () {
    test('should return watch status whether data is found', () async {
      final tId = 1;
      when(mockLocalDataSource.getMovieById(tId)).thenAnswer((_) async => null);

      final result = await repository.isAddedToWatchlist(tId);

      expect(result, false);
    });
  });

  group('get watchlist movies', () {
    test('should return list of Movies', () async {
      when(
        mockLocalDataSource.getWatchlistMovies(),
      ).thenAnswer((_) async => [testMovieTable]);

      final result = await repository.getWatchlistMovies();

      final resultList = result.getOrElse(() => []);
      expect(resultList, [testWatchlistMovie]);
    });
  });
}
