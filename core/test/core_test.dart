import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Core Library Exports', () {
    test('should export Genre entity', () {
      final genre = Genre(id: 1, name: 'Action');
      expect(genre, isA<Genre>());
    });

    test('should export GenreModel', () {
      final genreModel = GenreModel(id: 1, name: 'Action');
      expect(genreModel, isA<GenreModel>());
    });

    test('should export DatabaseHelper', () {
      final dbHelper = DatabaseHelper();
      expect(dbHelper, isA<DatabaseHelper>());
    });

    test('should export constants', () {
      expect(BASE_IMAGE_URL, isNotNull);
      expect(kRichBlack, isNotNull);
    });

    test('should export exceptions', () {
      expect(ServerException(), isA<ServerException>());
      expect(DatabaseException('test'), isA<DatabaseException>());
      expect(CacheException('test'), isA<CacheException>());
    });

    test('should export failures', () {
      expect(const ServerFailure('test'), isA<ServerFailure>());
      expect(const ConnectionFailure('test'), isA<ConnectionFailure>());
      expect(const DatabaseFailure('test'), isA<DatabaseFailure>());
      expect(const CacheFailure('test'), isA<CacheFailure>());
    });

    test('should export RequestState enum', () {
      expect(RequestState.Empty, isA<RequestState>());
      expect(RequestState.Loading, isA<RequestState>());
      expect(RequestState.Loaded, isA<RequestState>());
      expect(RequestState.Error, isA<RequestState>());
      expect(RequestState.values.length, 4);
    });

    test('should export utils', () {
      expect(BASE_IMAGE_URL, isA<String>());
    });
  });
}
