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

import 'package:serverpod/serverpod.dart' as _i1;

/// Documento adjunto al expediente digital del empleado (CI, Finiquito, Contrato, etc.).
abstract class RrhhEmployeeDocument
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  RrhhEmployeeDocument._({
    this.id,
    required this.employeeId,
    required this.documentType,
    required this.title,
    required this.fileUrl,
    required this.fileName,
    int? fileSizeBytes,
    this.mimeType,
    bool? isVerified,
    this.verifiedBy,
    this.verifiedAt,
    required this.createdAt,
    required this.updatedAt,
  }) : fileSizeBytes = fileSizeBytes ?? 0,
       isVerified = isVerified ?? true;

  factory RrhhEmployeeDocument({
    int? id,
    required int employeeId,
    required String documentType,
    required String title,
    required String fileUrl,
    required String fileName,
    int? fileSizeBytes,
    String? mimeType,
    bool? isVerified,
    String? verifiedBy,
    DateTime? verifiedAt,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _RrhhEmployeeDocumentImpl;

  factory RrhhEmployeeDocument.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return RrhhEmployeeDocument(
      id: jsonSerialization['id'] as int?,
      employeeId: jsonSerialization['employeeId'] as int,
      documentType: jsonSerialization['documentType'] as String,
      title: jsonSerialization['title'] as String,
      fileUrl: jsonSerialization['fileUrl'] as String,
      fileName: jsonSerialization['fileName'] as String,
      fileSizeBytes: jsonSerialization['fileSizeBytes'] as int?,
      mimeType: jsonSerialization['mimeType'] as String?,
      isVerified: jsonSerialization['isVerified'] == null
          ? null
          : _i1.BoolJsonExtension.fromJson(jsonSerialization['isVerified']),
      verifiedBy: jsonSerialization['verifiedBy'] as String?,
      verifiedAt: jsonSerialization['verifiedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['verifiedAt']),
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      updatedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
    );
  }

  static final t = RrhhEmployeeDocumentTable();

  static const db = RrhhEmployeeDocumentRepository._();

  @override
  int? id;

  /// Empleado al que pertenece el documento.
  int employeeId;

  /// Tipo de documento: 'CI', 'AVISO_LUZ_AGUA', 'CROQUIS', 'FELCC', 'FOTO', 'SEGURO_SUS', 'CONTRATO_FIRMADO', 'FINIQUITO', 'OTRO'.
  String documentType;

  /// Título descriptivo del documento.
  String title;

  /// Ruta o URL de almacenamiento del archivo.
  String fileUrl;

  /// Nombre original del archivo.
  String fileName;

  /// Tamaño del archivo en bytes.
  int? fileSizeBytes;

  /// Tipo MIME del archivo (ej: application/pdf, image/jpeg).
  String? mimeType;

  /// Estado de verificación por parte de RRHH.
  bool isVerified;

  /// Usuario que verificó el documento.
  String? verifiedBy;

  /// Fecha de verificación.
  DateTime? verifiedAt;

  DateTime createdAt;

  DateTime updatedAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [RrhhEmployeeDocument]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  RrhhEmployeeDocument copyWith({
    int? id,
    int? employeeId,
    String? documentType,
    String? title,
    String? fileUrl,
    String? fileName,
    int? fileSizeBytes,
    String? mimeType,
    bool? isVerified,
    String? verifiedBy,
    DateTime? verifiedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'RrhhEmployeeDocument',
      if (id != null) 'id': id,
      'employeeId': employeeId,
      'documentType': documentType,
      'title': title,
      'fileUrl': fileUrl,
      'fileName': fileName,
      if (fileSizeBytes != null) 'fileSizeBytes': fileSizeBytes,
      if (mimeType != null) 'mimeType': mimeType,
      'isVerified': isVerified,
      if (verifiedBy != null) 'verifiedBy': verifiedBy,
      if (verifiedAt != null) 'verifiedAt': verifiedAt?.toJson(),
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'RrhhEmployeeDocument',
      if (id != null) 'id': id,
      'employeeId': employeeId,
      'documentType': documentType,
      'title': title,
      'fileUrl': fileUrl,
      'fileName': fileName,
      if (fileSizeBytes != null) 'fileSizeBytes': fileSizeBytes,
      if (mimeType != null) 'mimeType': mimeType,
      'isVerified': isVerified,
      if (verifiedBy != null) 'verifiedBy': verifiedBy,
      if (verifiedAt != null) 'verifiedAt': verifiedAt?.toJson(),
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  static RrhhEmployeeDocumentInclude include() {
    return RrhhEmployeeDocumentInclude._();
  }

  static RrhhEmployeeDocumentIncludeList includeList({
    _i1.WhereExpressionBuilder<RrhhEmployeeDocumentTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<RrhhEmployeeDocumentTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<RrhhEmployeeDocumentTable>? orderByList,
    RrhhEmployeeDocumentInclude? include,
  }) {
    return RrhhEmployeeDocumentIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(RrhhEmployeeDocument.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(RrhhEmployeeDocument.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _RrhhEmployeeDocumentImpl extends RrhhEmployeeDocument {
  _RrhhEmployeeDocumentImpl({
    int? id,
    required int employeeId,
    required String documentType,
    required String title,
    required String fileUrl,
    required String fileName,
    int? fileSizeBytes,
    String? mimeType,
    bool? isVerified,
    String? verifiedBy,
    DateTime? verifiedAt,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         employeeId: employeeId,
         documentType: documentType,
         title: title,
         fileUrl: fileUrl,
         fileName: fileName,
         fileSizeBytes: fileSizeBytes,
         mimeType: mimeType,
         isVerified: isVerified,
         verifiedBy: verifiedBy,
         verifiedAt: verifiedAt,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [RrhhEmployeeDocument]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  RrhhEmployeeDocument copyWith({
    Object? id = _Undefined,
    int? employeeId,
    String? documentType,
    String? title,
    String? fileUrl,
    String? fileName,
    Object? fileSizeBytes = _Undefined,
    Object? mimeType = _Undefined,
    bool? isVerified,
    Object? verifiedBy = _Undefined,
    Object? verifiedAt = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return RrhhEmployeeDocument(
      id: id is int? ? id : this.id,
      employeeId: employeeId ?? this.employeeId,
      documentType: documentType ?? this.documentType,
      title: title ?? this.title,
      fileUrl: fileUrl ?? this.fileUrl,
      fileName: fileName ?? this.fileName,
      fileSizeBytes: fileSizeBytes is int? ? fileSizeBytes : this.fileSizeBytes,
      mimeType: mimeType is String? ? mimeType : this.mimeType,
      isVerified: isVerified ?? this.isVerified,
      verifiedBy: verifiedBy is String? ? verifiedBy : this.verifiedBy,
      verifiedAt: verifiedAt is DateTime? ? verifiedAt : this.verifiedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class RrhhEmployeeDocumentUpdateTable
    extends _i1.UpdateTable<RrhhEmployeeDocumentTable> {
  RrhhEmployeeDocumentUpdateTable(super.table);

  _i1.ColumnValue<int, int> employeeId(int value) => _i1.ColumnValue(
    table.employeeId,
    value,
  );

  _i1.ColumnValue<String, String> documentType(String value) => _i1.ColumnValue(
    table.documentType,
    value,
  );

  _i1.ColumnValue<String, String> title(String value) => _i1.ColumnValue(
    table.title,
    value,
  );

  _i1.ColumnValue<String, String> fileUrl(String value) => _i1.ColumnValue(
    table.fileUrl,
    value,
  );

  _i1.ColumnValue<String, String> fileName(String value) => _i1.ColumnValue(
    table.fileName,
    value,
  );

  _i1.ColumnValue<int, int> fileSizeBytes(int? value) => _i1.ColumnValue(
    table.fileSizeBytes,
    value,
  );

  _i1.ColumnValue<String, String> mimeType(String? value) => _i1.ColumnValue(
    table.mimeType,
    value,
  );

  _i1.ColumnValue<bool, bool> isVerified(bool value) => _i1.ColumnValue(
    table.isVerified,
    value,
  );

  _i1.ColumnValue<String, String> verifiedBy(String? value) => _i1.ColumnValue(
    table.verifiedBy,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> verifiedAt(DateTime? value) =>
      _i1.ColumnValue(
        table.verifiedAt,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> updatedAt(DateTime value) =>
      _i1.ColumnValue(
        table.updatedAt,
        value,
      );
}

class RrhhEmployeeDocumentTable extends _i1.Table<int?> {
  RrhhEmployeeDocumentTable({super.tableRelation})
    : super(tableName: 'rrhh_employee_document') {
    updateTable = RrhhEmployeeDocumentUpdateTable(this);
    employeeId = _i1.ColumnInt(
      'employeeId',
      this,
    );
    documentType = _i1.ColumnString(
      'documentType',
      this,
    );
    title = _i1.ColumnString(
      'title',
      this,
    );
    fileUrl = _i1.ColumnString(
      'fileUrl',
      this,
    );
    fileName = _i1.ColumnString(
      'fileName',
      this,
    );
    fileSizeBytes = _i1.ColumnInt(
      'fileSizeBytes',
      this,
      hasDefault: true,
    );
    mimeType = _i1.ColumnString(
      'mimeType',
      this,
    );
    isVerified = _i1.ColumnBool(
      'isVerified',
      this,
      hasDefault: true,
    );
    verifiedBy = _i1.ColumnString(
      'verifiedBy',
      this,
    );
    verifiedAt = _i1.ColumnDateTime(
      'verifiedAt',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
    updatedAt = _i1.ColumnDateTime(
      'updatedAt',
      this,
    );
  }

  late final RrhhEmployeeDocumentUpdateTable updateTable;

  /// Empleado al que pertenece el documento.
  late final _i1.ColumnInt employeeId;

  /// Tipo de documento: 'CI', 'AVISO_LUZ_AGUA', 'CROQUIS', 'FELCC', 'FOTO', 'SEGURO_SUS', 'CONTRATO_FIRMADO', 'FINIQUITO', 'OTRO'.
  late final _i1.ColumnString documentType;

  /// Título descriptivo del documento.
  late final _i1.ColumnString title;

  /// Ruta o URL de almacenamiento del archivo.
  late final _i1.ColumnString fileUrl;

  /// Nombre original del archivo.
  late final _i1.ColumnString fileName;

  /// Tamaño del archivo en bytes.
  late final _i1.ColumnInt fileSizeBytes;

  /// Tipo MIME del archivo (ej: application/pdf, image/jpeg).
  late final _i1.ColumnString mimeType;

  /// Estado de verificación por parte de RRHH.
  late final _i1.ColumnBool isVerified;

  /// Usuario que verificó el documento.
  late final _i1.ColumnString verifiedBy;

  /// Fecha de verificación.
  late final _i1.ColumnDateTime verifiedAt;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime updatedAt;

  @override
  List<_i1.Column> get columns => [
    id,
    employeeId,
    documentType,
    title,
    fileUrl,
    fileName,
    fileSizeBytes,
    mimeType,
    isVerified,
    verifiedBy,
    verifiedAt,
    createdAt,
    updatedAt,
  ];
}

class RrhhEmployeeDocumentInclude extends _i1.IncludeObject {
  RrhhEmployeeDocumentInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => RrhhEmployeeDocument.t;
}

class RrhhEmployeeDocumentIncludeList extends _i1.IncludeList {
  RrhhEmployeeDocumentIncludeList._({
    _i1.WhereExpressionBuilder<RrhhEmployeeDocumentTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(RrhhEmployeeDocument.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => RrhhEmployeeDocument.t;
}

class RrhhEmployeeDocumentRepository {
  const RrhhEmployeeDocumentRepository._();

  /// Returns a list of [RrhhEmployeeDocument]s matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order of the items use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// The maximum number of items can be set by [limit]. If no limit is set,
  /// all items matching the query will be returned.
  ///
  /// [offset] defines how many items to skip, after which [limit] (or all)
  /// items are read from the database.
  ///
  /// ```dart
  /// var persons = await Persons.db.find(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// );
  /// ```
  Future<List<RrhhEmployeeDocument>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<RrhhEmployeeDocumentTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<RrhhEmployeeDocumentTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<RrhhEmployeeDocumentTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<RrhhEmployeeDocument>(
      where: where?.call(RrhhEmployeeDocument.t),
      orderBy: orderBy?.call(RrhhEmployeeDocument.t),
      orderByList: orderByList?.call(RrhhEmployeeDocument.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [RrhhEmployeeDocument] matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// [offset] defines how many items to skip, after which the next one will be picked.
  ///
  /// ```dart
  /// var youngestPerson = await Persons.db.findFirstRow(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.age,
  /// );
  /// ```
  Future<RrhhEmployeeDocument?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<RrhhEmployeeDocumentTable>? where,
    int? offset,
    _i1.OrderByBuilder<RrhhEmployeeDocumentTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<RrhhEmployeeDocumentTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<RrhhEmployeeDocument>(
      where: where?.call(RrhhEmployeeDocument.t),
      orderBy: orderBy?.call(RrhhEmployeeDocument.t),
      orderByList: orderByList?.call(RrhhEmployeeDocument.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [RrhhEmployeeDocument] by its [id] or null if no such row exists.
  Future<RrhhEmployeeDocument?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<RrhhEmployeeDocument>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [RrhhEmployeeDocument]s in the list and returns the inserted rows.
  ///
  /// The returned [RrhhEmployeeDocument]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<RrhhEmployeeDocument>> insert(
    _i1.DatabaseSession session,
    List<RrhhEmployeeDocument> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<RrhhEmployeeDocument>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [RrhhEmployeeDocument] and returns the inserted row.
  ///
  /// The returned [RrhhEmployeeDocument] will have its `id` field set.
  Future<RrhhEmployeeDocument> insertRow(
    _i1.DatabaseSession session,
    RrhhEmployeeDocument row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<RrhhEmployeeDocument>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [RrhhEmployeeDocument]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<RrhhEmployeeDocument>> update(
    _i1.DatabaseSession session,
    List<RrhhEmployeeDocument> rows, {
    _i1.ColumnSelections<RrhhEmployeeDocumentTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<RrhhEmployeeDocument>(
      rows,
      columns: columns?.call(RrhhEmployeeDocument.t),
      transaction: transaction,
    );
  }

  /// Updates a single [RrhhEmployeeDocument]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<RrhhEmployeeDocument> updateRow(
    _i1.DatabaseSession session,
    RrhhEmployeeDocument row, {
    _i1.ColumnSelections<RrhhEmployeeDocumentTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<RrhhEmployeeDocument>(
      row,
      columns: columns?.call(RrhhEmployeeDocument.t),
      transaction: transaction,
    );
  }

  /// Updates a single [RrhhEmployeeDocument] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<RrhhEmployeeDocument?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<RrhhEmployeeDocumentUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<RrhhEmployeeDocument>(
      id,
      columnValues: columnValues(RrhhEmployeeDocument.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [RrhhEmployeeDocument]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<RrhhEmployeeDocument>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<RrhhEmployeeDocumentUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<RrhhEmployeeDocumentTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<RrhhEmployeeDocumentTable>? orderBy,
    _i1.OrderByListBuilder<RrhhEmployeeDocumentTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<RrhhEmployeeDocument>(
      columnValues: columnValues(RrhhEmployeeDocument.t.updateTable),
      where: where(RrhhEmployeeDocument.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(RrhhEmployeeDocument.t),
      orderByList: orderByList?.call(RrhhEmployeeDocument.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [RrhhEmployeeDocument]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<RrhhEmployeeDocument>> delete(
    _i1.DatabaseSession session,
    List<RrhhEmployeeDocument> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<RrhhEmployeeDocument>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [RrhhEmployeeDocument].
  Future<RrhhEmployeeDocument> deleteRow(
    _i1.DatabaseSession session,
    RrhhEmployeeDocument row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<RrhhEmployeeDocument>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<RrhhEmployeeDocument>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<RrhhEmployeeDocumentTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<RrhhEmployeeDocument>(
      where: where(RrhhEmployeeDocument.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<RrhhEmployeeDocumentTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<RrhhEmployeeDocument>(
      where: where?.call(RrhhEmployeeDocument.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [RrhhEmployeeDocument] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<RrhhEmployeeDocumentTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<RrhhEmployeeDocument>(
      where: where(RrhhEmployeeDocument.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
