import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:core/data/models/genre_model.dart';
import 'package:tv/data/models/tv_detail_response.dart';
import 'package:tv/data/models/tv_model.dart';
import 'package:tv/data/repositories/tv_repository_impl.dart';
import 'package:core/utils/exception.dart';
import 'package:core/utils/failure.dart';
import 'package:tv/domain/entities/tv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../test/dummy_data/dummy_tv_objects.dart';
import '../../../test/helpers/test_helper.mocks.dart';

void main() {
  late TvRepositoryImpl repository;
  late MockTvRemoteDataSource mockRemoteDataSource;
  late MockTvLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockTvRemoteDataSource();
    mockLocalDataSource = MockTvLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = TvRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  final tTvModel = TvModel(
    adult: false,
    backdropPath: '/path.jpg',
    genreIds: [18, 80],
    id: 1,
    originCountry: ['US'],
    originalLanguage: 'en',
    originalName: 'Test TV Show',
    overview: 'Test overview',
    popularity: 100.0,
    posterPath: '/poster.jpg',
    firstAirDate: '2023-01-01',
    name: 'Test TV Show',
    voteAverage: 8.5,
    voteCount: 1000,
  );

  final tTv = Tv(
    adult: false,
    backdropPath: '/path.jpg',
    genreIds: [18, 80],
    id: 1,
    originCountry: ['US'],
    originalLanguage: 'en',
    originalName: 'Test TV Show',
    overview: 'Test overview',
    popularity: 100.0,
    posterPath: '/poster.jpg',
    firstAirDate: '2023-01-01',
    name: 'Test TV Show',
    voteAverage: 8.5,
    voteCount: 1000,
  );

  final tTvDetailResponse = TvDetailResponse(
    adult: false,
    backdropPath: '/path.jpg',
    episodeRunTime: [45, 50],
    firstAirDate: '2023-01-01',
    genres: [GenreModel(id: 18, name: 'Drama')],
    homepage: 'https://test.com',
    id: 1,
    inProduction: true,
    languages: ['en'],
    lastAirDate: '2023-12-31',
    name: 'Test TV Show',
    numberOfEpisodes: 10,
    numberOfSeasons: 1,
    originalLanguage: 'en',
    originalName: 'Test TV Show',
    overview: 'Test overview',
    popularity: 100.0,
    posterPath: '/poster.jpg',
    status: 'Returning Series',
    tagline: 'Test tagline',
    voteAverage: 8.5,
    voteCount: 1000,
  );

  final tTvModelList = <TvModel>[tTvModel];
  final tTvList = <Tv>[tTv];

  group('On The Air TVs', () {
    test('should check if the device is online', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemoteDataSource.getNowPlayingTvs()).thenAnswer((_) async => []);

      await repository.getOnTheAirTvs();

      verify(mockNetworkInfo.isConnected);
    });

    group('when device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test(
        'should return remote data when call to remote data source is successful',
        () async {
          when(
            mockRemoteDataSource.getNowPlayingTvs(),
          ).thenAnswer((_) async => tTvModelList);

          final result = await repository.getOnTheAirTvs();

          verify(mockRemoteDataSource.getNowPlayingTvs());
          final resultList = result.getOrElse(() => []);
          expect(resultList, tTvList);
        },
      );

      test(
        'should cache data locally when call to remote data source is successful',
        () async {
          when(
            mockRemoteDataSource.getNowPlayingTvs(),
          ).thenAnswer((_) async => tTvModelList);

          await repository.getOnTheAirTvs();

          verify(mockRemoteDataSource.getNowPlayingTvs());
          verify(mockLocalDataSource.cacheOnTheAirTvs([testTvCache]));
        },
      );

      test(
        'should return server failure when call to remote data source is unsuccessful',
        () async {
          when(
            mockRemoteDataSource.getNowPlayingTvs(),
          ).thenThrow(ServerException());

          final result = await repository.getOnTheAirTvs();

          verify(mockRemoteDataSource.getNowPlayingTvs());
          expect(result, equals(Left(ServerFailure(''))));
        },
      );
    });

    group('when device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      test('should return cached data when device is offline', () async {
        when(
          mockLocalDataSource.getCachedOnTheAirTvs(),
        ).thenAnswer((_) async => [testTvCache]);

        final result = await repository.getOnTheAirTvs();

        verify(mockLocalDataSource.getCachedOnTheAirTvs());
        final resultList = result.getOrElse(() => []);
        expect(resultList, [testTvCache.toEntity()]);
      });

      test('should return CacheFailure when app has no cache', () async {
        when(
          mockLocalDataSource.getCachedOnTheAirTvs(),
        ).thenThrow(CacheException('No Cache'));

        final result = await repository.getOnTheAirTvs();

        verify(mockLocalDataSource.getCachedOnTheAirTvs());
        expect(result, Left(CacheFailure('No Cache')));
      });
    });
  });

  group('Popular TVs', () {
    test('should return tv list when call to data source is success', () async {
      when(
        mockRemoteDataSource.getPopularTvs(),
      ).thenAnswer((_) async => tTvModelList);

      final result = await repository.getPopularTvs();

      final resultList = result.getOrElse(() => []);
      expect(resultList, tTvList);
    });

    test(
      'should return server failure when call to data source is unsuccessful',
      () async {
        when(mockRemoteDataSource.getPopularTvs()).thenThrow(ServerException());

        final result = await repository.getPopularTvs();

        expect(result, Left(ServerFailure('')));
      },
    );

    test(
      'should return connection failure when device is not connected',
      () async {
        when(
          mockRemoteDataSource.getPopularTvs(),
        ).thenThrow(SocketException('Failed to connect'));

        final result = await repository.getPopularTvs();

        expect(
          result,
          Left(ConnectionFailure('Failed to connect to the network')),
        );
      },
    );
  });

  group('Top Rated TVs', () {
    test(
      'should return tv list when call to data source is successful',
      () async {
        when(
          mockRemoteDataSource.getTopRatedTvs(),
        ).thenAnswer((_) async => tTvModelList);

        final result = await repository.getTopRatedTvs();

        final resultList = result.getOrElse(() => []);
        expect(resultList, tTvList);
      },
    );

    test(
      'should return ServerFailure when call to data source is unsuccessful',
      () async {
        when(
          mockRemoteDataSource.getTopRatedTvs(),
        ).thenThrow(ServerException());

        final result = await repository.getTopRatedTvs();

        expect(result, equals(Left(ServerFailure(''))));
      },
    );

    test(
      'should return ConnectionFailure when device is not connected',
      () async {
        when(
          mockRemoteDataSource.getTopRatedTvs(),
        ).thenThrow(SocketException('Failed to connect'));

        final result = await repository.getTopRatedTvs();

        expect(
          result,
          Left(ConnectionFailure('Failed to connect to the network')),
        );
      },
    );
  });

  group('Get TV Detail', () {
    final tId = 1;

    test(
      'should return TV data when call to remote data source is successful',
      () async {
        when(
          mockRemoteDataSource.getTvDetail(tId),
        ).thenAnswer((_) async => tTvDetailResponse);

        final result = await repository.getTvDetail(tId);

        verify(mockRemoteDataSource.getTvDetail(tId));
        expect(result, equals(Right(testTvDetail)));
      },
    );

    test(
      'should return Server Failure when call to remote data source is unsuccessful',
      () async {
        when(
          mockRemoteDataSource.getTvDetail(tId),
        ).thenThrow(ServerException());

        final result = await repository.getTvDetail(tId);

        verify(mockRemoteDataSource.getTvDetail(tId));
        expect(result, equals(Left(ServerFailure(''))));
      },
    );

    test(
      'should return connection failure when device is not connected',
      () async {
        when(
          mockRemoteDataSource.getTvDetail(tId),
        ).thenThrow(SocketException('Failed to connect'));

        final result = await repository.getTvDetail(tId);

        verify(mockRemoteDataSource.getTvDetail(tId));
        expect(
          result,
          Left(ConnectionFailure('Failed to connect to the network')),
        );
      },
    );
  });

  group('Get TV Recommendations', () {
    final tId = 1;

    test(
      'should return list when call to remote data source is successful',
      () async {
        when(
          mockRemoteDataSource.getTvRecommendations(tId),
        ).thenAnswer((_) async => tTvModelList);

        final result = await repository.getTvRecommendations(tId);

        verify(mockRemoteDataSource.getTvRecommendations(tId));
        final resultList = result.getOrElse(() => []);
        expect(resultList, equals(tTvList));
      },
    );

    test(
      'should return server failure when call to remote data source is unsuccessful',
      () async {
        when(
          mockRemoteDataSource.getTvRecommendations(tId),
        ).thenThrow(ServerException());

        final result = await repository.getTvRecommendations(tId);

        verify(mockRemoteDataSource.getTvRecommendations(tId));
        expect(result, equals(Left(ServerFailure(''))));
      },
    );

    test(
      'should return connection failure when device is not connected',
      () async {
        when(
          mockRemoteDataSource.getTvRecommendations(tId),
        ).thenThrow(SocketException('Failed to connect'));

        final result = await repository.getTvRecommendations(tId);

        verify(mockRemoteDataSource.getTvRecommendations(tId));
        expect(
          result,
          Left(ConnectionFailure('Failed to connect to the network')),
        );
      },
    );
  });

  group('Search TVs', () {
    final tQuery = 'Breaking Bad';

    test(
      'should return tv list when call to data source is successful',
      () async {
        when(
          mockRemoteDataSource.searchTvs(tQuery),
        ).thenAnswer((_) async => tTvModelList);

        final result = await repository.searchTvs(tQuery);

        final resultList = result.getOrElse(() => []);
        expect(resultList, tTvList);
      },
    );

    test(
      'should return ServerFailure when call to data source is unsuccessful',
      () async {
        when(
          mockRemoteDataSource.searchTvs(tQuery),
        ).thenThrow(ServerException());

        final result = await repository.searchTvs(tQuery);

        expect(result, Left(ServerFailure('')));
      },
    );

    test(
      'should return ConnectionFailure when device is not connected',
      () async {
        when(
          mockRemoteDataSource.searchTvs(tQuery),
        ).thenThrow(SocketException('Failed to connect'));

        final result = await repository.searchTvs(tQuery);

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
        mockLocalDataSource.insertWatchlist(testTvTable),
      ).thenAnswer((_) async => 'Added to Watchlist');

      final result = await repository.saveWatchlist(testTvDetail);

      expect(result, Right('Added to Watchlist'));
    });

    test('should return DatabaseFailure when saving unsuccessful', () async {
      when(
        mockLocalDataSource.insertWatchlist(testTvTable),
      ).thenThrow(DatabaseException('Failed to add watchlist'));

      final result = await repository.saveWatchlist(testTvDetail);

      expect(result, Left(DatabaseFailure('Failed to add watchlist')));
    });
  });

  group('remove watchlist', () {
    test('should return success message when remove successful', () async {
      when(
        mockLocalDataSource.removeWatchlist(testTvTable),
      ).thenAnswer((_) async => 'Removed from Watchlist');

      final result = await repository.removeWatchlist(testTvDetail);

      expect(result, Right('Removed from Watchlist'));
    });

    test('should return DatabaseFailure when remove unsuccessful', () async {
      when(
        mockLocalDataSource.removeWatchlist(testTvTable),
      ).thenThrow(DatabaseException('Failed to remove watchlist'));

      final result = await repository.removeWatchlist(testTvDetail);

      expect(result, Left(DatabaseFailure('Failed to remove watchlist')));
    });
  });

  group('get watchlist status', () {
    test('should return watch status whether data is found', () async {
      final tId = 1;
      when(mockLocalDataSource.getTvById(tId)).thenAnswer((_) async => null);

      final result = await repository.isAddedToWatchlist(tId);

      expect(result, false);
    });
  });

  group('get watchlist tvs', () {
    test('should return list of TVs', () async {
      when(
        mockLocalDataSource.getWatchlistTvs(),
      ).thenAnswer((_) async => [testTvTable]);

      final result = await repository.getWatchlistTvs();

      final resultList = result.getOrElse(() => []);
      expect(resultList, [testWatchlistTv]);
    });
  });
}
