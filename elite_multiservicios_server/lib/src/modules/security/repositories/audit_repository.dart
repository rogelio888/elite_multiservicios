import 'dart:convert';
import 'package:serverpod/serverpod.dart';
import '../../../generated/protocol.dart';
import '../../../audit/audit_event.dart';
import '../../../authorization/rbac_guard.dart';

/// Repositorio para la persistencia inmutable de la bitácora de auditoría en PostgreSQL.
class AuditRepository {
  final Session session;

  const AuditRepository(this.session);

  /// Inserta un nuevo evento de auditoría en base de datos.
  Future<AuditLog> record(AuditEventRecord record) async {
    final entity = AuditLog(
      action: record.action,
      userId: record.userId,
      userIdentifier: record.userIdentifier,
      resource: record.resource,
      ipAddress: record.ipAddress,
      result: record.result.name.toUpperCase(),
      metadata: record.metadata != null ? jsonEncode(record.metadata) : null,
      timestamp: record.timestamp,
    );

    return await AuditLog.db.insertRow(session, entity);
  }

  /// Lista eventos de auditoría con filtros opcionales.
  Future<List<AuditLog>> listLogs({
    int limit = 50,
    int offset = 0,
    int? userId,
    String? action,
  }) async {
    return await AuditLog.db.find(
      session,
      where: (t) {
        Expression filter = Constant.bool(true);
        if (userId != null) {
          filter = filter & t.userId.equals(userId);
        }
        if (action != null) {
          filter = filter & t.action.equals(action);
        }
        return filter;
      },
      limit: limit,
      offset: offset,
      orderBy: (t) => t.timestamp,
      orderDescending: true,
    );
  }

  /// Lista eventos de auditoría paginados con filtros avanzados.
  Future<AuditLogPageResponse> listLogsPaged({
    int page = 1,
    int pageSize = 25,
    String? action,
    String? result,
    int? userId,
    DateTime? fromDate,
    DateTime? toDate,
    String? search,
  }) async {
    final effectivePage = page < 1 ? 1 : page;
    final effectivePageSize = pageSize < 1 ? 25 : pageSize;
    final offset = (effectivePage - 1) * effectivePageSize;

    Expression whereBuilder(AuditLogTable t) {
      Expression filter = Constant.bool(true);
      if (action != null && action.isNotEmpty && action != 'TODAS') {
        filter = filter & t.action.equals(action);
      }
      if (result != null && result.isNotEmpty && result != 'TODOS') {
        filter = filter & t.result.equals(result);
      }
      if (userId != null) {
        filter = filter & t.userId.equals(userId);
      }
      if (fromDate != null) {
        filter = filter & (t.timestamp >= fromDate);
      }
      if (toDate != null) {
        filter = filter & (t.timestamp <= toDate);
      }
      if (search != null && search.trim().isNotEmpty) {
        final s = '%${search.trim().toLowerCase()}%';
        filter =
            filter &
            (t.userIdentifier.ilike(s) |
                t.resource.ilike(s) |
                t.ipAddress.ilike(s) |
                t.action.ilike(s));
      }
      return filter;
    }

    final totalCount = await AuditLog.db.count(
      session,
      where: whereBuilder,
    );

    final totalPages = totalCount == 0
        ? 1
        : (totalCount / effectivePageSize).ceil();

    final items = await AuditLog.db.find(
      session,
      where: whereBuilder,
      limit: effectivePageSize,
      offset: offset,
      orderBy: (t) => t.timestamp,
      orderDescending: true,
    );

    // Enriquecer registros que no tengan email legible (registros antiguos o con UUID)
    final missingEmailItems = items
        .where(
          (i) => i.userIdentifier == null || !i.userIdentifier!.contains('@'),
        )
        .toList();

    if (missingEmailItems.isNotEmpty) {
      final userIds = missingEmailItems
          .map((i) => i.userId)
          .whereType<int>()
          .toSet();

      final userMap = <int, String>{};
      if (userIds.isNotEmpty) {
        final users = await AppUser.db.find(
          session,
          where: (t) => t.id.inSet(userIds),
        );
        for (final u in users) {
          if (u.id != null) {
            userMap[u.id!] = u.email;
          }
        }
      }

      for (final item in missingEmailItems) {
        if (item.userId != null && userMap.containsKey(item.userId)) {
          item.userIdentifier = userMap[item.userId];
        } else if (item.userIdentifier != null &&
            !item.userIdentifier!.contains('@')) {
          try {
            final appUser = await RbacGuard.resolveAppUser(
              session,
              item.userIdentifier!,
            );
            item.userIdentifier = appUser.email;
          } catch (_) {}
        }
      }
    }

    return AuditLogPageResponse(
      items: items,
      totalCount: totalCount,
      page: effectivePage,
      totalPages: totalPages,
      pageSize: effectivePageSize,
    );
  }
}
