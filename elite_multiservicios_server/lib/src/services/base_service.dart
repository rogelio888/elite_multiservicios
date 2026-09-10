import 'package:serverpod/serverpod.dart';

/// Contrato base para los servicios de negocio del backend.
abstract class BaseService {
  final Session session;

  const BaseService(this.session);
}
