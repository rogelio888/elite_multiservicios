import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:elite_multiservicios_client/elite_multiservicios_client.dart';
import 'package:elite_multiservicios_flutter/features/security/domain/exceptions/auth_exception.dart';
import 'package:elite_multiservicios_flutter/features/security/services/auth_service.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

void main() {
  setUp(() {
    FlutterSecureStorage.setMockInitialValues({});
  });

  group('AuthException Tests', () {
    test('creates AuthException with message, code and details', () {
      final ex = AuthException(
        'Error de prueba',
        code: 'TEST_CODE',
        details: 'Detalle adicional',
      );

      expect(ex.message, equals('Error de prueba'));
      expect(ex.code, equals('TEST_CODE'));
      expect(ex.details, equals('Detalle adicional'));
      expect(ex.toString(), equals('Error de prueba'));
    });
  });

  group('AuthService Unit Tests', () {
    test('instantiates with proper default unauthenticated state', () {
      final authService = AuthService();

      expect(authService.isAuthenticated, isFalse);
      expect(authService.currentUser, isNull);
    });

    test(
      'exposes logout and dispose lifecycle without throwing errors',
      () async {
        final authService = AuthService();

        await expectLater(authService.logout(), completes);
        authService.dispose();
      },
    );

    test(
      'Path 2.3: checkMfaRequired implements Fail-Closed with retries and aborts with AuthException on network failure',
      () async {
        final mockClient = MockClient();
        final mockMfa = MockEndpointMfa();
        final mockAuthManager = MockFlutterAuthSessionManager();

        final authNotifier = ValueNotifier<AuthSuccess?>(null);
        when(() => mockAuthManager.authInfoListenable).thenReturn(authNotifier);
        when(
          () => mockAuthManager.signOutDevice(),
        ).thenAnswer((_) async => true);
        when(() => mockClient.authKeyProvider).thenReturn(mockAuthManager);
        when(() => mockClient.mfa).thenReturn(mockMfa);

        int attempts = 0;
        when(
          () => mockMfa.checkRequired(
            rememberMe: any(named: 'rememberMe'),
            trustedDeviceToken: any(named: 'trustedDeviceToken'),
          ),
        ).thenAnswer((_) async {
          attempts++;
          throw Exception('SocketException: Failed host lookup');
        });

        final authService = AuthService(client: mockClient);

        await expectLater(
          () => authService.checkMfaRequired(rememberMe: false),
          throwsA(
            isA<AuthException>().having(
              (e) => e.code,
              'code',
              equals('NETWORK_ERROR'),
            ),
          ),
        );

        // Debe haber intentado exactamente 3 veces antes de abortar
        expect(attempts, equals(3));
        expect(authService.isMfaPending, isFalse);
        expect(authService.currentMfaChallenge, isNull);
        verify(() => mockAuthManager.signOutDevice()).called(1);
      },
    );
  });
}

class MockClient extends Mock implements Client {}

class MockEndpointMfa extends Mock implements EndpointMfa {}

class MockFlutterAuthSessionManager extends Mock
    implements FlutterAuthSessionManager {}
