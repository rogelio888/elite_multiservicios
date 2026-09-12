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

import 'package:serverpod/serverpod.dart' as _i1;

abstract class ServerMetricsResponse
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  ServerMetricsResponse._({
    required this.uptimeSeconds,
    required this.memoryRssBytes,
    required this.databaseLatencyMs,
    required this.activeSessionsCount,
    required this.failedLoginsLast24h,
    required this.serverTimestamp,
    required this.serverVersion,
  });

  factory ServerMetricsResponse({
    required int uptimeSeconds,
    required int memoryRssBytes,
    required int databaseLatencyMs,
    required int activeSessionsCount,
    required int failedLoginsLast24h,
    required DateTime serverTimestamp,
    required String serverVersion,
  }) = _ServerMetricsResponseImpl;

  factory ServerMetricsResponse.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return ServerMetricsResponse(
      uptimeSeconds: jsonSerialization['uptimeSeconds'] as int,
      memoryRssBytes: jsonSerialization['memoryRssBytes'] as int,
      databaseLatencyMs: jsonSerialization['databaseLatencyMs'] as int,
      activeSessionsCount: jsonSerialization['activeSessionsCount'] as int,
      failedLoginsLast24h: jsonSerialization['failedLoginsLast24h'] as int,
      serverTimestamp: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['serverTimestamp'],
      ),
      serverVersion: jsonSerialization['serverVersion'] as String,
    );
  }

  int uptimeSeconds;

  int memoryRssBytes;

  int databaseLatencyMs;

  int activeSessionsCount;

  int failedLoginsLast24h;

  DateTime serverTimestamp;

  String serverVersion;

  /// Returns a shallow copy of this [ServerMetricsResponse]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ServerMetricsResponse copyWith({
    int? uptimeSeconds,
    int? memoryRssBytes,
    int? databaseLatencyMs,
    int? activeSessionsCount,
    int? failedLoginsLast24h,
    DateTime? serverTimestamp,
    String? serverVersion,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ServerMetricsResponse',
      'uptimeSeconds': uptimeSeconds,
      'memoryRssBytes': memoryRssBytes,
      'databaseLatencyMs': databaseLatencyMs,
      'activeSessionsCount': activeSessionsCount,
      'failedLoginsLast24h': failedLoginsLast24h,
      'serverTimestamp': serverTimestamp.toJson(),
      'serverVersion': serverVersion,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ServerMetricsResponse',
      'uptimeSeconds': uptimeSeconds,
      'memoryRssBytes': memoryRssBytes,
      'databaseLatencyMs': databaseLatencyMs,
      'activeSessionsCount': activeSessionsCount,
      'failedLoginsLast24h': failedLoginsLast24h,
      'serverTimestamp': serverTimestamp.toJson(),
      'serverVersion': serverVersion,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _ServerMetricsResponseImpl extends ServerMetricsResponse {
  _ServerMetricsResponseImpl({
    required int uptimeSeconds,
    required int memoryRssBytes,
    required int databaseLatencyMs,
    required int activeSessionsCount,
    required int failedLoginsLast24h,
    required DateTime serverTimestamp,
    required String serverVersion,
  }) : super._(
         uptimeSeconds: uptimeSeconds,
         memoryRssBytes: memoryRssBytes,
         databaseLatencyMs: databaseLatencyMs,
         activeSessionsCount: activeSessionsCount,
         failedLoginsLast24h: failedLoginsLast24h,
         serverTimestamp: serverTimestamp,
         serverVersion: serverVersion,
       );

  /// Returns a shallow copy of this [ServerMetricsResponse]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ServerMetricsResponse copyWith({
    int? uptimeSeconds,
    int? memoryRssBytes,
    int? databaseLatencyMs,
    int? activeSessionsCount,
    int? failedLoginsLast24h,
    DateTime? serverTimestamp,
    String? serverVersion,
  }) {
    return ServerMetricsResponse(
      uptimeSeconds: uptimeSeconds ?? this.uptimeSeconds,
      memoryRssBytes: memoryRssBytes ?? this.memoryRssBytes,
      databaseLatencyMs: databaseLatencyMs ?? this.databaseLatencyMs,
      activeSessionsCount: activeSessionsCount ?? this.activeSessionsCount,
      failedLoginsLast24h: failedLoginsLast24h ?? this.failedLoginsLast24h,
      serverTimestamp: serverTimestamp ?? this.serverTimestamp,
      serverVersion: serverVersion ?? this.serverVersion,
    );
  }
}
