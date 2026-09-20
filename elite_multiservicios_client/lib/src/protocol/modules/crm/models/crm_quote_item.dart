/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:serverpod_client/serverpod_client.dart' as _i1;

/// Partida o línea de cotización dentro de una oportunidad comercial.
abstract class CrmQuoteItem implements _i1.SerializableModel {
  CrmQuoteItem._({
    this.id,
    required this.opportunityId,
    required this.category,
    required this.concept,
    required this.unitType,
    required this.quantity,
    required this.unitPrice,
    bool? isDeleted,
    required this.createdAt,
    required this.updatedAt,
  }) : isDeleted = isDeleted ?? false;

  factory CrmQuoteItem({
    int? id,
    required int opportunityId,
    required String category,
    required String concept,
    required String unitType,
    required double quantity,
    required double unitPrice,
    bool? isDeleted,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _CrmQuoteItemImpl;

  factory CrmQuoteItem.fromJson(Map<String, dynamic> jsonSerialization) {
    return CrmQuoteItem(
      id: jsonSerialization['id'] as int?,
      opportunityId: jsonSerialization['opportunityId'] as int,
      category: jsonSerialization['category'] as String,
      concept: jsonSerialization['concept'] as String,
      unitType: jsonSerialization['unitType'] as String,
      quantity: (jsonSerialization['quantity'] as num).toDouble(),
      unitPrice: (jsonSerialization['unitPrice'] as num).toDouble(),
      isDeleted: jsonSerialization['isDeleted'] == null
          ? null
          : _i1.BoolJsonExtension.fromJson(jsonSerialization['isDeleted']),
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      updatedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  /// ID de la oportunidad a la que pertenece la cotización.
  int opportunityId;

  /// Categoría: Personal, Limpieza, Mantenimiento, Equipamiento, Materiales, Tecnología.
  String category;

  /// Concepto descriptivo del servicio o insumo.
  String concept;

  /// Tipo de unidad: Puesto 24/7, Puesto 12h, Operario, Global, m², Unid., Servicio, Kit, Tanque.
  String unitType;

  /// Cantidad requerida.
  double quantity;

  /// Precio unitario en Bs.
  double unitPrice;

  /// Eliminación lógica y auditoría temporal.
  bool isDeleted;

  DateTime createdAt;

  DateTime updatedAt;

  /// Returns a shallow copy of this [CrmQuoteItem]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  CrmQuoteItem copyWith({
    int? id,
    int? opportunityId,
    String? category,
    String? concept,
    String? unitType,
    double? quantity,
    double? unitPrice,
    bool? isDeleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CrmQuoteItem',
      if (id != null) 'id': id,
      'opportunityId': opportunityId,
      'category': category,
      'concept': concept,
      'unitType': unitType,
      'quantity': quantity,
      'unitPrice': unitPrice,
      'isDeleted': isDeleted,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CrmQuoteItemImpl extends CrmQuoteItem {
  _CrmQuoteItemImpl({
    int? id,
    required int opportunityId,
    required String category,
    required String concept,
    required String unitType,
    required double quantity,
    required double unitPrice,
    bool? isDeleted,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         opportunityId: opportunityId,
         category: category,
         concept: concept,
         unitType: unitType,
         quantity: quantity,
         unitPrice: unitPrice,
         isDeleted: isDeleted,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [CrmQuoteItem]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  CrmQuoteItem copyWith({
    Object? id = _Undefined,
    int? opportunityId,
    String? category,
    String? concept,
    String? unitType,
    double? quantity,
    double? unitPrice,
    bool? isDeleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CrmQuoteItem(
      id: id is int? ? id : this.id,
      opportunityId: opportunityId ?? this.opportunityId,
      category: category ?? this.category,
      concept: concept ?? this.concept,
      unitType: unitType ?? this.unitType,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
      isDeleted: isDeleted ?? this.isDeleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
