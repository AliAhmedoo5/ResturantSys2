import 'dart:ffi';
import 'dart:io';

import 'package:ffi/ffi.dart';

final class PrivateStorageFailure implements Exception {
  const PrivateStorageFailure();
  @override
  String toString() =>
      'Windows storage is unavailable or its protection has changed.';
}

/// Current Windows identity only. Existing folders are checked, never repaired
/// silently. This does not defend against administrators or the same OS user.
final class WindowsPrivateStorage {
  WindowsPrivateStorage._(this.directory);
  final Directory directory;

  static Directory localAppData() {
    _requireWindows();
    return using((arena) {
      // FOLDERID_LocalAppData: F1B32785-6FBA-4FCF-9D55-7B8E7F157091.
      final id = arena<Uint8>(16);
      id.asTypedList(16).setAll(0, [
        0x85,
        0x27,
        0xb3,
        0xf1,
        0xba,
        0x6f,
        0xcf,
        0x4f,
        0x9d,
        0x55,
        0x7b,
        0x8e,
        0x7f,
        0x15,
        0x70,
        0x91,
      ]);
      final output = arena<Pointer<Utf16>>();
      try {
        if (_knownFolder(id.cast(), 0, nullptr, output) < 0 ||
            output.value == nullptr) {
          throw const PrivateStorageFailure();
        }
        return Directory(output.value.toDartString());
      } finally {
        if (output.value != nullptr) _coTaskMemFree(output.value.cast());
      }
    });
  }

  static WindowsPrivateStorage open() => provisionIn(localAppData());

  /// An explicitly selected existing local parent is also supported. Only the
  /// fixed CrunchCartel child is created; no parent permissions are changed.
  static WindowsPrivateStorage provisionIn(Directory parent) {
    _requireWindows();
    _checkPath(parent);
    final directory = Directory.fromUri(parent.uri.resolve('CrunchCartel/'));
    using((arena) {
      final descriptor = _descriptor(arena, _policy(_currentSid()));
      try {
        final attributes = arena<_SecurityAttributes>();
        attributes.ref
          ..length = sizeOf<_SecurityAttributes>()
          ..descriptor = descriptor
          ..inheritHandle = 0;
        // Resolve the lazy FFI binding before creation: resolving it afterwards
        // can overwrite the thread's last-error value on the first failed call.
        final lastError = _lastError;
        if (_createDirectory(
                  directory.path.toNativeUtf16(allocator: arena),
                  attributes,
                ) ==
                0 &&
            lastError() != 183) {
          throw const PrivateStorageFailure();
        }
      } finally {
        _localFree(descriptor);
      }
    });
    final result = WindowsPrivateStorage._(directory);
    result.verify();
    return result;
  }

  void verify() {
    _requireWindows();
    _checkPath(directory);
    using((arena) {
      final expected = _descriptor(arena, _policy(_currentSid()));
      final actual = arena<Pointer<Void>>();
      try {
        // SE_FILE_OBJECT, OWNER_SECURITY_INFORMATION | DACL_SECURITY_INFORMATION.
        if (_getSecurity(
                  directory.path.toNativeUtf16(allocator: arena),
                  1,
                  5,
                  nullptr,
                  nullptr,
                  nullptr,
                  nullptr,
                  actual,
                ) !=
                0 ||
            actual.value == nullptr ||
            _sddl(arena, actual.value) != _sddl(arena, expected)) {
          throw const PrivateStorageFailure();
        }
      } finally {
        _localFree(expected);
        if (actual.value != nullptr) _localFree(actual.value);
      }
    });
  }
}

String _policy(String sid) => 'O:${sid}D:P(A;OICI;FA;;;SY)(A;OICI;FA;;;$sid)';

void _requireWindows() {
  if (!Platform.isWindows)
    throw UnsupportedError('Windows storage is required.');
}

