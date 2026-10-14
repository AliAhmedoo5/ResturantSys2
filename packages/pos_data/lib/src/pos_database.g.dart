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

class SchemaUpgrades extends Table
    with TableInfo<SchemaUpgrades, SchemaUpgrade> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  SchemaUpgrades(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _toVersionMeta = const VerificationMeta(
    'toVersion',
  );
  late final GeneratedColumn<int> toVersion = GeneratedColumn<int>(
    'to_version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL PRIMARY KEY CHECK (to_version >= 2)',
  );
  static const VerificationMeta _fromVersionMeta = const VerificationMeta(
    'fromVersion',
  );
  late final GeneratedColumn<int> fromVersion = GeneratedColumn<int>(
    'from_version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints:
        'NOT NULL CHECK (from_version >= 1 AND from_version < to_version)',
  );
  static const VerificationMeta _appliedAtUtcMeta = const VerificationMeta(
    'appliedAtUtc',
  );
  late final GeneratedColumn<String> appliedAtUtc = GeneratedColumn<String>(
    'applied_at_utc',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _appVersionMeta = const VerificationMeta(
    'appVersion',
  );
  late final GeneratedColumn<String> appVersion = GeneratedColumn<String>(
    'app_version',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _backupDirectoryMeta = const VerificationMeta(
    'backupDirectory',
  );
  late final GeneratedColumn<String> backupDirectory = GeneratedColumn<String>(
    'backup_directory',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _backupSha256Meta = const VerificationMeta(
    'backupSha256',
  );
  late final GeneratedColumn<String> backupSha256 = GeneratedColumn<String>(
    'backup_sha256',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (length(backup_sha256) = 64)',
  );
  @override
  List<GeneratedColumn> get $columns => [
    toVersion,
    fromVersion,
    appliedAtUtc,
    appVersion,
    backupDirectory,
    backupSha256,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'schema_upgrades';
  @override
  VerificationContext validateIntegrity(
    Insertable<SchemaUpgrade> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('to_version')) {
      context.handle(
        _toVersionMeta,
        toVersion.isAcceptableOrUnknown(data['to_version']!, _toVersionMeta),
      );
    }
    if (data.containsKey('from_version')) {
      context.handle(
        _fromVersionMeta,
        fromVersion.isAcceptableOrUnknown(
          data['from_version']!,
          _fromVersionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_fromVersionMeta);
    }
    if (data.containsKey('applied_at_utc')) {
      context.handle(
        _appliedAtUtcMeta,
        appliedAtUtc.isAcceptableOrUnknown(
          data['applied_at_utc']!,
          _appliedAtUtcMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_appliedAtUtcMeta);
    }
    if (data.containsKey('app_version')) {
      context.handle(
        _appVersionMeta,
        appVersion.isAcceptableOrUnknown(data['app_version']!, _appVersionMeta),
      );
    } else if (isInserting) {
      context.missing(_appVersionMeta);
    }
    if (data.containsKey('backup_directory')) {
      context.handle(
        _backupDirectoryMeta,
        backupDirectory.isAcceptableOrUnknown(
          data['backup_directory']!,
          _backupDirectoryMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_backupDirectoryMeta);
    }
    if (data.containsKey('backup_sha256')) {
      context.handle(
        _backupSha256Meta,
        backupSha256.isAcceptableOrUnknown(
          data['backup_sha256']!,
          _backupSha256Meta,
        ),
      );
    } else if (isInserting) {
      context.missing(_backupSha256Meta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {toVersion};
  @override
  SchemaUpgrade map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SchemaUpgrade(
      toVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}to_version'],
      )!,
      fromVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}from_version'],
      )!,
      appliedAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}applied_at_utc'],
      )!,
      appVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}app_version'],
      )!,
      backupDirectory: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}backup_directory'],
      )!,
      backupSha256: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}backup_sha256'],
      )!,
    );
  }

  @override
  SchemaUpgrades createAlias(String alias) {
    return SchemaUpgrades(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class SchemaUpgrade extends DataClass implements Insertable<SchemaUpgrade> {
  final int toVersion;
  final int fromVersion;
  final String appliedAtUtc;
  final String appVersion;
  final String backupDirectory;
  final String backupSha256;
  const SchemaUpgrade({
    required this.toVersion,
    required this.fromVersion,
    required this.appliedAtUtc,
    required this.appVersion,
    required this.backupDirectory,
    required this.backupSha256,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['to_version'] = Variable<int>(toVersion);
    map['from_version'] = Variable<int>(fromVersion);
    map['applied_at_utc'] = Variable<String>(appliedAtUtc);
    map['app_version'] = Variable<String>(appVersion);
    map['backup_directory'] = Variable<String>(backupDirectory);
    map['backup_sha256'] = Variable<String>(backupSha256);
    return map;
  }

  SchemaUpgradesCompanion toCompanion(bool nullToAbsent) {
    return SchemaUpgradesCompanion(
      toVersion: Value(toVersion),
      fromVersion: Value(fromVersion),
      appliedAtUtc: Value(appliedAtUtc),
      appVersion: Value(appVersion),
      backupDirectory: Value(backupDirectory),
      backupSha256: Value(backupSha256),
    );
  }

  factory SchemaUpgrade.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SchemaUpgrade(
      toVersion: serializer.fromJson<int>(json['to_version']),
      fromVersion: serializer.fromJson<int>(json['from_version']),
      appliedAtUtc: serializer.fromJson<String>(json['applied_at_utc']),
      appVersion: serializer.fromJson<String>(json['app_version']),
      backupDirectory: serializer.fromJson<String>(json['backup_directory']),
      backupSha256: serializer.fromJson<String>(json['backup_sha256']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'to_version': serializer.toJson<int>(toVersion),
      'from_version': serializer.toJson<int>(fromVersion),
      'applied_at_utc': serializer.toJson<String>(appliedAtUtc),
      'app_version': serializer.toJson<String>(appVersion),
      'backup_directory': serializer.toJson<String>(backupDirectory),
      'backup_sha256': serializer.toJson<String>(backupSha256),
    };
  }

  SchemaUpgrade copyWith({
    int? toVersion,
    int? fromVersion,
    String? appliedAtUtc,
    String? appVersion,
    String? backupDirectory,
    String? backupSha256,
  }) => SchemaUpgrade(
    toVersion: toVersion ?? this.toVersion,
    fromVersion: fromVersion ?? this.fromVersion,
    appliedAtUtc: appliedAtUtc ?? this.appliedAtUtc,
    appVersion: appVersion ?? this.appVersion,
    backupDirectory: backupDirectory ?? this.backupDirectory,
    backupSha256: backupSha256 ?? this.backupSha256,
  );
  SchemaUpgrade copyWithCompanion(SchemaUpgradesCompanion data) {
    return SchemaUpgrade(
      toVersion: data.toVersion.present ? data.toVersion.value : this.toVersion,
      fromVersion: data.fromVersion.present
          ? data.fromVersion.value
          : this.fromVersion,
      appliedAtUtc: data.appliedAtUtc.present
          ? data.appliedAtUtc.value
          : this.appliedAtUtc,
      appVersion: data.appVersion.present
          ? data.appVersion.value
          : this.appVersion,
      backupDirectory: data.backupDirectory.present
          ? data.backupDirectory.value
          : this.backupDirectory,
      backupSha256: data.backupSha256.present
          ? data.backupSha256.value
          : this.backupSha256,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SchemaUpgrade(')
          ..write('toVersion: $toVersion, ')
          ..write('fromVersion: $fromVersion, ')
          ..write('appliedAtUtc: $appliedAtUtc, ')
          ..write('appVersion: $appVersion, ')
          ..write('backupDirectory: $backupDirectory, ')
          ..write('backupSha256: $backupSha256')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    toVersion,
    fromVersion,
    appliedAtUtc,
    appVersion,
    backupDirectory,
    backupSha256,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SchemaUpgrade &&
          other.toVersion == this.toVersion &&
          other.fromVersion == this.fromVersion &&
          other.appliedAtUtc == this.appliedAtUtc &&
          other.appVersion == this.appVersion &&
          other.backupDirectory == this.backupDirectory &&
          other.backupSha256 == this.backupSha256);
}

class SchemaUpgradesCompanion extends UpdateCompanion<SchemaUpgrade> {
  final Value<int> toVersion;
  final Value<int> fromVersion;
  final Value<String> appliedAtUtc;
  final Value<String> appVersion;
  final Value<String> backupDirectory;
  final Value<String> backupSha256;
  const SchemaUpgradesCompanion({
    this.toVersion = const Value.absent(),
    this.fromVersion = const Value.absent(),
    this.appliedAtUtc = const Value.absent(),
    this.appVersion = const Value.absent(),
    this.backupDirectory = const Value.absent(),
    this.backupSha256 = const Value.absent(),
  });
  SchemaUpgradesCompanion.insert({
    this.toVersion = const Value.absent(),
    required int fromVersion,
    required String appliedAtUtc,
    required String appVersion,
    required String backupDirectory,
    required String backupSha256,
  }) : fromVersion = Value(fromVersion),
       appliedAtUtc = Value(appliedAtUtc),
       appVersion = Value(appVersion),
       backupDirectory = Value(backupDirectory),
       backupSha256 = Value(backupSha256);
  static Insertable<SchemaUpgrade> custom({
    Expression<int>? toVersion,
    Expression<int>? fromVersion,
    Expression<String>? appliedAtUtc,
    Expression<String>? appVersion,
    Expression<String>? backupDirectory,
    Expression<String>? backupSha256,
  }) {
    return RawValuesInsertable({
      if (toVersion != null) 'to_version': toVersion,
      if (fromVersion != null) 'from_version': fromVersion,
      if (appliedAtUtc != null) 'applied_at_utc': appliedAtUtc,
      if (appVersion != null) 'app_version': appVersion,
      if (backupDirectory != null) 'backup_directory': backupDirectory,
      if (backupSha256 != null) 'backup_sha256': backupSha256,
    });
  }

  SchemaUpgradesCompanion copyWith({
    Value<int>? toVersion,
    Value<int>? fromVersion,
    Value<String>? appliedAtUtc,
    Value<String>? appVersion,
    Value<String>? backupDirectory,
    Value<String>? backupSha256,
  }) {
    return SchemaUpgradesCompanion(
      toVersion: toVersion ?? this.toVersion,
      fromVersion: fromVersion ?? this.fromVersion,
      appliedAtUtc: appliedAtUtc ?? this.appliedAtUtc,
      appVersion: appVersion ?? this.appVersion,
      backupDirectory: backupDirectory ?? this.backupDirectory,
      backupSha256: backupSha256 ?? this.backupSha256,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (toVersion.present) {
      map['to_version'] = Variable<int>(toVersion.value);
    }
    if (fromVersion.present) {
      map['from_version'] = Variable<int>(fromVersion.value);
    }
    if (appliedAtUtc.present) {
      map['applied_at_utc'] = Variable<String>(appliedAtUtc.value);
    }
    if (appVersion.present) {
      map['app_version'] = Variable<String>(appVersion.value);
    }
    if (backupDirectory.present) {
      map['backup_directory'] = Variable<String>(backupDirectory.value);
    }
    if (backupSha256.present) {
      map['backup_sha256'] = Variable<String>(backupSha256.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SchemaUpgradesCompanion(')
          ..write('toVersion: $toVersion, ')
          ..write('fromVersion: $fromVersion, ')
          ..write('appliedAtUtc: $appliedAtUtc, ')
          ..write('appVersion: $appVersion, ')
          ..write('backupDirectory: $backupDirectory, ')
          ..write('backupSha256: $backupSha256')
          ..write(')'))
        .toString();
  }
}

abstract class _$PosDatabase extends GeneratedDatabase {
  _$PosDatabase(QueryExecutor e) : super(e);
  $PosDatabaseManager get managers => $PosDatabaseManager(this);
  late final DatabaseMetadata databaseMetadata = DatabaseMetadata(this);
  late final SchemaUpgrades schemaUpgrades = SchemaUpgrades(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    databaseMetadata,
    schemaUpgrades,
  ];
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
typedef $SchemaUpgradesCreateCompanionBuilder =
    SchemaUpgradesCompanion Function({
      Value<int> toVersion,
      required int fromVersion,
      required String appliedAtUtc,
      required String appVersion,
      required String backupDirectory,
      required String backupSha256,
    });
typedef $SchemaUpgradesUpdateCompanionBuilder =
    SchemaUpgradesCompanion Function({
      Value<int> toVersion,
      Value<int> fromVersion,
      Value<String> appliedAtUtc,
      Value<String> appVersion,
      Value<String> backupDirectory,
      Value<String> backupSha256,
    });

class $SchemaUpgradesFilterComposer
    extends Composer<_$PosDatabase, SchemaUpgrades> {
  $SchemaUpgradesFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get toVersion => $composableBuilder(
    column: $table.toVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get fromVersion => $composableBuilder(
    column: $table.fromVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get appliedAtUtc => $composableBuilder(
    column: $table.appliedAtUtc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get appVersion => $composableBuilder(
    column: $table.appVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get backupDirectory => $composableBuilder(
    column: $table.backupDirectory,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get backupSha256 => $composableBuilder(
    column: $table.backupSha256,
    builder: (column) => ColumnFilters(column),
  );
}

class $SchemaUpgradesOrderingComposer
    extends Composer<_$PosDatabase, SchemaUpgrades> {
  $SchemaUpgradesOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get toVersion => $composableBuilder(
    column: $table.toVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get fromVersion => $composableBuilder(
    column: $table.fromVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get appliedAtUtc => $composableBuilder(
    column: $table.appliedAtUtc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get appVersion => $composableBuilder(
    column: $table.appVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get backupDirectory => $composableBuilder(
    column: $table.backupDirectory,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get backupSha256 => $composableBuilder(
    column: $table.backupSha256,
    builder: (column) => ColumnOrderings(column),
  );
}

class $SchemaUpgradesAnnotationComposer
    extends Composer<_$PosDatabase, SchemaUpgrades> {
  $SchemaUpgradesAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get toVersion =>
      $composableBuilder(column: $table.toVersion, builder: (column) => column);

  GeneratedColumn<int> get fromVersion => $composableBuilder(
    column: $table.fromVersion,
    builder: (column) => column,
  );

  GeneratedColumn<String> get appliedAtUtc => $composableBuilder(
    column: $table.appliedAtUtc,
    builder: (column) => column,
  );

  GeneratedColumn<String> get appVersion => $composableBuilder(
    column: $table.appVersion,
    builder: (column) => column,
  );

  GeneratedColumn<String> get backupDirectory => $composableBuilder(
    column: $table.backupDirectory,
    builder: (column) => column,
  );

  GeneratedColumn<String> get backupSha256 => $composableBuilder(
    column: $table.backupSha256,
    builder: (column) => column,
  );
}

class $SchemaUpgradesTableManager
    extends
        RootTableManager<
          _$PosDatabase,
          SchemaUpgrades,
          SchemaUpgrade,
          $SchemaUpgradesFilterComposer,
          $SchemaUpgradesOrderingComposer,
          $SchemaUpgradesAnnotationComposer,
          $SchemaUpgradesCreateCompanionBuilder,
          $SchemaUpgradesUpdateCompanionBuilder,
          (
            SchemaUpgrade,
            BaseReferences<_$PosDatabase, SchemaUpgrades, SchemaUpgrade>,
          ),
          SchemaUpgrade,
          PrefetchHooks Function()
        > {
  $SchemaUpgradesTableManager(_$PosDatabase db, SchemaUpgrades table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $SchemaUpgradesFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $SchemaUpgradesOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $SchemaUpgradesAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> toVersion = const Value.absent(),
                Value<int> fromVersion = const Value.absent(),
                Value<String> appliedAtUtc = const Value.absent(),
                Value<String> appVersion = const Value.absent(),
                Value<String> backupDirectory = const Value.absent(),
                Value<String> backupSha256 = const Value.absent(),
              }) => SchemaUpgradesCompanion(
                toVersion: toVersion,
                fromVersion: fromVersion,
                appliedAtUtc: appliedAtUtc,
                appVersion: appVersion,
                backupDirectory: backupDirectory,
                backupSha256: backupSha256,
              ),
          createCompanionCallback:
              ({
                Value<int> toVersion = const Value.absent(),
                required int fromVersion,
                required String appliedAtUtc,
                required String appVersion,
                required String backupDirectory,
                required String backupSha256,
              }) => SchemaUpgradesCompanion.insert(
                toVersion: toVersion,
                fromVersion: fromVersion,
                appliedAtUtc: appliedAtUtc,
                appVersion: appVersion,
                backupDirectory: backupDirectory,
                backupSha256: backupSha256,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<SchemaUpgrades, SchemaUpgrade>(table),
                  BaseReferences<_$PosDatabase, SchemaUpgrades, SchemaUpgrade>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $SchemaUpgradesProcessedTableManager =
    ProcessedTableManager<
      _$PosDatabase,
      SchemaUpgrades,
      SchemaUpgrade,
      $SchemaUpgradesFilterComposer,
      $SchemaUpgradesOrderingComposer,
      $SchemaUpgradesAnnotationComposer,
      $SchemaUpgradesCreateCompanionBuilder,
      $SchemaUpgradesUpdateCompanionBuilder,
      (
        SchemaUpgrade,
        BaseReferences<_$PosDatabase, SchemaUpgrades, SchemaUpgrade>,
      ),
      SchemaUpgrade,
      PrefetchHooks Function()
    >;

class $PosDatabaseManager {
  final _$PosDatabase _db;
  $PosDatabaseManager(this._db);
  $DatabaseMetadataTableManager get databaseMetadata =>
      $DatabaseMetadataTableManager(_db, _db.databaseMetadata);
  $SchemaUpgradesTableManager get schemaUpgrades =>
      $SchemaUpgradesTableManager(_db, _db.schemaUpgrades);
}
