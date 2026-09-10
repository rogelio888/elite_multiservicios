import 'package:serverpod/serverpod.dart';

/// Contrato base para los repositorios de persistencia en PostgreSQL.
abstract class BaseRepository<T extends TableRow, IdType> {
  final Session session;

  const BaseRepository(this.session);

  /// Busca una entidad por su identificador único.
  Future<T?> findById(IdType id);

  /// Obtiene un listado paginado de entidades.
  Future<List<T>> findAll({int limit = 50, int offset = 0});
}
