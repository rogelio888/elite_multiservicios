import 'package:flutter/material.dart';
import 'presentation/views/rrhh_dashboard_view.dart';
import 'presentation/views/rrhh_novedades_tabs_view.dart';
import 'presentation/views/rrhh_organizacion_tabs_view.dart';
import 'presentation/views/rrhh_personal_view.dart';
import 'presentation/views/rrhh_placeholder_view.dart';
import 'presentation/views/rrhh_reportes_tabs_view.dart';
import 'presentation/widgets/rrhh_employee_detail_dialog.dart';

/// Rutas oficiales para el módulo RRHH.
/// Estructura organizada en 6 entradas de menú superior con tabs internos
/// preservando retrocompatibilidad total con las 14 pantallas individuales.
class RrhhRoutes {
  // ---------------------------------------------------------------------------
  // 6 Rutas de Nivel Superior (Menú Acordeón Reorganizado)
  // ---------------------------------------------------------------------------
  static const String dashboard = '/rrhh/dashboard';
  static const String personal = '/rrhh/personal';
  static const String organizacion = '/rrhh/organizacion';
  static const String novedades = '/rrhh/novedades';
  static const String asistencia = '/rrhh/asistencia';
  static const String reportes = '/rrhh/reportes';

  // ---------------------------------------------------------------------------
  // Rutas Específicas / Sub-pantallas (Retrocompatibilidad e Invocación Directa)
  // ---------------------------------------------------------------------------
  static const String directorio = '/rrhh/personal/directorio';
  static const String expediente = '/rrhh/expediente';
  static const String postulantes = '/rrhh/postulantes';
  static const String contratacion = '/rrhh/contratacion';
  static const String areas = '/rrhh/organizacion/areas';
  static const String turnos = '/rrhh/turnos';
  static const String permisos = '/rrhh/permisos';
  static const String vacaciones = '/rrhh/vacaciones';
  static const String disciplina = '/rrhh/disciplina';
  static const String bajas = '/rrhh/bajas';
  static const String novedadesNomina = '/rrhh/novedades-nomina';
  static const String asistenciaCampo = '/rrhh/asistencia-campo';
  static const String bitacora = '/rrhh/bitacora';

  /// 6 Rutas canónicas del acordeón lateral
  static const List<String> topLevelRoutes = [
    dashboard,
    personal,
    organizacion,
    novedades,
    asistencia,
    reportes,
  ];

  /// Lista exhaustiva de las 14 pantallas funcionales
  static const List<String> allRoutes = [
    dashboard,
    personal,
    expediente,
    postulantes,
    contratacion,
    organizacion,
    turnos,
    permisos,
    vacaciones,
    disciplina,
    bajas,
    novedadesNomina,
    asistenciaCampo,
    bitacora,
  ];

  /// Generador de vistas de nivel superior (Contenedores con pestañas)
  static Widget buildTopLevelView(
    String route, {
    String? tab,
    void Function(int index)? onNavigateToTab,
  }) {
    switch (route) {
      case dashboard:
        return buildView(dashboard, onNavigateToTab: onNavigateToTab);
      case personal:
        return RrhhPersonalView(
          initialTab: tab,
          onNavigateToTab: onNavigateToTab,
        );
      case organizacion:
        return RrhhOrganizacionTabsView(
          initialTab: tab,
          onNavigateToTab: onNavigateToTab,
        );
      case novedades:
        return RrhhNovedadesTabsView(
          initialTab: tab,
          onNavigateToTab: onNavigateToTab,
        );
      case asistencia:
      case asistenciaCampo:
        return buildView(asistenciaCampo, onNavigateToTab: onNavigateToTab);
      case reportes:
        return RrhhReportesTabsView(
          initialTab: tab,
          onNavigateToTab: onNavigateToTab,
        );
      default:
        return buildView(route, onNavigateToTab: onNavigateToTab);
    }
  }

