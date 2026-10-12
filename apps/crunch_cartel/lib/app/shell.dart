import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../bootstrap/readiness.dart';
import 'theme.dart';

class CartelShell extends ConsumerWidget {
  const CartelShell({required this.path, required this.child, super.key});
  final String path;
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final readiness = ref.watch(readinessProvider);
    final compact = MediaQuery.sizeOf(context).width < 1100;
    final manager = path == '/preview/manager';
    final counter = path == '/preview/counter';
    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.f1): () => _help(context),
        const SingleActivator(LogicalKeyboardKey.home, control: true): () =>
            context.go('/'),
      },
      child: Focus(
        autofocus: true,
        child: Scaffold(
          body: Row(
            children: [
              Container(
                width: compact ? 80 : 216,
                decoration: const BoxDecoration(
                  color: CartelColors.panel,
                  border: Border(right: BorderSide(color: CartelColors.line)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        compact ? 16 : 24,
                        28,
                        compact ? 16 : 24,
                        32,
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: CartelColors.yellow,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.bolt_rounded,
                              color: CartelColors.black,
                              size: 32,
                            ),
                          ),
                          if (!compact) ...[
                            const SizedBox(width: 12),
                            const Text(
                              'CRUNCH\nCARTEL',
                              style: TextStyle(
                                fontWeight: FontWeight.w900,
                                height: 1.1,
                                letterSpacing: 1,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    if (!compact)
                      const Padding(
                        padding: EdgeInsets.fromLTRB(24, 0, 16, 12),
                        child: Text(
                          'WORKSPACE PREVIEW',
                          style: TextStyle(
                            fontSize: 10,
                            letterSpacing: 1.6,
                            color: CartelColors.muted,
                          ),
                        ),
                      ),
                    _nav(
                      context,
                      '/',
                      'Welcome',
                      Icons.grid_view_rounded,
                      compact,
                    ),
                    if (counter)
                      _nav(
                        context,
                        '/preview/counter',
                        'Counter',
                        Icons.point_of_sale_rounded,
                        compact,
                      ),
                    if (manager)
                      _nav(
                        context,
                        '/preview/manager',
                        'Management',
                        Icons.space_dashboard_outlined,
                        compact,
                      ),
                    _nav(
                      context,
                      '/setup',
                      'Setup guide',
                      Icons.tune_rounded,
                      compact,
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Tooltip(
                        message: 'Keyboard help (F1)',
                        child: OutlinedButton(
                          onPressed: () => _help(context),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.all(12),
                          ),
                          child: compact
                              ? const Icon(Icons.keyboard_outlined)
                              : const Row(
                                  children: [
                                    Icon(Icons.keyboard_outlined, size: 20),
                                    SizedBox(width: 10),
                                    Text('Keyboard help'),
                                    Spacer(),
                                    Text(
                                      'F1',
                                      style: TextStyle(
                                        color: CartelColors.muted,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ),
                    if (!compact)
                      const Padding(
                        padding: EdgeInsets.fromLTRB(24, 4, 16, 24),
                        child: Text(
                          'WINDOWS  /  PREVIEW 0.2',
                          style: TextStyle(
                            fontSize: 10,
                            color: CartelColors.muted,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Container(
                      constraints: const BoxConstraints(minHeight: 64),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: CartelColors.line),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.radio_button_checked,
                            size: 14,
                            color: CartelColors.yellow,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              '${readiness.title}  •  ${readiness.message}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: CartelColors.muted,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          const Text(
                            'PKR',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(child: child),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _nav(
    BuildContext context,
    String route,
    String label,
    IconData icon,
    bool compact,
  ) {
    final selected = path == route;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Tooltip(
        message: compact ? label : '',
        child: TextButton(
          onPressed: () => context.go(route),
          style: TextButton.styleFrom(
            minimumSize: const Size(48, 48),
            padding: EdgeInsets.symmetric(
              horizontal: compact ? 12 : 16,
              vertical: 16,
            ),
            backgroundColor: selected
                ? CartelColors.yellow
                : Colors.transparent,
            foregroundColor: selected ? CartelColors.black : CartelColors.muted,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Row(
            mainAxisAlignment: compact
                ? MainAxisAlignment.center
                : MainAxisAlignment.start,
            children: [
              Icon(icon, size: 20),
              if (!compact) ...[
                const SizedBox(width: 12),
                Text(
                  label,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _help(BuildContext context) => showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Keyboard shortcuts'),
      content: const Text(
        'F1 — Open this guide\nCtrl + Home — Welcome\nTab / Shift + Tab — Move focus\nEnter / Space — Activate a focused control\nEscape — Close this dialog',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        ),
      ],
    ),
  );
}
