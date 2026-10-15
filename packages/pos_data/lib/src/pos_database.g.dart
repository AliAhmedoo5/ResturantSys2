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

class IdempotencyCommands extends Table
    with TableInfo<IdempotencyCommands, IdempotencyCommand> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  IdempotencyCommands(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _intentKeyMeta = const VerificationMeta(
    'intentKey',
  );
  late final GeneratedColumn<String> intentKey = GeneratedColumn<String>(
    'intent_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints:
        'NOT NULL PRIMARY KEY CHECK (length(intent_key) BETWEEN 1 AND 128)',
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _requestHashMeta = const VerificationMeta(
    'requestHash',
  );
  late final GeneratedColumn<String> requestHash = GeneratedColumn<String>(
    'request_hash',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (length(request_hash) = 64)',
  );
  static const VerificationMeta _resultJsonMeta = const VerificationMeta(
    'resultJson',
  );
  late final GeneratedColumn<String> resultJson = GeneratedColumn<String>(
    'result_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _createdAtUtcMeta = const VerificationMeta(
    'createdAtUtc',
  );
  late final GeneratedColumn<String> createdAtUtc = GeneratedColumn<String>(
    'created_at_utc',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  @override
  List<GeneratedColumn> get $columns => [
    intentKey,
    kind,
    requestHash,
    resultJson,
    createdAtUtc,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'idempotency_commands';
  @override
  VerificationContext validateIntegrity(
    Insertable<IdempotencyCommand> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('intent_key')) {
      context.handle(
        _intentKeyMeta,
        intentKey.isAcceptableOrUnknown(data['intent_key']!, _intentKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_intentKeyMeta);
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('request_hash')) {
      context.handle(
        _requestHashMeta,
        requestHash.isAcceptableOrUnknown(
          data['request_hash']!,
          _requestHashMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_requestHashMeta);
    }
    if (data.containsKey('result_json')) {
      context.handle(
        _resultJsonMeta,
        resultJson.isAcceptableOrUnknown(data['result_json']!, _resultJsonMeta),
      );
    } else if (isInserting) {
      context.missing(_resultJsonMeta);
    }
    if (data.containsKey('created_at_utc')) {
      context.handle(
        _createdAtUtcMeta,
        createdAtUtc.isAcceptableOrUnknown(
          data['created_at_utc']!,
          _createdAtUtcMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_createdAtUtcMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {intentKey};
  @override
  IdempotencyCommand map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return IdempotencyCommand(
      intentKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}intent_key'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      requestHash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}request_hash'],
      )!,
      resultJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}result_json'],
      )!,
      createdAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_at_utc'],
      )!,
    );
  }

  @override
  IdempotencyCommands createAlias(String alias) {
    return IdempotencyCommands(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class IdempotencyCommand extends DataClass
    implements Insertable<IdempotencyCommand> {
  final String intentKey;
  final String kind;
  final String requestHash;
  final String resultJson;
  final String createdAtUtc;
  const IdempotencyCommand({
    required this.intentKey,
    required this.kind,
    required this.requestHash,
    required this.resultJson,
    required this.createdAtUtc,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['intent_key'] = Variable<String>(intentKey);
    map['kind'] = Variable<String>(kind);
    map['request_hash'] = Variable<String>(requestHash);
    map['result_json'] = Variable<String>(resultJson);
    map['created_at_utc'] = Variable<String>(createdAtUtc);
    return map;
  }

  IdempotencyCommandsCompanion toCompanion(bool nullToAbsent) {
    return IdempotencyCommandsCompanion(
      intentKey: Value(intentKey),
      kind: Value(kind),
      requestHash: Value(requestHash),
      resultJson: Value(resultJson),
      createdAtUtc: Value(createdAtUtc),
    );
  }

  factory IdempotencyCommand.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return IdempotencyCommand(
      intentKey: serializer.fromJson<String>(json['intent_key']),
      kind: serializer.fromJson<String>(json['kind']),
      requestHash: serializer.fromJson<String>(json['request_hash']),
      resultJson: serializer.fromJson<String>(json['result_json']),
      createdAtUtc: serializer.fromJson<String>(json['created_at_utc']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'intent_key': serializer.toJson<String>(intentKey),
      'kind': serializer.toJson<String>(kind),
      'request_hash': serializer.toJson<String>(requestHash),
      'result_json': serializer.toJson<String>(resultJson),
      'created_at_utc': serializer.toJson<String>(createdAtUtc),
    };
  }

  IdempotencyCommand copyWith({
    String? intentKey,
    String? kind,
    String? requestHash,
    String? resultJson,
    String? createdAtUtc,
  }) => IdempotencyCommand(
    intentKey: intentKey ?? this.intentKey,
    kind: kind ?? this.kind,
    requestHash: requestHash ?? this.requestHash,
    resultJson: resultJson ?? this.resultJson,
    createdAtUtc: createdAtUtc ?? this.createdAtUtc,
  );
  IdempotencyCommand copyWithCompanion(IdempotencyCommandsCompanion data) {
    return IdempotencyCommand(
      intentKey: data.intentKey.present ? data.intentKey.value : this.intentKey,
      kind: data.kind.present ? data.kind.value : this.kind,
      requestHash: data.requestHash.present
          ? data.requestHash.value
          : this.requestHash,
      resultJson: data.resultJson.present
          ? data.resultJson.value
          : this.resultJson,
      createdAtUtc: data.createdAtUtc.present
          ? data.createdAtUtc.value
          : this.createdAtUtc,
    );
  }

  @override
  String toString() {
    return (StringBuffer('IdempotencyCommand(')
          ..write('intentKey: $intentKey, ')
          ..write('kind: $kind, ')
          ..write('requestHash: $requestHash, ')
          ..write('resultJson: $resultJson, ')
          ..write('createdAtUtc: $createdAtUtc')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(intentKey, kind, requestHash, resultJson, createdAtUtc);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is IdempotencyCommand &&
          other.intentKey == this.intentKey &&
          other.kind == this.kind &&
          other.requestHash == this.requestHash &&
          other.resultJson == this.resultJson &&
          other.createdAtUtc == this.createdAtUtc);
}

class IdempotencyCommandsCompanion extends UpdateCompanion<IdempotencyCommand> {
  final Value<String> intentKey;
  final Value<String> kind;
  final Value<String> requestHash;
  final Value<String> resultJson;
  final Value<String> createdAtUtc;
  final Value<int> rowid;
  const IdempotencyCommandsCompanion({
    this.intentKey = const Value.absent(),
    this.kind = const Value.absent(),
    this.requestHash = const Value.absent(),
    this.resultJson = const Value.absent(),
    this.createdAtUtc = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  IdempotencyCommandsCompanion.insert({
    required String intentKey,
    required String kind,
    required String requestHash,
    required String resultJson,
    required String createdAtUtc,
    this.rowid = const Value.absent(),
  }) : intentKey = Value(intentKey),
       kind = Value(kind),
       requestHash = Value(requestHash),
       resultJson = Value(resultJson),
       createdAtUtc = Value(createdAtUtc);
  static Insertable<IdempotencyCommand> custom({
    Expression<String>? intentKey,
    Expression<String>? kind,
    Expression<String>? requestHash,
    Expression<String>? resultJson,
    Expression<String>? createdAtUtc,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (intentKey != null) 'intent_key': intentKey,
      if (kind != null) 'kind': kind,
      if (requestHash != null) 'request_hash': requestHash,
      if (resultJson != null) 'result_json': resultJson,
      if (createdAtUtc != null) 'created_at_utc': createdAtUtc,
      if (rowid != null) 'rowid': rowid,
    });
  }

  IdempotencyCommandsCompanion copyWith({
    Value<String>? intentKey,
    Value<String>? kind,
    Value<String>? requestHash,
    Value<String>? resultJson,
    Value<String>? createdAtUtc,
    Value<int>? rowid,
  }) {
    return IdempotencyCommandsCompanion(
      intentKey: intentKey ?? this.intentKey,
      kind: kind ?? this.kind,
      requestHash: requestHash ?? this.requestHash,
      resultJson: resultJson ?? this.resultJson,
      createdAtUtc: createdAtUtc ?? this.createdAtUtc,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (intentKey.present) {
      map['intent_key'] = Variable<String>(intentKey.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (requestHash.present) {
      map['request_hash'] = Variable<String>(requestHash.value);
    }
    if (resultJson.present) {
      map['result_json'] = Variable<String>(resultJson.value);
    }
    if (createdAtUtc.present) {
      map['created_at_utc'] = Variable<String>(createdAtUtc.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('IdempotencyCommandsCompanion(')
          ..write('intentKey: $intentKey, ')
          ..write('kind: $kind, ')
          ..write('requestHash: $requestHash, ')
          ..write('resultJson: $resultJson, ')
          ..write('createdAtUtc: $createdAtUtc, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class CommandVersions extends Table
    with TableInfo<CommandVersions, CommandVersion> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  CommandVersions(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _entityTypeMeta = const VerificationMeta(
    'entityType',
  );
  late final GeneratedColumn<String> entityType = GeneratedColumn<String>(
    'entity_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _entityIdMeta = const VerificationMeta(
    'entityId',
  );
  late final GeneratedColumn<String> entityId = GeneratedColumn<String>(
    'entity_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _revisionMeta = const VerificationMeta(
    'revision',
  );
  late final GeneratedColumn<int> revision = GeneratedColumn<int>(
    'revision',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (revision >= 1)',
  );
  @override
  List<GeneratedColumn> get $columns => [entityType, entityId, revision];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'command_versions';
  @override
  VerificationContext validateIntegrity(
    Insertable<CommandVersion> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('entity_type')) {
      context.handle(
        _entityTypeMeta,
        entityType.isAcceptableOrUnknown(data['entity_type']!, _entityTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_entityTypeMeta);
    }
    if (data.containsKey('entity_id')) {
      context.handle(
        _entityIdMeta,
        entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta),
      );
    } else if (isInserting) {
      context.missing(_entityIdMeta);
    }
    if (data.containsKey('revision')) {
      context.handle(
        _revisionMeta,
        revision.isAcceptableOrUnknown(data['revision']!, _revisionMeta),
      );
    } else if (isInserting) {
      context.missing(_revisionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {entityType, entityId};
  @override
  CommandVersion map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CommandVersion(
      entityType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_type'],
      )!,
      entityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_id'],
      )!,
      revision: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}revision'],
      )!,
    );
  }

  @override
  CommandVersions createAlias(String alias) {
    return CommandVersions(attachedDatabase, alias);
  }

  @override
  List<String> get customConstraints => const [
    'PRIMARY KEY(entity_type, entity_id)',
  ];
  @override
  bool get dontWriteConstraints => true;
}

class CommandVersion extends DataClass implements Insertable<CommandVersion> {
  final String entityType;
  final String entityId;
  final int revision;
  const CommandVersion({
    required this.entityType,
    required this.entityId,
    required this.revision,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['entity_type'] = Variable<String>(entityType);
    map['entity_id'] = Variable<String>(entityId);
    map['revision'] = Variable<int>(revision);
    return map;
  }

  CommandVersionsCompanion toCompanion(bool nullToAbsent) {
    return CommandVersionsCompanion(
      entityType: Value(entityType),
      entityId: Value(entityId),
      revision: Value(revision),
    );
  }

  factory CommandVersion.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CommandVersion(
      entityType: serializer.fromJson<String>(json['entity_type']),
      entityId: serializer.fromJson<String>(json['entity_id']),
      revision: serializer.fromJson<int>(json['revision']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'entity_type': serializer.toJson<String>(entityType),
      'entity_id': serializer.toJson<String>(entityId),
      'revision': serializer.toJson<int>(revision),
    };
  }

  CommandVersion copyWith({
    String? entityType,
    String? entityId,
    int? revision,
  }) => CommandVersion(
    entityType: entityType ?? this.entityType,
    entityId: entityId ?? this.entityId,
    revision: revision ?? this.revision,
  );
  CommandVersion copyWithCompanion(CommandVersionsCompanion data) {
    return CommandVersion(
      entityType: data.entityType.present
          ? data.entityType.value
          : this.entityType,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      revision: data.revision.present ? data.revision.value : this.revision,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CommandVersion(')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('revision: $revision')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(entityType, entityId, revision);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CommandVersion &&
          other.entityType == this.entityType &&
          other.entityId == this.entityId &&
          other.revision == this.revision);
}

class CommandVersionsCompanion extends UpdateCompanion<CommandVersion> {
  final Value<String> entityType;
  final Value<String> entityId;
  final Value<int> revision;
  final Value<int> rowid;
  const CommandVersionsCompanion({
    this.entityType = const Value.absent(),
    this.entityId = const Value.absent(),
    this.revision = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CommandVersionsCompanion.insert({
    required String entityType,
    required String entityId,
    required int revision,
    this.rowid = const Value.absent(),
  }) : entityType = Value(entityType),
       entityId = Value(entityId),
       revision = Value(revision);
  static Insertable<CommandVersion> custom({
    Expression<String>? entityType,
    Expression<String>? entityId,
    Expression<int>? revision,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (entityType != null) 'entity_type': entityType,
      if (entityId != null) 'entity_id': entityId,
      if (revision != null) 'revision': revision,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CommandVersionsCompanion copyWith({
    Value<String>? entityType,
    Value<String>? entityId,
    Value<int>? revision,
    Value<int>? rowid,
  }) {
    return CommandVersionsCompanion(
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      revision: revision ?? this.revision,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (entityType.present) {
      map['entity_type'] = Variable<String>(entityType.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<String>(entityId.value);
    }
    if (revision.present) {
      map['revision'] = Variable<int>(revision.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CommandVersionsCompanion(')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('revision: $revision, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class AuditEvents extends Table with TableInfo<AuditEvents, AuditEvent> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  AuditEvents(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL PRIMARY KEY',
  );
  static const VerificationMeta _commandIdMeta = const VerificationMeta(
    'commandId',
  );
  late final GeneratedColumn<String> commandId = GeneratedColumn<String>(
    'command_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints:
        'NOT NULL UNIQUE REFERENCES idempotency_commands(intent_key)',
  );
  static const VerificationMeta _entityTypeMeta = const VerificationMeta(
    'entityType',
  );
  late final GeneratedColumn<String> entityType = GeneratedColumn<String>(
    'entity_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _entityIdMeta = const VerificationMeta(
    'entityId',
  );
  late final GeneratedColumn<String> entityId = GeneratedColumn<String>(
    'entity_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _eventTypeMeta = const VerificationMeta(
    'eventType',
  );
  late final GeneratedColumn<String> eventType = GeneratedColumn<String>(
    'event_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _actorIdMeta = const VerificationMeta(
    'actorId',
  );
  late final GeneratedColumn<String> actorId = GeneratedColumn<String>(
    'actor_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _sessionIdMeta = const VerificationMeta(
    'sessionId',
  );
  late final GeneratedColumn<String> sessionId = GeneratedColumn<String>(
    'session_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _approverIdMeta = const VerificationMeta(
    'approverId',
  );
  late final GeneratedColumn<String> approverId = GeneratedColumn<String>(
    'approver_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _businessDayIdMeta = const VerificationMeta(
    'businessDayId',
  );
  late final GeneratedColumn<String> businessDayId = GeneratedColumn<String>(
    'business_day_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _terminalIdMeta = const VerificationMeta(
    'terminalId',
  );
  late final GeneratedColumn<String> terminalId = GeneratedColumn<String>(
    'terminal_id',
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
  static const VerificationMeta _reasonMeta = const VerificationMeta('reason');
  late final GeneratedColumn<String> reason = GeneratedColumn<String>(
    'reason',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _beforeJsonMeta = const VerificationMeta(
    'beforeJson',
  );
  late final GeneratedColumn<String> beforeJson = GeneratedColumn<String>(
    'before_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _afterJsonMeta = const VerificationMeta(
    'afterJson',
  );
  late final GeneratedColumn<String> afterJson = GeneratedColumn<String>(
    'after_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _createdAtUtcMeta = const VerificationMeta(
    'createdAtUtc',
  );
  late final GeneratedColumn<String> createdAtUtc = GeneratedColumn<String>(
    'created_at_utc',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    commandId,
    entityType,
    entityId,
    eventType,
    actorId,
    sessionId,
    approverId,
    businessDayId,
    terminalId,
    appVersion,
    reason,
    beforeJson,
    afterJson,
    createdAtUtc,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'audit_events';
  @override
  VerificationContext validateIntegrity(
    Insertable<AuditEvent> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('command_id')) {
      context.handle(
        _commandIdMeta,
        commandId.isAcceptableOrUnknown(data['command_id']!, _commandIdMeta),
      );
    } else if (isInserting) {
      context.missing(_commandIdMeta);
    }
    if (data.containsKey('entity_type')) {
      context.handle(
        _entityTypeMeta,
        entityType.isAcceptableOrUnknown(data['entity_type']!, _entityTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_entityTypeMeta);
    }
    if (data.containsKey('entity_id')) {
      context.handle(
        _entityIdMeta,
        entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta),
      );
    } else if (isInserting) {
      context.missing(_entityIdMeta);
    }
    if (data.containsKey('event_type')) {
      context.handle(
        _eventTypeMeta,
        eventType.isAcceptableOrUnknown(data['event_type']!, _eventTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_eventTypeMeta);
    }
    if (data.containsKey('actor_id')) {
      context.handle(
        _actorIdMeta,
        actorId.isAcceptableOrUnknown(data['actor_id']!, _actorIdMeta),
      );
    } else if (isInserting) {
      context.missing(_actorIdMeta);
    }
    if (data.containsKey('session_id')) {
      context.handle(
        _sessionIdMeta,
        sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('approver_id')) {
      context.handle(
        _approverIdMeta,
        approverId.isAcceptableOrUnknown(data['approver_id']!, _approverIdMeta),
      );
    }
    if (data.containsKey('business_day_id')) {
      context.handle(
        _businessDayIdMeta,
        businessDayId.isAcceptableOrUnknown(
          data['business_day_id']!,
          _businessDayIdMeta,
        ),
      );
    }
    if (data.containsKey('terminal_id')) {
      context.handle(
        _terminalIdMeta,
        terminalId.isAcceptableOrUnknown(data['terminal_id']!, _terminalIdMeta),
      );
    } else if (isInserting) {
      context.missing(_terminalIdMeta);
    }
    if (data.containsKey('app_version')) {
      context.handle(
        _appVersionMeta,
        appVersion.isAcceptableOrUnknown(data['app_version']!, _appVersionMeta),
      );
    } else if (isInserting) {
      context.missing(_appVersionMeta);
    }
    if (data.containsKey('reason')) {
      context.handle(
        _reasonMeta,
        reason.isAcceptableOrUnknown(data['reason']!, _reasonMeta),
      );
    } else if (isInserting) {
      context.missing(_reasonMeta);
    }
    if (data.containsKey('before_json')) {
      context.handle(
        _beforeJsonMeta,
        beforeJson.isAcceptableOrUnknown(data['before_json']!, _beforeJsonMeta),
      );
    } else if (isInserting) {
      context.missing(_beforeJsonMeta);
    }
    if (data.containsKey('after_json')) {
      context.handle(
        _afterJsonMeta,
        afterJson.isAcceptableOrUnknown(data['after_json']!, _afterJsonMeta),
      );
    } else if (isInserting) {
      context.missing(_afterJsonMeta);
    }
    if (data.containsKey('created_at_utc')) {
      context.handle(
        _createdAtUtcMeta,
        createdAtUtc.isAcceptableOrUnknown(
          data['created_at_utc']!,
          _createdAtUtcMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_createdAtUtcMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AuditEvent map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AuditEvent(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      commandId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}command_id'],
      )!,
      entityType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_type'],
      )!,
      entityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_id'],
      )!,
      eventType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}event_type'],
      )!,
      actorId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}actor_id'],
      )!,
      sessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}session_id'],
      )!,
      approverId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}approver_id'],
      ),
      businessDayId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}business_day_id'],
      ),
      terminalId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}terminal_id'],
      )!,
      appVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}app_version'],
      )!,
      reason: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reason'],
      )!,
      beforeJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}before_json'],
      )!,
      afterJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}after_json'],
      )!,
      createdAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_at_utc'],
      )!,
    );
  }

  @override
  AuditEvents createAlias(String alias) {
    return AuditEvents(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class AuditEvent extends DataClass implements Insertable<AuditEvent> {
  final String id;
  final String commandId;
  final String entityType;
  final String entityId;
  final String eventType;
  final String actorId;
  final String sessionId;
  final String? approverId;
  final String? businessDayId;
  final String terminalId;
  final String appVersion;
  final String reason;
  final String beforeJson;
  final String afterJson;
  final String createdAtUtc;
  const AuditEvent({
    required this.id,
    required this.commandId,
    required this.entityType,
    required this.entityId,
    required this.eventType,
    required this.actorId,
    required this.sessionId,
    this.approverId,
    this.businessDayId,
    required this.terminalId,
    required this.appVersion,
    required this.reason,
    required this.beforeJson,
    required this.afterJson,
    required this.createdAtUtc,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['command_id'] = Variable<String>(commandId);
    map['entity_type'] = Variable<String>(entityType);
    map['entity_id'] = Variable<String>(entityId);
    map['event_type'] = Variable<String>(eventType);
    map['actor_id'] = Variable<String>(actorId);
    map['session_id'] = Variable<String>(sessionId);
    if (!nullToAbsent || approverId != null) {
      map['approver_id'] = Variable<String>(approverId);
    }
    if (!nullToAbsent || businessDayId != null) {
      map['business_day_id'] = Variable<String>(businessDayId);
    }
    map['terminal_id'] = Variable<String>(terminalId);
    map['app_version'] = Variable<String>(appVersion);
    map['reason'] = Variable<String>(reason);
    map['before_json'] = Variable<String>(beforeJson);
    map['after_json'] = Variable<String>(afterJson);
    map['created_at_utc'] = Variable<String>(createdAtUtc);
    return map;
  }

  AuditEventsCompanion toCompanion(bool nullToAbsent) {
    return AuditEventsCompanion(
      id: Value(id),
      commandId: Value(commandId),
      entityType: Value(entityType),
      entityId: Value(entityId),
      eventType: Value(eventType),
      actorId: Value(actorId),
      sessionId: Value(sessionId),
      approverId: approverId == null && nullToAbsent
          ? const Value.absent()
          : Value(approverId),
      businessDayId: businessDayId == null && nullToAbsent
          ? const Value.absent()
          : Value(businessDayId),
      terminalId: Value(terminalId),
      appVersion: Value(appVersion),
      reason: Value(reason),
      beforeJson: Value(beforeJson),
      afterJson: Value(afterJson),
      createdAtUtc: Value(createdAtUtc),
    );
  }

  factory AuditEvent.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AuditEvent(
      id: serializer.fromJson<String>(json['id']),
      commandId: serializer.fromJson<String>(json['command_id']),
      entityType: serializer.fromJson<String>(json['entity_type']),
      entityId: serializer.fromJson<String>(json['entity_id']),
      eventType: serializer.fromJson<String>(json['event_type']),
      actorId: serializer.fromJson<String>(json['actor_id']),
      sessionId: serializer.fromJson<String>(json['session_id']),
      approverId: serializer.fromJson<String?>(json['approver_id']),
      businessDayId: serializer.fromJson<String?>(json['business_day_id']),
      terminalId: serializer.fromJson<String>(json['terminal_id']),
      appVersion: serializer.fromJson<String>(json['app_version']),
      reason: serializer.fromJson<String>(json['reason']),
      beforeJson: serializer.fromJson<String>(json['before_json']),
      afterJson: serializer.fromJson<String>(json['after_json']),
      createdAtUtc: serializer.fromJson<String>(json['created_at_utc']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'command_id': serializer.toJson<String>(commandId),
      'entity_type': serializer.toJson<String>(entityType),
      'entity_id': serializer.toJson<String>(entityId),
      'event_type': serializer.toJson<String>(eventType),
      'actor_id': serializer.toJson<String>(actorId),
      'session_id': serializer.toJson<String>(sessionId),
      'approver_id': serializer.toJson<String?>(approverId),
      'business_day_id': serializer.toJson<String?>(businessDayId),
      'terminal_id': serializer.toJson<String>(terminalId),
      'app_version': serializer.toJson<String>(appVersion),
      'reason': serializer.toJson<String>(reason),
      'before_json': serializer.toJson<String>(beforeJson),
      'after_json': serializer.toJson<String>(afterJson),
      'created_at_utc': serializer.toJson<String>(createdAtUtc),
    };
  }

  AuditEvent copyWith({
    String? id,
    String? commandId,
    String? entityType,
    String? entityId,
    String? eventType,
    String? actorId,
    String? sessionId,
    Value<String?> approverId = const Value.absent(),
    Value<String?> businessDayId = const Value.absent(),
    String? terminalId,
    String? appVersion,
    String? reason,
    String? beforeJson,
    String? afterJson,
    String? createdAtUtc,
  }) => AuditEvent(
    id: id ?? this.id,
    commandId: commandId ?? this.commandId,
    entityType: entityType ?? this.entityType,
    entityId: entityId ?? this.entityId,
    eventType: eventType ?? this.eventType,
    actorId: actorId ?? this.actorId,
    sessionId: sessionId ?? this.sessionId,
    approverId: approverId.present ? approverId.value : this.approverId,
    businessDayId: businessDayId.present
        ? businessDayId.value
        : this.businessDayId,
    terminalId: terminalId ?? this.terminalId,
    appVersion: appVersion ?? this.appVersion,
    reason: reason ?? this.reason,
    beforeJson: beforeJson ?? this.beforeJson,
    afterJson: afterJson ?? this.afterJson,
    createdAtUtc: createdAtUtc ?? this.createdAtUtc,
  );
  AuditEvent copyWithCompanion(AuditEventsCompanion data) {
    return AuditEvent(
      id: data.id.present ? data.id.value : this.id,
      commandId: data.commandId.present ? data.commandId.value : this.commandId,
      entityType: data.entityType.present
          ? data.entityType.value
          : this.entityType,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      eventType: data.eventType.present ? data.eventType.value : this.eventType,
      actorId: data.actorId.present ? data.actorId.value : this.actorId,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      approverId: data.approverId.present
          ? data.approverId.value
          : this.approverId,
      businessDayId: data.businessDayId.present
          ? data.businessDayId.value
          : this.businessDayId,
      terminalId: data.terminalId.present
          ? data.terminalId.value
          : this.terminalId,
      appVersion: data.appVersion.present
          ? data.appVersion.value
          : this.appVersion,
      reason: data.reason.present ? data.reason.value : this.reason,
      beforeJson: data.beforeJson.present
          ? data.beforeJson.value
          : this.beforeJson,
      afterJson: data.afterJson.present ? data.afterJson.value : this.afterJson,
      createdAtUtc: data.createdAtUtc.present
          ? data.createdAtUtc.value
          : this.createdAtUtc,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AuditEvent(')
          ..write('id: $id, ')
          ..write('commandId: $commandId, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('eventType: $eventType, ')
          ..write('actorId: $actorId, ')
          ..write('sessionId: $sessionId, ')
          ..write('approverId: $approverId, ')
          ..write('businessDayId: $businessDayId, ')
          ..write('terminalId: $terminalId, ')
          ..write('appVersion: $appVersion, ')
          ..write('reason: $reason, ')
          ..write('beforeJson: $beforeJson, ')
          ..write('afterJson: $afterJson, ')
          ..write('createdAtUtc: $createdAtUtc')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    commandId,
    entityType,
    entityId,
    eventType,
    actorId,
    sessionId,
    approverId,
    businessDayId,
    terminalId,
    appVersion,
    reason,
    beforeJson,
    afterJson,
    createdAtUtc,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AuditEvent &&
          other.id == this.id &&
          other.commandId == this.commandId &&
          other.entityType == this.entityType &&
          other.entityId == this.entityId &&
          other.eventType == this.eventType &&
          other.actorId == this.actorId &&
          other.sessionId == this.sessionId &&
          other.approverId == this.approverId &&
          other.businessDayId == this.businessDayId &&
          other.terminalId == this.terminalId &&
          other.appVersion == this.appVersion &&
          other.reason == this.reason &&
          other.beforeJson == this.beforeJson &&
          other.afterJson == this.afterJson &&
          other.createdAtUtc == this.createdAtUtc);
}

class AuditEventsCompanion extends UpdateCompanion<AuditEvent> {
  final Value<String> id;
  final Value<String> commandId;
  final Value<String> entityType;
  final Value<String> entityId;
  final Value<String> eventType;
  final Value<String> actorId;
  final Value<String> sessionId;
  final Value<String?> approverId;
  final Value<String?> businessDayId;
  final Value<String> terminalId;
  final Value<String> appVersion;
  final Value<String> reason;
  final Value<String> beforeJson;
  final Value<String> afterJson;
  final Value<String> createdAtUtc;
  final Value<int> rowid;
  const AuditEventsCompanion({
    this.id = const Value.absent(),
    this.commandId = const Value.absent(),
    this.entityType = const Value.absent(),
    this.entityId = const Value.absent(),
    this.eventType = const Value.absent(),
    this.actorId = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.approverId = const Value.absent(),
    this.businessDayId = const Value.absent(),
    this.terminalId = const Value.absent(),
    this.appVersion = const Value.absent(),
    this.reason = const Value.absent(),
    this.beforeJson = const Value.absent(),
    this.afterJson = const Value.absent(),
    this.createdAtUtc = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AuditEventsCompanion.insert({
    required String id,
    required String commandId,
    required String entityType,
    required String entityId,
    required String eventType,
    required String actorId,
    required String sessionId,
    this.approverId = const Value.absent(),
    this.businessDayId = const Value.absent(),
    required String terminalId,
    required String appVersion,
    required String reason,
    required String beforeJson,
    required String afterJson,
    required String createdAtUtc,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       commandId = Value(commandId),
       entityType = Value(entityType),
       entityId = Value(entityId),
       eventType = Value(eventType),
       actorId = Value(actorId),
       sessionId = Value(sessionId),
       terminalId = Value(terminalId),
       appVersion = Value(appVersion),
       reason = Value(reason),
       beforeJson = Value(beforeJson),
       afterJson = Value(afterJson),
       createdAtUtc = Value(createdAtUtc);
  static Insertable<AuditEvent> custom({
    Expression<String>? id,
    Expression<String>? commandId,
    Expression<String>? entityType,
    Expression<String>? entityId,
    Expression<String>? eventType,
    Expression<String>? actorId,
    Expression<String>? sessionId,
    Expression<String>? approverId,
    Expression<String>? businessDayId,
    Expression<String>? terminalId,
    Expression<String>? appVersion,
    Expression<String>? reason,
    Expression<String>? beforeJson,
    Expression<String>? afterJson,
    Expression<String>? createdAtUtc,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (commandId != null) 'command_id': commandId,
      if (entityType != null) 'entity_type': entityType,
      if (entityId != null) 'entity_id': entityId,
      if (eventType != null) 'event_type': eventType,
      if (actorId != null) 'actor_id': actorId,
      if (sessionId != null) 'session_id': sessionId,
      if (approverId != null) 'approver_id': approverId,
      if (businessDayId != null) 'business_day_id': businessDayId,
      if (terminalId != null) 'terminal_id': terminalId,
      if (appVersion != null) 'app_version': appVersion,
      if (reason != null) 'reason': reason,
      if (beforeJson != null) 'before_json': beforeJson,
      if (afterJson != null) 'after_json': afterJson,
      if (createdAtUtc != null) 'created_at_utc': createdAtUtc,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AuditEventsCompanion copyWith({
    Value<String>? id,
    Value<String>? commandId,
    Value<String>? entityType,
    Value<String>? entityId,
    Value<String>? eventType,
    Value<String>? actorId,
    Value<String>? sessionId,
    Value<String?>? approverId,
    Value<String?>? businessDayId,
    Value<String>? terminalId,
    Value<String>? appVersion,
    Value<String>? reason,
    Value<String>? beforeJson,
    Value<String>? afterJson,
    Value<String>? createdAtUtc,
    Value<int>? rowid,
  }) {
    return AuditEventsCompanion(
      id: id ?? this.id,
      commandId: commandId ?? this.commandId,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      eventType: eventType ?? this.eventType,
      actorId: actorId ?? this.actorId,
      sessionId: sessionId ?? this.sessionId,
      approverId: approverId ?? this.approverId,
      businessDayId: businessDayId ?? this.businessDayId,
      terminalId: terminalId ?? this.terminalId,
      appVersion: appVersion ?? this.appVersion,
      reason: reason ?? this.reason,
      beforeJson: beforeJson ?? this.beforeJson,
      afterJson: afterJson ?? this.afterJson,
      createdAtUtc: createdAtUtc ?? this.createdAtUtc,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (commandId.present) {
      map['command_id'] = Variable<String>(commandId.value);
    }
    if (entityType.present) {
      map['entity_type'] = Variable<String>(entityType.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<String>(entityId.value);
    }
    if (eventType.present) {
      map['event_type'] = Variable<String>(eventType.value);
    }
    if (actorId.present) {
      map['actor_id'] = Variable<String>(actorId.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<String>(sessionId.value);
    }
    if (approverId.present) {
      map['approver_id'] = Variable<String>(approverId.value);
    }
    if (businessDayId.present) {
      map['business_day_id'] = Variable<String>(businessDayId.value);
    }
    if (terminalId.present) {
      map['terminal_id'] = Variable<String>(terminalId.value);
    }
    if (appVersion.present) {
      map['app_version'] = Variable<String>(appVersion.value);
    }
    if (reason.present) {
      map['reason'] = Variable<String>(reason.value);
    }
    if (beforeJson.present) {
      map['before_json'] = Variable<String>(beforeJson.value);
    }
    if (afterJson.present) {
      map['after_json'] = Variable<String>(afterJson.value);
    }
    if (createdAtUtc.present) {
      map['created_at_utc'] = Variable<String>(createdAtUtc.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AuditEventsCompanion(')
          ..write('id: $id, ')
          ..write('commandId: $commandId, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('eventType: $eventType, ')
          ..write('actorId: $actorId, ')
          ..write('sessionId: $sessionId, ')
          ..write('approverId: $approverId, ')
          ..write('businessDayId: $businessDayId, ')
          ..write('terminalId: $terminalId, ')
          ..write('appVersion: $appVersion, ')
          ..write('reason: $reason, ')
          ..write('beforeJson: $beforeJson, ')
          ..write('afterJson: $afterJson, ')
          ..write('createdAtUtc: $createdAtUtc, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class StaffCredentials extends Table
    with TableInfo<StaffCredentials, StaffCredential> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  StaffCredentials(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL PRIMARY KEY',
  );
  static const VerificationMeta _displayNameMeta = const VerificationMeta(
    'displayName',
  );
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
    'display_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints:
        'NOT NULL CHECK (length(trim(display_name)) BETWEEN 1 AND 100)',
  );
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
    'role',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (role IN (\'cashier\', \'manager\'))',
  );
  static const VerificationMeta _enabledMeta = const VerificationMeta(
    'enabled',
  );
  late final GeneratedColumn<int> enabled = GeneratedColumn<int>(
    'enabled',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (enabled IN (0, 1))',
  );
  static const VerificationMeta _revisionMeta = const VerificationMeta(
    'revision',
  );
  late final GeneratedColumn<int> revision = GeneratedColumn<int>(
    'revision',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (revision >= 1)',
  );
  static const VerificationMeta _pinFingerprintMeta = const VerificationMeta(
    'pinFingerprint',
  );
  late final GeneratedColumn<String> pinFingerprint = GeneratedColumn<String>(
    'pin_fingerprint',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (length(pin_fingerprint) = 44)',
  );
  static const VerificationMeta _saltBase64Meta = const VerificationMeta(
    'saltBase64',
  );
  late final GeneratedColumn<String> saltBase64 = GeneratedColumn<String>(
    'salt_base64',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (length(salt_base64) = 24)',
  );
  static const VerificationMeta _hashBase64Meta = const VerificationMeta(
    'hashBase64',
  );
  late final GeneratedColumn<String> hashBase64 = GeneratedColumn<String>(
    'hash_base64',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (length(hash_base64) = 44)',
  );
  static const VerificationMeta _verifierVersionMeta = const VerificationMeta(
    'verifierVersion',
  );
  late final GeneratedColumn<int> verifierVersion = GeneratedColumn<int>(
    'verifier_version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (verifier_version = 1)',
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    displayName,
    role,
    enabled,
    revision,
    pinFingerprint,
    saltBase64,
    hashBase64,
    verifierVersion,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'staff_credentials';
  @override
  VerificationContext validateIntegrity(
    Insertable<StaffCredential> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('display_name')) {
      context.handle(
        _displayNameMeta,
        displayName.isAcceptableOrUnknown(
          data['display_name']!,
          _displayNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_displayNameMeta);
    }
    if (data.containsKey('role')) {
      context.handle(
        _roleMeta,
        role.isAcceptableOrUnknown(data['role']!, _roleMeta),
      );
    } else if (isInserting) {
      context.missing(_roleMeta);
    }
    if (data.containsKey('enabled')) {
      context.handle(
        _enabledMeta,
        enabled.isAcceptableOrUnknown(data['enabled']!, _enabledMeta),
      );
    } else if (isInserting) {
      context.missing(_enabledMeta);
    }
    if (data.containsKey('revision')) {
      context.handle(
        _revisionMeta,
        revision.isAcceptableOrUnknown(data['revision']!, _revisionMeta),
      );
    } else if (isInserting) {
      context.missing(_revisionMeta);
    }
    if (data.containsKey('pin_fingerprint')) {
      context.handle(
        _pinFingerprintMeta,
        pinFingerprint.isAcceptableOrUnknown(
          data['pin_fingerprint']!,
          _pinFingerprintMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_pinFingerprintMeta);
    }
    if (data.containsKey('salt_base64')) {
      context.handle(
        _saltBase64Meta,
        saltBase64.isAcceptableOrUnknown(data['salt_base64']!, _saltBase64Meta),
      );
    } else if (isInserting) {
      context.missing(_saltBase64Meta);
    }
    if (data.containsKey('hash_base64')) {
      context.handle(
        _hashBase64Meta,
        hashBase64.isAcceptableOrUnknown(data['hash_base64']!, _hashBase64Meta),
      );
    } else if (isInserting) {
      context.missing(_hashBase64Meta);
    }
    if (data.containsKey('verifier_version')) {
      context.handle(
        _verifierVersionMeta,
        verifierVersion.isAcceptableOrUnknown(
          data['verifier_version']!,
          _verifierVersionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_verifierVersionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StaffCredential map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StaffCredential(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      displayName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}display_name'],
      )!,
      role: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}role'],
      )!,
      enabled: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}enabled'],
      )!,
      revision: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}revision'],
      )!,
      pinFingerprint: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pin_fingerprint'],
      )!,
      saltBase64: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}salt_base64'],
      )!,
      hashBase64: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}hash_base64'],
      )!,
      verifierVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}verifier_version'],
      )!,
    );
  }

  @override
  StaffCredentials createAlias(String alias) {
    return StaffCredentials(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class StaffCredential extends DataClass implements Insertable<StaffCredential> {
  final String id;
  final String displayName;
  final String role;
  final int enabled;
  final int revision;
  final String pinFingerprint;
  final String saltBase64;
  final String hashBase64;
  final int verifierVersion;
  const StaffCredential({
    required this.id,
    required this.displayName,
    required this.role,
    required this.enabled,
    required this.revision,
    required this.pinFingerprint,
    required this.saltBase64,
    required this.hashBase64,
    required this.verifierVersion,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['display_name'] = Variable<String>(displayName);
    map['role'] = Variable<String>(role);
    map['enabled'] = Variable<int>(enabled);
    map['revision'] = Variable<int>(revision);
    map['pin_fingerprint'] = Variable<String>(pinFingerprint);
    map['salt_base64'] = Variable<String>(saltBase64);
    map['hash_base64'] = Variable<String>(hashBase64);
    map['verifier_version'] = Variable<int>(verifierVersion);
    return map;
  }

  StaffCredentialsCompanion toCompanion(bool nullToAbsent) {
    return StaffCredentialsCompanion(
      id: Value(id),
      displayName: Value(displayName),
      role: Value(role),
      enabled: Value(enabled),
      revision: Value(revision),
      pinFingerprint: Value(pinFingerprint),
      saltBase64: Value(saltBase64),
      hashBase64: Value(hashBase64),
      verifierVersion: Value(verifierVersion),
    );
  }

  factory StaffCredential.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StaffCredential(
      id: serializer.fromJson<String>(json['id']),
      displayName: serializer.fromJson<String>(json['display_name']),
      role: serializer.fromJson<String>(json['role']),
      enabled: serializer.fromJson<int>(json['enabled']),
      revision: serializer.fromJson<int>(json['revision']),
      pinFingerprint: serializer.fromJson<String>(json['pin_fingerprint']),
      saltBase64: serializer.fromJson<String>(json['salt_base64']),
      hashBase64: serializer.fromJson<String>(json['hash_base64']),
      verifierVersion: serializer.fromJson<int>(json['verifier_version']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'display_name': serializer.toJson<String>(displayName),
      'role': serializer.toJson<String>(role),
      'enabled': serializer.toJson<int>(enabled),
      'revision': serializer.toJson<int>(revision),
      'pin_fingerprint': serializer.toJson<String>(pinFingerprint),
      'salt_base64': serializer.toJson<String>(saltBase64),
      'hash_base64': serializer.toJson<String>(hashBase64),
      'verifier_version': serializer.toJson<int>(verifierVersion),
    };
  }

  StaffCredential copyWith({
    String? id,
    String? displayName,
    String? role,
    int? enabled,
    int? revision,
    String? pinFingerprint,
    String? saltBase64,
    String? hashBase64,
    int? verifierVersion,
  }) => StaffCredential(
    id: id ?? this.id,
    displayName: displayName ?? this.displayName,
    role: role ?? this.role,
    enabled: enabled ?? this.enabled,
    revision: revision ?? this.revision,
    pinFingerprint: pinFingerprint ?? this.pinFingerprint,
    saltBase64: saltBase64 ?? this.saltBase64,
    hashBase64: hashBase64 ?? this.hashBase64,
    verifierVersion: verifierVersion ?? this.verifierVersion,
  );
  StaffCredential copyWithCompanion(StaffCredentialsCompanion data) {
    return StaffCredential(
      id: data.id.present ? data.id.value : this.id,
      displayName: data.displayName.present
          ? data.displayName.value
          : this.displayName,
      role: data.role.present ? data.role.value : this.role,
      enabled: data.enabled.present ? data.enabled.value : this.enabled,
      revision: data.revision.present ? data.revision.value : this.revision,
      pinFingerprint: data.pinFingerprint.present
          ? data.pinFingerprint.value
          : this.pinFingerprint,
      saltBase64: data.saltBase64.present
          ? data.saltBase64.value
          : this.saltBase64,
      hashBase64: data.hashBase64.present
          ? data.hashBase64.value
          : this.hashBase64,
      verifierVersion: data.verifierVersion.present
          ? data.verifierVersion.value
          : this.verifierVersion,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StaffCredential(')
          ..write('id: $id, ')
          ..write('displayName: $displayName, ')
          ..write('role: $role, ')
          ..write('enabled: $enabled, ')
          ..write('revision: $revision, ')
          ..write('pinFingerprint: $pinFingerprint, ')
          ..write('saltBase64: $saltBase64, ')
          ..write('hashBase64: $hashBase64, ')
          ..write('verifierVersion: $verifierVersion')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    displayName,
    role,
    enabled,
    revision,
    pinFingerprint,
    saltBase64,
    hashBase64,
    verifierVersion,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StaffCredential &&
          other.id == this.id &&
          other.displayName == this.displayName &&
          other.role == this.role &&
          other.enabled == this.enabled &&
          other.revision == this.revision &&
          other.pinFingerprint == this.pinFingerprint &&
          other.saltBase64 == this.saltBase64 &&
          other.hashBase64 == this.hashBase64 &&
          other.verifierVersion == this.verifierVersion);
}

class StaffCredentialsCompanion extends UpdateCompanion<StaffCredential> {
  final Value<String> id;
  final Value<String> displayName;
  final Value<String> role;
  final Value<int> enabled;
  final Value<int> revision;
  final Value<String> pinFingerprint;
  final Value<String> saltBase64;
  final Value<String> hashBase64;
  final Value<int> verifierVersion;
  final Value<int> rowid;
  const StaffCredentialsCompanion({
    this.id = const Value.absent(),
    this.displayName = const Value.absent(),
    this.role = const Value.absent(),
    this.enabled = const Value.absent(),
    this.revision = const Value.absent(),
    this.pinFingerprint = const Value.absent(),
    this.saltBase64 = const Value.absent(),
    this.hashBase64 = const Value.absent(),
    this.verifierVersion = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StaffCredentialsCompanion.insert({
    required String id,
    required String displayName,
    required String role,
    required int enabled,
    required int revision,
    required String pinFingerprint,
    required String saltBase64,
    required String hashBase64,
    required int verifierVersion,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       displayName = Value(displayName),
       role = Value(role),
       enabled = Value(enabled),
       revision = Value(revision),
       pinFingerprint = Value(pinFingerprint),
       saltBase64 = Value(saltBase64),
       hashBase64 = Value(hashBase64),
       verifierVersion = Value(verifierVersion);
  static Insertable<StaffCredential> custom({
    Expression<String>? id,
    Expression<String>? displayName,
    Expression<String>? role,
    Expression<int>? enabled,
    Expression<int>? revision,
    Expression<String>? pinFingerprint,
    Expression<String>? saltBase64,
    Expression<String>? hashBase64,
    Expression<int>? verifierVersion,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (displayName != null) 'display_name': displayName,
      if (role != null) 'role': role,
      if (enabled != null) 'enabled': enabled,
      if (revision != null) 'revision': revision,
      if (pinFingerprint != null) 'pin_fingerprint': pinFingerprint,
      if (saltBase64 != null) 'salt_base64': saltBase64,
      if (hashBase64 != null) 'hash_base64': hashBase64,
      if (verifierVersion != null) 'verifier_version': verifierVersion,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StaffCredentialsCompanion copyWith({
    Value<String>? id,
    Value<String>? displayName,
    Value<String>? role,
    Value<int>? enabled,
    Value<int>? revision,
    Value<String>? pinFingerprint,
    Value<String>? saltBase64,
    Value<String>? hashBase64,
    Value<int>? verifierVersion,
    Value<int>? rowid,
  }) {
    return StaffCredentialsCompanion(
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      role: role ?? this.role,
      enabled: enabled ?? this.enabled,
      revision: revision ?? this.revision,
      pinFingerprint: pinFingerprint ?? this.pinFingerprint,
      saltBase64: saltBase64 ?? this.saltBase64,
      hashBase64: hashBase64 ?? this.hashBase64,
      verifierVersion: verifierVersion ?? this.verifierVersion,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (enabled.present) {
      map['enabled'] = Variable<int>(enabled.value);
    }
    if (revision.present) {
      map['revision'] = Variable<int>(revision.value);
    }
    if (pinFingerprint.present) {
      map['pin_fingerprint'] = Variable<String>(pinFingerprint.value);
    }
    if (saltBase64.present) {
      map['salt_base64'] = Variable<String>(saltBase64.value);
    }
    if (hashBase64.present) {
      map['hash_base64'] = Variable<String>(hashBase64.value);
    }
    if (verifierVersion.present) {
      map['verifier_version'] = Variable<int>(verifierVersion.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StaffCredentialsCompanion(')
          ..write('id: $id, ')
          ..write('displayName: $displayName, ')
          ..write('role: $role, ')
          ..write('enabled: $enabled, ')
          ..write('revision: $revision, ')
          ..write('pinFingerprint: $pinFingerprint, ')
          ..write('saltBase64: $saltBase64, ')
          ..write('hashBase64: $hashBase64, ')
          ..write('verifierVersion: $verifierVersion, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class InstallationSecurity extends Table
    with TableInfo<InstallationSecurity, InstallationSecurityData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  InstallationSecurity(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _keyIdMeta = const VerificationMeta('keyId');
  late final GeneratedColumn<String> keyId = GeneratedColumn<String>(
    'key_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (length(key_id) = 44)',
  );
  static const VerificationMeta _terminalIdMeta = const VerificationMeta(
    'terminalId',
  );
  late final GeneratedColumn<String> terminalId = GeneratedColumn<String>(
    'terminal_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _setupIntentMeta = const VerificationMeta(
    'setupIntent',
  );
  late final GeneratedColumn<String> setupIntent = GeneratedColumn<String>(
    'setup_intent',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL UNIQUE',
  );
  static const VerificationMeta _setupHashMeta = const VerificationMeta(
    'setupHash',
  );
  late final GeneratedColumn<String> setupHash = GeneratedColumn<String>(
    'setup_hash',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (length(setup_hash) = 64)',
  );
  static const VerificationMeta _firstManagerIdMeta = const VerificationMeta(
    'firstManagerId',
  );
  late final GeneratedColumn<String> firstManagerId = GeneratedColumn<String>(
    'first_manager_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES staff_credentials(id)',
  );
  static const VerificationMeta _primaryCashierIdMeta = const VerificationMeta(
    'primaryCashierId',
  );
  late final GeneratedColumn<String> primaryCashierId = GeneratedColumn<String>(
    'primary_cashier_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES staff_credentials(id)',
  );
  static const VerificationMeta _recoveryAcknowledgedAtMsMeta =
      const VerificationMeta('recoveryAcknowledgedAtMs');
  late final GeneratedColumn<int> recoveryAcknowledgedAtMs =
      GeneratedColumn<int>(
        'recovery_acknowledged_at_ms',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
        $customConstraints: 'NOT NULL CHECK (recovery_acknowledged_at_ms >= 0)',
      );
  @override
  List<GeneratedColumn> get $columns => [
    singleton,
    keyId,
    terminalId,
    setupIntent,
    setupHash,
    firstManagerId,
    primaryCashierId,
    recoveryAcknowledgedAtMs,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'installation_security';
  @override
  VerificationContext validateIntegrity(
    Insertable<InstallationSecurityData> instance, {
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
    if (data.containsKey('key_id')) {
      context.handle(
        _keyIdMeta,
        keyId.isAcceptableOrUnknown(data['key_id']!, _keyIdMeta),
      );
    } else if (isInserting) {
      context.missing(_keyIdMeta);
    }
    if (data.containsKey('terminal_id')) {
      context.handle(
        _terminalIdMeta,
        terminalId.isAcceptableOrUnknown(data['terminal_id']!, _terminalIdMeta),
      );
    } else if (isInserting) {
      context.missing(_terminalIdMeta);
    }
    if (data.containsKey('setup_intent')) {
      context.handle(
        _setupIntentMeta,
        setupIntent.isAcceptableOrUnknown(
          data['setup_intent']!,
          _setupIntentMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_setupIntentMeta);
    }
    if (data.containsKey('setup_hash')) {
      context.handle(
        _setupHashMeta,
        setupHash.isAcceptableOrUnknown(data['setup_hash']!, _setupHashMeta),
      );
    } else if (isInserting) {
      context.missing(_setupHashMeta);
    }
    if (data.containsKey('first_manager_id')) {
      context.handle(
        _firstManagerIdMeta,
        firstManagerId.isAcceptableOrUnknown(
          data['first_manager_id']!,
          _firstManagerIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_firstManagerIdMeta);
    }
    if (data.containsKey('primary_cashier_id')) {
      context.handle(
        _primaryCashierIdMeta,
        primaryCashierId.isAcceptableOrUnknown(
          data['primary_cashier_id']!,
          _primaryCashierIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_primaryCashierIdMeta);
    }
    if (data.containsKey('recovery_acknowledged_at_ms')) {
      context.handle(
        _recoveryAcknowledgedAtMsMeta,
        recoveryAcknowledgedAtMs.isAcceptableOrUnknown(
          data['recovery_acknowledged_at_ms']!,
          _recoveryAcknowledgedAtMsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_recoveryAcknowledgedAtMsMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {singleton};
  @override
  InstallationSecurityData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return InstallationSecurityData(
      singleton: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}singleton'],
      )!,
      keyId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key_id'],
      )!,
      terminalId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}terminal_id'],
      )!,
      setupIntent: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}setup_intent'],
      )!,
      setupHash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}setup_hash'],
      )!,
      firstManagerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}first_manager_id'],
      )!,
      primaryCashierId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}primary_cashier_id'],
      )!,
      recoveryAcknowledgedAtMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}recovery_acknowledged_at_ms'],
      )!,
    );
  }

  @override
  InstallationSecurity createAlias(String alias) {
    return InstallationSecurity(attachedDatabase, alias);
  }

  @override
  List<String> get customConstraints => const [
    'CHECK(first_manager_id <> primary_cashier_id)',
  ];
  @override
  bool get dontWriteConstraints => true;
}

class InstallationSecurityData extends DataClass
    implements Insertable<InstallationSecurityData> {
  final int singleton;
  final String keyId;
  final String terminalId;
  final String setupIntent;
  final String setupHash;
  final String firstManagerId;
  final String primaryCashierId;
  final int recoveryAcknowledgedAtMs;
  const InstallationSecurityData({
    required this.singleton,
    required this.keyId,
    required this.terminalId,
    required this.setupIntent,
    required this.setupHash,
    required this.firstManagerId,
    required this.primaryCashierId,
    required this.recoveryAcknowledgedAtMs,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['singleton'] = Variable<int>(singleton);
    map['key_id'] = Variable<String>(keyId);
    map['terminal_id'] = Variable<String>(terminalId);
    map['setup_intent'] = Variable<String>(setupIntent);
    map['setup_hash'] = Variable<String>(setupHash);
    map['first_manager_id'] = Variable<String>(firstManagerId);
    map['primary_cashier_id'] = Variable<String>(primaryCashierId);
    map['recovery_acknowledged_at_ms'] = Variable<int>(
      recoveryAcknowledgedAtMs,
    );
    return map;
  }

  InstallationSecurityCompanion toCompanion(bool nullToAbsent) {
    return InstallationSecurityCompanion(
      singleton: Value(singleton),
      keyId: Value(keyId),
      terminalId: Value(terminalId),
      setupIntent: Value(setupIntent),
      setupHash: Value(setupHash),
      firstManagerId: Value(firstManagerId),
      primaryCashierId: Value(primaryCashierId),
      recoveryAcknowledgedAtMs: Value(recoveryAcknowledgedAtMs),
    );
  }

  factory InstallationSecurityData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return InstallationSecurityData(
      singleton: serializer.fromJson<int>(json['singleton']),
      keyId: serializer.fromJson<String>(json['key_id']),
      terminalId: serializer.fromJson<String>(json['terminal_id']),
      setupIntent: serializer.fromJson<String>(json['setup_intent']),
      setupHash: serializer.fromJson<String>(json['setup_hash']),
      firstManagerId: serializer.fromJson<String>(json['first_manager_id']),
      primaryCashierId: serializer.fromJson<String>(json['primary_cashier_id']),
      recoveryAcknowledgedAtMs: serializer.fromJson<int>(
        json['recovery_acknowledged_at_ms'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'singleton': serializer.toJson<int>(singleton),
      'key_id': serializer.toJson<String>(keyId),
      'terminal_id': serializer.toJson<String>(terminalId),
      'setup_intent': serializer.toJson<String>(setupIntent),
      'setup_hash': serializer.toJson<String>(setupHash),
      'first_manager_id': serializer.toJson<String>(firstManagerId),
      'primary_cashier_id': serializer.toJson<String>(primaryCashierId),
      'recovery_acknowledged_at_ms': serializer.toJson<int>(
        recoveryAcknowledgedAtMs,
      ),
    };
  }

  InstallationSecurityData copyWith({
    int? singleton,
    String? keyId,
    String? terminalId,
    String? setupIntent,
    String? setupHash,
    String? firstManagerId,
    String? primaryCashierId,
    int? recoveryAcknowledgedAtMs,
  }) => InstallationSecurityData(
    singleton: singleton ?? this.singleton,
    keyId: keyId ?? this.keyId,
    terminalId: terminalId ?? this.terminalId,
    setupIntent: setupIntent ?? this.setupIntent,
    setupHash: setupHash ?? this.setupHash,
    firstManagerId: firstManagerId ?? this.firstManagerId,
    primaryCashierId: primaryCashierId ?? this.primaryCashierId,
    recoveryAcknowledgedAtMs:
        recoveryAcknowledgedAtMs ?? this.recoveryAcknowledgedAtMs,
  );
  InstallationSecurityData copyWithCompanion(
    InstallationSecurityCompanion data,
  ) {
    return InstallationSecurityData(
      singleton: data.singleton.present ? data.singleton.value : this.singleton,
      keyId: data.keyId.present ? data.keyId.value : this.keyId,
      terminalId: data.terminalId.present
          ? data.terminalId.value
          : this.terminalId,
      setupIntent: data.setupIntent.present
          ? data.setupIntent.value
          : this.setupIntent,
      setupHash: data.setupHash.present ? data.setupHash.value : this.setupHash,
      firstManagerId: data.firstManagerId.present
          ? data.firstManagerId.value
          : this.firstManagerId,
      primaryCashierId: data.primaryCashierId.present
          ? data.primaryCashierId.value
          : this.primaryCashierId,
      recoveryAcknowledgedAtMs: data.recoveryAcknowledgedAtMs.present
          ? data.recoveryAcknowledgedAtMs.value
          : this.recoveryAcknowledgedAtMs,
    );
  }

  @override
  String toString() {
    return (StringBuffer('InstallationSecurityData(')
          ..write('singleton: $singleton, ')
          ..write('keyId: $keyId, ')
          ..write('terminalId: $terminalId, ')
          ..write('setupIntent: $setupIntent, ')
          ..write('setupHash: $setupHash, ')
          ..write('firstManagerId: $firstManagerId, ')
          ..write('primaryCashierId: $primaryCashierId, ')
          ..write('recoveryAcknowledgedAtMs: $recoveryAcknowledgedAtMs')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    singleton,
    keyId,
    terminalId,
    setupIntent,
    setupHash,
    firstManagerId,
    primaryCashierId,
    recoveryAcknowledgedAtMs,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is InstallationSecurityData &&
          other.singleton == this.singleton &&
          other.keyId == this.keyId &&
          other.terminalId == this.terminalId &&
          other.setupIntent == this.setupIntent &&
          other.setupHash == this.setupHash &&
          other.firstManagerId == this.firstManagerId &&
          other.primaryCashierId == this.primaryCashierId &&
          other.recoveryAcknowledgedAtMs == this.recoveryAcknowledgedAtMs);
}

class InstallationSecurityCompanion
    extends UpdateCompanion<InstallationSecurityData> {
  final Value<int> singleton;
  final Value<String> keyId;
  final Value<String> terminalId;
  final Value<String> setupIntent;
  final Value<String> setupHash;
  final Value<String> firstManagerId;
  final Value<String> primaryCashierId;
  final Value<int> recoveryAcknowledgedAtMs;
  const InstallationSecurityCompanion({
    this.singleton = const Value.absent(),
    this.keyId = const Value.absent(),
    this.terminalId = const Value.absent(),
    this.setupIntent = const Value.absent(),
    this.setupHash = const Value.absent(),
    this.firstManagerId = const Value.absent(),
    this.primaryCashierId = const Value.absent(),
    this.recoveryAcknowledgedAtMs = const Value.absent(),
  });
  InstallationSecurityCompanion.insert({
    this.singleton = const Value.absent(),
    required String keyId,
    required String terminalId,
    required String setupIntent,
    required String setupHash,
    required String firstManagerId,
    required String primaryCashierId,
    required int recoveryAcknowledgedAtMs,
  }) : keyId = Value(keyId),
       terminalId = Value(terminalId),
       setupIntent = Value(setupIntent),
       setupHash = Value(setupHash),
       firstManagerId = Value(firstManagerId),
       primaryCashierId = Value(primaryCashierId),
       recoveryAcknowledgedAtMs = Value(recoveryAcknowledgedAtMs);
  static Insertable<InstallationSecurityData> custom({
    Expression<int>? singleton,
    Expression<String>? keyId,
    Expression<String>? terminalId,
    Expression<String>? setupIntent,
    Expression<String>? setupHash,
    Expression<String>? firstManagerId,
    Expression<String>? primaryCashierId,
    Expression<int>? recoveryAcknowledgedAtMs,
  }) {
    return RawValuesInsertable({
      if (singleton != null) 'singleton': singleton,
      if (keyId != null) 'key_id': keyId,
      if (terminalId != null) 'terminal_id': terminalId,
      if (setupIntent != null) 'setup_intent': setupIntent,
      if (setupHash != null) 'setup_hash': setupHash,
      if (firstManagerId != null) 'first_manager_id': firstManagerId,
      if (primaryCashierId != null) 'primary_cashier_id': primaryCashierId,
      if (recoveryAcknowledgedAtMs != null)
        'recovery_acknowledged_at_ms': recoveryAcknowledgedAtMs,
    });
  }

  InstallationSecurityCompanion copyWith({
    Value<int>? singleton,
    Value<String>? keyId,
    Value<String>? terminalId,
    Value<String>? setupIntent,
    Value<String>? setupHash,
    Value<String>? firstManagerId,
    Value<String>? primaryCashierId,
    Value<int>? recoveryAcknowledgedAtMs,
  }) {
    return InstallationSecurityCompanion(
      singleton: singleton ?? this.singleton,
      keyId: keyId ?? this.keyId,
      terminalId: terminalId ?? this.terminalId,
      setupIntent: setupIntent ?? this.setupIntent,
      setupHash: setupHash ?? this.setupHash,
      firstManagerId: firstManagerId ?? this.firstManagerId,
      primaryCashierId: primaryCashierId ?? this.primaryCashierId,
      recoveryAcknowledgedAtMs:
          recoveryAcknowledgedAtMs ?? this.recoveryAcknowledgedAtMs,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (singleton.present) {
      map['singleton'] = Variable<int>(singleton.value);
    }
    if (keyId.present) {
      map['key_id'] = Variable<String>(keyId.value);
    }
    if (terminalId.present) {
      map['terminal_id'] = Variable<String>(terminalId.value);
    }
    if (setupIntent.present) {
      map['setup_intent'] = Variable<String>(setupIntent.value);
    }
    if (setupHash.present) {
      map['setup_hash'] = Variable<String>(setupHash.value);
    }
    if (firstManagerId.present) {
      map['first_manager_id'] = Variable<String>(firstManagerId.value);
    }
    if (primaryCashierId.present) {
      map['primary_cashier_id'] = Variable<String>(primaryCashierId.value);
    }
    if (recoveryAcknowledgedAtMs.present) {
      map['recovery_acknowledged_at_ms'] = Variable<int>(
        recoveryAcknowledgedAtMs.value,
      );
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InstallationSecurityCompanion(')
          ..write('singleton: $singleton, ')
          ..write('keyId: $keyId, ')
          ..write('terminalId: $terminalId, ')
          ..write('setupIntent: $setupIntent, ')
          ..write('setupHash: $setupHash, ')
          ..write('firstManagerId: $firstManagerId, ')
          ..write('primaryCashierId: $primaryCashierId, ')
          ..write('recoveryAcknowledgedAtMs: $recoveryAcknowledgedAtMs')
          ..write(')'))
        .toString();
  }
}

class AuthAttemptLimits extends Table
    with TableInfo<AuthAttemptLimits, AuthAttemptLimit> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  AuthAttemptLimits(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _scopeMeta = const VerificationMeta('scope');
  late final GeneratedColumn<String> scope = GeneratedColumn<String>(
    'scope',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (scope IN (\'device\', \'account\'))',
  );
  static const VerificationMeta _subjectIdMeta = const VerificationMeta(
    'subjectId',
  );
  late final GeneratedColumn<String> subjectId = GeneratedColumn<String>(
    'subject_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _windowStartMsMeta = const VerificationMeta(
    'windowStartMs',
  );
  late final GeneratedColumn<int> windowStartMs = GeneratedColumn<int>(
    'window_start_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (window_start_ms >= 0)',
  );
  static const VerificationMeta _lastSeenMsMeta = const VerificationMeta(
    'lastSeenMs',
  );
  late final GeneratedColumn<int> lastSeenMs = GeneratedColumn<int>(
    'last_seen_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (last_seen_ms >= window_start_ms)',
  );
  static const VerificationMeta _reservedCountMeta = const VerificationMeta(
    'reservedCount',
  );
  late final GeneratedColumn<int> reservedCount = GeneratedColumn<int>(
    'reserved_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (reserved_count >= 0)',
  );
  @override
  List<GeneratedColumn> get $columns => [
    scope,
    subjectId,
    windowStartMs,
    lastSeenMs,
    reservedCount,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'auth_attempt_limits';
  @override
  VerificationContext validateIntegrity(
    Insertable<AuthAttemptLimit> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('scope')) {
      context.handle(
        _scopeMeta,
        scope.isAcceptableOrUnknown(data['scope']!, _scopeMeta),
      );
    } else if (isInserting) {
      context.missing(_scopeMeta);
    }
    if (data.containsKey('subject_id')) {
      context.handle(
        _subjectIdMeta,
        subjectId.isAcceptableOrUnknown(data['subject_id']!, _subjectIdMeta),
      );
    } else if (isInserting) {
      context.missing(_subjectIdMeta);
    }
    if (data.containsKey('window_start_ms')) {
      context.handle(
        _windowStartMsMeta,
        windowStartMs.isAcceptableOrUnknown(
          data['window_start_ms']!,
          _windowStartMsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_windowStartMsMeta);
    }
    if (data.containsKey('last_seen_ms')) {
      context.handle(
        _lastSeenMsMeta,
        lastSeenMs.isAcceptableOrUnknown(
          data['last_seen_ms']!,
          _lastSeenMsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lastSeenMsMeta);
    }
    if (data.containsKey('reserved_count')) {
      context.handle(
        _reservedCountMeta,
        reservedCount.isAcceptableOrUnknown(
          data['reserved_count']!,
          _reservedCountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_reservedCountMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {scope, subjectId};
  @override
  AuthAttemptLimit map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AuthAttemptLimit(
      scope: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}scope'],
      )!,
      subjectId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}subject_id'],
      )!,
      windowStartMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}window_start_ms'],
      )!,
      lastSeenMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}last_seen_ms'],
      )!,
      reservedCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reserved_count'],
      )!,
    );
  }

  @override
  AuthAttemptLimits createAlias(String alias) {
    return AuthAttemptLimits(attachedDatabase, alias);
  }

  @override
  List<String> get customConstraints => const [
    'PRIMARY KEY(scope, subject_id)',
  ];
  @override
  bool get dontWriteConstraints => true;
}

class AuthAttemptLimit extends DataClass
    implements Insertable<AuthAttemptLimit> {
  final String scope;
  final String subjectId;
  final int windowStartMs;
  final int lastSeenMs;
  final int reservedCount;
  const AuthAttemptLimit({
    required this.scope,
    required this.subjectId,
    required this.windowStartMs,
    required this.lastSeenMs,
    required this.reservedCount,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['scope'] = Variable<String>(scope);
    map['subject_id'] = Variable<String>(subjectId);
    map['window_start_ms'] = Variable<int>(windowStartMs);
    map['last_seen_ms'] = Variable<int>(lastSeenMs);
    map['reserved_count'] = Variable<int>(reservedCount);
    return map;
  }

  AuthAttemptLimitsCompanion toCompanion(bool nullToAbsent) {
    return AuthAttemptLimitsCompanion(
      scope: Value(scope),
      subjectId: Value(subjectId),
      windowStartMs: Value(windowStartMs),
      lastSeenMs: Value(lastSeenMs),
      reservedCount: Value(reservedCount),
    );
  }

  factory AuthAttemptLimit.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AuthAttemptLimit(
      scope: serializer.fromJson<String>(json['scope']),
      subjectId: serializer.fromJson<String>(json['subject_id']),
      windowStartMs: serializer.fromJson<int>(json['window_start_ms']),
      lastSeenMs: serializer.fromJson<int>(json['last_seen_ms']),
      reservedCount: serializer.fromJson<int>(json['reserved_count']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'scope': serializer.toJson<String>(scope),
      'subject_id': serializer.toJson<String>(subjectId),
      'window_start_ms': serializer.toJson<int>(windowStartMs),
      'last_seen_ms': serializer.toJson<int>(lastSeenMs),
      'reserved_count': serializer.toJson<int>(reservedCount),
    };
  }

  AuthAttemptLimit copyWith({
    String? scope,
    String? subjectId,
    int? windowStartMs,
    int? lastSeenMs,
    int? reservedCount,
  }) => AuthAttemptLimit(
    scope: scope ?? this.scope,
    subjectId: subjectId ?? this.subjectId,
    windowStartMs: windowStartMs ?? this.windowStartMs,
    lastSeenMs: lastSeenMs ?? this.lastSeenMs,
    reservedCount: reservedCount ?? this.reservedCount,
  );
  AuthAttemptLimit copyWithCompanion(AuthAttemptLimitsCompanion data) {
    return AuthAttemptLimit(
      scope: data.scope.present ? data.scope.value : this.scope,
      subjectId: data.subjectId.present ? data.subjectId.value : this.subjectId,
      windowStartMs: data.windowStartMs.present
          ? data.windowStartMs.value
          : this.windowStartMs,
      lastSeenMs: data.lastSeenMs.present
          ? data.lastSeenMs.value
          : this.lastSeenMs,
      reservedCount: data.reservedCount.present
          ? data.reservedCount.value
          : this.reservedCount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AuthAttemptLimit(')
          ..write('scope: $scope, ')
          ..write('subjectId: $subjectId, ')
          ..write('windowStartMs: $windowStartMs, ')
          ..write('lastSeenMs: $lastSeenMs, ')
          ..write('reservedCount: $reservedCount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(scope, subjectId, windowStartMs, lastSeenMs, reservedCount);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AuthAttemptLimit &&
          other.scope == this.scope &&
          other.subjectId == this.subjectId &&
          other.windowStartMs == this.windowStartMs &&
          other.lastSeenMs == this.lastSeenMs &&
          other.reservedCount == this.reservedCount);
}

class AuthAttemptLimitsCompanion extends UpdateCompanion<AuthAttemptLimit> {
  final Value<String> scope;
  final Value<String> subjectId;
  final Value<int> windowStartMs;
  final Value<int> lastSeenMs;
  final Value<int> reservedCount;
  final Value<int> rowid;
  const AuthAttemptLimitsCompanion({
    this.scope = const Value.absent(),
    this.subjectId = const Value.absent(),
    this.windowStartMs = const Value.absent(),
    this.lastSeenMs = const Value.absent(),
    this.reservedCount = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AuthAttemptLimitsCompanion.insert({
    required String scope,
    required String subjectId,
    required int windowStartMs,
    required int lastSeenMs,
    required int reservedCount,
    this.rowid = const Value.absent(),
  }) : scope = Value(scope),
       subjectId = Value(subjectId),
       windowStartMs = Value(windowStartMs),
       lastSeenMs = Value(lastSeenMs),
       reservedCount = Value(reservedCount);
  static Insertable<AuthAttemptLimit> custom({
    Expression<String>? scope,
    Expression<String>? subjectId,
    Expression<int>? windowStartMs,
    Expression<int>? lastSeenMs,
    Expression<int>? reservedCount,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (scope != null) 'scope': scope,
      if (subjectId != null) 'subject_id': subjectId,
      if (windowStartMs != null) 'window_start_ms': windowStartMs,
      if (lastSeenMs != null) 'last_seen_ms': lastSeenMs,
      if (reservedCount != null) 'reserved_count': reservedCount,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AuthAttemptLimitsCompanion copyWith({
    Value<String>? scope,
    Value<String>? subjectId,
    Value<int>? windowStartMs,
    Value<int>? lastSeenMs,
    Value<int>? reservedCount,
    Value<int>? rowid,
  }) {
    return AuthAttemptLimitsCompanion(
      scope: scope ?? this.scope,
      subjectId: subjectId ?? this.subjectId,
      windowStartMs: windowStartMs ?? this.windowStartMs,
      lastSeenMs: lastSeenMs ?? this.lastSeenMs,
      reservedCount: reservedCount ?? this.reservedCount,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (scope.present) {
      map['scope'] = Variable<String>(scope.value);
    }
    if (subjectId.present) {
      map['subject_id'] = Variable<String>(subjectId.value);
    }
    if (windowStartMs.present) {
      map['window_start_ms'] = Variable<int>(windowStartMs.value);
    }
    if (lastSeenMs.present) {
      map['last_seen_ms'] = Variable<int>(lastSeenMs.value);
    }
    if (reservedCount.present) {
      map['reserved_count'] = Variable<int>(reservedCount.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AuthAttemptLimitsCompanion(')
          ..write('scope: $scope, ')
          ..write('subjectId: $subjectId, ')
          ..write('windowStartMs: $windowStartMs, ')
          ..write('lastSeenMs: $lastSeenMs, ')
          ..write('reservedCount: $reservedCount, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class AuthSessions extends Table with TableInfo<AuthSessions, AuthSession> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  AuthSessions(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL PRIMARY KEY',
  );
  static const VerificationMeta _tokenHashMeta = const VerificationMeta(
    'tokenHash',
  );
  late final GeneratedColumn<String> tokenHash = GeneratedColumn<String>(
    'token_hash',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL UNIQUE CHECK (length(token_hash) = 64)',
  );
  static const VerificationMeta _staffIdMeta = const VerificationMeta(
    'staffId',
  );
  late final GeneratedColumn<String> staffId = GeneratedColumn<String>(
    'staff_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES staff_credentials(id)',
  );
  static const VerificationMeta _credentialRevisionMeta =
      const VerificationMeta('credentialRevision');
  late final GeneratedColumn<int> credentialRevision = GeneratedColumn<int>(
    'credential_revision',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (credential_revision >= 1)',
  );
  static const VerificationMeta _roleAtIssueMeta = const VerificationMeta(
    'roleAtIssue',
  );
  late final GeneratedColumn<String> roleAtIssue = GeneratedColumn<String>(
    'role_at_issue',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints:
        'NOT NULL CHECK (role_at_issue IN (\'cashier\', \'manager\'))',
  );
  static const VerificationMeta _terminalIdMeta = const VerificationMeta(
    'terminalId',
  );
  late final GeneratedColumn<String> terminalId = GeneratedColumn<String>(
    'terminal_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _issuedAtMsMeta = const VerificationMeta(
    'issuedAtMs',
  );
  late final GeneratedColumn<int> issuedAtMs = GeneratedColumn<int>(
    'issued_at_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (issued_at_ms >= 0)',
  );
  static const VerificationMeta _lastSeenMsMeta = const VerificationMeta(
    'lastSeenMs',
  );
  late final GeneratedColumn<int> lastSeenMs = GeneratedColumn<int>(
    'last_seen_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (last_seen_ms >= issued_at_ms)',
  );
  static const VerificationMeta _expiresAtMsMeta = const VerificationMeta(
    'expiresAtMs',
  );
  late final GeneratedColumn<int> expiresAtMs = GeneratedColumn<int>(
    'expires_at_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (expires_at_ms > issued_at_ms)',
  );
  static const VerificationMeta _revokedMeta = const VerificationMeta(
    'revoked',
  );
  late final GeneratedColumn<int> revoked = GeneratedColumn<int>(
    'revoked',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (revoked IN (0, 1))',
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    tokenHash,
    staffId,
    credentialRevision,
    roleAtIssue,
    terminalId,
    issuedAtMs,
    lastSeenMs,
    expiresAtMs,
    revoked,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'auth_sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<AuthSession> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('token_hash')) {
      context.handle(
        _tokenHashMeta,
        tokenHash.isAcceptableOrUnknown(data['token_hash']!, _tokenHashMeta),
      );
    } else if (isInserting) {
      context.missing(_tokenHashMeta);
    }
    if (data.containsKey('staff_id')) {
      context.handle(
        _staffIdMeta,
        staffId.isAcceptableOrUnknown(data['staff_id']!, _staffIdMeta),
      );
    } else if (isInserting) {
      context.missing(_staffIdMeta);
    }
    if (data.containsKey('credential_revision')) {
      context.handle(
        _credentialRevisionMeta,
        credentialRevision.isAcceptableOrUnknown(
          data['credential_revision']!,
          _credentialRevisionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_credentialRevisionMeta);
    }
    if (data.containsKey('role_at_issue')) {
      context.handle(
        _roleAtIssueMeta,
        roleAtIssue.isAcceptableOrUnknown(
          data['role_at_issue']!,
          _roleAtIssueMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_roleAtIssueMeta);
    }
    if (data.containsKey('terminal_id')) {
      context.handle(
        _terminalIdMeta,
        terminalId.isAcceptableOrUnknown(data['terminal_id']!, _terminalIdMeta),
      );
    } else if (isInserting) {
      context.missing(_terminalIdMeta);
    }
    if (data.containsKey('issued_at_ms')) {
      context.handle(
        _issuedAtMsMeta,
        issuedAtMs.isAcceptableOrUnknown(
          data['issued_at_ms']!,
          _issuedAtMsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_issuedAtMsMeta);
    }
    if (data.containsKey('last_seen_ms')) {
      context.handle(
        _lastSeenMsMeta,
        lastSeenMs.isAcceptableOrUnknown(
          data['last_seen_ms']!,
          _lastSeenMsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lastSeenMsMeta);
    }
    if (data.containsKey('expires_at_ms')) {
      context.handle(
        _expiresAtMsMeta,
        expiresAtMs.isAcceptableOrUnknown(
          data['expires_at_ms']!,
          _expiresAtMsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_expiresAtMsMeta);
    }
    if (data.containsKey('revoked')) {
      context.handle(
        _revokedMeta,
        revoked.isAcceptableOrUnknown(data['revoked']!, _revokedMeta),
      );
    } else if (isInserting) {
      context.missing(_revokedMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AuthSession map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AuthSession(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      tokenHash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}token_hash'],
      )!,
      staffId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}staff_id'],
      )!,
      credentialRevision: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}credential_revision'],
      )!,
      roleAtIssue: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}role_at_issue'],
      )!,
      terminalId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}terminal_id'],
      )!,
      issuedAtMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}issued_at_ms'],
      )!,
      lastSeenMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}last_seen_ms'],
      )!,
      expiresAtMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}expires_at_ms'],
      )!,
      revoked: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}revoked'],
      )!,
    );
  }

  @override
  AuthSessions createAlias(String alias) {
    return AuthSessions(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class AuthSession extends DataClass implements Insertable<AuthSession> {
  final String id;
  final String tokenHash;
  final String staffId;
  final int credentialRevision;
  final String roleAtIssue;
  final String terminalId;
  final int issuedAtMs;
  final int lastSeenMs;
  final int expiresAtMs;
  final int revoked;
  const AuthSession({
    required this.id,
    required this.tokenHash,
    required this.staffId,
    required this.credentialRevision,
    required this.roleAtIssue,
    required this.terminalId,
    required this.issuedAtMs,
    required this.lastSeenMs,
    required this.expiresAtMs,
    required this.revoked,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['token_hash'] = Variable<String>(tokenHash);
    map['staff_id'] = Variable<String>(staffId);
    map['credential_revision'] = Variable<int>(credentialRevision);
    map['role_at_issue'] = Variable<String>(roleAtIssue);
    map['terminal_id'] = Variable<String>(terminalId);
    map['issued_at_ms'] = Variable<int>(issuedAtMs);
    map['last_seen_ms'] = Variable<int>(lastSeenMs);
    map['expires_at_ms'] = Variable<int>(expiresAtMs);
    map['revoked'] = Variable<int>(revoked);
    return map;
  }

  AuthSessionsCompanion toCompanion(bool nullToAbsent) {
    return AuthSessionsCompanion(
      id: Value(id),
      tokenHash: Value(tokenHash),
      staffId: Value(staffId),
      credentialRevision: Value(credentialRevision),
      roleAtIssue: Value(roleAtIssue),
      terminalId: Value(terminalId),
      issuedAtMs: Value(issuedAtMs),
      lastSeenMs: Value(lastSeenMs),
      expiresAtMs: Value(expiresAtMs),
      revoked: Value(revoked),
    );
  }

  factory AuthSession.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AuthSession(
      id: serializer.fromJson<String>(json['id']),
      tokenHash: serializer.fromJson<String>(json['token_hash']),
      staffId: serializer.fromJson<String>(json['staff_id']),
      credentialRevision: serializer.fromJson<int>(json['credential_revision']),
      roleAtIssue: serializer.fromJson<String>(json['role_at_issue']),
      terminalId: serializer.fromJson<String>(json['terminal_id']),
      issuedAtMs: serializer.fromJson<int>(json['issued_at_ms']),
      lastSeenMs: serializer.fromJson<int>(json['last_seen_ms']),
      expiresAtMs: serializer.fromJson<int>(json['expires_at_ms']),
      revoked: serializer.fromJson<int>(json['revoked']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'token_hash': serializer.toJson<String>(tokenHash),
      'staff_id': serializer.toJson<String>(staffId),
      'credential_revision': serializer.toJson<int>(credentialRevision),
      'role_at_issue': serializer.toJson<String>(roleAtIssue),
      'terminal_id': serializer.toJson<String>(terminalId),
      'issued_at_ms': serializer.toJson<int>(issuedAtMs),
      'last_seen_ms': serializer.toJson<int>(lastSeenMs),
      'expires_at_ms': serializer.toJson<int>(expiresAtMs),
      'revoked': serializer.toJson<int>(revoked),
    };
  }

  AuthSession copyWith({
    String? id,
    String? tokenHash,
    String? staffId,
    int? credentialRevision,
    String? roleAtIssue,
    String? terminalId,
    int? issuedAtMs,
    int? lastSeenMs,
    int? expiresAtMs,
    int? revoked,
  }) => AuthSession(
    id: id ?? this.id,
    tokenHash: tokenHash ?? this.tokenHash,
    staffId: staffId ?? this.staffId,
    credentialRevision: credentialRevision ?? this.credentialRevision,
    roleAtIssue: roleAtIssue ?? this.roleAtIssue,
    terminalId: terminalId ?? this.terminalId,
    issuedAtMs: issuedAtMs ?? this.issuedAtMs,
    lastSeenMs: lastSeenMs ?? this.lastSeenMs,
    expiresAtMs: expiresAtMs ?? this.expiresAtMs,
    revoked: revoked ?? this.revoked,
  );
  AuthSession copyWithCompanion(AuthSessionsCompanion data) {
    return AuthSession(
      id: data.id.present ? data.id.value : this.id,
      tokenHash: data.tokenHash.present ? data.tokenHash.value : this.tokenHash,
      staffId: data.staffId.present ? data.staffId.value : this.staffId,
      credentialRevision: data.credentialRevision.present
          ? data.credentialRevision.value
          : this.credentialRevision,
      roleAtIssue: data.roleAtIssue.present
          ? data.roleAtIssue.value
          : this.roleAtIssue,
      terminalId: data.terminalId.present
          ? data.terminalId.value
          : this.terminalId,
      issuedAtMs: data.issuedAtMs.present
          ? data.issuedAtMs.value
          : this.issuedAtMs,
      lastSeenMs: data.lastSeenMs.present
          ? data.lastSeenMs.value
          : this.lastSeenMs,
      expiresAtMs: data.expiresAtMs.present
          ? data.expiresAtMs.value
          : this.expiresAtMs,
      revoked: data.revoked.present ? data.revoked.value : this.revoked,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AuthSession(')
          ..write('id: $id, ')
          ..write('tokenHash: $tokenHash, ')
          ..write('staffId: $staffId, ')
          ..write('credentialRevision: $credentialRevision, ')
          ..write('roleAtIssue: $roleAtIssue, ')
          ..write('terminalId: $terminalId, ')
          ..write('issuedAtMs: $issuedAtMs, ')
          ..write('lastSeenMs: $lastSeenMs, ')
          ..write('expiresAtMs: $expiresAtMs, ')
          ..write('revoked: $revoked')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    tokenHash,
    staffId,
    credentialRevision,
    roleAtIssue,
    terminalId,
    issuedAtMs,
    lastSeenMs,
    expiresAtMs,
    revoked,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AuthSession &&
          other.id == this.id &&
          other.tokenHash == this.tokenHash &&
          other.staffId == this.staffId &&
          other.credentialRevision == this.credentialRevision &&
          other.roleAtIssue == this.roleAtIssue &&
          other.terminalId == this.terminalId &&
          other.issuedAtMs == this.issuedAtMs &&
          other.lastSeenMs == this.lastSeenMs &&
          other.expiresAtMs == this.expiresAtMs &&
          other.revoked == this.revoked);
}

class AuthSessionsCompanion extends UpdateCompanion<AuthSession> {
  final Value<String> id;
  final Value<String> tokenHash;
  final Value<String> staffId;
  final Value<int> credentialRevision;
  final Value<String> roleAtIssue;
  final Value<String> terminalId;
  final Value<int> issuedAtMs;
  final Value<int> lastSeenMs;
  final Value<int> expiresAtMs;
  final Value<int> revoked;
  final Value<int> rowid;
  const AuthSessionsCompanion({
    this.id = const Value.absent(),
    this.tokenHash = const Value.absent(),
    this.staffId = const Value.absent(),
    this.credentialRevision = const Value.absent(),
    this.roleAtIssue = const Value.absent(),
    this.terminalId = const Value.absent(),
    this.issuedAtMs = const Value.absent(),
    this.lastSeenMs = const Value.absent(),
    this.expiresAtMs = const Value.absent(),
    this.revoked = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AuthSessionsCompanion.insert({
    required String id,
    required String tokenHash,
    required String staffId,
    required int credentialRevision,
    required String roleAtIssue,
    required String terminalId,
    required int issuedAtMs,
    required int lastSeenMs,
    required int expiresAtMs,
    required int revoked,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       tokenHash = Value(tokenHash),
       staffId = Value(staffId),
       credentialRevision = Value(credentialRevision),
       roleAtIssue = Value(roleAtIssue),
       terminalId = Value(terminalId),
       issuedAtMs = Value(issuedAtMs),
       lastSeenMs = Value(lastSeenMs),
       expiresAtMs = Value(expiresAtMs),
       revoked = Value(revoked);
  static Insertable<AuthSession> custom({
    Expression<String>? id,
    Expression<String>? tokenHash,
    Expression<String>? staffId,
    Expression<int>? credentialRevision,
    Expression<String>? roleAtIssue,
    Expression<String>? terminalId,
    Expression<int>? issuedAtMs,
    Expression<int>? lastSeenMs,
    Expression<int>? expiresAtMs,
    Expression<int>? revoked,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tokenHash != null) 'token_hash': tokenHash,
      if (staffId != null) 'staff_id': staffId,
      if (credentialRevision != null) 'credential_revision': credentialRevision,
      if (roleAtIssue != null) 'role_at_issue': roleAtIssue,
      if (terminalId != null) 'terminal_id': terminalId,
      if (issuedAtMs != null) 'issued_at_ms': issuedAtMs,
      if (lastSeenMs != null) 'last_seen_ms': lastSeenMs,
      if (expiresAtMs != null) 'expires_at_ms': expiresAtMs,
      if (revoked != null) 'revoked': revoked,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AuthSessionsCompanion copyWith({
    Value<String>? id,
    Value<String>? tokenHash,
    Value<String>? staffId,
    Value<int>? credentialRevision,
    Value<String>? roleAtIssue,
    Value<String>? terminalId,
    Value<int>? issuedAtMs,
    Value<int>? lastSeenMs,
    Value<int>? expiresAtMs,
    Value<int>? revoked,
    Value<int>? rowid,
  }) {
    return AuthSessionsCompanion(
      id: id ?? this.id,
      tokenHash: tokenHash ?? this.tokenHash,
      staffId: staffId ?? this.staffId,
      credentialRevision: credentialRevision ?? this.credentialRevision,
      roleAtIssue: roleAtIssue ?? this.roleAtIssue,
      terminalId: terminalId ?? this.terminalId,
      issuedAtMs: issuedAtMs ?? this.issuedAtMs,
      lastSeenMs: lastSeenMs ?? this.lastSeenMs,
      expiresAtMs: expiresAtMs ?? this.expiresAtMs,
      revoked: revoked ?? this.revoked,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (tokenHash.present) {
      map['token_hash'] = Variable<String>(tokenHash.value);
    }
    if (staffId.present) {
      map['staff_id'] = Variable<String>(staffId.value);
    }
    if (credentialRevision.present) {
      map['credential_revision'] = Variable<int>(credentialRevision.value);
    }
    if (roleAtIssue.present) {
      map['role_at_issue'] = Variable<String>(roleAtIssue.value);
    }
    if (terminalId.present) {
      map['terminal_id'] = Variable<String>(terminalId.value);
    }
    if (issuedAtMs.present) {
      map['issued_at_ms'] = Variable<int>(issuedAtMs.value);
    }
    if (lastSeenMs.present) {
      map['last_seen_ms'] = Variable<int>(lastSeenMs.value);
    }
    if (expiresAtMs.present) {
      map['expires_at_ms'] = Variable<int>(expiresAtMs.value);
    }
    if (revoked.present) {
      map['revoked'] = Variable<int>(revoked.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AuthSessionsCompanion(')
          ..write('id: $id, ')
          ..write('tokenHash: $tokenHash, ')
          ..write('staffId: $staffId, ')
          ..write('credentialRevision: $credentialRevision, ')
          ..write('roleAtIssue: $roleAtIssue, ')
          ..write('terminalId: $terminalId, ')
          ..write('issuedAtMs: $issuedAtMs, ')
          ..write('lastSeenMs: $lastSeenMs, ')
          ..write('expiresAtMs: $expiresAtMs, ')
          ..write('revoked: $revoked, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class SecurityEvents extends Table
    with TableInfo<SecurityEvents, SecurityEvent> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  SecurityEvents(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL PRIMARY KEY',
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints:
        'NOT NULL CHECK (kind IN (\'onboarding_completed\', \'login_attempt_reserved\', \'login_failed\', \'login_succeeded\', \'session_locked\'))',
  );
  static const VerificationMeta _staffIdMeta = const VerificationMeta(
    'staffId',
  );
  late final GeneratedColumn<String> staffId = GeneratedColumn<String>(
    'staff_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'REFERENCES staff_credentials(id)',
  );
  static const VerificationMeta _sessionIdMeta = const VerificationMeta(
    'sessionId',
  );
  late final GeneratedColumn<String> sessionId = GeneratedColumn<String>(
    'session_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'REFERENCES auth_sessions(id)',
  );
  static const VerificationMeta _terminalIdMeta = const VerificationMeta(
    'terminalId',
  );
  late final GeneratedColumn<String> terminalId = GeneratedColumn<String>(
    'terminal_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _occurredAtMsMeta = const VerificationMeta(
    'occurredAtMs',
  );
  late final GeneratedColumn<int> occurredAtMs = GeneratedColumn<int>(
    'occurred_at_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (occurred_at_ms >= 0)',
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    kind,
    staffId,
    sessionId,
    terminalId,
    occurredAtMs,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'security_events';
  @override
  VerificationContext validateIntegrity(
    Insertable<SecurityEvent> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('staff_id')) {
      context.handle(
        _staffIdMeta,
        staffId.isAcceptableOrUnknown(data['staff_id']!, _staffIdMeta),
      );
    }
    if (data.containsKey('session_id')) {
      context.handle(
        _sessionIdMeta,
        sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta),
      );
    }
    if (data.containsKey('terminal_id')) {
      context.handle(
        _terminalIdMeta,
        terminalId.isAcceptableOrUnknown(data['terminal_id']!, _terminalIdMeta),
      );
    } else if (isInserting) {
      context.missing(_terminalIdMeta);
    }
    if (data.containsKey('occurred_at_ms')) {
      context.handle(
        _occurredAtMsMeta,
        occurredAtMs.isAcceptableOrUnknown(
          data['occurred_at_ms']!,
          _occurredAtMsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_occurredAtMsMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SecurityEvent map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SecurityEvent(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      staffId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}staff_id'],
      ),
      sessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}session_id'],
      ),
      terminalId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}terminal_id'],
      )!,
      occurredAtMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}occurred_at_ms'],
      )!,
    );
  }

  @override
  SecurityEvents createAlias(String alias) {
    return SecurityEvents(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class SecurityEvent extends DataClass implements Insertable<SecurityEvent> {
  final String id;
  final String kind;
  final String? staffId;
  final String? sessionId;
  final String terminalId;
  final int occurredAtMs;
  const SecurityEvent({
    required this.id,
    required this.kind,
    this.staffId,
    this.sessionId,
    required this.terminalId,
    required this.occurredAtMs,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['kind'] = Variable<String>(kind);
    if (!nullToAbsent || staffId != null) {
      map['staff_id'] = Variable<String>(staffId);
    }
    if (!nullToAbsent || sessionId != null) {
      map['session_id'] = Variable<String>(sessionId);
    }
    map['terminal_id'] = Variable<String>(terminalId);
    map['occurred_at_ms'] = Variable<int>(occurredAtMs);
    return map;
  }

  SecurityEventsCompanion toCompanion(bool nullToAbsent) {
    return SecurityEventsCompanion(
      id: Value(id),
      kind: Value(kind),
      staffId: staffId == null && nullToAbsent
          ? const Value.absent()
          : Value(staffId),
      sessionId: sessionId == null && nullToAbsent
          ? const Value.absent()
          : Value(sessionId),
      terminalId: Value(terminalId),
      occurredAtMs: Value(occurredAtMs),
    );
  }

  factory SecurityEvent.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SecurityEvent(
      id: serializer.fromJson<String>(json['id']),
      kind: serializer.fromJson<String>(json['kind']),
      staffId: serializer.fromJson<String?>(json['staff_id']),
      sessionId: serializer.fromJson<String?>(json['session_id']),
      terminalId: serializer.fromJson<String>(json['terminal_id']),
      occurredAtMs: serializer.fromJson<int>(json['occurred_at_ms']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'kind': serializer.toJson<String>(kind),
      'staff_id': serializer.toJson<String?>(staffId),
      'session_id': serializer.toJson<String?>(sessionId),
      'terminal_id': serializer.toJson<String>(terminalId),
      'occurred_at_ms': serializer.toJson<int>(occurredAtMs),
    };
  }

  SecurityEvent copyWith({
    String? id,
    String? kind,
    Value<String?> staffId = const Value.absent(),
    Value<String?> sessionId = const Value.absent(),
    String? terminalId,
    int? occurredAtMs,
  }) => SecurityEvent(
    id: id ?? this.id,
    kind: kind ?? this.kind,
    staffId: staffId.present ? staffId.value : this.staffId,
    sessionId: sessionId.present ? sessionId.value : this.sessionId,
    terminalId: terminalId ?? this.terminalId,
    occurredAtMs: occurredAtMs ?? this.occurredAtMs,
  );
  SecurityEvent copyWithCompanion(SecurityEventsCompanion data) {
    return SecurityEvent(
      id: data.id.present ? data.id.value : this.id,
      kind: data.kind.present ? data.kind.value : this.kind,
      staffId: data.staffId.present ? data.staffId.value : this.staffId,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      terminalId: data.terminalId.present
          ? data.terminalId.value
          : this.terminalId,
      occurredAtMs: data.occurredAtMs.present
          ? data.occurredAtMs.value
          : this.occurredAtMs,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SecurityEvent(')
          ..write('id: $id, ')
          ..write('kind: $kind, ')
          ..write('staffId: $staffId, ')
          ..write('sessionId: $sessionId, ')
          ..write('terminalId: $terminalId, ')
          ..write('occurredAtMs: $occurredAtMs')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, kind, staffId, sessionId, terminalId, occurredAtMs);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SecurityEvent &&
          other.id == this.id &&
          other.kind == this.kind &&
          other.staffId == this.staffId &&
          other.sessionId == this.sessionId &&
          other.terminalId == this.terminalId &&
          other.occurredAtMs == this.occurredAtMs);
}

class SecurityEventsCompanion extends UpdateCompanion<SecurityEvent> {
  final Value<String> id;
  final Value<String> kind;
  final Value<String?> staffId;
  final Value<String?> sessionId;
  final Value<String> terminalId;
  final Value<int> occurredAtMs;
  final Value<int> rowid;
  const SecurityEventsCompanion({
    this.id = const Value.absent(),
    this.kind = const Value.absent(),
    this.staffId = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.terminalId = const Value.absent(),
    this.occurredAtMs = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SecurityEventsCompanion.insert({
    required String id,
    required String kind,
    this.staffId = const Value.absent(),
    this.sessionId = const Value.absent(),
    required String terminalId,
    required int occurredAtMs,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       kind = Value(kind),
       terminalId = Value(terminalId),
       occurredAtMs = Value(occurredAtMs);
  static Insertable<SecurityEvent> custom({
    Expression<String>? id,
    Expression<String>? kind,
    Expression<String>? staffId,
    Expression<String>? sessionId,
    Expression<String>? terminalId,
    Expression<int>? occurredAtMs,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (kind != null) 'kind': kind,
      if (staffId != null) 'staff_id': staffId,
      if (sessionId != null) 'session_id': sessionId,
      if (terminalId != null) 'terminal_id': terminalId,
      if (occurredAtMs != null) 'occurred_at_ms': occurredAtMs,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SecurityEventsCompanion copyWith({
    Value<String>? id,
    Value<String>? kind,
    Value<String?>? staffId,
    Value<String?>? sessionId,
    Value<String>? terminalId,
    Value<int>? occurredAtMs,
    Value<int>? rowid,
  }) {
    return SecurityEventsCompanion(
      id: id ?? this.id,
      kind: kind ?? this.kind,
      staffId: staffId ?? this.staffId,
      sessionId: sessionId ?? this.sessionId,
      terminalId: terminalId ?? this.terminalId,
      occurredAtMs: occurredAtMs ?? this.occurredAtMs,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (staffId.present) {
      map['staff_id'] = Variable<String>(staffId.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<String>(sessionId.value);
    }
    if (terminalId.present) {
      map['terminal_id'] = Variable<String>(terminalId.value);
    }
    if (occurredAtMs.present) {
      map['occurred_at_ms'] = Variable<int>(occurredAtMs.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SecurityEventsCompanion(')
          ..write('id: $id, ')
          ..write('kind: $kind, ')
          ..write('staffId: $staffId, ')
          ..write('sessionId: $sessionId, ')
          ..write('terminalId: $terminalId, ')
          ..write('occurredAtMs: $occurredAtMs, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$PosDatabase extends GeneratedDatabase {
  _$PosDatabase(QueryExecutor e) : super(e);
  $PosDatabaseManager get managers => $PosDatabaseManager(this);
  late final DatabaseMetadata databaseMetadata = DatabaseMetadata(this);
  late final SchemaUpgrades schemaUpgrades = SchemaUpgrades(this);
  late final IdempotencyCommands idempotencyCommands = IdempotencyCommands(
    this,
  );
  late final CommandVersions commandVersions = CommandVersions(this);
  late final AuditEvents auditEvents = AuditEvents(this);
  late final Trigger auditEventsNoUpdate = Trigger(
    'CREATE TRIGGER audit_events_no_update BEFORE UPDATE ON audit_events BEGIN SELECT RAISE (ABORT, \'Audit events are immutable\');END',
    'audit_events_no_update',
  );
  late final Trigger auditEventsNoDelete = Trigger(
    'CREATE TRIGGER audit_events_no_delete BEFORE DELETE ON audit_events BEGIN SELECT RAISE (ABORT, \'Audit events are immutable\');END',
    'audit_events_no_delete',
  );
  late final Trigger commandsNoUpdate = Trigger(
    'CREATE TRIGGER commands_no_update BEFORE UPDATE ON idempotency_commands BEGIN SELECT RAISE (ABORT, \'Command results are immutable\');END',
    'commands_no_update',
  );
  late final Trigger commandsNoDelete = Trigger(
    'CREATE TRIGGER commands_no_delete BEFORE DELETE ON idempotency_commands BEGIN SELECT RAISE (ABORT, \'Command results are immutable\');END',
    'commands_no_delete',
  );
  late final Trigger commandsNoReplace = Trigger(
    'CREATE TRIGGER commands_no_replace BEFORE INSERT ON idempotency_commands WHEN EXISTS (SELECT 1 FROM idempotency_commands WHERE intent_key = NEW.intent_key) BEGIN SELECT RAISE (ABORT, \'Command results cannot be replaced\');END',
    'commands_no_replace',
  );
  late final Trigger auditEventsNoReplace = Trigger(
    'CREATE TRIGGER audit_events_no_replace BEFORE INSERT ON audit_events WHEN EXISTS (SELECT 1 FROM audit_events WHERE id = NEW.id OR command_id = NEW.command_id) BEGIN SELECT RAISE (ABORT, \'Audit events cannot be replaced\');END',
    'audit_events_no_replace',
  );
  late final StaffCredentials staffCredentials = StaffCredentials(this);
  late final Index activePinFingerprints = Index(
    'active_pin_fingerprints',
    'CREATE UNIQUE INDEX active_pin_fingerprints ON staff_credentials (pin_fingerprint) WHERE enabled = 1',
  );
  late final InstallationSecurity installationSecurity = InstallationSecurity(
    this,
  );
  late final AuthAttemptLimits authAttemptLimits = AuthAttemptLimits(this);
  late final AuthSessions authSessions = AuthSessions(this);
  late final SecurityEvents securityEvents = SecurityEvents(this);
  late final Trigger securityEventsNoUpdate = Trigger(
    'CREATE TRIGGER security_events_no_update BEFORE UPDATE ON security_events BEGIN SELECT RAISE (ABORT, \'Security history is immutable\');END',
    'security_events_no_update',
  );
  late final Trigger securityEventsNoDelete = Trigger(
    'CREATE TRIGGER security_events_no_delete BEFORE DELETE ON security_events BEGIN SELECT RAISE (ABORT, \'Security history is immutable\');END',
    'security_events_no_delete',
  );
  late final Trigger securityEventsNoReplace = Trigger(
    'CREATE TRIGGER security_events_no_replace BEFORE INSERT ON security_events WHEN EXISTS (SELECT 1 FROM security_events WHERE id = NEW.id) BEGIN SELECT RAISE (ABORT, \'Security history cannot be replaced\');END',
    'security_events_no_replace',
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    databaseMetadata,
    schemaUpgrades,
    idempotencyCommands,
    commandVersions,
    auditEvents,
    auditEventsNoUpdate,
    auditEventsNoDelete,
    commandsNoUpdate,
    commandsNoDelete,
    commandsNoReplace,
    auditEventsNoReplace,
    staffCredentials,
    activePinFingerprints,
    installationSecurity,
    authAttemptLimits,
    authSessions,
    securityEvents,
    securityEventsNoUpdate,
    securityEventsNoDelete,
    securityEventsNoReplace,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'audit_events',
        limitUpdateKind: UpdateKind.update,
      ),
      result: [],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'audit_events',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'idempotency_commands',
        limitUpdateKind: UpdateKind.update,
      ),
      result: [],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'idempotency_commands',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'idempotency_commands',
        limitUpdateKind: UpdateKind.insert,
      ),
      result: [],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'audit_events',
        limitUpdateKind: UpdateKind.insert,
      ),
      result: [],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'security_events',
        limitUpdateKind: UpdateKind.update,
      ),
      result: [],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'security_events',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'security_events',
        limitUpdateKind: UpdateKind.insert,
      ),
      result: [],
    ),
  ]);
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
typedef $IdempotencyCommandsCreateCompanionBuilder =
    IdempotencyCommandsCompanion Function({
      required String intentKey,
      required String kind,
      required String requestHash,
      required String resultJson,
      required String createdAtUtc,
      Value<int> rowid,
    });
typedef $IdempotencyCommandsUpdateCompanionBuilder =
    IdempotencyCommandsCompanion Function({
      Value<String> intentKey,
      Value<String> kind,
      Value<String> requestHash,
      Value<String> resultJson,
      Value<String> createdAtUtc,
      Value<int> rowid,
    });

final class $IdempotencyCommandsReferences
    extends
        BaseReferences<_$PosDatabase, IdempotencyCommands, IdempotencyCommand> {
  $IdempotencyCommandsReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<AuditEvents, List<AuditEvent>>
  _auditEventsRefsTable(_$PosDatabase db) => MultiTypedResultKey.fromTable(
    db.auditEvents,
    aliasName: 'idempotency_commands__intent_key__audit_events__command_id',
  );

  $AuditEventsProcessedTableManager get auditEventsRefs {
    final manager = $AuditEventsTableManager($_db, $_db.auditEvents).filter(
      (f) =>
          f.commandId.intentKey.sqlEquals($_itemColumn<String>('intent_key')!),
    );

    final cache = $_typedResult.readTableOrNull(_auditEventsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $IdempotencyCommandsFilterComposer
    extends Composer<_$PosDatabase, IdempotencyCommands> {
  $IdempotencyCommandsFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get intentKey => $composableBuilder(
    column: $table.intentKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get requestHash => $composableBuilder(
    column: $table.requestHash,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get resultJson => $composableBuilder(
    column: $table.resultJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdAtUtc => $composableBuilder(
    column: $table.createdAtUtc,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> auditEventsRefs(
    Expression<bool> Function($AuditEventsFilterComposer f) f,
  ) {
    final $AuditEventsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.intentKey,
      referencedTable: $db.auditEvents,
      getReferencedColumn: (t) => t.commandId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $AuditEventsFilterComposer(
            $db: $db,
            $table: $db.auditEvents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $IdempotencyCommandsOrderingComposer
    extends Composer<_$PosDatabase, IdempotencyCommands> {
  $IdempotencyCommandsOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get intentKey => $composableBuilder(
    column: $table.intentKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get requestHash => $composableBuilder(
    column: $table.requestHash,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get resultJson => $composableBuilder(
    column: $table.resultJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdAtUtc => $composableBuilder(
    column: $table.createdAtUtc,
    builder: (column) => ColumnOrderings(column),
  );
}

class $IdempotencyCommandsAnnotationComposer
    extends Composer<_$PosDatabase, IdempotencyCommands> {
  $IdempotencyCommandsAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get intentKey =>
      $composableBuilder(column: $table.intentKey, builder: (column) => column);

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get requestHash => $composableBuilder(
    column: $table.requestHash,
    builder: (column) => column,
  );

  GeneratedColumn<String> get resultJson => $composableBuilder(
    column: $table.resultJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get createdAtUtc => $composableBuilder(
    column: $table.createdAtUtc,
    builder: (column) => column,
  );

  Expression<T> auditEventsRefs<T extends Object>(
    Expression<T> Function($AuditEventsAnnotationComposer a) f,
  ) {
    final $AuditEventsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.intentKey,
      referencedTable: $db.auditEvents,
      getReferencedColumn: (t) => t.commandId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $AuditEventsAnnotationComposer(
            $db: $db,
            $table: $db.auditEvents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $IdempotencyCommandsTableManager
    extends
        RootTableManager<
          _$PosDatabase,
          IdempotencyCommands,
          IdempotencyCommand,
          $IdempotencyCommandsFilterComposer,
          $IdempotencyCommandsOrderingComposer,
          $IdempotencyCommandsAnnotationComposer,
          $IdempotencyCommandsCreateCompanionBuilder,
          $IdempotencyCommandsUpdateCompanionBuilder,
          (IdempotencyCommand, $IdempotencyCommandsReferences),
          IdempotencyCommand,
          PrefetchHooks Function({bool auditEventsRefs})
        > {
  $IdempotencyCommandsTableManager(_$PosDatabase db, IdempotencyCommands table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $IdempotencyCommandsFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $IdempotencyCommandsOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $IdempotencyCommandsAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> intentKey = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<String> requestHash = const Value.absent(),
                Value<String> resultJson = const Value.absent(),
                Value<String> createdAtUtc = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => IdempotencyCommandsCompanion(
                intentKey: intentKey,
                kind: kind,
                requestHash: requestHash,
                resultJson: resultJson,
                createdAtUtc: createdAtUtc,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String intentKey,
                required String kind,
                required String requestHash,
                required String resultJson,
                required String createdAtUtc,
                Value<int> rowid = const Value.absent(),
              }) => IdempotencyCommandsCompanion.insert(
                intentKey: intentKey,
                kind: kind,
                requestHash: requestHash,
                resultJson: resultJson,
                createdAtUtc: createdAtUtc,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<IdempotencyCommands, IdempotencyCommand>(table),
                  $IdempotencyCommandsReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({auditEventsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (auditEventsRefs) db.auditEvents],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (auditEventsRefs)
                    await $_getPrefetchedData<
                      IdempotencyCommand,
                      IdempotencyCommands,
                      AuditEvent
                    >(
                      currentTable: table,
                      referencedTable: $IdempotencyCommandsReferences
                          ._auditEventsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $IdempotencyCommandsReferences(
                            db,
                            table,
                            p0,
                          ).auditEventsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.commandId == item.intentKey,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $IdempotencyCommandsProcessedTableManager =
    ProcessedTableManager<
      _$PosDatabase,
      IdempotencyCommands,
      IdempotencyCommand,
      $IdempotencyCommandsFilterComposer,
      $IdempotencyCommandsOrderingComposer,
      $IdempotencyCommandsAnnotationComposer,
      $IdempotencyCommandsCreateCompanionBuilder,
      $IdempotencyCommandsUpdateCompanionBuilder,
      (IdempotencyCommand, $IdempotencyCommandsReferences),
      IdempotencyCommand,
      PrefetchHooks Function({bool auditEventsRefs})
    >;
typedef $CommandVersionsCreateCompanionBuilder =
    CommandVersionsCompanion Function({
      required String entityType,
      required String entityId,
      required int revision,
      Value<int> rowid,
    });
typedef $CommandVersionsUpdateCompanionBuilder =
    CommandVersionsCompanion Function({
      Value<String> entityType,
      Value<String> entityId,
      Value<int> revision,
      Value<int> rowid,
    });

class $CommandVersionsFilterComposer
    extends Composer<_$PosDatabase, CommandVersions> {
  $CommandVersionsFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get revision => $composableBuilder(
    column: $table.revision,
    builder: (column) => ColumnFilters(column),
  );
}

class $CommandVersionsOrderingComposer
    extends Composer<_$PosDatabase, CommandVersions> {
  $CommandVersionsOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get revision => $composableBuilder(
    column: $table.revision,
    builder: (column) => ColumnOrderings(column),
  );
}

class $CommandVersionsAnnotationComposer
    extends Composer<_$PosDatabase, CommandVersions> {
  $CommandVersionsAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => column);

  GeneratedColumn<int> get revision =>
      $composableBuilder(column: $table.revision, builder: (column) => column);
}

class $CommandVersionsTableManager
    extends
        RootTableManager<
          _$PosDatabase,
          CommandVersions,
          CommandVersion,
          $CommandVersionsFilterComposer,
          $CommandVersionsOrderingComposer,
          $CommandVersionsAnnotationComposer,
          $CommandVersionsCreateCompanionBuilder,
          $CommandVersionsUpdateCompanionBuilder,
          (
            CommandVersion,
            BaseReferences<_$PosDatabase, CommandVersions, CommandVersion>,
          ),
          CommandVersion,
          PrefetchHooks Function()
        > {
  $CommandVersionsTableManager(_$PosDatabase db, CommandVersions table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $CommandVersionsFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $CommandVersionsOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $CommandVersionsAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> entityType = const Value.absent(),
                Value<String> entityId = const Value.absent(),
                Value<int> revision = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CommandVersionsCompanion(
                entityType: entityType,
                entityId: entityId,
                revision: revision,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String entityType,
                required String entityId,
                required int revision,
                Value<int> rowid = const Value.absent(),
              }) => CommandVersionsCompanion.insert(
                entityType: entityType,
                entityId: entityId,
                revision: revision,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<CommandVersions, CommandVersion>(table),
                  BaseReferences<
                    _$PosDatabase,
                    CommandVersions,
                    CommandVersion
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $CommandVersionsProcessedTableManager =
    ProcessedTableManager<
      _$PosDatabase,
      CommandVersions,
      CommandVersion,
      $CommandVersionsFilterComposer,
      $CommandVersionsOrderingComposer,
      $CommandVersionsAnnotationComposer,
      $CommandVersionsCreateCompanionBuilder,
      $CommandVersionsUpdateCompanionBuilder,
      (
        CommandVersion,
        BaseReferences<_$PosDatabase, CommandVersions, CommandVersion>,
      ),
      CommandVersion,
      PrefetchHooks Function()
    >;
typedef $AuditEventsCreateCompanionBuilder =
    AuditEventsCompanion Function({
      required String id,
      required String commandId,
      required String entityType,
      required String entityId,
      required String eventType,
      required String actorId,
      required String sessionId,
      Value<String?> approverId,
      Value<String?> businessDayId,
      required String terminalId,
      required String appVersion,
      required String reason,
      required String beforeJson,
      required String afterJson,
      required String createdAtUtc,
      Value<int> rowid,
    });
typedef $AuditEventsUpdateCompanionBuilder =
    AuditEventsCompanion Function({
      Value<String> id,
      Value<String> commandId,
      Value<String> entityType,
      Value<String> entityId,
      Value<String> eventType,
      Value<String> actorId,
      Value<String> sessionId,
      Value<String?> approverId,
      Value<String?> businessDayId,
      Value<String> terminalId,
      Value<String> appVersion,
      Value<String> reason,
      Value<String> beforeJson,
      Value<String> afterJson,
      Value<String> createdAtUtc,
      Value<int> rowid,
    });

final class $AuditEventsReferences
    extends BaseReferences<_$PosDatabase, AuditEvents, AuditEvent> {
  $AuditEventsReferences(super.$_db, super.$_table, super.$_typedResult);

  static IdempotencyCommands _commandIdTable(_$PosDatabase db) =>
      db.idempotencyCommands.createAlias(
        'audit_events__command_id__idempotency_commands__intent_key',
      );

  $IdempotencyCommandsProcessedTableManager get commandId {
    final $_column = $_itemColumn<String>('command_id')!;

    final manager = $IdempotencyCommandsTableManager(
      $_db,
      $_db.idempotencyCommands,
    ).filter((f) => f.intentKey.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_commandIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $AuditEventsFilterComposer extends Composer<_$PosDatabase, AuditEvents> {
  $AuditEventsFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get eventType => $composableBuilder(
    column: $table.eventType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get actorId => $composableBuilder(
    column: $table.actorId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sessionId => $composableBuilder(
    column: $table.sessionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get approverId => $composableBuilder(
    column: $table.approverId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get businessDayId => $composableBuilder(
    column: $table.businessDayId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get terminalId => $composableBuilder(
    column: $table.terminalId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get appVersion => $composableBuilder(
    column: $table.appVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reason => $composableBuilder(
    column: $table.reason,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get beforeJson => $composableBuilder(
    column: $table.beforeJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get afterJson => $composableBuilder(
    column: $table.afterJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdAtUtc => $composableBuilder(
    column: $table.createdAtUtc,
    builder: (column) => ColumnFilters(column),
  );

  $IdempotencyCommandsFilterComposer get commandId {
    final $IdempotencyCommandsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.commandId,
      referencedTable: $db.idempotencyCommands,
      getReferencedColumn: (t) => t.intentKey,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $IdempotencyCommandsFilterComposer(
            $db: $db,
            $table: $db.idempotencyCommands,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $AuditEventsOrderingComposer
    extends Composer<_$PosDatabase, AuditEvents> {
  $AuditEventsOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get eventType => $composableBuilder(
    column: $table.eventType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get actorId => $composableBuilder(
    column: $table.actorId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sessionId => $composableBuilder(
    column: $table.sessionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get approverId => $composableBuilder(
    column: $table.approverId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get businessDayId => $composableBuilder(
    column: $table.businessDayId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get terminalId => $composableBuilder(
    column: $table.terminalId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get appVersion => $composableBuilder(
    column: $table.appVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reason => $composableBuilder(
    column: $table.reason,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get beforeJson => $composableBuilder(
    column: $table.beforeJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get afterJson => $composableBuilder(
    column: $table.afterJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdAtUtc => $composableBuilder(
    column: $table.createdAtUtc,
    builder: (column) => ColumnOrderings(column),
  );

  $IdempotencyCommandsOrderingComposer get commandId {
    final $IdempotencyCommandsOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.commandId,
      referencedTable: $db.idempotencyCommands,
      getReferencedColumn: (t) => t.intentKey,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $IdempotencyCommandsOrderingComposer(
            $db: $db,
            $table: $db.idempotencyCommands,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $AuditEventsAnnotationComposer
    extends Composer<_$PosDatabase, AuditEvents> {
  $AuditEventsAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => column);

  GeneratedColumn<String> get eventType =>
      $composableBuilder(column: $table.eventType, builder: (column) => column);

  GeneratedColumn<String> get actorId =>
      $composableBuilder(column: $table.actorId, builder: (column) => column);

  GeneratedColumn<String> get sessionId =>
      $composableBuilder(column: $table.sessionId, builder: (column) => column);

  GeneratedColumn<String> get approverId => $composableBuilder(
    column: $table.approverId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get businessDayId => $composableBuilder(
    column: $table.businessDayId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get terminalId => $composableBuilder(
    column: $table.terminalId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get appVersion => $composableBuilder(
    column: $table.appVersion,
    builder: (column) => column,
  );

  GeneratedColumn<String> get reason =>
      $composableBuilder(column: $table.reason, builder: (column) => column);

  GeneratedColumn<String> get beforeJson => $composableBuilder(
    column: $table.beforeJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get afterJson =>
      $composableBuilder(column: $table.afterJson, builder: (column) => column);

  GeneratedColumn<String> get createdAtUtc => $composableBuilder(
    column: $table.createdAtUtc,
    builder: (column) => column,
  );

  $IdempotencyCommandsAnnotationComposer get commandId {
    final $IdempotencyCommandsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.commandId,
      referencedTable: $db.idempotencyCommands,
      getReferencedColumn: (t) => t.intentKey,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $IdempotencyCommandsAnnotationComposer(
            $db: $db,
            $table: $db.idempotencyCommands,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $AuditEventsTableManager
    extends
        RootTableManager<
          _$PosDatabase,
          AuditEvents,
          AuditEvent,
          $AuditEventsFilterComposer,
          $AuditEventsOrderingComposer,
          $AuditEventsAnnotationComposer,
          $AuditEventsCreateCompanionBuilder,
          $AuditEventsUpdateCompanionBuilder,
          (AuditEvent, $AuditEventsReferences),
          AuditEvent,
          PrefetchHooks Function({bool commandId})
        > {
  $AuditEventsTableManager(_$PosDatabase db, AuditEvents table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $AuditEventsFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $AuditEventsOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $AuditEventsAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> commandId = const Value.absent(),
                Value<String> entityType = const Value.absent(),
                Value<String> entityId = const Value.absent(),
                Value<String> eventType = const Value.absent(),
                Value<String> actorId = const Value.absent(),
                Value<String> sessionId = const Value.absent(),
                Value<String?> approverId = const Value.absent(),
                Value<String?> businessDayId = const Value.absent(),
                Value<String> terminalId = const Value.absent(),
                Value<String> appVersion = const Value.absent(),
                Value<String> reason = const Value.absent(),
                Value<String> beforeJson = const Value.absent(),
                Value<String> afterJson = const Value.absent(),
                Value<String> createdAtUtc = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AuditEventsCompanion(
                id: id,
                commandId: commandId,
                entityType: entityType,
                entityId: entityId,
                eventType: eventType,
                actorId: actorId,
                sessionId: sessionId,
                approverId: approverId,
                businessDayId: businessDayId,
                terminalId: terminalId,
                appVersion: appVersion,
                reason: reason,
                beforeJson: beforeJson,
                afterJson: afterJson,
                createdAtUtc: createdAtUtc,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String commandId,
                required String entityType,
                required String entityId,
                required String eventType,
                required String actorId,
                required String sessionId,
                Value<String?> approverId = const Value.absent(),
                Value<String?> businessDayId = const Value.absent(),
                required String terminalId,
                required String appVersion,
                required String reason,
                required String beforeJson,
                required String afterJson,
                required String createdAtUtc,
                Value<int> rowid = const Value.absent(),
              }) => AuditEventsCompanion.insert(
                id: id,
                commandId: commandId,
                entityType: entityType,
                entityId: entityId,
                eventType: eventType,
                actorId: actorId,
                sessionId: sessionId,
                approverId: approverId,
                businessDayId: businessDayId,
                terminalId: terminalId,
                appVersion: appVersion,
                reason: reason,
                beforeJson: beforeJson,
                afterJson: afterJson,
                createdAtUtc: createdAtUtc,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<AuditEvents, AuditEvent>(table),
                  $AuditEventsReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({commandId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (commandId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.commandId,
                                referencedTable: $AuditEventsReferences
                                    ._commandIdTable(db),
                                referencedColumn: $AuditEventsReferences
                                    ._commandIdTable(db)
                                    .intentKey,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $AuditEventsProcessedTableManager =
    ProcessedTableManager<
      _$PosDatabase,
      AuditEvents,
      AuditEvent,
      $AuditEventsFilterComposer,
      $AuditEventsOrderingComposer,
      $AuditEventsAnnotationComposer,
      $AuditEventsCreateCompanionBuilder,
      $AuditEventsUpdateCompanionBuilder,
      (AuditEvent, $AuditEventsReferences),
      AuditEvent,
      PrefetchHooks Function({bool commandId})
    >;
typedef $StaffCredentialsCreateCompanionBuilder =
    StaffCredentialsCompanion Function({
      required String id,
      required String displayName,
      required String role,
      required int enabled,
      required int revision,
      required String pinFingerprint,
      required String saltBase64,
      required String hashBase64,
      required int verifierVersion,
      Value<int> rowid,
    });
typedef $StaffCredentialsUpdateCompanionBuilder =
    StaffCredentialsCompanion Function({
      Value<String> id,
      Value<String> displayName,
      Value<String> role,
      Value<int> enabled,
      Value<int> revision,
      Value<String> pinFingerprint,
      Value<String> saltBase64,
      Value<String> hashBase64,
      Value<int> verifierVersion,
      Value<int> rowid,
    });

final class $StaffCredentialsReferences
    extends BaseReferences<_$PosDatabase, StaffCredentials, StaffCredential> {
  $StaffCredentialsReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<AuthSessions, List<AuthSession>>
  _authSessionsRefsTable(_$PosDatabase db) => MultiTypedResultKey.fromTable(
    db.authSessions,
    aliasName: 'staff_credentials__id__auth_sessions__staff_id',
  );

  $AuthSessionsProcessedTableManager get authSessionsRefs {
    final manager = $AuthSessionsTableManager(
      $_db,
      $_db.authSessions,
    ).filter((f) => f.staffId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_authSessionsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<SecurityEvents, List<SecurityEvent>>
  _securityEventsRefsTable(_$PosDatabase db) => MultiTypedResultKey.fromTable(
    db.securityEvents,
    aliasName: 'staff_credentials__id__security_events__staff_id',
  );

  $SecurityEventsProcessedTableManager get securityEventsRefs {
    final manager = $SecurityEventsTableManager(
      $_db,
      $_db.securityEvents,
    ).filter((f) => f.staffId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_securityEventsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $StaffCredentialsFilterComposer
    extends Composer<_$PosDatabase, StaffCredentials> {
  $StaffCredentialsFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get revision => $composableBuilder(
    column: $table.revision,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pinFingerprint => $composableBuilder(
    column: $table.pinFingerprint,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get saltBase64 => $composableBuilder(
    column: $table.saltBase64,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get hashBase64 => $composableBuilder(
    column: $table.hashBase64,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get verifierVersion => $composableBuilder(
    column: $table.verifierVersion,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> authSessionsRefs(
    Expression<bool> Function($AuthSessionsFilterComposer f) f,
  ) {
    final $AuthSessionsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.authSessions,
      getReferencedColumn: (t) => t.staffId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $AuthSessionsFilterComposer(
            $db: $db,
            $table: $db.authSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> securityEventsRefs(
    Expression<bool> Function($SecurityEventsFilterComposer f) f,
  ) {
    final $SecurityEventsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.securityEvents,
      getReferencedColumn: (t) => t.staffId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $SecurityEventsFilterComposer(
            $db: $db,
            $table: $db.securityEvents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $StaffCredentialsOrderingComposer
    extends Composer<_$PosDatabase, StaffCredentials> {
  $StaffCredentialsOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get revision => $composableBuilder(
    column: $table.revision,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pinFingerprint => $composableBuilder(
    column: $table.pinFingerprint,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get saltBase64 => $composableBuilder(
    column: $table.saltBase64,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get hashBase64 => $composableBuilder(
    column: $table.hashBase64,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get verifierVersion => $composableBuilder(
    column: $table.verifierVersion,
    builder: (column) => ColumnOrderings(column),
  );
}

class $StaffCredentialsAnnotationComposer
    extends Composer<_$PosDatabase, StaffCredentials> {
  $StaffCredentialsAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<int> get enabled =>
      $composableBuilder(column: $table.enabled, builder: (column) => column);

  GeneratedColumn<int> get revision =>
      $composableBuilder(column: $table.revision, builder: (column) => column);

  GeneratedColumn<String> get pinFingerprint => $composableBuilder(
    column: $table.pinFingerprint,
    builder: (column) => column,
  );

  GeneratedColumn<String> get saltBase64 => $composableBuilder(
    column: $table.saltBase64,
    builder: (column) => column,
  );

  GeneratedColumn<String> get hashBase64 => $composableBuilder(
    column: $table.hashBase64,
    builder: (column) => column,
  );

  GeneratedColumn<int> get verifierVersion => $composableBuilder(
    column: $table.verifierVersion,
    builder: (column) => column,
  );

  Expression<T> authSessionsRefs<T extends Object>(
    Expression<T> Function($AuthSessionsAnnotationComposer a) f,
  ) {
    final $AuthSessionsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.authSessions,
      getReferencedColumn: (t) => t.staffId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $AuthSessionsAnnotationComposer(
            $db: $db,
            $table: $db.authSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> securityEventsRefs<T extends Object>(
    Expression<T> Function($SecurityEventsAnnotationComposer a) f,
  ) {
    final $SecurityEventsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.securityEvents,
      getReferencedColumn: (t) => t.staffId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $SecurityEventsAnnotationComposer(
            $db: $db,
            $table: $db.securityEvents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $StaffCredentialsTableManager
    extends
        RootTableManager<
          _$PosDatabase,
          StaffCredentials,
          StaffCredential,
          $StaffCredentialsFilterComposer,
          $StaffCredentialsOrderingComposer,
          $StaffCredentialsAnnotationComposer,
          $StaffCredentialsCreateCompanionBuilder,
          $StaffCredentialsUpdateCompanionBuilder,
          (StaffCredential, $StaffCredentialsReferences),
          StaffCredential,
          PrefetchHooks Function({
            bool authSessionsRefs,
            bool securityEventsRefs,
          })
        > {
  $StaffCredentialsTableManager(_$PosDatabase db, StaffCredentials table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $StaffCredentialsFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $StaffCredentialsOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $StaffCredentialsAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> displayName = const Value.absent(),
                Value<String> role = const Value.absent(),
                Value<int> enabled = const Value.absent(),
                Value<int> revision = const Value.absent(),
                Value<String> pinFingerprint = const Value.absent(),
                Value<String> saltBase64 = const Value.absent(),
                Value<String> hashBase64 = const Value.absent(),
                Value<int> verifierVersion = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StaffCredentialsCompanion(
                id: id,
                displayName: displayName,
                role: role,
                enabled: enabled,
                revision: revision,
                pinFingerprint: pinFingerprint,
                saltBase64: saltBase64,
                hashBase64: hashBase64,
                verifierVersion: verifierVersion,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String displayName,
                required String role,
                required int enabled,
                required int revision,
                required String pinFingerprint,
                required String saltBase64,
                required String hashBase64,
                required int verifierVersion,
                Value<int> rowid = const Value.absent(),
              }) => StaffCredentialsCompanion.insert(
                id: id,
                displayName: displayName,
                role: role,
                enabled: enabled,
                revision: revision,
                pinFingerprint: pinFingerprint,
                saltBase64: saltBase64,
                hashBase64: hashBase64,
                verifierVersion: verifierVersion,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<StaffCredentials, StaffCredential>(table),
                  $StaffCredentialsReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({authSessionsRefs = false, securityEventsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (authSessionsRefs) db.authSessions,
                    if (securityEventsRefs) db.securityEvents,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (authSessionsRefs)
                        await $_getPrefetchedData<
                          StaffCredential,
                          StaffCredentials,
                          AuthSession
                        >(
                          currentTable: table,
                          referencedTable: $StaffCredentialsReferences
                              ._authSessionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $StaffCredentialsReferences(
                                db,
                                table,
                                p0,
                              ).authSessionsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.staffId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (securityEventsRefs)
                        await $_getPrefetchedData<
                          StaffCredential,
                          StaffCredentials,
                          SecurityEvent
                        >(
                          currentTable: table,
                          referencedTable: $StaffCredentialsReferences
                              ._securityEventsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $StaffCredentialsReferences(
                                db,
                                table,
                                p0,
                              ).securityEventsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.staffId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $StaffCredentialsProcessedTableManager =
    ProcessedTableManager<
      _$PosDatabase,
      StaffCredentials,
      StaffCredential,
      $StaffCredentialsFilterComposer,
      $StaffCredentialsOrderingComposer,
      $StaffCredentialsAnnotationComposer,
      $StaffCredentialsCreateCompanionBuilder,
      $StaffCredentialsUpdateCompanionBuilder,
      (StaffCredential, $StaffCredentialsReferences),
      StaffCredential,
      PrefetchHooks Function({bool authSessionsRefs, bool securityEventsRefs})
    >;
typedef $InstallationSecurityCreateCompanionBuilder =
    InstallationSecurityCompanion Function({
      Value<int> singleton,
      required String keyId,
      required String terminalId,
      required String setupIntent,
      required String setupHash,
      required String firstManagerId,
      required String primaryCashierId,
      required int recoveryAcknowledgedAtMs,
    });
typedef $InstallationSecurityUpdateCompanionBuilder =
    InstallationSecurityCompanion Function({
      Value<int> singleton,
      Value<String> keyId,
      Value<String> terminalId,
      Value<String> setupIntent,
      Value<String> setupHash,
      Value<String> firstManagerId,
      Value<String> primaryCashierId,
      Value<int> recoveryAcknowledgedAtMs,
    });

final class $InstallationSecurityReferences
    extends
        BaseReferences<
          _$PosDatabase,
          InstallationSecurity,
          InstallationSecurityData
        > {
  $InstallationSecurityReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static StaffCredentials _firstManagerIdTable(_$PosDatabase db) =>
      db.staffCredentials.createAlias(
        'installation_security__first_manager_id__staff_credentials__id',
      );

  $StaffCredentialsProcessedTableManager get firstManagerId {
    final $_column = $_itemColumn<String>('first_manager_id')!;

    final manager = $StaffCredentialsTableManager(
      $_db,
      $_db.staffCredentials,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_firstManagerIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static StaffCredentials _primaryCashierIdTable(_$PosDatabase db) =>
      db.staffCredentials.createAlias(
        'installation_security__primary_cashier_id__staff_credentials__id',
      );

  $StaffCredentialsProcessedTableManager get primaryCashierId {
    final $_column = $_itemColumn<String>('primary_cashier_id')!;

    final manager = $StaffCredentialsTableManager(
      $_db,
      $_db.staffCredentials,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_primaryCashierIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $InstallationSecurityFilterComposer
    extends Composer<_$PosDatabase, InstallationSecurity> {
  $InstallationSecurityFilterComposer({
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

  ColumnFilters<String> get keyId => $composableBuilder(
    column: $table.keyId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get terminalId => $composableBuilder(
    column: $table.terminalId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get setupIntent => $composableBuilder(
    column: $table.setupIntent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get setupHash => $composableBuilder(
    column: $table.setupHash,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get recoveryAcknowledgedAtMs => $composableBuilder(
    column: $table.recoveryAcknowledgedAtMs,
    builder: (column) => ColumnFilters(column),
  );

  $StaffCredentialsFilterComposer get firstManagerId {
    final $StaffCredentialsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.firstManagerId,
      referencedTable: $db.staffCredentials,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $StaffCredentialsFilterComposer(
            $db: $db,
            $table: $db.staffCredentials,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $StaffCredentialsFilterComposer get primaryCashierId {
    final $StaffCredentialsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.primaryCashierId,
      referencedTable: $db.staffCredentials,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $StaffCredentialsFilterComposer(
            $db: $db,
            $table: $db.staffCredentials,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $InstallationSecurityOrderingComposer
    extends Composer<_$PosDatabase, InstallationSecurity> {
  $InstallationSecurityOrderingComposer({
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

  ColumnOrderings<String> get keyId => $composableBuilder(
    column: $table.keyId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get terminalId => $composableBuilder(
    column: $table.terminalId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get setupIntent => $composableBuilder(
    column: $table.setupIntent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get setupHash => $composableBuilder(
    column: $table.setupHash,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get recoveryAcknowledgedAtMs => $composableBuilder(
    column: $table.recoveryAcknowledgedAtMs,
    builder: (column) => ColumnOrderings(column),
  );

  $StaffCredentialsOrderingComposer get firstManagerId {
    final $StaffCredentialsOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.firstManagerId,
      referencedTable: $db.staffCredentials,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $StaffCredentialsOrderingComposer(
            $db: $db,
            $table: $db.staffCredentials,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $StaffCredentialsOrderingComposer get primaryCashierId {
    final $StaffCredentialsOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.primaryCashierId,
      referencedTable: $db.staffCredentials,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $StaffCredentialsOrderingComposer(
            $db: $db,
            $table: $db.staffCredentials,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $InstallationSecurityAnnotationComposer
    extends Composer<_$PosDatabase, InstallationSecurity> {
  $InstallationSecurityAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get singleton =>
      $composableBuilder(column: $table.singleton, builder: (column) => column);

  GeneratedColumn<String> get keyId =>
      $composableBuilder(column: $table.keyId, builder: (column) => column);

  GeneratedColumn<String> get terminalId => $composableBuilder(
    column: $table.terminalId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get setupIntent => $composableBuilder(
    column: $table.setupIntent,
    builder: (column) => column,
  );

  GeneratedColumn<String> get setupHash =>
      $composableBuilder(column: $table.setupHash, builder: (column) => column);

  GeneratedColumn<int> get recoveryAcknowledgedAtMs => $composableBuilder(
    column: $table.recoveryAcknowledgedAtMs,
    builder: (column) => column,
  );

  $StaffCredentialsAnnotationComposer get firstManagerId {
    final $StaffCredentialsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.firstManagerId,
      referencedTable: $db.staffCredentials,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $StaffCredentialsAnnotationComposer(
            $db: $db,
            $table: $db.staffCredentials,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $StaffCredentialsAnnotationComposer get primaryCashierId {
    final $StaffCredentialsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.primaryCashierId,
      referencedTable: $db.staffCredentials,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $StaffCredentialsAnnotationComposer(
            $db: $db,
            $table: $db.staffCredentials,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $InstallationSecurityTableManager
    extends
        RootTableManager<
          _$PosDatabase,
          InstallationSecurity,
          InstallationSecurityData,
          $InstallationSecurityFilterComposer,
          $InstallationSecurityOrderingComposer,
          $InstallationSecurityAnnotationComposer,
          $InstallationSecurityCreateCompanionBuilder,
          $InstallationSecurityUpdateCompanionBuilder,
          (InstallationSecurityData, $InstallationSecurityReferences),
          InstallationSecurityData,
          PrefetchHooks Function({bool firstManagerId, bool primaryCashierId})
        > {
  $InstallationSecurityTableManager(
    _$PosDatabase db,
    InstallationSecurity table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $InstallationSecurityFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $InstallationSecurityOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $InstallationSecurityAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> singleton = const Value.absent(),
                Value<String> keyId = const Value.absent(),
                Value<String> terminalId = const Value.absent(),
                Value<String> setupIntent = const Value.absent(),
                Value<String> setupHash = const Value.absent(),
                Value<String> firstManagerId = const Value.absent(),
                Value<String> primaryCashierId = const Value.absent(),
                Value<int> recoveryAcknowledgedAtMs = const Value.absent(),
              }) => InstallationSecurityCompanion(
                singleton: singleton,
                keyId: keyId,
                terminalId: terminalId,
                setupIntent: setupIntent,
                setupHash: setupHash,
                firstManagerId: firstManagerId,
                primaryCashierId: primaryCashierId,
                recoveryAcknowledgedAtMs: recoveryAcknowledgedAtMs,
              ),
          createCompanionCallback:
              ({
                Value<int> singleton = const Value.absent(),
                required String keyId,
                required String terminalId,
                required String setupIntent,
                required String setupHash,
                required String firstManagerId,
                required String primaryCashierId,
                required int recoveryAcknowledgedAtMs,
              }) => InstallationSecurityCompanion.insert(
                singleton: singleton,
                keyId: keyId,
                terminalId: terminalId,
                setupIntent: setupIntent,
                setupHash: setupHash,
                firstManagerId: firstManagerId,
                primaryCashierId: primaryCashierId,
                recoveryAcknowledgedAtMs: recoveryAcknowledgedAtMs,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<InstallationSecurity, InstallationSecurityData>(
                    table,
                  ),
                  $InstallationSecurityReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({firstManagerId = false, primaryCashierId = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (firstManagerId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.firstManagerId,
                                    referencedTable:
                                        $InstallationSecurityReferences
                                            ._firstManagerIdTable(db),
                                    referencedColumn:
                                        $InstallationSecurityReferences
                                            ._firstManagerIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (primaryCashierId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.primaryCashierId,
                                    referencedTable:
                                        $InstallationSecurityReferences
                                            ._primaryCashierIdTable(db),
                                    referencedColumn:
                                        $InstallationSecurityReferences
                                            ._primaryCashierIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $InstallationSecurityProcessedTableManager =
    ProcessedTableManager<
      _$PosDatabase,
      InstallationSecurity,
      InstallationSecurityData,
      $InstallationSecurityFilterComposer,
      $InstallationSecurityOrderingComposer,
      $InstallationSecurityAnnotationComposer,
      $InstallationSecurityCreateCompanionBuilder,
      $InstallationSecurityUpdateCompanionBuilder,
      (InstallationSecurityData, $InstallationSecurityReferences),
      InstallationSecurityData,
      PrefetchHooks Function({bool firstManagerId, bool primaryCashierId})
    >;
typedef $AuthAttemptLimitsCreateCompanionBuilder =
    AuthAttemptLimitsCompanion Function({
      required String scope,
      required String subjectId,
      required int windowStartMs,
      required int lastSeenMs,
      required int reservedCount,
      Value<int> rowid,
    });
typedef $AuthAttemptLimitsUpdateCompanionBuilder =
    AuthAttemptLimitsCompanion Function({
      Value<String> scope,
      Value<String> subjectId,
      Value<int> windowStartMs,
      Value<int> lastSeenMs,
      Value<int> reservedCount,
      Value<int> rowid,
    });

class $AuthAttemptLimitsFilterComposer
    extends Composer<_$PosDatabase, AuthAttemptLimits> {
  $AuthAttemptLimitsFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get scope => $composableBuilder(
    column: $table.scope,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get subjectId => $composableBuilder(
    column: $table.subjectId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get windowStartMs => $composableBuilder(
    column: $table.windowStartMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lastSeenMs => $composableBuilder(
    column: $table.lastSeenMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get reservedCount => $composableBuilder(
    column: $table.reservedCount,
    builder: (column) => ColumnFilters(column),
  );
}

class $AuthAttemptLimitsOrderingComposer
    extends Composer<_$PosDatabase, AuthAttemptLimits> {
  $AuthAttemptLimitsOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get scope => $composableBuilder(
    column: $table.scope,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get subjectId => $composableBuilder(
    column: $table.subjectId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get windowStartMs => $composableBuilder(
    column: $table.windowStartMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lastSeenMs => $composableBuilder(
    column: $table.lastSeenMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get reservedCount => $composableBuilder(
    column: $table.reservedCount,
    builder: (column) => ColumnOrderings(column),
  );
}

class $AuthAttemptLimitsAnnotationComposer
    extends Composer<_$PosDatabase, AuthAttemptLimits> {
  $AuthAttemptLimitsAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get scope =>
      $composableBuilder(column: $table.scope, builder: (column) => column);

  GeneratedColumn<String> get subjectId =>
      $composableBuilder(column: $table.subjectId, builder: (column) => column);

  GeneratedColumn<int> get windowStartMs => $composableBuilder(
    column: $table.windowStartMs,
    builder: (column) => column,
  );

  GeneratedColumn<int> get lastSeenMs => $composableBuilder(
    column: $table.lastSeenMs,
    builder: (column) => column,
  );

  GeneratedColumn<int> get reservedCount => $composableBuilder(
    column: $table.reservedCount,
    builder: (column) => column,
  );
}

class $AuthAttemptLimitsTableManager
    extends
        RootTableManager<
          _$PosDatabase,
          AuthAttemptLimits,
          AuthAttemptLimit,
          $AuthAttemptLimitsFilterComposer,
          $AuthAttemptLimitsOrderingComposer,
          $AuthAttemptLimitsAnnotationComposer,
          $AuthAttemptLimitsCreateCompanionBuilder,
          $AuthAttemptLimitsUpdateCompanionBuilder,
          (
            AuthAttemptLimit,
            BaseReferences<_$PosDatabase, AuthAttemptLimits, AuthAttemptLimit>,
          ),
          AuthAttemptLimit,
          PrefetchHooks Function()
        > {
  $AuthAttemptLimitsTableManager(_$PosDatabase db, AuthAttemptLimits table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $AuthAttemptLimitsFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $AuthAttemptLimitsOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $AuthAttemptLimitsAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> scope = const Value.absent(),
                Value<String> subjectId = const Value.absent(),
                Value<int> windowStartMs = const Value.absent(),
                Value<int> lastSeenMs = const Value.absent(),
                Value<int> reservedCount = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AuthAttemptLimitsCompanion(
                scope: scope,
                subjectId: subjectId,
                windowStartMs: windowStartMs,
                lastSeenMs: lastSeenMs,
                reservedCount: reservedCount,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String scope,
                required String subjectId,
                required int windowStartMs,
                required int lastSeenMs,
                required int reservedCount,
                Value<int> rowid = const Value.absent(),
              }) => AuthAttemptLimitsCompanion.insert(
                scope: scope,
                subjectId: subjectId,
                windowStartMs: windowStartMs,
                lastSeenMs: lastSeenMs,
                reservedCount: reservedCount,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<AuthAttemptLimits, AuthAttemptLimit>(table),
                  BaseReferences<
                    _$PosDatabase,
                    AuthAttemptLimits,
                    AuthAttemptLimit
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $AuthAttemptLimitsProcessedTableManager =
    ProcessedTableManager<
      _$PosDatabase,
      AuthAttemptLimits,
      AuthAttemptLimit,
      $AuthAttemptLimitsFilterComposer,
      $AuthAttemptLimitsOrderingComposer,
      $AuthAttemptLimitsAnnotationComposer,
      $AuthAttemptLimitsCreateCompanionBuilder,
      $AuthAttemptLimitsUpdateCompanionBuilder,
      (
        AuthAttemptLimit,
        BaseReferences<_$PosDatabase, AuthAttemptLimits, AuthAttemptLimit>,
      ),
      AuthAttemptLimit,
      PrefetchHooks Function()
    >;
typedef $AuthSessionsCreateCompanionBuilder =
    AuthSessionsCompanion Function({
      required String id,
      required String tokenHash,
      required String staffId,
      required int credentialRevision,
      required String roleAtIssue,
      required String terminalId,
      required int issuedAtMs,
      required int lastSeenMs,
      required int expiresAtMs,
      required int revoked,
      Value<int> rowid,
    });
typedef $AuthSessionsUpdateCompanionBuilder =
    AuthSessionsCompanion Function({
      Value<String> id,
      Value<String> tokenHash,
      Value<String> staffId,
      Value<int> credentialRevision,
      Value<String> roleAtIssue,
      Value<String> terminalId,
      Value<int> issuedAtMs,
      Value<int> lastSeenMs,
      Value<int> expiresAtMs,
      Value<int> revoked,
      Value<int> rowid,
    });

final class $AuthSessionsReferences
    extends BaseReferences<_$PosDatabase, AuthSessions, AuthSession> {
  $AuthSessionsReferences(super.$_db, super.$_table, super.$_typedResult);

  static StaffCredentials _staffIdTable(_$PosDatabase db) => db.staffCredentials
      .createAlias('auth_sessions__staff_id__staff_credentials__id');

  $StaffCredentialsProcessedTableManager get staffId {
    final $_column = $_itemColumn<String>('staff_id')!;

    final manager = $StaffCredentialsTableManager(
      $_db,
      $_db.staffCredentials,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_staffIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<SecurityEvents, List<SecurityEvent>>
  _securityEventsRefsTable(_$PosDatabase db) => MultiTypedResultKey.fromTable(
    db.securityEvents,
    aliasName: 'auth_sessions__id__security_events__session_id',
  );

  $SecurityEventsProcessedTableManager get securityEventsRefs {
    final manager = $SecurityEventsTableManager(
      $_db,
      $_db.securityEvents,
    ).filter((f) => f.sessionId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_securityEventsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $AuthSessionsFilterComposer
    extends Composer<_$PosDatabase, AuthSessions> {
  $AuthSessionsFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tokenHash => $composableBuilder(
    column: $table.tokenHash,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get credentialRevision => $composableBuilder(
    column: $table.credentialRevision,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get roleAtIssue => $composableBuilder(
    column: $table.roleAtIssue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get terminalId => $composableBuilder(
    column: $table.terminalId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get issuedAtMs => $composableBuilder(
    column: $table.issuedAtMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lastSeenMs => $composableBuilder(
    column: $table.lastSeenMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get expiresAtMs => $composableBuilder(
    column: $table.expiresAtMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get revoked => $composableBuilder(
    column: $table.revoked,
    builder: (column) => ColumnFilters(column),
  );

  $StaffCredentialsFilterComposer get staffId {
    final $StaffCredentialsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.staffId,
      referencedTable: $db.staffCredentials,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $StaffCredentialsFilterComposer(
            $db: $db,
            $table: $db.staffCredentials,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> securityEventsRefs(
    Expression<bool> Function($SecurityEventsFilterComposer f) f,
  ) {
    final $SecurityEventsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.securityEvents,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $SecurityEventsFilterComposer(
            $db: $db,
            $table: $db.securityEvents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $AuthSessionsOrderingComposer
    extends Composer<_$PosDatabase, AuthSessions> {
  $AuthSessionsOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tokenHash => $composableBuilder(
    column: $table.tokenHash,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get credentialRevision => $composableBuilder(
    column: $table.credentialRevision,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get roleAtIssue => $composableBuilder(
    column: $table.roleAtIssue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get terminalId => $composableBuilder(
    column: $table.terminalId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get issuedAtMs => $composableBuilder(
    column: $table.issuedAtMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lastSeenMs => $composableBuilder(
    column: $table.lastSeenMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get expiresAtMs => $composableBuilder(
    column: $table.expiresAtMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get revoked => $composableBuilder(
    column: $table.revoked,
    builder: (column) => ColumnOrderings(column),
  );

  $StaffCredentialsOrderingComposer get staffId {
    final $StaffCredentialsOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.staffId,
      referencedTable: $db.staffCredentials,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $StaffCredentialsOrderingComposer(
            $db: $db,
            $table: $db.staffCredentials,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $AuthSessionsAnnotationComposer
    extends Composer<_$PosDatabase, AuthSessions> {
  $AuthSessionsAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get tokenHash =>
      $composableBuilder(column: $table.tokenHash, builder: (column) => column);

  GeneratedColumn<int> get credentialRevision => $composableBuilder(
    column: $table.credentialRevision,
    builder: (column) => column,
  );

  GeneratedColumn<String> get roleAtIssue => $composableBuilder(
    column: $table.roleAtIssue,
    builder: (column) => column,
  );

  GeneratedColumn<String> get terminalId => $composableBuilder(
    column: $table.terminalId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get issuedAtMs => $composableBuilder(
    column: $table.issuedAtMs,
    builder: (column) => column,
  );

  GeneratedColumn<int> get lastSeenMs => $composableBuilder(
    column: $table.lastSeenMs,
    builder: (column) => column,
  );

  GeneratedColumn<int> get expiresAtMs => $composableBuilder(
    column: $table.expiresAtMs,
    builder: (column) => column,
  );

  GeneratedColumn<int> get revoked =>
      $composableBuilder(column: $table.revoked, builder: (column) => column);

  $StaffCredentialsAnnotationComposer get staffId {
    final $StaffCredentialsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.staffId,
      referencedTable: $db.staffCredentials,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $StaffCredentialsAnnotationComposer(
            $db: $db,
            $table: $db.staffCredentials,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> securityEventsRefs<T extends Object>(
    Expression<T> Function($SecurityEventsAnnotationComposer a) f,
  ) {
    final $SecurityEventsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.securityEvents,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $SecurityEventsAnnotationComposer(
            $db: $db,
            $table: $db.securityEvents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $AuthSessionsTableManager
    extends
        RootTableManager<
          _$PosDatabase,
          AuthSessions,
          AuthSession,
          $AuthSessionsFilterComposer,
          $AuthSessionsOrderingComposer,
          $AuthSessionsAnnotationComposer,
          $AuthSessionsCreateCompanionBuilder,
          $AuthSessionsUpdateCompanionBuilder,
          (AuthSession, $AuthSessionsReferences),
          AuthSession,
          PrefetchHooks Function({bool staffId, bool securityEventsRefs})
        > {
  $AuthSessionsTableManager(_$PosDatabase db, AuthSessions table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $AuthSessionsFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $AuthSessionsOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $AuthSessionsAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> tokenHash = const Value.absent(),
                Value<String> staffId = const Value.absent(),
                Value<int> credentialRevision = const Value.absent(),
                Value<String> roleAtIssue = const Value.absent(),
                Value<String> terminalId = const Value.absent(),
                Value<int> issuedAtMs = const Value.absent(),
                Value<int> lastSeenMs = const Value.absent(),
                Value<int> expiresAtMs = const Value.absent(),
                Value<int> revoked = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AuthSessionsCompanion(
                id: id,
                tokenHash: tokenHash,
                staffId: staffId,
                credentialRevision: credentialRevision,
                roleAtIssue: roleAtIssue,
                terminalId: terminalId,
                issuedAtMs: issuedAtMs,
                lastSeenMs: lastSeenMs,
                expiresAtMs: expiresAtMs,
                revoked: revoked,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String tokenHash,
                required String staffId,
                required int credentialRevision,
                required String roleAtIssue,
                required String terminalId,
                required int issuedAtMs,
                required int lastSeenMs,
                required int expiresAtMs,
                required int revoked,
                Value<int> rowid = const Value.absent(),
              }) => AuthSessionsCompanion.insert(
                id: id,
                tokenHash: tokenHash,
                staffId: staffId,
                credentialRevision: credentialRevision,
                roleAtIssue: roleAtIssue,
                terminalId: terminalId,
                issuedAtMs: issuedAtMs,
                lastSeenMs: lastSeenMs,
                expiresAtMs: expiresAtMs,
                revoked: revoked,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<AuthSessions, AuthSession>(table),
                  $AuthSessionsReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({staffId = false, securityEventsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (securityEventsRefs) db.securityEvents,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (staffId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.staffId,
                                    referencedTable: $AuthSessionsReferences
                                        ._staffIdTable(db),
                                    referencedColumn: $AuthSessionsReferences
                                        ._staffIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (securityEventsRefs)
                        await $_getPrefetchedData<
                          AuthSession,
                          AuthSessions,
                          SecurityEvent
                        >(
                          currentTable: table,
                          referencedTable: $AuthSessionsReferences
                              ._securityEventsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $AuthSessionsReferences(
                                db,
                                table,
                                p0,
                              ).securityEventsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.sessionId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $AuthSessionsProcessedTableManager =
    ProcessedTableManager<
      _$PosDatabase,
      AuthSessions,
      AuthSession,
      $AuthSessionsFilterComposer,
      $AuthSessionsOrderingComposer,
      $AuthSessionsAnnotationComposer,
      $AuthSessionsCreateCompanionBuilder,
      $AuthSessionsUpdateCompanionBuilder,
      (AuthSession, $AuthSessionsReferences),
      AuthSession,
      PrefetchHooks Function({bool staffId, bool securityEventsRefs})
    >;
typedef $SecurityEventsCreateCompanionBuilder =
    SecurityEventsCompanion Function({
      required String id,
      required String kind,
      Value<String?> staffId,
      Value<String?> sessionId,
      required String terminalId,
      required int occurredAtMs,
      Value<int> rowid,
    });
typedef $SecurityEventsUpdateCompanionBuilder =
    SecurityEventsCompanion Function({
      Value<String> id,
      Value<String> kind,
      Value<String?> staffId,
      Value<String?> sessionId,
      Value<String> terminalId,
      Value<int> occurredAtMs,
      Value<int> rowid,
    });

final class $SecurityEventsReferences
    extends BaseReferences<_$PosDatabase, SecurityEvents, SecurityEvent> {
  $SecurityEventsReferences(super.$_db, super.$_table, super.$_typedResult);

  static StaffCredentials _staffIdTable(_$PosDatabase db) => db.staffCredentials
      .createAlias('security_events__staff_id__staff_credentials__id');

  $StaffCredentialsProcessedTableManager? get staffId {
    final $_column = $_itemColumn<String>('staff_id');
    if ($_column == null) return null;
    final manager = $StaffCredentialsTableManager(
      $_db,
      $_db.staffCredentials,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_staffIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static AuthSessions _sessionIdTable(_$PosDatabase db) => db.authSessions
      .createAlias('security_events__session_id__auth_sessions__id');

  $AuthSessionsProcessedTableManager? get sessionId {
    final $_column = $_itemColumn<String>('session_id');
    if ($_column == null) return null;
    final manager = $AuthSessionsTableManager(
      $_db,
      $_db.authSessions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sessionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $SecurityEventsFilterComposer
    extends Composer<_$PosDatabase, SecurityEvents> {
  $SecurityEventsFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get terminalId => $composableBuilder(
    column: $table.terminalId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get occurredAtMs => $composableBuilder(
    column: $table.occurredAtMs,
    builder: (column) => ColumnFilters(column),
  );

  $StaffCredentialsFilterComposer get staffId {
    final $StaffCredentialsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.staffId,
      referencedTable: $db.staffCredentials,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $StaffCredentialsFilterComposer(
            $db: $db,
            $table: $db.staffCredentials,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $AuthSessionsFilterComposer get sessionId {
    final $AuthSessionsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.authSessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $AuthSessionsFilterComposer(
            $db: $db,
            $table: $db.authSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $SecurityEventsOrderingComposer
    extends Composer<_$PosDatabase, SecurityEvents> {
  $SecurityEventsOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get terminalId => $composableBuilder(
    column: $table.terminalId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get occurredAtMs => $composableBuilder(
    column: $table.occurredAtMs,
    builder: (column) => ColumnOrderings(column),
  );

  $StaffCredentialsOrderingComposer get staffId {
    final $StaffCredentialsOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.staffId,
      referencedTable: $db.staffCredentials,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $StaffCredentialsOrderingComposer(
            $db: $db,
            $table: $db.staffCredentials,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $AuthSessionsOrderingComposer get sessionId {
    final $AuthSessionsOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.authSessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $AuthSessionsOrderingComposer(
            $db: $db,
            $table: $db.authSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $SecurityEventsAnnotationComposer
    extends Composer<_$PosDatabase, SecurityEvents> {
  $SecurityEventsAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get terminalId => $composableBuilder(
    column: $table.terminalId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get occurredAtMs => $composableBuilder(
    column: $table.occurredAtMs,
    builder: (column) => column,
  );

  $StaffCredentialsAnnotationComposer get staffId {
    final $StaffCredentialsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.staffId,
      referencedTable: $db.staffCredentials,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $StaffCredentialsAnnotationComposer(
            $db: $db,
            $table: $db.staffCredentials,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $AuthSessionsAnnotationComposer get sessionId {
    final $AuthSessionsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.authSessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $AuthSessionsAnnotationComposer(
            $db: $db,
            $table: $db.authSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $SecurityEventsTableManager
    extends
        RootTableManager<
          _$PosDatabase,
          SecurityEvents,
          SecurityEvent,
          $SecurityEventsFilterComposer,
          $SecurityEventsOrderingComposer,
          $SecurityEventsAnnotationComposer,
          $SecurityEventsCreateCompanionBuilder,
          $SecurityEventsUpdateCompanionBuilder,
          (SecurityEvent, $SecurityEventsReferences),
          SecurityEvent,
          PrefetchHooks Function({bool staffId, bool sessionId})
        > {
  $SecurityEventsTableManager(_$PosDatabase db, SecurityEvents table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $SecurityEventsFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $SecurityEventsOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $SecurityEventsAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<String?> staffId = const Value.absent(),
                Value<String?> sessionId = const Value.absent(),
                Value<String> terminalId = const Value.absent(),
                Value<int> occurredAtMs = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SecurityEventsCompanion(
                id: id,
                kind: kind,
                staffId: staffId,
                sessionId: sessionId,
                terminalId: terminalId,
                occurredAtMs: occurredAtMs,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String kind,
                Value<String?> staffId = const Value.absent(),
                Value<String?> sessionId = const Value.absent(),
                required String terminalId,
                required int occurredAtMs,
                Value<int> rowid = const Value.absent(),
              }) => SecurityEventsCompanion.insert(
                id: id,
                kind: kind,
                staffId: staffId,
                sessionId: sessionId,
                terminalId: terminalId,
                occurredAtMs: occurredAtMs,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<SecurityEvents, SecurityEvent>(table),
                  $SecurityEventsReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({staffId = false, sessionId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (staffId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.staffId,
                                referencedTable: $SecurityEventsReferences
                                    ._staffIdTable(db),
                                referencedColumn: $SecurityEventsReferences
                                    ._staffIdTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (sessionId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.sessionId,
                                referencedTable: $SecurityEventsReferences
                                    ._sessionIdTable(db),
                                referencedColumn: $SecurityEventsReferences
                                    ._sessionIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $SecurityEventsProcessedTableManager =
    ProcessedTableManager<
      _$PosDatabase,
      SecurityEvents,
      SecurityEvent,
      $SecurityEventsFilterComposer,
      $SecurityEventsOrderingComposer,
      $SecurityEventsAnnotationComposer,
      $SecurityEventsCreateCompanionBuilder,
      $SecurityEventsUpdateCompanionBuilder,
      (SecurityEvent, $SecurityEventsReferences),
      SecurityEvent,
      PrefetchHooks Function({bool staffId, bool sessionId})
    >;

class $PosDatabaseManager {
  final _$PosDatabase _db;
  $PosDatabaseManager(this._db);
  $DatabaseMetadataTableManager get databaseMetadata =>
      $DatabaseMetadataTableManager(_db, _db.databaseMetadata);
  $SchemaUpgradesTableManager get schemaUpgrades =>
      $SchemaUpgradesTableManager(_db, _db.schemaUpgrades);
  $IdempotencyCommandsTableManager get idempotencyCommands =>
      $IdempotencyCommandsTableManager(_db, _db.idempotencyCommands);
  $CommandVersionsTableManager get commandVersions =>
      $CommandVersionsTableManager(_db, _db.commandVersions);
  $AuditEventsTableManager get auditEvents =>
      $AuditEventsTableManager(_db, _db.auditEvents);
  $StaffCredentialsTableManager get staffCredentials =>
      $StaffCredentialsTableManager(_db, _db.staffCredentials);
  $InstallationSecurityTableManager get installationSecurity =>
      $InstallationSecurityTableManager(_db, _db.installationSecurity);
  $AuthAttemptLimitsTableManager get authAttemptLimits =>
      $AuthAttemptLimitsTableManager(_db, _db.authAttemptLimits);
  $AuthSessionsTableManager get authSessions =>
      $AuthSessionsTableManager(_db, _db.authSessions);
  $SecurityEventsTableManager get securityEvents =>
      $SecurityEventsTableManager(_db, _db.securityEvents);
}
