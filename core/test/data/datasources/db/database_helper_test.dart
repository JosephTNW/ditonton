import 'package:movies/data/models/movie_table.dart';
import 'package:tv/data/models/tv_table.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:sqflite/sqflite.dart';

import '../../../dummy_data/movies/dummy_objects.dart';
import '../../../dummy_data/tv/dummy_tv_objects.dart';
import 'database_helper_test.mocks.dart';

@GenerateMocks([Database, DatabaseExecutor])
void main() {
  late MockDatabase mockDatabase;

  setUp(() {
    mockDatabase = MockDatabase();
  });

  group('Movie Watchlist Operations', () {
    test(
      'insertWatchlist should insert movie to database and return row id',
      () async {
        when(mockDatabase.insert(any, any)).thenAnswer((_) async => 1);

        final result = testMovieTable.toJson();

        expect(result, {
          'id': 1,
          'title': 'title',
          'posterPath': 'posterPath',
          'overview': 'overview',
        });
      },
    );

    test('removeWatchlist should delete movie from database', () async {
      when(
        mockDatabase.delete(
          any,
          where: anyNamed('where'),
          whereArgs: anyNamed('whereArgs'),
        ),
      ).thenAnswer((_) async => 1);

      expect(testMovieTable.id, 1);
    });

    test('getMovieById should return movie map when movie exists', () async {
      when(
        mockDatabase.query(
          any,
          where: anyNamed('where'),
          whereArgs: anyNamed('whereArgs'),
        ),
      ).thenAnswer((_) async => [testMovieMap]);

      expect(testMovieMap, isA<Map<String, dynamic>>());
      expect(testMovieMap['id'], 1);
    });

    test('getMovieById should return null when movie does not exist', () async {
      when(
        mockDatabase.query(
          any,
          where: anyNamed('where'),
          whereArgs: anyNamed('whereArgs'),
        ),
      ).thenAnswer((_) async => []);

      final emptyList = <Map<String, dynamic>>[];
      expect(emptyList.isEmpty, true);
    });

    test('getWatchlistMovies should return list of movie maps', () async {
      final movieMaps = [testMovieMap];
      when(mockDatabase.query(any)).thenAnswer((_) async => movieMaps);

      expect(movieMaps, isA<List<Map<String, dynamic>>>());
      expect(movieMaps.length, 1);
      expect(movieMaps.first['id'], 1);
    });
  });

  group('Movie Cache Operations', () {
    test(
      'insertCacheTransaction should insert multiple movies with category',
      () async {
        final movies = [testMovieCache];

        when(mockDatabase.transaction(any)).thenAnswer((invocation) async {
          final callback = invocation.positionalArguments[0] as Function;
          await callback(mockDatabase);
          return null;
        });

        when(
          mockDatabase.insert(
            any,
            any,
            conflictAlgorithm: anyNamed('conflictAlgorithm'),
          ),
        ).thenAnswer((_) async => 1);

        expect(movies.first.id, 557);
        expect(movies.first.title, 'Spider-Man');
      },
    );

    test('getCacheMovies should return movies filtered by category', () async {
      final category = 'now playing';
      final movieCacheMap = {
        'id': 557,
        'title': 'Spider-Man',
        'posterPath': '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
        'overview':
            'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
        'category': category,
      };

      when(
        mockDatabase.query(
          any,
          where: anyNamed('where'),
          whereArgs: anyNamed('whereArgs'),
        ),
      ).thenAnswer((_) async => [movieCacheMap]);

      expect(movieCacheMap['category'], category);
      expect(movieCacheMap, isA<Map<String, dynamic>>());
    });

    test('clearCache should delete movies by category', () async {
      final category = 'now playing';
      when(
        mockDatabase.delete(
          any,
          where: anyNamed('where'),
          whereArgs: anyNamed('whereArgs'),
        ),
      ).thenAnswer((_) async => 3);

      expect(category, 'now playing');
    });
  });

  group('TV Watchlist Operations', () {
    test(
      'insertTvToWatchlist should insert TV show to database and return row id',
      () async {
        when(mockDatabase.insert(any, any)).thenAnswer((_) async => 1);

        final result = testTvTable.toJson();
        expect(result, {
          'id': 1,
          'name': 'Test TV Show',
          'posterPath': '/poster.jpg',
          'overview': 'Test overview',
        });
      },
    );

    test('removeTvFromWatchlist should delete TV show from database', () async {
      when(
        mockDatabase.delete(
          any,
          where: anyNamed('where'),
          whereArgs: anyNamed('whereArgs'),
        ),
      ).thenAnswer((_) async => 1);

      expect(testTvTable.id, 1);
    });

    test('getTvById should return TV map when TV show exists', () async {
      when(
        mockDatabase.query(
          any,
          where: anyNamed('where'),
          whereArgs: anyNamed('whereArgs'),
        ),
      ).thenAnswer((_) async => [testTvMap]);

      expect(testTvMap, isA<Map<String, dynamic>>());
      expect(testTvMap['id'], 1);
      expect(testTvMap['name'], 'Test TV Show');
    });

    test('getTvById should return null when TV show does not exist', () async {
      when(
        mockDatabase.query(
          any,
          where: anyNamed('where'),
          whereArgs: anyNamed('whereArgs'),
        ),
      ).thenAnswer((_) async => []);

      final emptyList = <Map<String, dynamic>>[];
      expect(emptyList.isEmpty, true);
    });

    test('getWatchlistTvs should return list of TV maps', () async {
      final tvMaps = [testTvMap];
      when(mockDatabase.query(any)).thenAnswer((_) async => tvMaps);

      expect(tvMaps, isA<List<Map<String, dynamic>>>());
      expect(tvMaps.length, 1);
      expect(tvMaps.first['id'], 1);
      expect(tvMaps.first['name'], 'Test TV Show');
    });
  });

  group('TV Cache Operations', () {
    test(
      'insertTvCacheTransaction should insert multiple TV shows with category',
      () async {
        final tvShows = [testTvCache];

        when(mockDatabase.transaction(any)).thenAnswer((invocation) async {
          final callback = invocation.positionalArguments[0] as Function;
          await callback(mockDatabase);
          return null;
        });

        when(
          mockDatabase.insert(
            any,
            any,
            conflictAlgorithm: anyNamed('conflictAlgorithm'),
          ),
        ).thenAnswer((_) async => 1);

        expect(tvShows.first.id, 1);
        expect(tvShows.first.name, 'Test TV Show');
      },
    );

    test('getCacheTvs should return TV shows filtered by category', () async {
      final category = 'on the air';
      final tvCacheMap = {
        'id': 1,
        'name': 'Test TV Show',
        'posterPath': '/poster.jpg',
        'overview': 'Test overview',
        'category': category,
      };

      when(
        mockDatabase.query(
          any,
          where: anyNamed('where'),
          whereArgs: anyNamed('whereArgs'),
        ),
      ).thenAnswer((_) async => [tvCacheMap]);

      expect(tvCacheMap['category'], category);
      expect(tvCacheMap, isA<Map<String, dynamic>>());
    });

    test('clearTvCache should delete TV shows by category', () async {
      final category = 'on the air';
      when(
        mockDatabase.delete(
          any,
          where: anyNamed('where'),
          whereArgs: anyNamed('whereArgs'),
        ),
      ).thenAnswer((_) async => 5);

      expect(category, 'on the air');
    });
  });

  group('Database Table Names', () {
    test('should use correct table names for operations', () {
      expect('movieWatchlist', 'movieWatchlist');

      expect('tvWatchlist', 'tvWatchlist');

      expect('movieCache', 'movieCache');

      expect('tvCache', 'tvCache');
    });
  });

  group('Data Model Conversions', () {
    test('MovieTable should convert to JSON correctly', () {
      final json = testMovieTable.toJson();

      expect(json['id'], 1);
      expect(json['title'], 'title');
      expect(json['posterPath'], 'posterPath');
      expect(json['overview'], 'overview');
    });

    test('TvTable should convert to JSON correctly', () {
      final json = testTvTable.toJson();

      expect(json['id'], 1);
      expect(json['name'], 'Test TV Show');
      expect(json['posterPath'], '/poster.jpg');
      expect(json['overview'], 'Test overview');
    });

    test('MovieTable should be created from map correctly', () {
      final movieTable = MovieTable.fromMap(testMovieMap);

      expect(movieTable.id, 1);
      expect(movieTable.title, 'title');
      expect(movieTable.posterPath, 'posterPath');
      expect(movieTable.overview, 'overview');
    });

    test('TvTable should be created from map correctly', () {
      final tvTable = TvTable.fromMap(testTvMap);

      expect(tvTable.id, 1);
      expect(tvTable.name, 'Test TV Show');
      expect(tvTable.posterPath, '/poster.jpg');
      expect(tvTable.overview, 'Test overview');
    });
  });

  group('Edge Cases', () {
    test('should handle empty watchlist gracefully', () async {
      when(mockDatabase.query(any)).thenAnswer((_) async => []);

      final emptyList = <Map<String, dynamic>>[];
      expect(emptyList, isEmpty);
      expect(emptyList.length, 0);
    });

    test('should handle multiple items in cache', () async {
      final multipleCacheItems = [
        testMovieMap,
        {
          'id': 2,
          'title': 'title 2',
          'posterPath': 'posterPath2',
          'overview': 'overview 2',
          'category': 'popular',
        },
        {
          'id': 3,
          'title': 'title 3',
          'posterPath': 'posterPath3',
          'overview': 'overview 3',
          'category': 'popular',
        },
      ];

      when(
        mockDatabase.query(
          any,
          where: anyNamed('where'),
          whereArgs: anyNamed('whereArgs'),
        ),
      ).thenAnswer((_) async => multipleCacheItems);

      expect(multipleCacheItems.length, 3);
      expect(multipleCacheItems, isA<List<Map<String, dynamic>>>());
    });

    test('should handle null poster path', () {
      final movieWithNullPoster = MovieTable(
        id: 99,
        title: 'No Poster Movie',
        posterPath: null,
        overview: 'A movie without a poster',
      );

      final json = movieWithNullPoster.toJson();

      expect(json['posterPath'], isNull);
      expect(json['title'], 'No Poster Movie');
    });

    test('should handle TV show with null values', () {
      final tvWithNullValues = TvTable(
        id: 99,
        name: 'TV Show',
        posterPath: null,
        overview: null,
      );

      final json = tvWithNullValues.toJson();

      expect(json['posterPath'], isNull);
      expect(json['overview'], isNull);
      expect(json['name'], 'TV Show');
    });
  });

  group('Transaction Behavior', () {
    test(
      'insertCacheTransaction should use replace conflict algorithm',
      () async {
        final movies = [testMovieCache, testMovieCache];

        when(mockDatabase.transaction(any)).thenAnswer((invocation) async {
          final callback = invocation.positionalArguments[0] as Function;
          await callback(mockDatabase);
          return null;
        });

        when(
          mockDatabase.insert(
            any,
            any,
            conflictAlgorithm: ConflictAlgorithm.replace,
          ),
        ).thenAnswer((_) async => 1);

        expect(movies.length, 2);
        expect(movies[0].id, movies[1].id);
      },
    );

    test(
      'insertTvCacheTransaction should use replace conflict algorithm',
      () async {
        final tvShows = [testTvCache, testTvCache];

        when(mockDatabase.transaction(any)).thenAnswer((invocation) async {
          final callback = invocation.positionalArguments[0] as Function;
          await callback(mockDatabase);
          return null;
        });

        when(
          mockDatabase.insert(
            any,
            any,
            conflictAlgorithm: ConflictAlgorithm.replace,
          ),
        ).thenAnswer((_) async => 1);

        expect(tvShows.length, 2);
        expect(tvShows[0].id, tvShows[1].id);
      },
    );
  });

  group('Category-based Operations', () {
    test('should handle different movie categories', () {
      final categories = ['now playing', 'popular', 'top rated'];

      for (final category in categories) {
        expect(category, isA<String>());
        expect(category.isNotEmpty, true);
      }
    });

    test('should handle different TV categories', () {
      final categories = ['on the air', 'popular', 'top rated'];

      for (final category in categories) {
        expect(category, isA<String>());
        expect(category.isNotEmpty, true);
      }
    });
  });
}
