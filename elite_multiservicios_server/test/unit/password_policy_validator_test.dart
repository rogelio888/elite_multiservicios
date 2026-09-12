import 'package:test/test.dart';
import 'package:elite_multiservicios_server/src/modules/security/services/password_policy_validator.dart';
import 'package:elite_multiservicios_server/src/exceptions/app_exception.dart';

void main() {
  group('PasswordPolicyValidator Unit Tests', () {
    test('validates compliant password successfully without throwing', () {
      expect(
        () => PasswordPolicyValidator.validate(
          password: 'PasswordSuperSegura2026!',
          email: 'admin@elitemultiservicios.com',
          fullName: 'Administrador General',
        ),
        returnsNormally,
      );
    });

    test('rejects passwords shorter than 10 characters', () {
      expect(
        () => PasswordPolicyValidator.validate(
          password: 'Aa1!short',
          email: 'user@empresa.com',
          fullName: 'Juan Perez',
        ),
        throwsA(
          isA<PasswordPolicyException>().having(
            (e) => e.errors,
            'errors',
            contains(contains('al menos 10 caracteres')),
          ),
        ),
      );
    });

    test('requires at least one uppercase, lowercase, number, and symbol', () {
      // Falta mayúscula
      expect(
        () => PasswordPolicyValidator.validate(
          password: 'password12345!',
          email: 'user@empresa.com',
          fullName: 'Juan Perez',
        ),
        throwsA(
          isA<PasswordPolicyException>().having(
            (e) => e.errors,
            'errors',
            contains(contains('letra mayúscula')),
          ),
        ),
      );

      // Falta minúscula
      expect(
        () => PasswordPolicyValidator.validate(
          password: 'PASSWORD12345!',
          email: 'user@empresa.com',
          fullName: 'Juan Perez',
        ),
        throwsA(
          isA<PasswordPolicyException>().having(
            (e) => e.errors,
            'errors',
            contains(contains('letra minúscula')),
          ),
        ),
      );

      // Falta número
      expect(
        () => PasswordPolicyValidator.validate(
          password: 'PasswordSinNumero!',
          email: 'user@empresa.com',
          fullName: 'Juan Perez',
        ),
        throwsA(
          isA<PasswordPolicyException>().having(
            (e) => e.errors,
            'errors',
            contains(contains('un número')),
          ),
        ),
      );

      // Falta símbolo
      expect(
        () => PasswordPolicyValidator.validate(
          password: 'PasswordSinSimbolo123',
          email: 'user@empresa.com',
          fullName: 'Juan Perez',
        ),
        throwsA(
          isA<PasswordPolicyException>().having(
            (e) => e.errors,
            'errors',
            contains(contains('símbolo especial')),
          ),
        ),
      );
    });

    test('rejects common dictionary passwords', () {
      expect(PasswordPolicyValidator.isCommonPassword('123456'), isTrue);
      expect(PasswordPolicyValidator.isCommonPassword('password'), isTrue);
      expect(PasswordPolicyValidator.isCommonPassword('qwertyuiop'), isTrue);

      expect(
        () => PasswordPolicyValidator.validate(
          password: 'Password123!',
          email: 'user@empresa.com',
          fullName: 'Juan Perez',
        ),
        // 'Password123!' contains 'password' -> if common check tests whole lowercase or contains
        returnsNormally, // 'Password123!' is not in the set
      );

      // If the password matches a common password in the set (e.g. '1234567890')
      expect(
        PasswordPolicyValidator.isCommonPassword('1234567890'),
        isTrue,
      );
    });

    test('rejects password containing email local part', () {
      expect(
        () => PasswordPolicyValidator.validate(
          password: 'RobertoSeguro2026!',
          email: 'roberto@empresa.com',
          fullName: 'Carlos Gomez',
        ),
        throwsA(
          isA<PasswordPolicyException>().having(
            (e) => e.errors,
            'errors',
            contains(contains('correo electrónico')),
          ),
        ),
      );
    });

    test('rejects password containing user full name parts', () {
      expect(
        () => PasswordPolicyValidator.validate(
          password: 'ClaveGomez2026!',
          email: 'user@empresa.com',
          fullName: 'Carlos Gomez',
        ),
        throwsA(
          isA<PasswordPolicyException>().having(
            (e) => e.errors,
            'errors',
            contains(contains('tu nombre')),
          ),
        ),
      );
    });

    test(
      'isValidForIdp returns true for valid password and false for invalid',
      () {
        expect(
          PasswordPolicyValidator.isValidForIdp('PasswordSuperSegura2026!'),
          isTrue,
        );
        // Menor a 10
        expect(PasswordPolicyValidator.isValidForIdp('short1!A'), isFalse);
        // Sin mayúscula
        expect(
          PasswordPolicyValidator.isValidForIdp('password123456!'),
          isFalse,
        );
        // Sin minúscula
        expect(
          PasswordPolicyValidator.isValidForIdp('PASSWORD123456!'),
          isFalse,
        );
        // Sin número
        expect(
          PasswordPolicyValidator.isValidForIdp('PasswordSinNumero!'),
          isFalse,
        );
        // Sin símbolo
        expect(
          PasswordPolicyValidator.isValidForIdp('PasswordSinSimbolo12'),
          isFalse,
        );
        // Común
        expect(PasswordPolicyValidator.isValidForIdp('1234567890'), isFalse);
      },
    );
  });
}
