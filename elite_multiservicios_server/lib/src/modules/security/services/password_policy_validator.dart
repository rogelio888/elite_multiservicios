import '../../../exceptions/app_exception.dart';

/// Validador de políticas corporativas de contraseñas para Elite Multiservicios.
class PasswordPolicyValidator {
  static const int minLength = 10;
  static const String _symbols = r'!@#$%^&*(),.?":{}|<>';

  static const Set<String> _commonPasswords = {
    '123456',
    'password',
    '12345678',
    'qwerty',
    '123456789',
    '12345',
    '1234',
    '111111',
    '1234567',
    'dragon',
    '123123',
    'baseball',
    'abc123',
    'football',
    'monkey',
    'letmein',
    '696969',
    'shadow',
    'master',
    '666666',
    'qwertyuiop',
    '123321',
    'mustang',
    '1234567890',
    'michael',
    '654321',
    'superman',
    '1qaz2wsx',
    '7777777',
    'fuckyou',
    '121212',
    '000000',
    'qazwsx',
    '123qwe',
    'killer',
    'trustno1',
    'jordan',
    'jennifer',
    'zxcvbnm',
    'asdfgh',
    'hunter',
    'buster',
    'soccer',
    'harley',
    'batman',
    'andrew',
    'tigger',
    'sunshine',
    'iloveyou',
    'fuckme',
    '2000',
    'charlie',
    'robert',
    'thomas',
    'hockey',
    'ranger',
    'daniel',
    'starwars',
    'klaster',
    '112233',
    'george',
    'asshole',
    'computer',
    'michelle',
    'jessica',
    'pepper',
    '1111',
    'zxcvbn',
    '555555',
    '11111111',
    '131313',
    'freedom',
    '777777',
    'pass',
    'fuck',
    'maggie',
    '159753',
    'aaaaaa',
    'ginger',
    'princess',
    'joshua',
    'cheese',
    'amanda',
    'summer',
    'love',
    'ashley',
    '6969',
    'nicole',
    'chelsea',
    'biteme',
    'matthew',
    'access',
    'yankees',
    '987654321',
    'dallas',
    'austin',
    'thunder',
    'taylor',
    'matrix',
    'william',
    'corvette',
    'hello',
    'martin',
    'heather',
    'secret',
    'fucker',
    'merlin',
    'diamond',
    '1234qwer',
    'gfhjkm',
    'hammer',
    'silver',
    '222222',
    '88888888',
    'anthony',
    'justin',
    'test',
    'bailey',
    'q1w2e3r4t5',
    'patrick',
    'internet',
    'scooter',
    'orange',
    '11111',
    'golfer',
    'cookie',
    'richard',
    'samantha',
    'bigdog',
    'guitar',
    'jackson',
    'whatever',
    'mickey',
    'chicken',
    'spanky',
    'qwerty123',
    'snoopy',
    'carlos',
    'startrek',
    'ncc1701',
    'falcon',
    'mercedes',
    'qwertyui',
    'admin',
    'welcome',
    'user',
    'test123',
    'root',
    'toor',
    'pass123',
    'admin123',
    'elite',
    'elite123',
    'elitemultiservicios',
    'password123',
    'passw0rd',
  };

  /// Valida la contraseña contra las políticas corporativas.
  /// Lanza [PasswordPolicyException] con la lista de errores si falla.
  static void validate({
    required String password,
    required String email,
    required String fullName,
  }) {
    final errors = <String>[];

    if (password.length < minLength) {
      errors.add('La contraseña debe tener al menos $minLength caracteres.');
    }
    if (!RegExp(r'[A-Z]').hasMatch(password)) {
      errors.add('Debe contener al menos una letra mayúscula.');
    }
    if (!RegExp(r'[a-z]').hasMatch(password)) {
      errors.add('Debe contener al menos una letra minúscula.');
    }
    if (!RegExp(r'[0-9]').hasMatch(password)) {
      errors.add('Debe contener al menos un número.');
    }
    if (!password.split('').any((c) => _symbols.contains(c))) {
      errors.add('Debe contener al menos un símbolo especial.');
    }
    if (isCommonPassword(password)) {
      errors.add('Esta contraseña es demasiado común. Elegí otra.');
    }

    final emailLocalPart = email.split('@').first.toLowerCase();
    if (emailLocalPart.length >= 3 &&
        password.toLowerCase().contains(emailLocalPart)) {
      errors.add('La contraseña no debe contener tu correo electrónico.');
    }

    final nameParts = fullName
        .toLowerCase()
        .split(' ')
        .where((p) => p.length >= 3);
    for (final part in nameParts) {
      if (password.toLowerCase().contains(part)) {
        errors.add('La contraseña no debe contener tu nombre.');
        break;
      }
    }

    if (errors.isNotEmpty) {
      throw PasswordPolicyException(errors: errors);
    }
  }

  /// Validador liviano para [EmailIdpConfig] (reglas estructurales sin contexto de usuario).
  static bool isValidForIdp(String password) {
    if (password.length < minLength) return false;
    if (!RegExp(r'[A-Z]').hasMatch(password)) return false;
    if (!RegExp(r'[a-z]').hasMatch(password)) return false;
    if (!RegExp(r'[0-9]').hasMatch(password)) return false;
    if (!password.split('').any((c) => _symbols.contains(c))) return false;
    if (isCommonPassword(password)) return false;
    return true;
  }

  static bool isCommonPassword(String password) {
    return _commonPasswords.contains(password.toLowerCase());
  }
}
