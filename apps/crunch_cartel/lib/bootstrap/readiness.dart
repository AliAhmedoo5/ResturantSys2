import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Build capabilities, not persisted setup status or an authenticated session.
/// Database-backed readiness replaces this boundary in chunks 03 and 04.
class PreviewReadiness {
  const PreviewReadiness();
  String get title => 'Design preview';
  String get message => 'Setup and billing are not enabled in this build.';
}

final readinessProvider = Provider<PreviewReadiness>((ref) => const PreviewReadiness());
