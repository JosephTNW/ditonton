import 'package:core/data/datasources/db/database_helper.dart';
import 'package:movies/data/models/movie_table.dart';
import 'package:tv/data/models/tv_table.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../../../dummy_data/movies/dummy_objects.dart';
import '../../../dummy_data/tv/dummy_tv_objects.dart';

void main() {
  late DatabaseHelper databaseHelper;

  setUpAll(() {
    sqfliteFfiInit();

    databaseFactory = databaseFactoryFfi;
  });

  setUp(() async {
    databaseHelper = DatabaseHelper();

    final db = await databaseHelper.database;

    if (db != null) {
      await db.delete('movieWatchlist');
      await db.delete('movieCache');
      await db.delete('tvWatchlist');
      await db.delete('tvCache');
    }
  });

  group('Movie Watchlist Operations - Real Database', () {
    test('insertWatchlist should insert movie and return row id', () async {
      final result = await databaseHelper.insertWatchlist(testMovieTable);

      expect(result, isA<int>());
      expect(result, greaterThan(0));
    });

    test('insertWatchlist should persist movie in database', () async {
      await databaseHelper.insertWatchlist(testMovieTable);

      final result = await databaseHelper.getMovieById(testMovieTable.id);

      expect(result, isNotNull);
      expect(result!['id'], testMovieTable.id);
      expect(result['title'], testMovieTable.title);
      expect(result['overview'], testMovieTable.overview);
      expect(result['posterPath'], testMovieTable.posterPath);
    });

    test('removeWatchlist should delete movie from database', () async {
      await databaseHelper.insertWatchlist(testMovieTable);

      final deleteResult = await databaseHelper.removeWatchlist(testMovieTable);
      final getResult = await databaseHelper.getMovieById(testMovieTable.id);

      expect(deleteResult, 1);
      expect(getResult, isNull);
    });

    test('getMovieById should return null when movie does not exist', () async {
      final result = await databaseHelper.getMovieById(9999);

      expect(result, isNull);
    });

    test(
      'getWatchlistMovies should return empty list when no movies',
      () async {
        final result = await databaseHelper.getWatchlistMovies();

        expect(result, isEmpty);
      },
    );

    test('getWatchlistMovies should return all watchlist movies', () async {
      final movie1 = testMovieTable;
      final movie2 = MovieTable(
        id: 2,
        title: 'Movie 2',
        posterPath: '/path2.jpg',
        overview: 'Overview 2',
      );

      await databaseHelper.insertWatchlist(movie1);
      await databaseHelper.insertWatchlist(movie2);

      final result = await databaseHelper.getWatchlistMovies();

      expect(result.length, 2);
      expect(result[0]['id'], movie1.id);
      expect(result[1]['id'], movie2.id);
    });

    test('insertWatchlist should not insert duplicate movies', () async {
      await databaseHelper.insertWatchlist(testMovieTable);

      try {
        await databaseHelper.insertWatchlist(testMovieTable);
        fail('Should throw exception for duplicate primary key');
      } catch (e) {
        expect(e, isA<Exception>());
      }
    });
  });

  group('Movie Cache Operations - Real Database', () {
    test('insertCacheTransaction should insert movies with category', () async {
      final movies = [testMovieCache];
      final category = 'now playing';

      await databaseHelper.insertCacheTransaction(movies, category);
      final result = await databaseHelper.getCacheMovies(category);

      expect(result.length, 1);
      expect(result[0]['id'], testMovieCache.id);
      expect(result[0]['title'], testMovieCache.title);
      expect(result[0]['category'], category);
    });

    test('insertCacheTransaction should handle multiple movies', () async {
      final movies = [
        testMovieCache,
        MovieTable(
          id: 2,
          title: 'Movie 2',
          posterPath: '/path2.jpg',
          overview: 'Overview 2',
        ),
        MovieTable(
          id: 3,
          title: 'Movie 3',
          posterPath: '/path3.jpg',
          overview: 'Overview 3',
        ),
      ];
      final category = 'popular';

      await databaseHelper.insertCacheTransaction(movies, category);
      final result = await databaseHelper.getCacheMovies(category);

      expect(result.length, 3);
      expect(result[0]['category'], category);
      expect(result[1]['category'], category);
      expect(result[2]['category'], category);
    });

    test(
      'insertCacheTransaction should replace existing movies with same id',
      () async {
        final movies1 = [
          MovieTable(
            id: 1,
            title: 'Original',
            posterPath: '/path.jpg',
            overview: 'Original overview',
          ),
        ];
        final movies2 = [
          MovieTable(
            id: 1,
            title: 'Updated',
            posterPath: '/path2.jpg',
            overview: 'Updated overview',
          ),
        ];
        final category = 'popular';

        await databaseHelper.insertCacheTransaction(movies1, category);
        await databaseHelper.insertCacheTransaction(movies2, category);
        final result = await databaseHelper.getCacheMovies(category);

        expect(result.length, 1);
        expect(result[0]['title'], 'Updated');
        expect(result[0]['overview'], 'Updated overview');
      },
    );

    test('getCacheMovies should filter by category', () async {
      final nowPlayingMovies = [testMovieCache];
      final popularMovies = [
        MovieTable(
          id: 2,
          title: 'Popular Movie',
          posterPath: '/path.jpg',
          overview: 'Overview',
        ),
      ];

      await databaseHelper.insertCacheTransaction(
        nowPlayingMovies,
        'now playing',
      );
      await databaseHelper.insertCacheTransaction(popularMovies, 'popular');

      final nowPlayingResult = await databaseHelper.getCacheMovies(
        'now playing',
      );
      final popularResult = await databaseHelper.getCacheMovies('popular');

      expect(nowPlayingResult.length, 1);
      expect(nowPlayingResult[0]['id'], testMovieCache.id);

      expect(popularResult.length, 1);
      expect(popularResult[0]['id'], 2);
    });

    test('clearCache should delete movies by category', () async {
      final nowPlayingMovies = [testMovieCache];
      final popularMovies = [
        MovieTable(
          id: 2,
          title: 'Popular Movie',
          posterPath: '/path.jpg',
          overview: 'Overview',
        ),
      ];

      await databaseHelper.insertCacheTransaction(
        nowPlayingMovies,
        'now playing',
      );
      await databaseHelper.insertCacheTransaction(popularMovies, 'popular');

      final deleteCount = await databaseHelper.clearCache('now playing');
      final nowPlayingResult = await databaseHelper.getCacheMovies(
        'now playing',
      );
      final popularResult = await databaseHelper.getCacheMovies('popular');

      expect(deleteCount, 1);
      expect(nowPlayingResult, isEmpty);
      expect(popularResult.length, 1);
    });

    test(
      'getCacheMovies should return empty list for non-existent category',
      () async {
        final result = await databaseHelper.getCacheMovies('non-existent');

        expect(result, isEmpty);
      },
    );
  });

  group('TV Watchlist Operations - Real Database', () {
    test(
      'insertTvToWatchlist should insert TV show and return row id',
      () async {
        final result = await databaseHelper.insertTvToWatchlist(testTvTable);

        expect(result, isA<int>());
        expect(result, greaterThan(0));
      },
    );

    test('insertTvToWatchlist should persist TV show in database', () async {
      await databaseHelper.insertTvToWatchlist(testTvTable);

      final result = await databaseHelper.getTvById(testTvTable.id);

      expect(result, isNotNull);
      expect(result!['id'], testTvTable.id);
      expect(result['name'], testTvTable.name);
      expect(result['overview'], testTvTable.overview);
      expect(result['posterPath'], testTvTable.posterPath);
    });

    test('removeTvFromWatchlist should delete TV show from database', () async {
      await databaseHelper.insertTvToWatchlist(testTvTable);

      final deleteResult = await databaseHelper.removeTvFromWatchlist(
        testTvTable,
      );
      final getResult = await databaseHelper.getTvById(testTvTable.id);

      expect(deleteResult, 1);
      expect(getResult, isNull);
    });

    test('getTvById should return null when TV show does not exist', () async {
      final result = await databaseHelper.getTvById(9999);

      expect(result, isNull);
    });

    test('getWatchlistTvs should return empty list when no TV shows', () async {
      final result = await databaseHelper.getWatchlistTvs();

      expect(result, isEmpty);
    });

    test('getWatchlistTvs should return all watchlist TV shows', () async {
      final tv1 = testTvTable;
      final tv2 = TvTable(
        id: 2,
        name: 'TV Show 2',
        posterPath: '/path2.jpg',
        overview: 'Overview 2',
      );

      await databaseHelper.insertTvToWatchlist(tv1);
      await databaseHelper.insertTvToWatchlist(tv2);

      final result = await databaseHelper.getWatchlistTvs();

      expect(result.length, 2);
      expect(result[0]['id'], tv1.id);
      expect(result[1]['id'], tv2.id);
    });

    test('insertTvToWatchlist should not insert duplicate TV shows', () async {
      await databaseHelper.insertTvToWatchlist(testTvTable);

      try {
        await databaseHelper.insertTvToWatchlist(testTvTable);
        fail('Should throw exception for duplicate primary key');
      } catch (e) {
        expect(e, isA<Exception>());
      }
    });
  });

  group('TV Cache Operations - Real Database', () {
    test(
      'insertTvCacheTransaction should insert TV shows with category',
      () async {
        final tvShows = [testTvCache];
        final category = 'on the air';

        await databaseHelper.insertTvCacheTransaction(tvShows, category);
        final result = await databaseHelper.getCacheTvs(category);

        expect(result.length, 1);
        expect(result[0]['id'], testTvCache.id);
        expect(result[0]['name'], testTvCache.name);
        expect(result[0]['category'], category);
      },
    );

    test('insertTvCacheTransaction should handle multiple TV shows', () async {
      final tvShows = [
        testTvCache,
        TvTable(
          id: 2,
          name: 'TV Show 2',
          posterPath: '/path2.jpg',
          overview: 'Overview 2',
        ),
        TvTable(
          id: 3,
          name: 'TV Show 3',
          posterPath: '/path3.jpg',
          overview: 'Overview 3',
        ),
      ];
      final category = 'popular';

      await databaseHelper.insertTvCacheTransaction(tvShows, category);
      final result = await databaseHelper.getCacheTvs(category);

      expect(result.length, 3);
      expect(result[0]['category'], category);
      expect(result[1]['category'], category);
      expect(result[2]['category'], category);
    });

    test(
      'insertTvCacheTransaction should replace existing TV shows with same id',
      () async {
        final tvShows1 = [
          TvTable(
            id: 1,
            name: 'Original',
            posterPath: '/path.jpg',
            overview: 'Original overview',
          ),
        ];
        final tvShows2 = [
          TvTable(
            id: 1,
            name: 'Updated',
            posterPath: '/path2.jpg',
            overview: 'Updated overview',
          ),
        ];
        final category = 'popular';

        await databaseHelper.insertTvCacheTransaction(tvShows1, category);
        await databaseHelper.insertTvCacheTransaction(tvShows2, category);
        final result = await databaseHelper.getCacheTvs(category);

        expect(result.length, 1);
        expect(result[0]['name'], 'Updated');
        expect(result[0]['overview'], 'Updated overview');
      },
    );

    test('getCacheTvs should filter by category', () async {
      final onTheAirShows = [testTvCache];
      final popularShows = [
        TvTable(
          id: 2,
          name: 'Popular TV Show',
          posterPath: '/path.jpg',
          overview: 'Overview',
        ),
      ];

      await databaseHelper.insertTvCacheTransaction(
        onTheAirShows,
        'on the air',
      );
      await databaseHelper.insertTvCacheTransaction(popularShows, 'popular');

      final onTheAirResult = await databaseHelper.getCacheTvs('on the air');
      final popularResult = await databaseHelper.getCacheTvs('popular');

      expect(onTheAirResult.length, 1);
      expect(onTheAirResult[0]['id'], testTvCache.id);

      expect(popularResult.length, 1);
      expect(popularResult[0]['id'], 2);
    });

    test('clearTvCache should delete TV shows by category', () async {
      final onTheAirShows = [testTvCache];
      final popularShows = [
        TvTable(
          id: 2,
          name: 'Popular TV Show',
          posterPath: '/path.jpg',
          overview: 'Overview',
        ),
      ];

      await databaseHelper.insertTvCacheTransaction(
        onTheAirShows,
        'on the air',
      );
      await databaseHelper.insertTvCacheTransaction(popularShows, 'popular');

      final deleteCount = await databaseHelper.clearTvCache('on the air');
      final onTheAirResult = await databaseHelper.getCacheTvs('on the air');
      final popularResult = await databaseHelper.getCacheTvs('popular');

      expect(deleteCount, 1);
      expect(onTheAirResult, isEmpty);
      expect(popularResult.length, 1);
    });

    test(
      'getCacheTvs should return empty list for non-existent category',
      () async {
        final result = await databaseHelper.getCacheTvs('non-existent');

        expect(result, isEmpty);
      },
    );
  });

  group('Integration Tests - Mixed Operations', () {
    test('should handle movies and TV shows independently', () async {
      await databaseHelper.insertWatchlist(testMovieTable);
      await databaseHelper.insertTvToWatchlist(testTvTable);

      final movies = await databaseHelper.getWatchlistMovies();
      final tvShows = await databaseHelper.getWatchlistTvs();

      expect(movies.length, 1);
      expect(tvShows.length, 1);
      expect(movies[0]['id'], testMovieTable.id);
      expect(tvShows[0]['id'], testTvTable.id);
    });

    test('should handle cache and watchlist independently', () async {
      await databaseHelper.insertWatchlist(testMovieTable);
      await databaseHelper.insertCacheTransaction([testMovieCache], 'popular');

      final watchlist = await databaseHelper.getWatchlistMovies();
      final cache = await databaseHelper.getCacheMovies('popular');

      expect(watchlist.length, 1);
      expect(cache.length, 1);

      await databaseHelper.clearCache('popular');
      final watchlistAfter = await databaseHelper.getWatchlistMovies();
      final cacheAfter = await databaseHelper.getCacheMovies('popular');

      expect(watchlistAfter.length, 1);
      expect(cacheAfter, isEmpty);
    });

    test('should handle null values in optional fields', () async {
      final movieWithNulls = MovieTable(
        id: 999,
        title: 'Test Movie',
        posterPath: null,
        overview: null,
      );

      await databaseHelper.insertWatchlist(movieWithNulls);
      final result = await databaseHelper.getMovieById(999);

      expect(result, isNotNull);
      expect(result!['id'], 999);
      expect(result['title'], 'Test Movie');
      expect(result['posterPath'], isNull);
      expect(result['overview'], isNull);
    });
  });
}
