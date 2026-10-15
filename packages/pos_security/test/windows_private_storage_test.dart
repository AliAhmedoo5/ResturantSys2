import 'dart:convert';
import 'dart:io';

import 'package:pos_security/installation_key_store.dart';
import 'package:pos_security/windows_private_storage.dart';
import 'package:test/test.dart';

void main() {
  late Directory parent;
  setUp(() async {
    parent = await Directory.systemTemp.createTemp('crunch-private-');
  });
  tearDown(() async {
    if (await parent.exists()) await parent.delete(recursive: true);
  });

  Future<String> powershell(String script, String path) async {
    final result = await Process.run(
      'pwsh',
      ['-NoProfile', '-NonInteractive', '-Command', script],
      environment: {'CRUNCH_TEST_PATH': path},
    );
    expect(result.exitCode, 0, reason: '${result.stderr}');
    return '${result.stdout}'.trim();
  }

  test(
    'known-folder API returns the current local application data folder',
    () async {
      final expected = await powershell(
        '[Environment]::GetFolderPath("LocalApplicationData")',
        parent.path,
      );
      expect(
        WindowsPrivateStorage.localAppData().path.toLowerCase(),
        expected.toLowerCase(),
      );
    },
  );

  test(
    'private directory reopens and files inherit only intended principals',
    () async {
      final storage = WindowsPrivateStorage.provisionIn(parent);
      final file = File.fromUri(storage.directory.uri.resolve('probe.txt'));
      await file.writeAsString('fixture');
      WindowsPrivateStorage.provisionIn(parent).verify();
      final report =
          jsonDecode(
                await powershell(r'''
$acl = Get-Acl -LiteralPath $env:CRUNCH_TEST_PATH
$sid = [Security.Principal.WindowsIdentity]::GetCurrent().User.Value
@{ owner = $acl.GetOwner([Security.Principal.SecurityIdentifier]).Value; current = $sid; rules = @($acl.GetAccessRules($true, $true, [Security.Principal.SecurityIdentifier]) | ForEach-Object { @{ sid = $_.IdentityReference.Value; inherited = $_.IsInherited; allow = $_.AccessControlType.ToString(); rights = [int]$_.FileSystemRights } }) } | ConvertTo-Json -Depth 4 -Compress
''', file.path),
              )
              as Map<String, dynamic>;
      final rules = report['rules'] as List<dynamic>;
      // A file's default owner can be Administrators on an elevated runner; the
      // directory itself has an explicitly assigned current-user owner.
      expect(rules, hasLength(2));
      expect(rules.map((rule) => rule['sid']).toSet(), {
        report['current'],
        'S-1-5-18',
      });
      for (final rule in rules) {
        expect(rule['inherited'], true);
        expect(rule['allow'], 'Allow');
        expect(rule['rights'], 0x1f01ff);
      }
    },
  );

  test(
    'pre-existing permissive folder is rejected without modifying it',
    () async {
      final directory = await Directory.fromUri(
        parent.uri.resolve('CrunchCartel/'),
      ).create();
      final before = await powershell(
        r'(Get-Acl -LiteralPath $env:CRUNCH_TEST_PATH).Sddl',
        directory.path,
      );
      expect(
        () => WindowsPrivateStorage.provisionIn(parent),
        throwsA(isA<PrivateStorageFailure>()),
      );
      expect(
        await powershell(
          r'(Get-Acl -LiteralPath $env:CRUNCH_TEST_PATH).Sddl',
          directory.path,
        ),
        before,
      );
    },
  );

  test('broadened permissions fail verification without repair', () async {
    final storage = WindowsPrivateStorage.provisionIn(parent);
    final store = InstallationKeyStore.privateStorage(storage);
    final prepared = await PreparedInstallationKey.create();
    await store.initialize(prepared);
    await powershell(r'''
$acl = Get-Acl -LiteralPath $env:CRUNCH_TEST_PATH
$sid = [Security.Principal.SecurityIdentifier]::new('S-1-1-0')
$rule = [Security.AccessControl.FileSystemAccessRule]::new($sid, 'ReadAndExecute', 'ContainerInherit,ObjectInherit', 'None', 'Allow')
$acl.AddAccessRule($rule)
Set-Acl -LiteralPath $env:CRUNCH_TEST_PATH -AclObject $acl
''', storage.directory.path);
    expect(storage.verify, throwsA(isA<PrivateStorageFailure>()));
    await expectLater(
      store.load(expectedKeyId: prepared.keyId),
      throwsA(isA<PrivateStorageFailure>()),
    );
    expect(
      () => WindowsPrivateStorage.provisionIn(parent),
      throwsA(isA<PrivateStorageFailure>()),
    );
  });

  test(
    'relative, traversal, missing, file and junction paths are rejected',
    () async {
      for (final path in [
        'relative',
        '${parent.path}\\..',
        '${parent.path}\\missing',
      ]) {
        expect(
          () => WindowsPrivateStorage.provisionIn(Directory(path)),
          throwsA(isA<PrivateStorageFailure>()),
        );
      }
      final file = await File.fromUri(
        parent.uri.resolve('file'),
      ).writeAsString('fixture');
      expect(
        () => WindowsPrivateStorage.provisionIn(Directory(file.path)),
        throwsA(isA<PrivateStorageFailure>()),
      );
      final junction = '${parent.path}\\junction';
      await powershell(
        r'''New-Item -ItemType Junction -Path ($env:CRUNCH_TEST_PATH + '\junction') -Target $env:CRUNCH_TEST_PATH | Out-Null''',
        parent.path,
      );
      try {
        expect(
          () => WindowsPrivateStorage.provisionIn(Directory(junction)),
          throwsA(isA<PrivateStorageFailure>()),
        );
      } finally {
        await powershell(
          r'''[IO.Directory]::Delete($env:CRUNCH_TEST_PATH)''',
          junction,
        );
      }
    },
  );

  test(
    'key-store publication works within protected inherited storage',
    () async {
      final storage = WindowsPrivateStorage.provisionIn(parent);
      final prepared = await PreparedInstallationKey.create();
    final store = InstallationKeyStore.privateStorage(storage);
      await store.initialize(prepared);
      storage.verify();
      final loaded = await store.load(expectedKeyId: prepared.keyId);
      expect(await loaded.fingerprint('4826'), isNotEmpty);
      loaded.dispose();
    },
  );
}
