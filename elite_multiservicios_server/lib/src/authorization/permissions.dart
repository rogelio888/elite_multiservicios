/// Definición canónica de permisos granulares del sistema empresarial.
/// La autorización siempre se valida a nivel de permisos, nunca únicamente por nombre de rol.
abstract class AppPermissions {
  // --- Módulo Usuarios ---
  static const String usersView = 'users.view';
  static const String usersCreate = 'users.create';
  static const String usersUpdate = 'users.update';
  static const String usersDisable = 'users.disable';
  static const String usersDelete = 'users.delete';

  // --- Módulo Roles & Permisos (RBAC) ---
  static const String rolesView = 'roles.view';
  static const String rolesManage = 'roles.manage';
  static const String permissionsView = 'permissions.view';
  static const String permissionsAssign = 'permissions.assign';

  // --- Módulo Auditoría ---
  static const String auditView = 'audit.view';
  static const String auditExport = 'audit.export';

  // --- Módulo Sesiones y Monitoreo ---
  static const String sessionsView = 'sessions.view';
  static const String sessionsRevoke = 'sessions.revoke';
  static const String serverMetricsView = 'metrics.view';

  // --- Operaciones de Mantenimiento ---
  static const String systemMaintenance = 'system.maintenance';

  // --- Módulo CRM: Prospectos (Leads) ---
  static const String crmLeadsView = 'leads.view';
  static const String crmLeadsCreate = 'leads.create';
  static const String crmLeadsUpdate = 'leads.update';
  static const String crmLeadsDelete = 'leads.delete';
  static const String crmLeadsPromote = 'leads.promote';

  /// Catálogo de todos los permisos registrados en el sistema.
  static const List<String> all = [
    usersView,
    usersCreate,
    usersUpdate,
    usersDisable,
    usersDelete,
    rolesView,
    rolesManage,
    permissionsView,
    permissionsAssign,
    auditView,
    auditExport,
    sessionsView,
    sessionsRevoke,
    serverMetricsView,
    systemMaintenance,
    crmLeadsView,
    crmLeadsCreate,
    crmLeadsUpdate,
    crmLeadsDelete,
    crmLeadsPromote,
  ];
}
