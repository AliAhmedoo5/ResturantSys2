@TestOn('windows')
library;

import 'dart:convert';
import 'dart:io';

import 'package:pos_security/installation_key_store.dart';
import 'package:test/test.dart';

void main() {
  late Directory root;
  late InstallationKeyStore store;
  late PreparedInstallationKey prepared;
  setUp(() async {
    root = await Directory.systemTemp.createTemp('cartel-key-store-test-');
    store = InstallationKeyStore(root);
    prepared = await PreparedInstallationKey.create();
  });
  tearDown(() async => root.delete(recursive: true));
  File keyFile() =>
      File.fromUri(root.uri.resolve(InstallationKeyStore.fileName));

  test(
    'protected key persists and retains fingerprints after reopening',
    () async {
      await store.initialize(prepared);
      final first = await store.load(expectedKeyId: prepared.keyId);
      final fingerprint = await first.fingerprint('0027');
      first.dispose();
      expect(() => first.fingerprint('0027'), throwsStateError);
      final reopened = await InstallationKeyStore(
        root,
      ).load(expectedKeyId: prepared.keyId);
      try {
        expect(await reopened.fingerprint('0027'), fingerprint);
      } finally {
        reopened.dispose();
      }
      final text = await keyFile().readAsString();
      expect(text, isNot(contains(prepared.recoveryCode)));
      expect(
        (jsonDecode(text) as Map).keys,
        unorderedEquals([
          'formatVersion',
          'keyId',
          'protectedKey',
          'recoveryEnvelope',
          'authenticationTag',
        ]),
      );
      expect((await root.list().toList()).length, 1);
    },
  );

  test('existing key cannot be silently reinitialized', () async {
    await store.initialize(prepared);
    final original = await keyFile().readAsBytes();
    await expectLater(
      store.initialize(await PreparedInstallationKey.create()),
      throwsA(isA<InstallationKeyExists>()),
    );
    expect(await keyFile().readAsBytes(), original);
  });

  test('concurrent initializers publish exactly one complete key', () async {
    final other = await PreparedInstallationKey.create();
    Future<String?> attempt(PreparedInstallationKey candidate) async {
      try {
        await InstallationKeyStore(root).initialize(candidate);
        return candidate.keyId;
      } on InstallationKeyExists {
        return null;
      }
    }

    final results = await Future.wait([attempt(prepared), attempt(other)]);
    expect(results.whereType<String>().length, 1);
    final loaded = await store.load(
      expectedKeyId: results.whereType<String>().single,
    );
    loaded.dispose();
    expect((await root.list().toList()).length, 1);
  });

  test(
    'missing file and missing destination are never recreated by load',
    () async {
      await expectLater(
        store.load(expectedKeyId: prepared.keyId),
        throwsA(isA<FileSystemException>()),
      );
      expect(await root.list().length, 0);
      final absent = Directory('${root.path}/absent');
      await expectLater(
        InstallationKeyStore(absent).initialize(prepared),
        throwsA(isA<FileSystemException>()),
      );
      expect(await absent.exists(), isFalse);
    },
  );

  test(
    'wrong database identity, corrupt JSON and oversized files fail closed',
    () async {
      await store.initialize(prepared);
      final other = await PreparedInstallationKey.create();
      await expectLater(
        store.load(expectedKeyId: other.keyId),
        throwsA(isA<InstallationKeyInvalid>()),
      );
      for (final text in ['{broken', 'x' * 32769]) {
        await keyFile().writeAsString(text);
        await expectLater(
          store.load(expectedKeyId: prepared.keyId),
          throwsA(isA<InstallationKeyInvalid>()),
        );
        expect(await keyFile().readAsString(), text);
      }
    },
  );

  test(
    'recovery preserves installation identity in a new destination',
    () async {
      await store.initialize(prepared);
      final original = await store.load(expectedKeyId: prepared.keyId);
      final fingerprint = await original.fingerprint('0027');
      original.dispose();
      final recovered = await PreparedInstallationKey.recover(
        expectedKeyId: prepared.keyId,
        recoveryCode: prepared.recoveryCode,
        recoveryEnvelope: prepared.recoveryEnvelope,
      );
      final destination = await Directory('${root.path}/replacement').create();
      await InstallationKeyStore(destination).initialize(recovered);
      final loaded = await InstallationKeyStore(
        destination,
      ).load(expectedKeyId: prepared.keyId);
      try {
        expect(await loaded.fingerprint('0027'), fingerprint);
      } finally {
        loaded.dispose();
      }
      final other = await PreparedInstallationKey.create();
      await expectLater(
        PreparedInstallationKey.recover(
          expectedKeyId: other.keyId,
          recoveryCode: prepared.recoveryCode,
          recoveryEnvelope: prepared.recoveryEnvelope,
        ),
        throwsA(isA<InstallationKeyInvalid>()),
      );
    },
  );

  test(
    'changed recovery metadata is rejected even while DPAPI remains valid',
    () async {
      await store.initialize(prepared);
      final data =
          jsonDecode(await keyFile().readAsString()) as Map<String, dynamic>;
      final other = await PreparedInstallationKey.create();
      data['recoveryEnvelope'] = other.recoveryEnvelope;
      await keyFile().writeAsString(jsonEncode(data));
      await expectLater(
        store.load(expectedKeyId: prepared.keyId),
        throwsA(isA<InstallationKeyInvalid>()),
      );
    },
  );

  test('unpublished staging files do not masquerade as a saved key', () async {
    final stale = await Directory('${root.path}/.key-pending-stale').create();
    await File('${stale.path}/installation-key.json').writeAsString('partial');
    await expectLater(
      store.load(expectedKeyId: prepared.keyId),
      throwsA(isA<FileSystemException>()),
    );
    await store.initialize(prepared);
    expect(await stale.exists(), isTrue);
    final loaded = await store.load(expectedKeyId: prepared.keyId);
    loaded.dispose();
  });
}
