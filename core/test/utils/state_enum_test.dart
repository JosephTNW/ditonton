import 'package:core/utils/state_enum.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RequestState', () {
    test('should have Empty state', () {
      expect(RequestState.Empty, isA<RequestState>());
    });

    test('should have Loading state', () {
      expect(RequestState.Loading, isA<RequestState>());
    });

    test('should have Loaded state', () {
      expect(RequestState.Loaded, isA<RequestState>());
    });

    test('should have Error state', () {
      expect(RequestState.Error, isA<RequestState>());
    });

    test('should have exactly 4 states', () {
      expect(RequestState.values.length, 4);
    });

    test('should support equality comparison', () {
      expect(RequestState.Empty, equals(RequestState.Empty));
      expect(RequestState.Loading, equals(RequestState.Loading));
      expect(RequestState.Loaded, equals(RequestState.Loaded));
      expect(RequestState.Error, equals(RequestState.Error));
    });

    test('different states should not be equal', () {
      expect(RequestState.Empty, isNot(equals(RequestState.Loading)));
      expect(RequestState.Empty, isNot(equals(RequestState.Loaded)));
      expect(RequestState.Empty, isNot(equals(RequestState.Error)));
      expect(RequestState.Loading, isNot(equals(RequestState.Loaded)));
      expect(RequestState.Loading, isNot(equals(RequestState.Error)));
      expect(RequestState.Loaded, isNot(equals(RequestState.Error)));
    });

    test('should work in switch statements', () {
      String getStateName(RequestState state) {
        switch (state) {
          case RequestState.Empty:
            return 'empty';
          case RequestState.Loading:
            return 'loading';
          case RequestState.Loaded:
            return 'loaded';
          case RequestState.Error:
            return 'error';
        }
      }

      expect(getStateName(RequestState.Empty), 'empty');
      expect(getStateName(RequestState.Loading), 'loading');
      expect(getStateName(RequestState.Loaded), 'loaded');
      expect(getStateName(RequestState.Error), 'error');
    });

    test('should work in collections', () {
      final states = [
        RequestState.Empty,
        RequestState.Loading,
        RequestState.Loaded,
        RequestState.Error,
      ];

      expect(states.contains(RequestState.Empty), true);
      expect(states.contains(RequestState.Loading), true);
      expect(states.contains(RequestState.Loaded), true);
      expect(states.contains(RequestState.Error), true);
      expect(states.length, 4);
    });
  });
}
