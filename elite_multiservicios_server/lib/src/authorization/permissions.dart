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

  // --- Módulo CRM: Pipeline & Oportunidades ---
  static const String crmPipelineView = 'pipeline.view';
  static const String crmPipelineCreate = 'pipeline.create';
  static const String crmPipelineUpdate = 'pipeline.update';
  static const String crmPipelineDelete = 'pipeline.delete';
  static const String crmPipelinePromoteToCustomer =
      'pipeline.promote_customer';

  // --- Módulo CRM: Clientes 360° ---
  static const String crmCustomersView = 'customers.view';
  static const String crmCustomersCreate = 'customers.create';
  static const String crmCustomersUpdate = 'customers.update';
  static const String crmCustomersDelete = 'customers.delete';
  static const String crmCustomerBranchesManage = 'customers.branches.manage';
  static const String crmCustomerContractsManage = 'customers.contracts.manage';
  static const String crmCustomerContractsComplete =
      'customers.contracts.complete';
  static const String crmCustomerContractsRenew = 'customers.contracts.renew';

  // --- Módulo CRM: Agenda & Tareas ---
  static const String crmAgendaView = 'agenda.view';
  static const String crmAgendaCreate = 'agenda.create';
  static const String crmAgendaUpdate = 'agenda.update';
  static const String crmAgendaDelete = 'agenda.delete';
  static const String crmAgendaComplete = 'agenda.complete';

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
    crmPipelineView,
    crmPipelineCreate,
    crmPipelineUpdate,
    crmPipelineDelete,
    crmPipelinePromoteToCustomer,
    crmCustomersView,
    crmCustomersCreate,
    crmCustomersUpdate,
    crmCustomersDelete,
    crmCustomerBranchesManage,
    crmCustomerContractsManage,
    crmCustomerContractsComplete,
    crmCustomerContractsRenew,
    crmAgendaView,
    crmAgendaCreate,
    crmAgendaUpdate,
    crmAgendaDelete,
    crmAgendaComplete,
  ];
}
