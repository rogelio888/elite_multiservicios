import 'dart:convert';
import 'dart:io';
import 'package:test/test.dart';

void main() {
  group('HTTP /health & System Metrics Integration Tests', () {
    test(
      'GET http://localhost:8082/health returns 200 OK and valid JSON health payload',
      () async {
        final client = HttpClient();
        try {
          final request = await client.getUrl(
            Uri.parse('http://localhost:8082/health'),
          );
          final response = await request.close();

          expect(response.statusCode, equals(HttpStatus.ok));

          final responseBody = await response.transform(utf8.decoder).join();
          final json = jsonDecode(responseBody) as Map<String, dynamic>;

          expect(json['status'], equals('ok'));
          expect(json['dbLatencyMs'], isA<num>());
          expect(json['timestamp'], isNotNull);
        } finally {
          client.close();
        }
      },
    );
  });
}