void _checkPath(Directory directory) {
  final path = directory.path.replaceAll(RegExp(r'\\+$'), '');
  if (!RegExp(r'^[A-Za-z]:\\').hasMatch(path))
    throw const PrivateStorageFailure();
  final parts = path.substring(3).split(r'\');
  if (parts.any(
    (part) =>
        part.isEmpty ||
        part == '.' ||
        part == '..' ||
        part.endsWith('.') ||
        part.endsWith(' ') ||
        part.contains(':') ||
        part.contains('/'),
  )) {
    throw const PrivateStorageFailure();
  }
  using((arena) {
    final root = path.substring(0, 3);
    if (_driveType(root.toNativeUtf16(allocator: arena)) != 3)
      throw const PrivateStorageFailure();
    var current = root;
    for (final part in parts) {
      current = current.endsWith(r'\') ? '$current$part' : '$current\\$part';
      final attributes = _fileAttributes(
        current.toNativeUtf16(allocator: arena),
      );
      // Reject missing paths, files and all reparse points, including junctions.
      if (attributes == 0xffffffff ||
          attributes & 0x10 == 0 ||
          attributes & 0x400 != 0) {
        throw const PrivateStorageFailure();
      }
    }
  });
}

String _currentSid() => using((arena) {
  final token = arena<Pointer<Void>>();
  if (_openToken(_currentProcess(), 8, token) == 0)
    throw const PrivateStorageFailure();
  try {
    final length = arena<Uint32>();
    _tokenInformation(token.value, 1, nullptr, 0, length);
    if (length.value == 0 || length.value > 65536)
      throw const PrivateStorageFailure();
    final buffer = arena<Uint8>(length.value);
    if (_tokenInformation(
          token.value,
          1,
          buffer.cast(),
          length.value,
          length,
        ) ==
        0) {
      throw const PrivateStorageFailure();
    }
    final output = arena<Pointer<Utf16>>();
    try {
      // TOKEN_USER starts with SID_AND_ATTRIBUTES, whose first field is PSID.
      if (_sidString(buffer.cast<Pointer<Void>>().value, output) == 0)
        throw const PrivateStorageFailure();
      return output.value.toDartString();
    } finally {
      if (output.value != nullptr) _localFree(output.value.cast());
    }
  } finally {
    _closeHandle(token.value);
  }
});

Pointer<Void> _descriptor(Arena arena, String sddl) {
  final output = arena<Pointer<Void>>();
  if (_fromSddl(sddl.toNativeUtf16(allocator: arena), 1, output, nullptr) ==
      0) {
    throw const PrivateStorageFailure();
  }
  return output.value;
}

String _sddl(Arena arena, Pointer<Void> descriptor) {
  final output = arena<Pointer<Utf16>>();
  try {
    if (_toSddl(descriptor, 1, 5, output, nullptr) == 0)
      throw const PrivateStorageFailure();
    // Windows may mark successful inheritance propagation with AI. Protection,
    // owner, ACE order, rights and inheritance flags must otherwise match exactly.
    return output.value.toDartString().replaceFirst('D:PAI(', 'D:P(');
  } finally {
    if (output.value != nullptr) _localFree(output.value.cast());
  }
}

final class _SecurityAttributes extends Struct {
  @Uint32()
  external int length;
  external Pointer<Void> descriptor;
  @Int32()
  external int inheritHandle;
}

// Native signatures follow the Windows SDK. These APIs are kept here because
// the pinned win32 package does not expose the SDDL conversion functions.
final _kernel = DynamicLibrary.open('kernel32.dll');
final _advapi = DynamicLibrary.open('advapi32.dll');
final _knownFolder = DynamicLibrary.open('shell32.dll')
    .lookupFunction<
      Int32 Function(
        Pointer<Void>,
        Uint32,
        Pointer<Void>,
        Pointer<Pointer<Utf16>>,
      ),
      int Function(Pointer<Void>, int, Pointer<Void>, Pointer<Pointer<Utf16>>)
    >('SHGetKnownFolderPath');
final _coTaskMemFree = DynamicLibrary.open('ole32.dll')
    .lookupFunction<Void Function(Pointer<Void>), void Function(Pointer<Void>)>(
      'CoTaskMemFree',
    );
final _localFree = _kernel
    .lookupFunction<
      Pointer<Void> Function(Pointer<Void>),
      Pointer<Void> Function(Pointer<Void>)
    >('LocalFree');
final _currentProcess = _kernel
    .lookupFunction<Pointer<Void> Function(), Pointer<Void> Function()>(
      'GetCurrentProcess',
    );
final _closeHandle = _kernel
    .lookupFunction<Int32 Function(Pointer<Void>), int Function(Pointer<Void>)>(
      'CloseHandle',
    );
final _lastError = _kernel.lookupFunction<Uint32 Function(), int Function()>(
  'GetLastError',
);
final _driveType = _kernel
    .lookupFunction<
      Uint32 Function(Pointer<Utf16>),
      int Function(Pointer<Utf16>)
    >('GetDriveTypeW');
final _fileAttributes = _kernel
    .lookupFunction<
      Uint32 Function(Pointer<Utf16>),
      int Function(Pointer<Utf16>)
    >('GetFileAttributesW');
final _createDirectory = _kernel
    .lookupFunction<
      Int32 Function(Pointer<Utf16>, Pointer<_SecurityAttributes>),
      int Function(Pointer<Utf16>, Pointer<_SecurityAttributes>)
    >('CreateDirectoryW');
final _openToken = _advapi
    .lookupFunction<
      Int32 Function(Pointer<Void>, Uint32, Pointer<Pointer<Void>>),
      int Function(Pointer<Void>, int, Pointer<Pointer<Void>>)
    >('OpenProcessToken');
final _tokenInformation = _advapi
    .lookupFunction<
      Int32 Function(
        Pointer<Void>,
        Int32,
        Pointer<Void>,
        Uint32,
        Pointer<Uint32>,
      ),
      int Function(Pointer<Void>, int, Pointer<Void>, int, Pointer<Uint32>)
    >('GetTokenInformation');
final _sidString = _advapi
    .lookupFunction<
      Int32 Function(Pointer<Void>, Pointer<Pointer<Utf16>>),
      int Function(Pointer<Void>, Pointer<Pointer<Utf16>>)
    >('ConvertSidToStringSidW');
final _fromSddl = _advapi
    .lookupFunction<
      Int32 Function(
        Pointer<Utf16>,
        Uint32,
        Pointer<Pointer<Void>>,
        Pointer<Uint32>,
      ),
      int Function(Pointer<Utf16>, int, Pointer<Pointer<Void>>, Pointer<Uint32>)
    >('ConvertStringSecurityDescriptorToSecurityDescriptorW');
final _toSddl = _advapi
    .lookupFunction<
      Int32 Function(
        Pointer<Void>,
        Uint32,
        Uint32,
        Pointer<Pointer<Utf16>>,
        Pointer<Uint32>,
      ),
      int Function(
        Pointer<Void>,
        int,
        int,
        Pointer<Pointer<Utf16>>,
        Pointer<Uint32>,
      )
    >('ConvertSecurityDescriptorToStringSecurityDescriptorW');
final _getSecurity = _advapi
    .lookupFunction<
      Uint32 Function(
        Pointer<Utf16>,
        Int32,
        Uint32,
        Pointer<Pointer<Void>>,
        Pointer<Pointer<Void>>,
        Pointer<Pointer<Void>>,
        Pointer<Pointer<Void>>,
        Pointer<Pointer<Void>>,
      ),
      int Function(
        Pointer<Utf16>,
        int,
        int,
        Pointer<Pointer<Void>>,
        Pointer<Pointer<Void>>,
        Pointer<Pointer<Void>>,
        Pointer<Pointer<Void>>,
        Pointer<Pointer<Void>>,
      )
    >('GetNamedSecurityInfoW');
