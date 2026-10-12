import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/preview/pages.dart';
import 'shell.dart';
import 'theme.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final router = GoRouter(
    initialLocation: '/',
    routes: [
      ShellRoute(
        builder: (context, state, child) =>
            CartelShell(path: state.uri.path, child: child),
        routes: [
          GoRoute(path: '/', builder: (context, state) => const WelcomePage()),
          GoRoute(
            path: '/preview/counter',
            builder: (context, state) => const CounterPreviewPage(),
          ),
          GoRoute(
            path: '/preview/manager',
            builder: (context, state) => const ManagerPreviewPage(),
          ),
          GoRoute(
            path: '/setup',
            builder: (context, state) => const SetupPreviewPage(),
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('This page is not available.'),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () => context.go('/'),
              child: const Text('Back to welcome'),
            ),
          ],
        ),
      ),
    ),
  );
  ref.onDispose(router.dispose);
  return router;
});

class CrunchCartelApp extends ConsumerWidget {
  const CrunchCartelApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => MaterialApp.router(
    title: 'Crunch Cartel',
    debugShowCheckedModeBanner: false,
    theme: cartelTheme(),
    routerConfig: ref.watch(routerProvider),
  );
}
