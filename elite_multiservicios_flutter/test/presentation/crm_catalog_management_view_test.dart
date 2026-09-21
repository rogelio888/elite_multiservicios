import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:elite_multiservicios_flutter/core/theme/app_theme.dart';
import 'package:elite_multiservicios_flutter/features/crm/presentation/views/crm_catalog_management_view.dart';

class _MockHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) => _MockHttpClient();
}

class _MockHttpClient implements HttpClient {
  @override
  dynamic noSuchMethod(Invocation invocation) => null;
  @override
  Future<HttpClientRequest> openUrl(String method, Uri url) async => _MockHttpClientRequest();
  @override
  Future<HttpClientRequest> postUrl(Uri url) async => _MockHttpClientRequest();
  @override
  Future<HttpClientRequest> getUrl(Uri url) async => _MockHttpClientRequest();
  @override
  Future<HttpClientRequest> open(String method, String host, int port, String path) async => _MockHttpClientRequest();
  @override
  Future<HttpClientRequest> post(String host, int port, String path) async => _MockHttpClientRequest();
  @override
  Future<HttpClientRequest> get(String host, int port, String path) async => _MockHttpClientRequest();
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

class _MockHttpClientResponse extends Stream<List<int>> implements HttpClientResponse {
  final List<int> _body = utf8.encode('[]');
  @override
  dynamic noSuchMethod(Invocation invocation) => null;
  @override
  int get statusCode => 200;
  @override
  StreamSubscription<List<int>> listen(void Function(List<int> event)? onData,
      {Function? onError, void Function()? onDone, bool? cancelOnError}) {
    return Stream<List<int>>.fromIterable([_body]).listen(
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

  testWidgets('CrmCatalogManagementView renders without throwing exceptions', (tester) async {
    tester.view.physicalSize = const Size(1280, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.darkTheme,
        home: const Scaffold(
          body: CrmCatalogManagementView(),
        ),
      ),
    );

    await tester.pump();
    expect(find.text('Catálogo & Tarifario Maestro'), findsOneWidget);
    expect(find.text('Partidas de Servicio'), findsOneWidget);
  });

  testWidgets('CrmCatalogManagementView renders on narrow mobile screens without error', (tester) async {
    tester.view.physicalSize = const Size(375, 812);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.darkTheme,
        home: const Scaffold(
          body: CrmCatalogManagementView(),
        ),
      ),
    );

    await tester.pump();
    expect(find.text('Catálogo & Tarifario Maestro'), findsOneWidget);
  });
}

