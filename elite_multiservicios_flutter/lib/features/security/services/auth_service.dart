import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:elite_multiservicios_client/elite_multiservicios_client.dart';
import 'package:flutter/foundation.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';
import '../../../../main.dart' as main_app;
import 'security_api_service.dart';

/// Servicio reactivo para orquestar la autenticación de usuarios, gestión de tokens JWT
/// y auditoría server-side de cierre de sesión en Elite Multiservicios.
class AuthService extends ChangeNotifier {
  static const _trustedDeviceKey = 'trusted_device_token';
  static const _rememberMeKey = 'remember_me_preference';
  static const _rememberedEmailKey = 'remembered_email';
  final _secureStorage = const FlutterSecureStorage();

  bool _isMfaPending = false;
  bool get isMfaPending => _isMfaPending;

  bool _isCheckingMfa = false;
  bool get isCheckingMfa => _isCheckingMfa;

  bool _currentRememberMe = false;
  bool get currentRememberMe => _currentRememberMe;

  MfaChallengeResponse? _currentMfaChallenge;
  MfaChallengeResponse? get currentMfaChallenge => _currentMfaChallenge;

  void setMfaPending(
    MfaChallengeResponse? challenge, {
    bool rememberMe = false,
  }) {
    _currentMfaChallenge = challenge;
    _isMfaPending = challenge != null;
    _currentRememberMe = rememberMe;
    notifyListeners();
  }

  void clearMfaPending() {
    _currentMfaChallenge = null;
    _isMfaPending = false;
    notifyListeners();
  }

  final Client _client;
  final SecurityApiService _securityApi;

  AuthService({
    Client? client,
    SecurityApiService? securityApi,
  }) : _client = client ?? main_app.client,
       _securityApi = securityApi ?? SecurityApiService() {
    if (_client.authKeyProvider == null) {
      _client.authSessionManager = FlutterAuthSessionManager();
    }
    // Suscribirse a cambios reactivos de autenticación en Serverpod
    _client.auth.authInfoListenable.addListener(_onAuthChanged);
  }

  void _onAuthChanged() {
    notifyListeners();
  }

  /// Indica si existe una sesión activa y autenticada.
  bool get isAuthenticated =>
      _client.authKeyProvider != null && _client.auth.isAuthenticated;

  /// Retorna los metadatos de sesión y tokens JWT del usuario autenticado actual.
  AuthSuccess? get currentAuthInfo =>
      _client.authKeyProvider != null ? _client.auth.authInfo : null;

  /// Alias de conveniencia para pruebas y vistas que consultan el usuario activo.
  AuthSuccess? get currentUser => currentAuthInfo;

  /// Nombre o identificador legible para presentar en la interfaz de usuario.
  String? get currentDisplayName =>
      currentAuthInfo != null ? 'Administrador' : null;

  /// Acceso al servicio de API de seguridad y RBAC.
  SecurityApiService get securityApi => _securityApi;

  /// Inicia sesión con credenciales corporativas mediante emailIdp de Serverpod.
  Future<bool> login({
    required String email,
    required String password,
    bool rememberMe = false,
  }) async {
    _isCheckingMfa = true;
    _currentRememberMe = rememberMe;
    try {
      final authSuccess = await _client.emailIdp.login(
        email: email.trim(),
        password: password,
      );

      // Actualizar el session manager con los tokens JWT y credenciales recibidas
      await _client.auth.updateSignedInUser(authSuccess);

      // Registrar sesión en base de datos para auditoría y monitoreo
      try {
        final token = authSuccess.token;
        final expiresAt =
            authSuccess.tokenExpiresAt ??
            DateTime.now().toUtc().add(const Duration(days: 30));
        await _client.sessionManagement.registerSession(
          sessionTokenHash: _hashToken(token),
          expiresAt: expiresAt,
          mfaVerified: false,
        );
      } catch (e) {
        if (kDebugMode) {
          print('Error registrando sesión: $e');
        }
      }

      // Verificar inmediatamente si MFA es requerido para este usuario
      final mfaChallenge = await checkMfaRequired(rememberMe: rememberMe);
      if (mfaChallenge != null) {
        setMfaPending(mfaChallenge, rememberMe: rememberMe);
      } else {
        clearMfaPending();
      }

      await saveRememberMePreference(
        rememberMe: rememberMe,
        email: email,
      );

      return true;
    } catch (e) {
      clearMfaPending();
      try {
        await _client.auth.signOutDevice();
      } catch (_) {}
      if (kDebugMode) {
        print('Error en login: $e');
      }
      rethrow;
    } finally {
      _isCheckingMfa = false;
      notifyListeners();
    }
  }

  /// Paso 1: Inicia la solicitud de recuperación. Envía un código por email.
  /// Retorna el `passwordResetRequestId` para los siguientes pasos.
  Future<UuidValue> startPasswordReset(String email) async {
    return await _client.emailIdp.startPasswordReset(email: email.trim());
  }

