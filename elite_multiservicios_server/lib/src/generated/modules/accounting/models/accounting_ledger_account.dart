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

abstract class AccountingLedgerAccount
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  AccountingLedgerAccount._({
    this.id,
    required this.code,
    required this.name,
    required this.type,
    this.description,
    required this.isActive,
  });

  factory AccountingLedgerAccount({
    int? id,
    required String code,
    required String name,
    required String type,
    String? description,
    required bool isActive,
  }) = _AccountingLedgerAccountImpl;

  factory AccountingLedgerAccount.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return AccountingLedgerAccount(
      id: jsonSerialization['id'] as int?,
      code: jsonSerialization['code'] as String,
      name: jsonSerialization['name'] as String,
      type: jsonSerialization['type'] as String,
      description: jsonSerialization['description'] as String?,
      isActive: _i1.BoolJsonExtension.fromJson(jsonSerialization['isActive']),
    );
  }

  static final t = AccountingLedgerAccountTable();

  static const db = AccountingLedgerAccountRepository._();

  @override
  int? id;

  String code;

  String name;

  String type;

  String? description;

  bool isActive;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [AccountingLedgerAccount]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AccountingLedgerAccount copyWith({
    int? id,
    String? code,
    String? name,
    String? type,
    String? description,
    bool? isActive,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AccountingLedgerAccount',
      if (id != null) 'id': id,
      'code': code,
      'name': name,
      'type': type,
      if (description != null) 'description': description,
      'isActive': isActive,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AccountingLedgerAccount',
      if (id != null) 'id': id,
      'code': code,
      'name': name,
      'type': type,
      if (description != null) 'description': description,
      'isActive': isActive,
    };
  }

  static AccountingLedgerAccountInclude include() {
    return AccountingLedgerAccountInclude._();
  }

  static AccountingLedgerAccountIncludeList includeList({
    _i1.WhereExpressionBuilder<AccountingLedgerAccountTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AccountingLedgerAccountTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AccountingLedgerAccountTable>? orderByList,
    AccountingLedgerAccountInclude? include,
  }) {
    return AccountingLedgerAccountIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AccountingLedgerAccount.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(AccountingLedgerAccount.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AccountingLedgerAccountImpl extends AccountingLedgerAccount {
  _AccountingLedgerAccountImpl({
    int? id,
    required String code,
    required String name,
    required String type,
    String? description,
    required bool isActive,
  }) : super._(
         id: id,
         code: code,
         name: name,
         type: type,
         description: description,
         isActive: isActive,
       );

  /// Returns a shallow copy of this [AccountingLedgerAccount]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AccountingLedgerAccount copyWith({
    Object? id = _Undefined,
    String? code,
    String? name,
    String? type,
    Object? description = _Undefined,
    bool? isActive,
  }) {
    return AccountingLedgerAccount(
      id: id is int? ? id : this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      type: type ?? this.type,
      description: description is String? ? description : this.description,
      isActive: isActive ?? this.isActive,
    );
  }
}

class AccountingLedgerAccountUpdateTable
    extends _i1.UpdateTable<AccountingLedgerAccountTable> {
  AccountingLedgerAccountUpdateTable(super.table);

  _i1.ColumnValue<String, String> code(String value) => _i1.ColumnValue(
    table.code,
    value,
  );

  _i1.ColumnValue<String, String> name(String value) => _i1.ColumnValue(
    table.name,
    value,
  );

  _i1.ColumnValue<String, String> type(String value) => _i1.ColumnValue(
    table.type,
    value,
  );

  _i1.ColumnValue<String, String> description(String? value) => _i1.ColumnValue(
    table.description,
    value,
  );

  _i1.ColumnValue<bool, bool> isActive(bool value) => _i1.ColumnValue(
    table.isActive,
    value,
  );
}

class AccountingLedgerAccountTable extends _i1.Table<int?> {
  AccountingLedgerAccountTable({super.tableRelation})
    : super(tableName: 'accounting_ledger_account') {
    updateTable = AccountingLedgerAccountUpdateTable(this);
    code = _i1.ColumnString(
      'code',
      this,
    );
    name = _i1.ColumnString(
      'name',
      this,
    );
    type = _i1.ColumnString(
      'type',
      this,
    );
    description = _i1.ColumnString(
      'description',
      this,
    );
    isActive = _i1.ColumnBool(
      'isActive',
      this,
    );
  }

  late final AccountingLedgerAccountUpdateTable updateTable;

  late final _i1.ColumnString code;

  late final _i1.ColumnString name;

  late final _i1.ColumnString type;

  late final _i1.ColumnString description;

  late final _i1.ColumnBool isActive;

