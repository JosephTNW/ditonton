import 'package:core/utils/exception.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ServerException', () {
    test('should be an instance of Exception', () {
      final exception = ServerException();
      expect(exception, isA<Exception>());
    });

    test('can be thrown and caught', () {
      expect(() => throw ServerException(), throwsA(isA<ServerException>()));
    });
  });

  group('DatabaseException', () {
    const testMessage = 'Database error occurred';

    test('should be an instance of Exception', () {
      final exception = DatabaseException(testMessage);
      expect(exception, isA<Exception>());
    });

    test('should contain the provided message', () {
      final exception = DatabaseException(testMessage);
      expect(exception.message, testMessage);
    });

    test('can be thrown and caught', () {
      expect(
        () => throw DatabaseException(testMessage),
        throwsA(isA<DatabaseException>()),
      );
    });

    test('should maintain message after being thrown', () {
      try {
        throw DatabaseException(testMessage);
      } catch (e) {
        expect(e, isA<DatabaseException>());
        expect((e as DatabaseException).message, testMessage);
      }
    });
  });

  group('CacheException', () {
    const testMessage = 'Cache error occurred';

    test('should be an instance of Exception', () {
      final exception = CacheException(testMessage);
      expect(exception, isA<Exception>());
    });

    test('should contain the provided message', () {
      final exception = CacheException(testMessage);
      expect(exception.message, testMessage);
    });

    test('can be thrown and caught', () {
      expect(
        () => throw CacheException(testMessage),
        throwsA(isA<CacheException>()),
      );
    });

    test('should maintain message after being thrown', () {
      try {
        throw CacheException(testMessage);
      } catch (e) {
        expect(e, isA<CacheException>());
        expect((e as CacheException).message, testMessage);
      }
    });
  });
}
