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

abstract class AccountingTax
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  AccountingTax._({
    this.id,
    required this.name,
    required this.rate,
    required this.type,
    this.ledgerAccountId,
    required this.isActive,
  });

  factory AccountingTax({
    int? id,
    required String name,
    required double rate,
    required String type,
    int? ledgerAccountId,
    required bool isActive,
  }) = _AccountingTaxImpl;

  factory AccountingTax.fromJson(Map<String, dynamic> jsonSerialization) {
    return AccountingTax(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      rate: (jsonSerialization['rate'] as num).toDouble(),
      type: jsonSerialization['type'] as String,
      ledgerAccountId: jsonSerialization['ledgerAccountId'] as int?,
      isActive: _i1.BoolJsonExtension.fromJson(jsonSerialization['isActive']),
    );
  }

  static final t = AccountingTaxTable();

  static const db = AccountingTaxRepository._();

  @override
  int? id;

  String name;

  double rate;

  String type;

  int? ledgerAccountId;

  bool isActive;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [AccountingTax]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AccountingTax copyWith({
    int? id,
    String? name,
    double? rate,
    String? type,
    int? ledgerAccountId,
    bool? isActive,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AccountingTax',
      if (id != null) 'id': id,
      'name': name,
      'rate': rate,
      'type': type,
      if (ledgerAccountId != null) 'ledgerAccountId': ledgerAccountId,
      'isActive': isActive,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AccountingTax',
      if (id != null) 'id': id,
      'name': name,
      'rate': rate,
      'type': type,
      if (ledgerAccountId != null) 'ledgerAccountId': ledgerAccountId,
      'isActive': isActive,
    };
  }

  static AccountingTaxInclude include() {
    return AccountingTaxInclude._();
  }

  static AccountingTaxIncludeList includeList({
    _i1.WhereExpressionBuilder<AccountingTaxTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AccountingTaxTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AccountingTaxTable>? orderByList,
    AccountingTaxInclude? include,
  }) {
    return AccountingTaxIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AccountingTax.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(AccountingTax.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AccountingTaxImpl extends AccountingTax {
  _AccountingTaxImpl({
    int? id,
    required String name,
    required double rate,
    required String type,
    int? ledgerAccountId,
    required bool isActive,
  }) : super._(
         id: id,
         name: name,
         rate: rate,
         type: type,
         ledgerAccountId: ledgerAccountId,
         isActive: isActive,
       );

  /// Returns a shallow copy of this [AccountingTax]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AccountingTax copyWith({
    Object? id = _Undefined,
    String? name,
    double? rate,
    String? type,
    Object? ledgerAccountId = _Undefined,
    bool? isActive,
  }) {
    return AccountingTax(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      rate: rate ?? this.rate,
      type: type ?? this.type,
      ledgerAccountId: ledgerAccountId is int?
          ? ledgerAccountId
          : this.ledgerAccountId,
      isActive: isActive ?? this.isActive,
    );
  }
}

class AccountingTaxUpdateTable extends _i1.UpdateTable<AccountingTaxTable> {
  AccountingTaxUpdateTable(super.table);

  _i1.ColumnValue<String, String> name(String value) => _i1.ColumnValue(
    table.name,
    value,
  );

  _i1.ColumnValue<double, double> rate(double value) => _i1.ColumnValue(
    table.rate,
    value,
  );

  _i1.ColumnValue<String, String> type(String value) => _i1.ColumnValue(
    table.type,
    value,
  );

  _i1.ColumnValue<int, int> ledgerAccountId(int? value) => _i1.ColumnValue(
    table.ledgerAccountId,
    value,
  );

  _i1.ColumnValue<bool, bool> isActive(bool value) => _i1.ColumnValue(
    table.isActive,
    value,
  );
}

class AccountingTaxTable extends _i1.Table<int?> {
  AccountingTaxTable({super.tableRelation})
    : super(tableName: 'accounting_tax') {
    updateTable = AccountingTaxUpdateTable(this);
    name = _i1.ColumnString(
      'name',
      this,
    );
    rate = _i1.ColumnDouble(
      'rate',
      this,
    );
    type = _i1.ColumnString(
      'type',
      this,
    );
    ledgerAccountId = _i1.ColumnInt(
      'ledgerAccountId',
      this,
    );
    isActive = _i1.ColumnBool(
      'isActive',
      this,
    );
  }

