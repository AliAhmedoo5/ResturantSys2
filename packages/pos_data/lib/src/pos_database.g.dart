// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pos_database.dart';

// ignore_for_file: type=lint
class DatabaseMetadata extends Table
    with TableInfo<DatabaseMetadata, DatabaseMetadataData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  DatabaseMetadata(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _singletonMeta = const VerificationMeta(
    'singleton',
  );
  late final GeneratedColumn<int> singleton = GeneratedColumn<int>(
    'singleton',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL PRIMARY KEY CHECK (singleton = 1)',
  );
  static const VerificationMeta _formatTagMeta = const VerificationMeta(
    'formatTag',
  );
  late final GeneratedColumn<String> formatTag = GeneratedColumn<String>(
    'format_tag',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (format_tag = \'crunch-cartel\')',
  );
  @override
  List<GeneratedColumn> get $columns => [singleton, formatTag];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'database_metadata';
  @override
  VerificationContext validateIntegrity(
    Insertable<DatabaseMetadataData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('singleton')) {
      context.handle(
        _singletonMeta,
        singleton.isAcceptableOrUnknown(data['singleton']!, _singletonMeta),
      );
    }
    if (data.containsKey('format_tag')) {
      context.handle(
        _formatTagMeta,
        formatTag.isAcceptableOrUnknown(data['format_tag']!, _formatTagMeta),
      );
    } else if (isInserting) {
      context.missing(_formatTagMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {singleton};
  @override
  DatabaseMetadataData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DatabaseMetadataData(
      singleton: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}singleton'],
      )!,
      formatTag: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}format_tag'],
      )!,
    );
  }

  @override
  DatabaseMetadata createAlias(String alias) {
    return DatabaseMetadata(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class DatabaseMetadataData extends DataClass
    implements Insertable<DatabaseMetadataData> {
  final int singleton;
  final String formatTag;
  const DatabaseMetadataData({
    required this.singleton,
    required this.formatTag,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['singleton'] = Variable<int>(singleton);
    map['format_tag'] = Variable<String>(formatTag);
    return map;
  }

  DatabaseMetadataCompanion toCompanion(bool nullToAbsent) {
    return DatabaseMetadataCompanion(
      singleton: Value(singleton),
      formatTag: Value(formatTag),
    );
  }

  factory DatabaseMetadataData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DatabaseMetadataData(
      singleton: serializer.fromJson<int>(json['singleton']),
      formatTag: serializer.fromJson<String>(json['format_tag']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'singleton': serializer.toJson<int>(singleton),
      'format_tag': serializer.toJson<String>(formatTag),
    };
  }

  DatabaseMetadataData copyWith({int? singleton, String? formatTag}) =>
      DatabaseMetadataData(
        singleton: singleton ?? this.singleton,
        formatTag: formatTag ?? this.formatTag,
      );
  DatabaseMetadataData copyWithCompanion(DatabaseMetadataCompanion data) {
    return DatabaseMetadataData(
      singleton: data.singleton.present ? data.singleton.value : this.singleton,
      formatTag: data.formatTag.present ? data.formatTag.value : this.formatTag,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DatabaseMetadataData(')
          ..write('singleton: $singleton, ')
          ..write('formatTag: $formatTag')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(singleton, formatTag);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DatabaseMetadataData &&
          other.singleton == this.singleton &&
          other.formatTag == this.formatTag);
}

class DatabaseMetadataCompanion extends UpdateCompanion<DatabaseMetadataData> {
  final Value<int> singleton;
  final Value<String> formatTag;
  const DatabaseMetadataCompanion({
    this.singleton = const Value.absent(),
    this.formatTag = const Value.absent(),
  });
  DatabaseMetadataCompanion.insert({
    this.singleton = const Value.absent(),
    required String formatTag,
  }) : formatTag = Value(formatTag);
  static Insertable<DatabaseMetadataData> custom({
    Expression<int>? singleton,
    Expression<String>? formatTag,
  }) {
    return RawValuesInsertable({
      if (singleton != null) 'singleton': singleton,
      if (formatTag != null) 'format_tag': formatTag,
    });
  }

  DatabaseMetadataCompanion copyWith({
    Value<int>? singleton,
    Value<String>? formatTag,
  }) {
    return DatabaseMetadataCompanion(
      singleton: singleton ?? this.singleton,
      formatTag: formatTag ?? this.formatTag,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (singleton.present) {
      map['singleton'] = Variable<int>(singleton.value);
    }
    if (formatTag.present) {
      map['format_tag'] = Variable<String>(formatTag.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DatabaseMetadataCompanion(')
          ..write('singleton: $singleton, ')
          ..write('formatTag: $formatTag')
          ..write(')'))
        .toString();
  }
}

abstract class _$PosDatabase extends GeneratedDatabase {
  _$PosDatabase(QueryExecutor e) : super(e);
  $PosDatabaseManager get managers => $PosDatabaseManager(this);
  late final DatabaseMetadata databaseMetadata = DatabaseMetadata(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [databaseMetadata];
}

typedef $DatabaseMetadataCreateCompanionBuilder =
    DatabaseMetadataCompanion Function({
      Value<int> singleton,
      required String formatTag,
    });
typedef $DatabaseMetadataUpdateCompanionBuilder =
    DatabaseMetadataCompanion Function({
      Value<int> singleton,
      Value<String> formatTag,
    });

class $DatabaseMetadataFilterComposer
    extends Composer<_$PosDatabase, DatabaseMetadata> {
  $DatabaseMetadataFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get singleton => $composableBuilder(
    column: $table.singleton,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get formatTag => $composableBuilder(
    column: $table.formatTag,
    builder: (column) => ColumnFilters(column),
  );
}

class $DatabaseMetadataOrderingComposer
    extends Composer<_$PosDatabase, DatabaseMetadata> {
  $DatabaseMetadataOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get singleton => $composableBuilder(
    column: $table.singleton,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get formatTag => $composableBuilder(
    column: $table.formatTag,
    builder: (column) => ColumnOrderings(column),
  );
}

class $DatabaseMetadataAnnotationComposer
    extends Composer<_$PosDatabase, DatabaseMetadata> {
  $DatabaseMetadataAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get singleton =>
      $composableBuilder(column: $table.singleton, builder: (column) => column);

  GeneratedColumn<String> get formatTag =>
      $composableBuilder(column: $table.formatTag, builder: (column) => column);
}

class $DatabaseMetadataTableManager
    extends
        RootTableManager<
          _$PosDatabase,
          DatabaseMetadata,
          DatabaseMetadataData,
          $DatabaseMetadataFilterComposer,
          $DatabaseMetadataOrderingComposer,
          $DatabaseMetadataAnnotationComposer,
          $DatabaseMetadataCreateCompanionBuilder,
          $DatabaseMetadataUpdateCompanionBuilder,
          (
            DatabaseMetadataData,
            BaseReferences<
              _$PosDatabase,
              DatabaseMetadata,
              DatabaseMetadataData
            >,
          ),
          DatabaseMetadataData,
          PrefetchHooks Function()
        > {
  $DatabaseMetadataTableManager(_$PosDatabase db, DatabaseMetadata table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $DatabaseMetadataFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $DatabaseMetadataOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $DatabaseMetadataAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> singleton = const Value.absent(),
                Value<String> formatTag = const Value.absent(),
              }) => DatabaseMetadataCompanion(
                singleton: singleton,
                formatTag: formatTag,
              ),
          createCompanionCallback:
              ({
                Value<int> singleton = const Value.absent(),
                required String formatTag,
              }) => DatabaseMetadataCompanion.insert(
                singleton: singleton,
                formatTag: formatTag,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<DatabaseMetadata, DatabaseMetadataData>(table),
                  BaseReferences<
                    _$PosDatabase,
                    DatabaseMetadata,
                    DatabaseMetadataData
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $DatabaseMetadataProcessedTableManager =
    ProcessedTableManager<
      _$PosDatabase,
      DatabaseMetadata,
      DatabaseMetadataData,
      $DatabaseMetadataFilterComposer,
      $DatabaseMetadataOrderingComposer,
      $DatabaseMetadataAnnotationComposer,
      $DatabaseMetadataCreateCompanionBuilder,
      $DatabaseMetadataUpdateCompanionBuilder,
      (
        DatabaseMetadataData,
        BaseReferences<_$PosDatabase, DatabaseMetadata, DatabaseMetadataData>,
      ),
      DatabaseMetadataData,
      PrefetchHooks Function()
    >;

class $PosDatabaseManager {
  final _$PosDatabase _db;
  $PosDatabaseManager(this._db);
  $DatabaseMetadataTableManager get databaseMetadata =>
      $DatabaseMetadataTableManager(_db, _db.databaseMetadata);
}
