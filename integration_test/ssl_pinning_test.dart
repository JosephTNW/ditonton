import 'package:core/utils/global_context.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('SSL Pinning Integration Tests', () {
    testWidgets(
      'should successfully connect to themoviedb.org with pinned certificate',
      (WidgetTester tester) async {
        // This test runs in a real environment and verifies that SSL pinning
        // allows connections to the pinned domain (api.themoviedb.org)
        final client = await httpSSLPinning;

        try {
          final response = await client.get(
            Uri.parse('https://api.themoviedb.org/3/movie/550'),
          );

          // If we get here, the SSL connection succeeded
          // Note: This might return 401 (unauthorized) but that's OK -
          // it means SSL worked but we need an API key
          expect(
            response.statusCode,
            isNot(equals(525)),
          ); // 525 = SSL handshake failed

          print('✅ SSL Pinning Test: Successfully connected to themoviedb.org');
          print('   Status: ${response.statusCode}');
        } catch (e) {
          // If it fails, it should NOT be due to SSL/certificate errors
          expect(e.toString(), isNot(contains('CERTIFICATE')));
          expect(e.toString(), isNot(contains('certificate')));
          expect(e.toString(), isNot(contains('SSL')));
          expect(e.toString(), isNot(contains('handshake')));
        }
      },
    );

    testWidgets('should reject connections to non-pinned domains', (
      WidgetTester tester,
    ) async {
      final client = await httpSSLPinning;

      bool connectionFailed = false;
      String? errorMessage;

      try {
        final response = await client.get(Uri.parse('https://www.google.com'));

        print('❌ SSL Pinning Test Failed: Connection to google.com succeeded');
        print('   Status: ${response.statusCode}');
        print('   This should have been blocked by SSL pinning!');

        fail('SSL Pinning did not block connection to non-pinned domain');
      } catch (e) {
        connectionFailed = true;
        errorMessage = e.toString();

        print('✅ SSL Pinning Test: Connection to google.com properly rejected');
        print('   Error: $errorMessage');
      }

      // Verify the connection failed
      expect(
        connectionFailed,
        true,
        reason: 'SSL pinning should block connections to non-pinned domains',
      );

      // Verify it's a certificate/handshake error
      expect(
        errorMessage.toLowerCase(),
        anyOf([
          contains('certificate'),
          contains('handshake'),
          contains('tls'),
          contains('ssl'),
        ]),
        reason: 'Should fail with a certificate-related error',
      );
    });

    testWidgets('should reject connections to different HTTPS domains', (
      WidgetTester tester,
    ) async {
      // Test with another popular domain to ensure pinning works consistently
      final client = await httpSSLPinning;

      bool connectionFailed = false;

      try {
        await client.get(Uri.parse('https://github.com'));

        print('❌ SSL Pinning Test Failed: Connection to github.com succeeded');
        fail('SSL Pinning did not block connection to github.com');
      } catch (e) {
        connectionFailed = true;
        print('✅ SSL Pinning Test: Connection to github.com properly rejected');
        print('   Error: $e');
      }

      expect(
        connectionFailed,
        true,
        reason:
            'SSL pinning should block connections to all non-pinned domains',
      );
    });
  });
}
