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
  String? get currentDisplayName => currentAuthInfo != null
      ? 'Usuario (${currentAuthInfo!.authUserId.uuid.substring(0, 8)})'
      : null;

  /// Acceso al servicio de API de seguridad y RBAC.
  SecurityApiService get securityApi => _securityApi;

  /// Inicia sesión con credenciales corporativas mediante emailIdp de Serverpod.
  Future<bool> login({
    required String email,
    required String password,
  }) async {
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
        );
      } catch (e) {
        if (kDebugMode) {
          print('Error registrando sesión: $e');
        }
      }

      notifyListeners();
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Error en login: $e');
      }
      rethrow;
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

  /// Flujo de Logout Server-Side auditado:
  /// 1. Revoca la sesión en base de datos y registra el evento LOGOUT en el servidor.
  /// 2. Purga los tokens JWT locales de almacenamiento seguro mediante client.auth.signOutDevice().
  Future<void> logout({int? activeSessionId}) async {
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
