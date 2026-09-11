import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:elite_multiservicios_flutter/core/theme/app_theme.dart';
import 'package:elite_multiservicios_flutter/features/security/presentation/security_shell_screen.dart';
import 'package:elite_multiservicios_flutter/features/security/presentation/widgets/status_badge.dart';

class _MockHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) => _MockHttpClient();
}

class _MockHttpClient implements HttpClient {
  @override
  dynamic noSuchMethod(Invocation invocation) => null;

  @override
  Future<HttpClientRequest> openUrl(String method, Uri url) async =>
      _MockHttpClientRequest();

  @override
  Future<HttpClientRequest> postUrl(Uri url) async => _MockHttpClientRequest();

  @override
  Future<HttpClientRequest> getUrl(Uri url) async => _MockHttpClientRequest();

  @override
  Future<HttpClientRequest> open(
    String method,
    String host,
    int port,
    String path,
  ) async => _MockHttpClientRequest();

  @override
  Future<HttpClientRequest> post(
    String host,
    int port,
    String path,
  ) async => _MockHttpClientRequest();

  @override
  Future<HttpClientRequest> get(
    String host,
    int port,
    String path,
  ) async => _MockHttpClientRequest();
}

class _MockHttpClientRequest implements HttpClientRequest {
  @override
  final HttpHeaders headers = _MockHttpHeaders();

  @override
  dynamic noSuchMethod(Invocation invocation) => null;

  @override
  void add(List<int> data) {}

  @override
  void write(Object? obj) {}

  @override
  Future<HttpClientResponse> close() async => _MockHttpClientResponse();
}

class _MockHttpHeaders implements HttpHeaders {
  final Map<String, List<String>> _headers = {};

  @override
  dynamic noSuchMethod(Invocation invocation) => null;

  @override
  List<String>? operator [](String name) => _headers[name];

  @override
  void add(String name, Object value, {bool preserveHeaderCase = false}) {
    _headers.putIfAbsent(name, () => []).add(value.toString());
  }

  @override
  void set(String name, Object value, {bool preserveHeaderCase = false}) {
    _headers[name] = [value.toString()];
  }

  @override
  String? value(String name) => _headers[name]?.firstOrNull;
}

class _MockHttpClientResponse extends Stream<List<int>>
    implements HttpClientResponse {
  final List<int> _body = utf8.encode('[]');

  @override
  dynamic noSuchMethod(Invocation invocation) => null;

  @override
  int get statusCode => 200;

  @override
  String get reasonPhrase => 'OK';

  @override
  int get contentLength => _body.length;

  @override
  HttpHeaders get headers => _MockHttpHeaders();

  @override
  StreamSubscription<List<int>> listen(
    void Function(List<int> event)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    return Stream.value(_body).listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }
}

void main() {
  setUpAll(() {
    HttpOverrides.global = _MockHttpOverrides();
  });

  tearDownAll(() {
    HttpOverrides.global = null;
  });

  group('Security Presentation & UI Widgets Tests', () {
    testWidgets('StatusBadge renders correctly with distinct variants', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const Scaffold(
            body: StatusBadge(
              label: 'Activo',
              variant: BadgeVariant.success,
              icon: Icons.check,
            ),
          ),
        ),
      );

      expect(find.text('Activo'), findsOneWidget);
      expect(find.byIcon(Icons.check), findsOneWidget);
    });

    testWidgets(
      'SecurityShellScreen renders sidebar and navigates across tabs',
      (tester) async {
        tester.view.physicalSize = const Size(1280, 800);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        addTearDown(() async {
          await tester.pumpWidget(const SizedBox());
          await tester.pump(const Duration(seconds: 5));
        });

        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            home: const SecurityShellScreen(),
          ),
        );

        expect(find.text('ELITE MULTISERVICIOS'), findsOneWidget);
        expect(find.text('Módulo de Seguridad'), findsOneWidget);
        expect(find.text('Dashboard General'), findsOneWidget);

        // Probar tap en navegación a "Usuarios"
        await tester.tap(find.text('Usuarios'));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));

        expect(find.text('Gestión de Usuarios'), findsWidgets);

        // Probar tap en navegación a "Auditoría"
        await tester.tap(find.text('Auditoría'));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));

        expect(find.textContaining('Bitácora de Auditoría'), findsWidgets);
      },
    );
  });
}
