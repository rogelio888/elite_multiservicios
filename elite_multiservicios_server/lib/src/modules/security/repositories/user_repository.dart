import 'package:serverpod/serverpod.dart';
import '../../../generated/protocol.dart';

/// Repositorio para gestión y persistencia de usuarios empresariales.
class UserRepository {
  final Session session;

  const UserRepository(this.session);

  /// Busca un usuario por su identificador primario.
  Future<AppUser?> findById(int id) async {
    return await AppUser.db.findById(session, id);
  }

  /// Busca un usuario activo por su correo electrónico.
  Future<AppUser?> findByEmail(String email) async {
    return await AppUser.db.findFirstRow(
      session,
      where: (t) => t.email.equals(email) & t.isDeleted.equals(false),
    );
  }

  /// Lista usuarios paginados con opción de filtro por estado.
  Future<List<AppUser>> listUsers({
    int limit = 50,
    int offset = 0,
    bool includeDeleted = false,
  }) async {
    return await AppUser.db.find(
      session,
      where: includeDeleted ? null : (t) => t.isDeleted.equals(false),
      limit: limit,
      offset: offset,
      orderBy: (t) => t.createdAt,
      orderDescending: true,
    );
  }

  /// Crea un nuevo usuario en base de datos.
  Future<AppUser> create(AppUser user) async {
    return await AppUser.db.insertRow(session, user);
  }

  /// Actualiza los datos de un usuario existente.
  Future<AppUser> update(AppUser user) async {
    return await AppUser.db.updateRow(
      session,
      user.copyWith(updatedAt: DateTime.now().toUtc()),
    );
  }

  /// Desactiva o activa la cuenta de un usuario.
  Future<AppUser?> setActiveStatus(int id, bool isActive) async {
    final user = await findById(id);
    if (user == null) return null;

    return await update(user.copyWith(isActive: isActive));
  }

  /// Realiza un borrado lógico (Soft Delete) del usuario.
  Future<bool> softDelete(int id) async {
    final user = await findById(id);
    if (user == null) return false;

    await update(user.copyWith(isDeleted: true, isActive: false));
    return true;
  }

  /// Realiza un borrado físico completo de un usuario para permitir su recreación limpia.
  Future<bool> hardDelete(int id) async {
    final user = await findById(id);
    if (user == null) return false;

    await AppUser.db.deleteRow(session, user);
    return true;
  }
}
