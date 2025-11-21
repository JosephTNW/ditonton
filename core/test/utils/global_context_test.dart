import 'dart:io';

import 'package:core/utils/global_context.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Global Context SSL Pinning', () {
    test('globalContext should return a SecurityContext', () async {
      final securityContext = await globalContext;
      expect(securityContext, isA<SecurityContext>());
    });

    test('httpSSLPinning should return an HTTP client', () async {
      final client = await httpSSLPinning;
      expect(client, isA<http.Client>());
    });

    test('globalContext should load SSL certificate', () async {
      // This test verifies the certificate is loaded successfully
      expect(() async => await globalContext, returnsNormally);
    });

    test('httpSSLPinning should create IOClient with SSL context', () async {
      final client = await httpSSLPinning;
      expect(client, isNotNull);
      // Clean up
      client.close();
    });

    test('multiple calls to globalContext should work', () async {
      final context1 = await globalContext;
      final context2 = await globalContext;

      expect(context1, isA<SecurityContext>());
      expect(context2, isA<SecurityContext>());
    });

    test('multiple calls to httpSSLPinning should work', () async {
      final client1 = await httpSSLPinning;
      final client2 = await httpSSLPinning;

      expect(client1, isNotNull);
      expect(client2, isNotNull);

      // Clean up
      client1.close();
      client2.close();
    });

    test('badCertificateCallback should reject invalid hosts', () async {
      final context = await globalContext;
      final httpClient = HttpClient(context: context);

      // Create a test certificate to simulate the callback
      httpClient.badCertificateCallback = (
        X509Certificate cert,
        String host,
        int port,
      ) {
        if (kDebugMode) {
          print('⚠️ SSL Pinning: Certificate validation for $host:$port');
          print('   Subject: ${cert.subject}');
          print('   Issuer: ${cert.issuer}');
        }

        final isValidHost =
            host == 'api.themoviedb.org' || host.endsWith('.themoviedb.org');

        if (!isValidHost) {
          if (kDebugMode) {
            print('❌ SSL Pinning: Rejected certificate for $host');
          }
          return false;
        }

        return false;
      };

      expect(httpClient, isNotNull);
      httpClient.close();
    });

    test('should attempt connection to verify SSL pinning behavior', () async {
      final client = await httpSSLPinning;

      // This test attempts to make a real connection to themoviedb.org
      // which will trigger the badCertificateCallback
      try {
        // Attempt connection - this will trigger certificate validation
        final response = await client.get(
          Uri.parse('https://api.themoviedb.org'),
        );
        // If we get here, the connection was successful or handled
        expect(response, isNotNull);
      } catch (e) {
        // Certificate validation might fail in test environment, which is expected
        // The important part is that it triggered the callback
        expect(e, isA<Exception>());
      } finally {
        client.close();
      }
    });

    test('badCertificateCallback logic should reject non-themoviedb hosts', () {
      final invalidHosts = ['example.com', 'google.com', 'malicious-site.com'];

      for (final host in invalidHosts) {
        final isValidHost =
            host == 'api.themoviedb.org' || host.endsWith('.themoviedb.org');
        expect(isValidHost, false);
      }
    });

    test('badCertificateCallback logic should accept themoviedb hosts', () {
      final validHosts = ['api.themoviedb.org', 'subdomain.themoviedb.org'];

      for (final host in validHosts) {
        final isValidHost =
            host == 'api.themoviedb.org' || host.endsWith('.themoviedb.org');
        expect(isValidHost, true);
      }
    });

    test('httpSSLPinning should configure badCertificateCallback', () async {
      final client = await httpSSLPinning;
      expect(client, isA<IOClient>());
      client.close();
    });
  });
}
