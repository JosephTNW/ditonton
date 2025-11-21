import 'package:core/utils/failure.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Failure', () {
    group('ServerFailure', () {
      const testMessage = 'Server error occurred';

      test('should be a subclass of Failure', () {
        const failure = ServerFailure(testMessage);
        expect(failure, isA<Failure>());
      });

      test('should contain the provided message', () {
        const failure = ServerFailure(testMessage);
        expect(failure.message, testMessage);
      });

      test('props should contain message', () {
        const failure = ServerFailure(testMessage);
        expect(failure.props, [testMessage]);
      });

      test('should support equality comparison', () {
        const failure1 = ServerFailure(testMessage);
        const failure2 = ServerFailure(testMessage);
        const failure3 = ServerFailure('Different message');

        expect(failure1, equals(failure2));
        expect(failure1, isNot(equals(failure3)));
      });
    });

    group('ConnectionFailure', () {
      const testMessage = 'Connection error occurred';

      test('should be a subclass of Failure', () {
        const failure = ConnectionFailure(testMessage);
        expect(failure, isA<Failure>());
      });

      test('should contain the provided message', () {
        const failure = ConnectionFailure(testMessage);
        expect(failure.message, testMessage);
      });

      test('props should contain message', () {
        const failure = ConnectionFailure(testMessage);
        expect(failure.props, [testMessage]);
      });

      test('should support equality comparison', () {
        const failure1 = ConnectionFailure(testMessage);
        const failure2 = ConnectionFailure(testMessage);
        const failure3 = ConnectionFailure('Different message');

        expect(failure1, equals(failure2));
        expect(failure1, isNot(equals(failure3)));
      });
    });

    group('DatabaseFailure', () {
      const testMessage = 'Database error occurred';

      test('should be a subclass of Failure', () {
        const failure = DatabaseFailure(testMessage);
        expect(failure, isA<Failure>());
      });

      test('should contain the provided message', () {
        const failure = DatabaseFailure(testMessage);
        expect(failure.message, testMessage);
      });

      test('props should contain message', () {
        const failure = DatabaseFailure(testMessage);
        expect(failure.props, [testMessage]);
      });

      test('should support equality comparison', () {
        const failure1 = DatabaseFailure(testMessage);
        const failure2 = DatabaseFailure(testMessage);
        const failure3 = DatabaseFailure('Different message');

        expect(failure1, equals(failure2));
        expect(failure1, isNot(equals(failure3)));
      });
    });

    group('CacheFailure', () {
      const testMessage = 'Cache error occurred';

      test('should be a subclass of Failure', () {
        const failure = CacheFailure(testMessage);
        expect(failure, isA<Failure>());
      });

      test('should contain the provided message', () {
        const failure = CacheFailure(testMessage);
        expect(failure.message, testMessage);
      });

      test('props should contain message', () {
        const failure = CacheFailure(testMessage);
        expect(failure.props, [testMessage]);
      });

      test('should support equality comparison', () {
        const failure1 = CacheFailure(testMessage);
        const failure2 = CacheFailure(testMessage);
        const failure3 = CacheFailure('Different message');

        expect(failure1, equals(failure2));
        expect(failure1, isNot(equals(failure3)));
      });
    });

    group('Failure hierarchy', () {
      test('different failure types should not be equal', () {
        const message = 'Error message';
        const serverFailure = ServerFailure(message);
        const connectionFailure = ConnectionFailure(message);
        const databaseFailure = DatabaseFailure(message);
        const cacheFailure = CacheFailure(message);

        expect(serverFailure, isNot(equals(connectionFailure)));
        expect(serverFailure, isNot(equals(databaseFailure)));
        expect(serverFailure, isNot(equals(cacheFailure)));
        expect(connectionFailure, isNot(equals(databaseFailure)));
        expect(connectionFailure, isNot(equals(cacheFailure)));
        expect(databaseFailure, isNot(equals(cacheFailure)));
      });
    });
  });
}
