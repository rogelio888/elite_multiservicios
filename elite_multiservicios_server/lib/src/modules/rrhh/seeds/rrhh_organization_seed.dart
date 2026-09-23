import 'package:serverpod/serverpod.dart';
import '../repositories/rrhh_organization_repository.dart';

/// Seed de base de datos para inicializar la Estructura Organizacional de RRHH:
/// Áreas Departamentales, Cargos de Personal y Especialidades Técnicas de Elite Multiservicios.
class RrhhOrganizationSeed {
  static Future<void> seed(Session session) async {
    session.log(
      'Ejecutando seed de Estructura Organizacional RRHH en PostgreSQL...',
      level: LogLevel.info,
    );

    final repo = RrhhOrganizationRepository(session);
    await repo.seedInitialOrganizationData();

    session.log(
      'Seed de Estructura Organizacional RRHH culminado exitosamente.',
      level: LogLevel.info,
    );
  }
}
