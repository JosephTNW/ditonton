import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

Future<SecurityContext> get globalContext async {
  final sslCert = await rootBundle.load('certificates/api.themoviedb.pem');
  if (kDebugMode) {
    print('✅ SSL Certificate loaded: ${sslCert.lengthInBytes} bytes');
  }
  SecurityContext securityContext = SecurityContext(withTrustedRoots: false);
  securityContext.setTrustedCertificatesBytes(sslCert.buffer.asUint8List());
  if (kDebugMode) {
    print('✅ SSL Pinning: SecurityContext configured');
  }
  return securityContext;
}

Future<http.Client> get httpSSLPinning async {
  HttpClient client = HttpClient(context: await globalContext);
  client.badCertificateCallback = (
    X509Certificate cert,
    String host,
    int port,
  ) {
    if (kDebugMode) {
      print('⚠️ SSL Pinning: Certificate validation for $host:$port');
      print('   Subject: ${cert.subject}');
      print('   Issuer: ${cert.issuer}');
    }

    // Only accept certificates for api.themoviedb.org
    // This provides an additional layer of security beyond the SecurityContext
    final isValidHost =
        host == 'api.themoviedb.org' || host.endsWith('.themoviedb.org');

    if (!isValidHost) {
      if (kDebugMode) {
        print('❌ SSL Pinning: Rejected certificate for $host');
      }
      return false;
    }

    // For themoviedb.org hosts, let the SecurityContext handle validation
    // Since we set withTrustedRoots: false, only our pinned certificate is trusted
    return false; // Let the SecurityContext do the validation
  };
  if (kDebugMode) {
    print('✅ SSL Pinning: HTTP Client initialized');
  }
  return IOClient(client);
}
