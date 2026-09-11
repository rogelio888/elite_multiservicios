import 'package:flutter_test/flutter_test.dart';
import 'package:elite_multiservicios_flutter/features/security/services/auth_service.dart';

void main() {
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

        expect(() async => await authService.logout(), returnsNormally);
        expect(() => authService.dispose(), returnsNormally);
      },
    );
  });
}
