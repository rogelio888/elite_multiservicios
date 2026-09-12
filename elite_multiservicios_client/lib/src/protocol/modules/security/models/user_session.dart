/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:serverpod_client/serverpod_client.dart' as _i1;

/// Sesión activa de usuario para monitoreo y control de concurrencia.
abstract class UserSession implements _i1.SerializableModel {
  UserSession._({
    this.id,
    required this.userId,
    required this.sessionTokenHash,
    this.ipAddress,
    this.deviceInfo,
    required this.isRevoked,
    bool? mfaVerified,
    this.revokedAt,
    required this.createdAt,
    required this.lastActivityAt,
    required this.expiresAt,
  }) : mfaVerified = mfaVerified ?? false;

  factory UserSession({
    int? id,
    required int userId,
    required String sessionTokenHash,
    String? ipAddress,
    String? deviceInfo,
    required bool isRevoked,
    bool? mfaVerified,
    DateTime? revokedAt,
    required DateTime createdAt,
    required DateTime lastActivityAt,
    required DateTime expiresAt,
  }) = _UserSessionImpl;

  factory UserSession.fromJson(Map<String, dynamic> jsonSerialization) {
    return UserSession(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as int,
      sessionTokenHash: jsonSerialization['sessionTokenHash'] as String,
      ipAddress: jsonSerialization['ipAddress'] as String?,
      deviceInfo: jsonSerialization['deviceInfo'] as String?,
      isRevoked: _i1.BoolJsonExtension.fromJson(jsonSerialization['isRevoked']),
      mfaVerified: jsonSerialization['mfaVerified'] == null
          ? null
          : _i1.BoolJsonExtension.fromJson(jsonSerialization['mfaVerified']),
      revokedAt: jsonSerialization['revokedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['revokedAt']),
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      lastActivityAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['lastActivityAt'],
      ),
      expiresAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['expiresAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  /// ID del usuario propietario de la sesión.
  int userId;

  /// Hash criptográfico del token de sesión (nunca el token plano).
  String sessionTokenHash;

  /// Dirección IP asociada a la sesión.
  String? ipAddress;

  /// Información de cliente/dispositivo (User-Agent).
  String? deviceInfo;

  /// Indicador de si la sesión ha sido revocada remotamente.
  bool isRevoked;

  /// Indicador de autenticación multifactor (MFA) verificada en esta sesión.
  bool mfaVerified;

  /// Momento de revocación de la sesión.
  DateTime? revokedAt;

  /// Momento de inicio de sesión.
  DateTime createdAt;

  /// Momento de última actividad registrada.
  DateTime lastActivityAt;

  /// Momento límite de expiración de la sesión.
  DateTime expiresAt;

  /// Returns a shallow copy of this [UserSession]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  UserSession copyWith({
    int? id,
    int? userId,
    String? sessionTokenHash,
    String? ipAddress,
    String? deviceInfo,
    bool? isRevoked,
    bool? mfaVerified,
    DateTime? revokedAt,
    DateTime? createdAt,
    DateTime? lastActivityAt,
    DateTime? expiresAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'UserSession',
      if (id != null) 'id': id,
      'userId': userId,
      'sessionTokenHash': sessionTokenHash,
      if (ipAddress != null) 'ipAddress': ipAddress,
      if (deviceInfo != null) 'deviceInfo': deviceInfo,
      'isRevoked': isRevoked,
      'mfaVerified': mfaVerified,
      if (revokedAt != null) 'revokedAt': revokedAt?.toJson(),
      'createdAt': createdAt.toJson(),
      'lastActivityAt': lastActivityAt.toJson(),
      'expiresAt': expiresAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UserSessionImpl extends UserSession {
  _UserSessionImpl({
    int? id,
    required int userId,
    required String sessionTokenHash,
    String? ipAddress,
    String? deviceInfo,
    required bool isRevoked,
    bool? mfaVerified,
    DateTime? revokedAt,
    required DateTime createdAt,
    required DateTime lastActivityAt,
    required DateTime expiresAt,
  }) : super._(
         id: id,
         userId: userId,
         sessionTokenHash: sessionTokenHash,
         ipAddress: ipAddress,
         deviceInfo: deviceInfo,
         isRevoked: isRevoked,
         mfaVerified: mfaVerified,
         revokedAt: revokedAt,
         createdAt: createdAt,
         lastActivityAt: lastActivityAt,
         expiresAt: expiresAt,
       );

  /// Returns a shallow copy of this [UserSession]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  UserSession copyWith({
    Object? id = _Undefined,
    int? userId,
    String? sessionTokenHash,
    Object? ipAddress = _Undefined,
    Object? deviceInfo = _Undefined,
    bool? isRevoked,
    bool? mfaVerified,
    Object? revokedAt = _Undefined,
    DateTime? createdAt,
    DateTime? lastActivityAt,
    DateTime? expiresAt,
  }) {
    return UserSession(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      sessionTokenHash: sessionTokenHash ?? this.sessionTokenHash,
      ipAddress: ipAddress is String? ? ipAddress : this.ipAddress,
      deviceInfo: deviceInfo is String? ? deviceInfo : this.deviceInfo,
      isRevoked: isRevoked ?? this.isRevoked,
      mfaVerified: mfaVerified ?? this.mfaVerified,
      revokedAt: revokedAt is DateTime? ? revokedAt : this.revokedAt,
      createdAt: createdAt ?? this.createdAt,
      lastActivityAt: lastActivityAt ?? this.lastActivityAt,
      expiresAt: expiresAt ?? this.expiresAt,
    );
  }
}