  /// Paso 2: Verifica el código de 8 dígitos recibido por email.
  /// Retorna el `finishPasswordResetToken` que autoriza el cambio.
  Future<String> verifyPasswordResetCode({
    required UuidValue passwordResetRequestId,
    required String verificationCode,
  }) async {
    return await _client.emailIdp.verifyPasswordResetCode(
      passwordResetRequestId: passwordResetRequestId,
      verificationCode: verificationCode.trim(),
    );
  }

  /// Paso 3: Aplica la nueva contraseña.
  Future<void> finishPasswordReset({
    required String finishPasswordResetToken,
    required String newPassword,
  }) async {
    await _client.emailIdp.finishPasswordReset(
      finishPasswordResetToken: finishPasswordResetToken,
      newPassword: newPassword,
    );
  }

  /// Obtiene el AppUser asociado a la sesión actual.
  Future<AppUser> getCurrentUser() async {
    return await _client.user.getCurrentUser();
  }

  /// Cambia la contraseña del usuario autenticado.
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    await _client.user.changePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
    );
  }

  /// Verifica si el usuario autenticado requiere MFA.
  /// Si sí, retorna el challenge. Si no, retorna null.
  Future<MfaChallengeResponse?> checkMfaRequired({
    required bool rememberMe,
  }) async {
    final trustedToken = await getTrustedDeviceToken();
    return await _client.mfa.checkRequired(
      rememberMe: rememberMe,
      trustedDeviceToken: trustedToken,
    );
  }

  /// Verifica el código MFA.
  Future<MfaVerifyResponse> verifyMfa({
    required String challengeId,
    required String code,
    required bool rememberMe,
  }) async {
    final response = await _client.mfa.verifyMfa(
      challengeId: challengeId,
      code: code,
      rememberMe: rememberMe,
    );
    // Si el backend devolvió un trustedDeviceToken, guardarlo
    if (response.trustedDeviceToken != null) {
      await saveTrustedDeviceToken(response.trustedDeviceToken!);
    }
    return response;
  }

  /// Reenvía un nuevo código MFA.
  Future<void> resendMfaCode({required String challengeId}) async {
    await _client.mfa.resendMfaCode(challengeId: challengeId);
  }

  /// Guarda el token de dispositivo de confianza.
  Future<void> saveTrustedDeviceToken(String token) async {
    try {
      await _secureStorage.write(key: _trustedDeviceKey, value: token);
    } catch (e) {
      if (kDebugMode) {
        print('Error guardando trusted device token: $e');
      }
    }
  }

  /// Lee el token de dispositivo de confianza.
  Future<String?> getTrustedDeviceToken() async {
    try {
      return await _secureStorage.read(key: _trustedDeviceKey);
    } catch (e) {
      if (kDebugMode) {
        print('Error leyendo trusted device token: $e');
      }
      return null;
    }
  }

  /// Elimina el token de dispositivo de confianza.
  Future<void> clearTrustedDeviceToken() async {
    try {
      await _secureStorage.delete(key: _trustedDeviceKey);
    } catch (e) {
      if (kDebugMode) {
        print('Error eliminando trusted device token: $e');
      }
    }
  }

  /// Retorna si el usuario tenía activada la preferencia 'Recordarme'.
  Future<bool> getRememberMePreference() async {
    try {
      final val = await _secureStorage.read(key: _rememberMeKey);
      return val == 'true';
    } catch (_) {
      return false;
    }
  }

  /// Retorna el correo recordado si existiera.
  Future<String?> getRememberedEmail() async {
    try {
      return await _secureStorage.read(key: _rememberedEmailKey);
    } catch (_) {
      return null;
    }
  }

  /// Guarda o elimina la preferencia 'Recordarme' y el correo recordado.
  Future<void> saveRememberMePreference({
    required bool rememberMe,
    String? email,
  }) async {
    try {
      if (rememberMe) {
        await _secureStorage.write(key: _rememberMeKey, value: 'true');
        if (email != null && email.trim().isNotEmpty) {
          await _secureStorage.write(
            key: _rememberedEmailKey,
            value: email.trim(),
          );
        }
      } else {
        await _secureStorage.delete(key: _rememberMeKey);
        await _secureStorage.delete(key: _rememberedEmailKey);
        await clearTrustedDeviceToken();
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error guardando preferencia rememberMe: $e');
      }
    }
  }

  /// Flujo de Logout Server-Side auditado:
  /// 1. Revoca la sesión en base de datos y registra el evento LOGOUT en el servidor.
  /// 2. Purga los tokens JWT locales de almacenamiento seguro mediante client.auth.signOutDevice().
  Future<void> logout({int? activeSessionId}) async {
    clearMfaPending();
    try {
      // 1. Intentar revocar en el servidor (best-effort)
      try {
        await _client.sessionManagement.logout();
      } catch (e) {
        if (kDebugMode) {
          print('Error revocando sesión en servidor: $e');
        }
        // Continuar con la purga local aunque falle la red
      }
    } finally {
      // 2. Purgar tokens locales
      await _client.auth.signOutDevice();
      notifyListeners();
    }
  }

  static String _hashToken(String token) {
    return sha256.convert(utf8.encode(token)).toString();
  }

  @override
  void dispose() {
    _client.auth.authInfoListenable.removeListener(_onAuthChanged);
    super.dispose();
  }
}