  @override
  List<_i1.Column> get columns => [
    id,
    code,
    name,
    type,
    description,
    isActive,
  ];
}

class AccountingLedgerAccountInclude extends _i1.IncludeObject {
  AccountingLedgerAccountInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => AccountingLedgerAccount.t;
}

class AccountingLedgerAccountIncludeList extends _i1.IncludeList {
  AccountingLedgerAccountIncludeList._({
    _i1.WhereExpressionBuilder<AccountingLedgerAccountTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(AccountingLedgerAccount.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => AccountingLedgerAccount.t;
}

class AccountingLedgerAccountRepository {
  const AccountingLedgerAccountRepository._();

  /// Returns a list of [AccountingLedgerAccount]s matching the given query parameters.
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
  Future<List<AccountingLedgerAccount>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<AccountingLedgerAccountTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AccountingLedgerAccountTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AccountingLedgerAccountTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<AccountingLedgerAccount>(
      where: where?.call(AccountingLedgerAccount.t),
      orderBy: orderBy?.call(AccountingLedgerAccount.t),
      orderByList: orderByList?.call(AccountingLedgerAccount.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [AccountingLedgerAccount] matching the given query parameters.
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
  Future<AccountingLedgerAccount?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<AccountingLedgerAccountTable>? where,
    int? offset,
    _i1.OrderByBuilder<AccountingLedgerAccountTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AccountingLedgerAccountTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<AccountingLedgerAccount>(
      where: where?.call(AccountingLedgerAccount.t),
      orderBy: orderBy?.call(AccountingLedgerAccount.t),
      orderByList: orderByList?.call(AccountingLedgerAccount.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [AccountingLedgerAccount] by its [id] or null if no such row exists.
  Future<AccountingLedgerAccount?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<AccountingLedgerAccount>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [AccountingLedgerAccount]s in the list and returns the inserted rows.
  ///
  /// The returned [AccountingLedgerAccount]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<AccountingLedgerAccount>> insert(
    _i1.DatabaseSession session,
    List<AccountingLedgerAccount> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<AccountingLedgerAccount>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [AccountingLedgerAccount] and returns the inserted row.
  ///
  /// The returned [AccountingLedgerAccount] will have its `id` field set.
  Future<AccountingLedgerAccount> insertRow(
    _i1.DatabaseSession session,
    AccountingLedgerAccount row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<AccountingLedgerAccount>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [AccountingLedgerAccount]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<AccountingLedgerAccount>> update(
    _i1.DatabaseSession session,
    List<AccountingLedgerAccount> rows, {
    _i1.ColumnSelections<AccountingLedgerAccountTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<AccountingLedgerAccount>(
      rows,
      columns: columns?.call(AccountingLedgerAccount.t),
      transaction: transaction,
    );
  }

  /// Updates a single [AccountingLedgerAccount]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<AccountingLedgerAccount> updateRow(
    _i1.DatabaseSession session,
    AccountingLedgerAccount row, {
    _i1.ColumnSelections<AccountingLedgerAccountTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<AccountingLedgerAccount>(
      row,
      columns: columns?.call(AccountingLedgerAccount.t),
      transaction: transaction,
    );
  }

  /// Updates a single [AccountingLedgerAccount] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<AccountingLedgerAccount?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<AccountingLedgerAccountUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<AccountingLedgerAccount>(
      id,
      columnValues: columnValues(AccountingLedgerAccount.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [AccountingLedgerAccount]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<AccountingLedgerAccount>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<AccountingLedgerAccountUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<AccountingLedgerAccountTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AccountingLedgerAccountTable>? orderBy,
    _i1.OrderByListBuilder<AccountingLedgerAccountTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<AccountingLedgerAccount>(
      columnValues: columnValues(AccountingLedgerAccount.t.updateTable),
      where: where(AccountingLedgerAccount.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AccountingLedgerAccount.t),
      orderByList: orderByList?.call(AccountingLedgerAccount.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [AccountingLedgerAccount]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<AccountingLedgerAccount>> delete(
    _i1.DatabaseSession session,
    List<AccountingLedgerAccount> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<AccountingLedgerAccount>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [AccountingLedgerAccount].
  Future<AccountingLedgerAccount> deleteRow(
    _i1.DatabaseSession session,
    AccountingLedgerAccount row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<AccountingLedgerAccount>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<AccountingLedgerAccount>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<AccountingLedgerAccountTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<AccountingLedgerAccount>(
      where: where(AccountingLedgerAccount.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<AccountingLedgerAccountTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<AccountingLedgerAccount>(
      where: where?.call(AccountingLedgerAccount.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [AccountingLedgerAccount] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<AccountingLedgerAccountTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<AccountingLedgerAccount>(
      where: where(AccountingLedgerAccount.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
