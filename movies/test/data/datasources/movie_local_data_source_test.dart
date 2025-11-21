import 'package:core/utils/exception.dart';
import 'package:movies/data/datasources/movie_local_data_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';
import '../../dummy_data/dummy_objects.dart';

void main() {
  late MovieLocalDataSourceImpl dataSource;
  late MockDatabaseHelper mockDatabaseHelper;

  setUp(() {
    mockDatabaseHelper = MockDatabaseHelper();
    dataSource = MovieLocalDataSourceImpl(databaseHelper: mockDatabaseHelper);
  });

  group('save watchlist', () {
    test(
      'should return success message when insert to database is success',
      () async {
        when(
          mockDatabaseHelper.insertWatchlist(testMovieTable),
        ).thenAnswer((_) async => 1);

        final result = await dataSource.insertWatchlist(testMovieTable);

        expect(result, 'Added to Watchlist');
      },
    );

    test(
      'should throw DatabaseException when insert to database is failed',
      () async {
        when(
          mockDatabaseHelper.insertWatchlist(testMovieTable),
        ).thenThrow(Exception());

        final call = dataSource.insertWatchlist(testMovieTable);

        expect(() => call, throwsA(isA<DatabaseException>()));
      },
    );
  });

  group('remove watchlist', () {
    test(
      'should return success message when remove from database is success',
      () async {
        when(
          mockDatabaseHelper.removeWatchlist(testMovieTable),
        ).thenAnswer((_) async => 1);

        final result = await dataSource.removeWatchlist(testMovieTable);

        expect(result, 'Removed from Watchlist');
      },
    );

    test(
      'should throw DatabaseException when remove from database is failed',
      () async {
        when(
          mockDatabaseHelper.removeWatchlist(testMovieTable),
        ).thenThrow(Exception());

        final call = dataSource.removeWatchlist(testMovieTable);

        expect(() => call, throwsA(isA<DatabaseException>()));
      },
    );
  });

  group('Get Movie Detail By Id', () {
    final tId = 1;

    test('should return Movie Detail Table when data is found', () async {
      when(
        mockDatabaseHelper.getMovieById(tId),
      ).thenAnswer((_) async => testMovieMap);

      final result = await dataSource.getMovieById(tId);

      expect(result, testMovieTable);
    });

    test('should return null when data is not found', () async {
      when(mockDatabaseHelper.getMovieById(tId)).thenAnswer((_) async => null);

      final result = await dataSource.getMovieById(tId);

      expect(result, null);
    });
  });

  group('get watchlist movies', () {
    test('should return list of MovieTable from database', () async {
      when(
        mockDatabaseHelper.getWatchlistMovies(),
      ).thenAnswer((_) async => [testMovieMap]);

      final result = await dataSource.getWatchlistMovies();

      expect(result, [testMovieTable]);
    });
  });

  group('cache now playing movies', () {
    test('should call database helper to save data', () async {
      when(
        mockDatabaseHelper.clearCache('now playing'),
      ).thenAnswer((_) async => 1);

      await dataSource.cacheNowPlayingMovies([testMovieCache]);

      verify(mockDatabaseHelper.clearCache('now playing'));
      verify(
        mockDatabaseHelper.insertCacheTransaction([
          testMovieCache,
        ], 'now playing'),
      );
    });

    test('should return list of movies when data is cached', () async {
      when(
        mockDatabaseHelper.getCacheMovies('now playing'),
      ).thenAnswer((_) async => [testMovieMap]);

      final result = await dataSource.getCachedNowPlayingMovies();

      expect(result, [testMovieTable]);
    });

    test('should throw CacheException when cache data is not found', () async {
      when(
        mockDatabaseHelper.getCacheMovies('now playing'),
      ).thenAnswer((_) async => []);

      final call = dataSource.getCachedNowPlayingMovies();

      await expectLater(call, completes);
    });
  });
}
