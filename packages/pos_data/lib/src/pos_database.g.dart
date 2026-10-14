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
}
