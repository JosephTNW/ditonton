import 'package:core/utils/exception.dart';
import 'package:tv/data/datasources/tv_local_data_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../test/dummy_data/dummy_tv_objects.dart';
import '../../../test/helpers/test_helper.mocks.dart';

void main() {
  late TvLocalDataSourceImpl dataSource;
  late MockDatabaseHelper mockDatabaseHelper;

  setUp(() {
    mockDatabaseHelper = MockDatabaseHelper();
    dataSource = TvLocalDataSourceImpl(databaseHelper: mockDatabaseHelper);
  });

  group('save watchlist', () {
    test(
      'should return success message when insert to database is success',
      () async {
        when(
          mockDatabaseHelper.insertTvToWatchlist(testTvTable),
        ).thenAnswer((_) async => 1);

        final result = await dataSource.insertWatchlist(testTvTable);

        expect(result, 'Added to Watchlist');
      },
    );

    test(
      'should throw DatabaseException when insert to database is failed',
      () async {
        when(
          mockDatabaseHelper.insertTvToWatchlist(testTvTable),
        ).thenThrow(Exception());

        final call = dataSource.insertWatchlist(testTvTable);

        expect(() => call, throwsA(isA<DatabaseException>()));
      },
    );
  });

  group('remove watchlist', () {
    test(
      'should return success message when remove from database is success',
      () async {
        when(
          mockDatabaseHelper.removeTvFromWatchlist(testTvTable),
        ).thenAnswer((_) async => 1);

        final result = await dataSource.removeWatchlist(testTvTable);

        expect(result, 'Removed from Watchlist');
      },
    );

    test(
      'should throw DatabaseException when remove from database is failed',
      () async {
        when(
          mockDatabaseHelper.removeTvFromWatchlist(testTvTable),
        ).thenThrow(Exception());

        final call = dataSource.removeWatchlist(testTvTable);

        expect(() => call, throwsA(isA<DatabaseException>()));
      },
    );
  });

  group('Get Tv Detail By Id', () {
    final tId = 1;

    test('should return Tv Detail Table when data is found', () async {
      when(
        mockDatabaseHelper.getTvById(tId),
      ).thenAnswer((_) async => testTvMap);

      final result = await dataSource.getTvById(tId);

      expect(result, testTvTable);
    });

    test('should return null when data is not found', () async {
      when(mockDatabaseHelper.getTvById(tId)).thenAnswer((_) async => null);

      final result = await dataSource.getTvById(tId);

      expect(result, null);
    });
  });

  group('get watchlist tvs', () {
    test('should return list of TvTable from database', () async {
      when(
        mockDatabaseHelper.getWatchlistTvs(),
      ).thenAnswer((_) async => [testTvMap]);

      final result = await dataSource.getWatchlistTvs();

      expect(result, [testTvTable]);
    });
  });

  group('cache on the air tvs', () {
    test('should call database helper to save data', () async {
      when(
        mockDatabaseHelper.clearTvCache('on the air'),
      ).thenAnswer((_) async => 1);

      await dataSource.cacheOnTheAirTvs([testTvCache]);

      verify(mockDatabaseHelper.clearTvCache('on the air'));
      verify(
        mockDatabaseHelper.insertTvCacheTransaction([
          testTvCache,
        ], 'on the air'),
      );
    });

    test('should return list of tvs if data is present', () async {
      when(
        mockDatabaseHelper.getCacheTvs('on the air'),
      ).thenAnswer((_) async => [testTvMap]);

      final result = await dataSource.getCachedOnTheAirTvs();

      expect(result, [testTvTable]);
    });
  });
}