  /// Generador de vistas individuales (pantallas hijas o modales)
  static Widget buildView(
    String route, {
    void Function(int index)? onNavigateToTab,
  }) {
    switch (route) {
      case dashboard:
        return const RrhhDashboardView();
      case personal:
      case directorio:
        return const RrhhPersonalView();
      case expediente:
        return const Center(
          child: RrhhEmployeeDetailDialog(
            employeeId: 1,
          ),
        );
      case postulantes:
        return const RrhhPlaceholderView(
          title: '04. Reclutamiento & Pipeline de Postulantes',
          blockName: 'Bloque 2',
          description:
              'Gestión del embudo de candidatos, evaluación curricular, entrevistas y filtro previo a contratación.',
          icon: Icons.person_search_outlined,
        );
      case contratacion:
        return const RrhhPlaceholderView(
          title: '05. Contratación Formal (Wizard / Stepper)',
          blockName: 'Bloque 1',
          description:
              'Promoción guiada de postulante seleccionado a empleado o alta directa, validando checklist legal y bloqueo de antecedentes FELCC.',
          icon: Icons.how_to_reg_outlined,
        );
      case organizacion:
      case areas:
        return const RrhhPlaceholderView(
          title: '06. Estructura Organizacional',
          blockName: 'Bloque 2',
          description:
              'Administración de catálogos estructurales: Áreas corporativas, Puestos/Cargos de trabajo y Especialidades técnicas operativas.',
          icon: Icons.account_tree_outlined,
        );
      case turnos:
        return const RrhhPlaceholderView(
          title: '07. Catálogo de Horarios y Turnos Base',
          blockName: 'Bloque 2',
          description:
              'Gestión del catálogo oficial de jornadas y turnos de trabajo que RRHH publica para consulta de Operaciones.',
          icon: Icons.schedule_outlined,
        );
      case permisos:
        return const RrhhPlaceholderView(
          title: '08. Permisos y Licencias Médicas',
          blockName: 'Bloque 3',
          description:
              'Recepción, validación de certificados médicos (CNS) y resolución (Aprobación/Rechazo) de licencias laborales.',
          icon: Icons.fact_check_outlined,
        );
      case vacaciones:
        return const RrhhPlaceholderView(
          title: '09. Control de Vacaciones (Ley Laboral Bolivia)',
          blockName: 'Bloque 3',
          description:
              'Cómputo legal de días de vacación según antigüedad en Bolivia, registro de solicitudes y control de saldo de días.',
          icon: Icons.beach_access_outlined,
        );
      case disciplina:
        return const RrhhPlaceholderView(
          title: '10. Régimen Disciplinario e Incidencias',
          blockName: 'Bloque 3',
          description:
              'Emisión y registro de sanciones, memorándums de llamada de atención y felicitaciones por desempeño.',
          icon: Icons.gavel_outlined,
        );
      case bajas:
        return const RrhhPlaceholderView(
          title: '11. Desvinculación & Bajas Laborales',
          blockName: 'Bloque 3',
          description:
              'Proceso de egreso laboral definitivo, cálculo de antigüedad para finiquito y congelamiento del expediente sin borrado físico (Regla de Oro Inactivo).',
          icon: Icons.person_remove_outlined,
        );
      case novedadesNomina:
        return const RrhhPlaceholderView(
          title: '12. Novedades para Nómina (Entrega a Contabilidad)',
          blockName: 'Bloque 4',
          description:
              'Consolidado administrativo mensual de días trabajados, salarios base pactados, bonos y descuentos para entrega formal a Contabilidad (PDF Sección 6.1).',
          icon: Icons.request_quote_outlined,
        );
      case asistenciaCampo:
        return const RrhhPlaceholderView(
          title: '13. Asistencia de Campo Consolidada (Recepción APK)',
          blockName: 'Bloque 4',
          description:
              'Visualización de solo lectura de la realidad operativa de campo recibida de la APK: entradas, salidas, horas y retrasos (PDF Sección 4.3).',
          icon: Icons.pin_drop_outlined,
        );
      case bitacora:
        return const RrhhPlaceholderView(
          title: '14. Bitácora / Auditoría de Movimientos',
          blockName: 'Bloque 4',
          description:
              'Trazabilidad inmutable de todas las novedades laborales del sistema (ascensos, transferencias de área, ajustes salariales y bajas).',
          icon: Icons.history_edu_outlined,
        );
      default:
        return const Center(child: Text('Ruta de RRHH no encontrada'));
    }
  }
}
