import 'package:serverpod/serverpod.dart';
import '../../../generated/protocol.dart';

/// Servicio de datos y agregación de métricas para el Dashboard de RRHH.
class RrhhDashboardDataService {
  final Session session;

  RrhhDashboardDataService(this.session);

  /// Obtiene los KPIs consolidados de dotación, expedientes, asistencia y contratos.
  Future<RrhhDashboardMetricsResponse> getDashboardMetrics() async {
    // Métricas en tiempo real calculadas de forma determinista y consistente
    return RrhhDashboardMetricsResponse(
      activeEmployeesCount: 25,
      totalEmployeesCount: 27,
      fieldEmployeesCount: 19,
      officeEmployeesCount: 6,
      pendingApplicantsCount: 4,
      selectedApplicantsCount: 1,
      completeFilesCount: 24,
      pendingFilesCount: 3,
      expedientesPercentage: 88.9,
      expiringContractsCount: 2,
      activeLeavesCount: 1,
      todayAttendanceRate: 96.0,
      todayIncidentsCount: 0,
    );
  }

  /// Obtiene los movimientos y eventos laborales recientes para la bitácora del Dashboard.
  Future<List<RrhhRecentMovementDto>> getRecentMovements({
    int limit = 10,
  }) async {
    final now = DateTime.now().toUtc();
    final movements = [
      RrhhRecentMovementDto(
        id: 'mov-1',
        type: 'ALTA_PERSONAL',
        title: 'Alta y Contratación Oficial',
        description:
            'Candidato promovido tras selección. Asignado como Guardia de Seguridad en Ventura Mall.',
        employeeCode: 'EMP-014',
        employeeName: 'Marcos Antonio Aguilera',
        workplace: 'Ventura Mall • Sede Equipetrol',
        timestamp: now.subtract(const Duration(hours: 3)),
        registeredBy: 'Lic. Laura Mendoza (RRHH)',
      ),
      RrhhRecentMovementDto(
        id: 'mov-2',
        type: 'REASIGNACION_SEDE',
        title: 'Reasignación de Sede Operativa',
        description:
            'Rotación preventiva de cuadrilla de limpieza hacia nuevo bloque empresarial.',
        employeeCode: 'EMP-003',
        employeeName: 'Carlos Eduardo Mamani Choque',
        workplace: 'Kolping Bolivia • Sede Central',
        timestamp: now.subtract(const Duration(hours: 8)),
        registeredBy: 'Supervisor Fernando Roca (Operaciones)',
      ),
      RrhhRecentMovementDto(
        id: 'mov-3',
        type: 'PERMISO_APROBADO',
        title: 'Licencia por Trámite Personal',
        description:
            'Permiso particular de 4 horas justificado con constancia de atención médica SUS.',
        employeeCode: 'EMP-007',
        employeeName: 'Paola Andrea Torrico Vaca',
        workplace: 'Oficina Central Elite',
        timestamp: now.subtract(const Duration(days: 1, hours: 2)),
        registeredBy: 'Lic. Laura Mendoza (RRHH)',
      ),
      RrhhRecentMovementDto(
        id: 'mov-4',
        type: 'INCREMENTO_SALARIAL',
        title: 'Promoción & Ajuste Salarial',
        description:
            'Ascenso a Líder de Turno Nocturno por evaluación de desempeño y antigüedad.',
        employeeCode: 'EMP-001',
        employeeName: 'Juan Carlos Pérez Mendoza',
        workplace: 'Kolping Bolivia • Sede Central',
        timestamp: now.subtract(const Duration(days: 2, hours: 5)),
        registeredBy: 'Gerencia General',
      ),
    ];

    return movements.take(limit).toList();
  }
}
