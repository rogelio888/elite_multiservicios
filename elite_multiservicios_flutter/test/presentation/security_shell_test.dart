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

    testWidgets(
      'SecurityShellScreen allows collapsing and expanding Seguridad section',
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

        // Al inicio, "Dashboard" y el acordeón "Seguridad" están presentes
        expect(find.text('Dashboard'), findsOneWidget);
        expect(
          find.byKey(const Key('nav_accordion_seguridad')),
          findsOneWidget,
        );

        // Como inicia expandido, las sub-pestañas están visibles
        expect(find.text('Usuarios'), findsOneWidget);
        expect(find.text('Roles & RBAC'), findsOneWidget);
        expect(find.text('Auditoría'), findsOneWidget);
        expect(find.text('Sesiones'), findsOneWidget);
        expect(find.text('Métricas'), findsOneWidget);

        // Tap en "Seguridad" para contraer el acordeón
        await tester.tap(find.byKey(const Key('nav_accordion_seguridad')));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));

        // Tras colapsar, las sub-pestañas no deben estar renderizadas
        expect(find.text('Usuarios'), findsNothing);
        expect(find.text('Roles & RBAC'), findsNothing);

        // Tap en "Seguridad" nuevamente para expandir
        await tester.tap(find.byKey(const Key('nav_accordion_seguridad')));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));

        // Vuelven a mostrarse
        expect(find.text('Usuarios'), findsOneWidget);
        expect(find.text('Roles & RBAC'), findsOneWidget);
      },
    );

    testWidgets(
      'SecurityShellScreen adapts to mobile viewport with Drawer and hamburger menu',
      (tester) async {
        // Simular viewport de iPhone 16 Pro Max (440 x 956)
        tester.view.physicalSize = const Size(440, 956);
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

        // En móvil, el botón hamburguesa debe estar presente en el Topbar
        expect(find.byIcon(Icons.menu), findsOneWidget);

        // Al inicio, el sidebar permanente NO debe estar en pantalla principal
        // (el Drawer está cerrado)
        expect(find.text('ELITE MULTISERVICIOS'), findsNothing);

        // Abrir Drawer mediante el botón hamburguesa
        await tester.tap(find.byIcon(Icons.menu));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));

        // Ahora el contenido del menú debe estar visible dentro del Drawer
        expect(find.text('ELITE MULTISERVICIOS'), findsOneWidget);
        expect(find.text('Usuarios'), findsOneWidget);

        // Navegar a Usuarios desde el Drawer
        await tester.tap(find.text('Usuarios'));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));

        // El drawer se cierra automáticamente y la vista de usuarios se muestra a ancho completo
        expect(find.text('Gestión de Usuarios'), findsWidgets);
      },
    );
  });
}
