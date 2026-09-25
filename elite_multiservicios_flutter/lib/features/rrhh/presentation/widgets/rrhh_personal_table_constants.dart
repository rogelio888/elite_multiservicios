/// Anchos fijos y estandarizados para las columnas de la tabla de Personal.
/// Garantiza consistencia pixel-perfect entre cabecera, filas y skeletons,
/// eliminando cualquier uso de Expanded/Flexible dentro de scrolls horizontales.
abstract class RrhhPersonalTableColumns {
  static const double codigo = 100.0;
  static const double foto = 50.0;
  static const double nombre = 220.0;
  static const double tipo = 90.0;
  static const double areaCargo = 210.0;
  static const double especialidad = 150.0;
  static const double disponibilidad = 140.0;
  static const double expediente = 80.0;
  static const double acciones = 110.0;

  static const double totalWidth = codigo +
      foto +
      nombre +
      tipo +
      areaCargo +
      especialidad +
      disponibilidad +
      expediente +
      acciones; // 1150.0
}