  late final AccountingTaxUpdateTable updateTable;

  late final _i1.ColumnString name;

  late final _i1.ColumnDouble rate;

  late final _i1.ColumnString type;

  late final _i1.ColumnInt ledgerAccountId;

  late final _i1.ColumnBool isActive;

  @override
  List<_i1.Column> get columns => [
    id,
    name,
    rate,
    type,
    ledgerAccountId,
    isActive,
  ];
}

class AccountingTaxInclude extends _i1.IncludeObject {
  AccountingTaxInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => AccountingTax.t;
}

class AccountingTaxIncludeList extends _i1.IncludeList {
  AccountingTaxIncludeList._({
    _i1.WhereExpressionBuilder<AccountingTaxTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(AccountingTax.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => AccountingTax.t;
}

class AccountingTaxRepository {
  const AccountingTaxRepository._();

  /// Returns a list of [AccountingTax]s matching the given query parameters.
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
  Future<List<AccountingTax>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<AccountingTaxTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AccountingTaxTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AccountingTaxTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<AccountingTax>(
      where: where?.call(AccountingTax.t),
      orderBy: orderBy?.call(AccountingTax.t),
      orderByList: orderByList?.call(AccountingTax.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [AccountingTax] matching the given query parameters.
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
  Future<AccountingTax?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<AccountingTaxTable>? where,
    int? offset,
    _i1.OrderByBuilder<AccountingTaxTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AccountingTaxTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<AccountingTax>(
      where: where?.call(AccountingTax.t),
      orderBy: orderBy?.call(AccountingTax.t),
      orderByList: orderByList?.call(AccountingTax.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [AccountingTax] by its [id] or null if no such row exists.
  Future<AccountingTax?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<AccountingTax>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [AccountingTax]s in the list and returns the inserted rows.
  ///
  /// The returned [AccountingTax]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<AccountingTax>> insert(
    _i1.DatabaseSession session,
    List<AccountingTax> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<AccountingTax>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [AccountingTax] and returns the inserted row.
  ///
  /// The returned [AccountingTax] will have its `id` field set.
  Future<AccountingTax> insertRow(
    _i1.DatabaseSession session,
    AccountingTax row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<AccountingTax>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [AccountingTax]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<AccountingTax>> update(
    _i1.DatabaseSession session,
    List<AccountingTax> rows, {
    _i1.ColumnSelections<AccountingTaxTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<AccountingTax>(
      rows,
      columns: columns?.call(AccountingTax.t),
      transaction: transaction,
    );
  }

  /// Updates a single [AccountingTax]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<AccountingTax> updateRow(
    _i1.DatabaseSession session,
    AccountingTax row, {
    _i1.ColumnSelections<AccountingTaxTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<AccountingTax>(
      row,
      columns: columns?.call(AccountingTax.t),
      transaction: transaction,
    );
  }

  /// Updates a single [AccountingTax] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<AccountingTax?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<AccountingTaxUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<AccountingTax>(
      id,
      columnValues: columnValues(AccountingTax.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [AccountingTax]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<AccountingTax>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<AccountingTaxUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<AccountingTaxTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AccountingTaxTable>? orderBy,
    _i1.OrderByListBuilder<AccountingTaxTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<AccountingTax>(
      columnValues: columnValues(AccountingTax.t.updateTable),
      where: where(AccountingTax.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AccountingTax.t),
      orderByList: orderByList?.call(AccountingTax.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [AccountingTax]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<AccountingTax>> delete(
    _i1.DatabaseSession session,
    List<AccountingTax> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<AccountingTax>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [AccountingTax].
  Future<AccountingTax> deleteRow(
    _i1.DatabaseSession session,
    AccountingTax row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<AccountingTax>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<AccountingTax>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<AccountingTaxTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<AccountingTax>(
      where: where(AccountingTax.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<AccountingTaxTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<AccountingTax>(
      where: where?.call(AccountingTax.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [AccountingTax] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<AccountingTaxTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<AccountingTax>(
      where: where(AccountingTax.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
