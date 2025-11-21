import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:core/utils/network_info.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'network_info_test.mocks.dart';

@GenerateMocks([DataConnectionChecker])
void main() {
  late NetworkInfoImpl networkInfo;
  late MockDataConnectionChecker mockDataConnectionChecker;

  setUp(() {
    mockDataConnectionChecker = MockDataConnectionChecker();
    networkInfo = NetworkInfoImpl(mockDataConnectionChecker);
  });

  group('isConnected', () {
    test(
      'should forward the call to DataConnectionChecker.hasConnection',
      () async {
        final tHasConnectionFuture = Future.value(true);
        when(
          mockDataConnectionChecker.hasConnection,
        ).thenAnswer((_) => tHasConnectionFuture);

        final result = networkInfo.isConnected;

        verify(mockDataConnectionChecker.hasConnection);
        expect(result, tHasConnectionFuture);
      },
    );

    test('should return true when device is connected', () async {
      when(
        mockDataConnectionChecker.hasConnection,
      ).thenAnswer((_) async => true);

      final result = await networkInfo.isConnected;

      expect(result, true);
    });

    test('should return false when device is not connected', () async {
      when(
        mockDataConnectionChecker.hasConnection,
      ).thenAnswer((_) async => false);

      final result = await networkInfo.isConnected;

      expect(result, false);
    });
  });
}
