import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme.dart';
import '../../shared/panel.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: const EdgeInsets.all(32),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'THE COUNTER STARTS HERE',
          style: TextStyle(
            color: CartelColors.muted,
            fontSize: 11,
            letterSpacing: 2,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 24),
        LayoutBuilder(
          builder: (context, constraints) {
            final brand = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'CRUNCH\nCARTEL',
                  style: TextStyle(
                    fontSize: constraints.maxWidth > 800 ? 76 : 52,
                    fontWeight: FontWeight.w900,
                    height: .92,
                    letterSpacing: -3,
                    color: CartelColors.yellow,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Your counter. Under control.',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Orders, stock and the bigger picture.\nOne home for your restaurant.',
                  style: TextStyle(color: CartelColors.muted, height: 1.6),
                ),
              ],
            );
            final status = Panel(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(
                        Icons.construction_outlined,
                        color: CartelColors.yellow,
                        size: 20,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'A first look',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Explore the workspace',
                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'This preview introduces the look and layout. Accounts, saved data and live transactions are coming next.',
                    style: TextStyle(color: CartelColors.muted, height: 1.6),
                  ),
                  const SizedBox(height: 20),
                  OutlinedButton.icon(
                    onPressed: () => context.go('/setup'),
                    icon: const Icon(Icons.arrow_forward, size: 18),
                    label: const Text('View setup guide'),
                  ),
                ],
              ),
            );
            if (constraints.maxWidth < 780)
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [brand, const SizedBox(height: 24), status],
              );
            return Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(flex: 6, child: brand),
                const SizedBox(width: 32),
                Expanded(flex: 4, child: status),
              ],
            );
          },
        ),
        const SizedBox(height: 36),
        const Divider(),
        const SizedBox(height: 24),
        const Row(
          children: [
            Text(
              'TWO SPACES. CLEAR RESPONSIBILITIES.',
              style: TextStyle(
                fontSize: 11,
                letterSpacing: 1.3,
                color: CartelColors.muted,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            final counter = _WorkspaceCard(
              icon: Icons.point_of_sale_rounded,
              title: 'The counter',
              role: 'CASHIER',
              description:
                  'Take orders, record payments and keep delivery moving.',
              button: 'Preview counter',
              onPressed: () => context.go('/preview/counter'),
              primary: true,
            );
            final manager = _WorkspaceCard(
              icon: Icons.space_dashboard_outlined,
              title: 'The bigger picture',
              role: 'MANAGER',
              description:
                  'Manage the menu, stock, staff and restaurant finances.',
              button: 'Preview management',
              onPressed: () => context.go('/preview/manager'),
            );
            if (constraints.maxWidth < 700)
              return Column(
                children: [counter, const SizedBox(height: 16), manager],
              );
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: counter),
                const SizedBox(width: 20),
                Expanded(child: manager),
              ],
            );
          },
        ),
        const SizedBox(height: 24),
        const Text(
          'Preview navigation does not sign you in. Each staff member will use their own PIN.',
          style: TextStyle(color: CartelColors.muted, fontSize: 12),
        ),
      ],
    ),
  );
}

class _WorkspaceCard extends StatelessWidget {
  const _WorkspaceCard({
    required this.icon,
    required this.title,
    required this.role,
    required this.description,
    required this.button,
    required this.onPressed,
    this.primary = false,
  });
  final IconData icon;
  final String title;
  final String role;
  final String description;
  final String button;
  final VoidCallback onPressed;
  final bool primary;

  @override
  Widget build(BuildContext context) => Panel(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: CartelColors.yellow, size: 24),
            const Spacer(),
            Text(
              role,
              style: const TextStyle(
                fontSize: 10,
                letterSpacing: 1.5,
                color: CartelColors.muted,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        Text(description, style: const TextStyle(color: CartelColors.muted)),
        const SizedBox(height: 20),
        if (primary)
          FilledButton.icon(
            onPressed: onPressed,
            icon: const Icon(Icons.arrow_forward, size: 18),
            label: Text(button),
          )
        else
          OutlinedButton.icon(
            onPressed: onPressed,
            icon: const Icon(Icons.arrow_forward, size: 18),
            label: Text(button),
          ),
      ],
    ),
  );
}

class CounterPreviewPage extends StatelessWidget {
  const CounterPreviewPage({super.key});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(24),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const PageHeading(
          'CASHIER WORKSPACE',
          'Ready for the first order.',
          'Counter preview • No active cashier or open shift',
        ),
        const SizedBox(height: 20),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final cartWidth = constraints.maxWidth < 850 ? 280.0 : 340.0;
              return Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Panel(
                      child: Center(
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(20),
                                decoration: const BoxDecoration(
                                  color: CartelColors.raised,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.lunch_dining_outlined,
                                  size: 44,
                                  color: CartelColors.yellow,
                                ),
                              ),
                              const SizedBox(height: 24),
                              Text(
                                'Your menu belongs here.',
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              const SizedBox(height: 12),
                              const ConstrainedBoxWithText(
                                'Menu items will appear after a Manager sets up products and their recipes. No sample products are loaded.',
                              ),
                              const SizedBox(height: 24),
                              OutlinedButton(
                                onPressed: () => context.go('/setup'),
                                child: const Text('See what comes first'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  SizedBox(
                    width: cartWidth,
                    child: Panel(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Current order',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              SizedBox(width: 8),
                              Icon(
                                Icons.receipt_long_outlined,
                                color: CartelColors.muted,
                                size: 20,
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          const Divider(),
                          const Expanded(
                            child: Center(
                              child: Text(
                                'No order started',
                                style: TextStyle(color: CartelColors.muted),
                              ),
                            ),
                          ),
                          const Divider(),
                          const SizedBox(height: 12),
                          const Row(
                            children: [
                              Text(
                                'TOTAL',
                                style: TextStyle(
                                  fontSize: 11,
                                  letterSpacing: 1.5,
                                  color: CartelColors.muted,
                                ),
                              ),
                              Spacer(),
                              Text(
                                'Rs. —',
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          const FilledButton(
                            onPressed: null,
                            child: Text('Checkout unavailable'),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Requires setup, cashier sign-in and an open shift.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12,
                              color: CartelColors.muted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    ),
  );
}

class ConstrainedBoxWithText extends StatelessWidget {
  const ConstrainedBoxWithText(this.text, {super.key});
  final String text;
  @override
  Widget build(BuildContext context) => ConstrainedBox(
    constraints: const BoxConstraints(maxWidth: 350),
    child: Text(
      text,
      textAlign: TextAlign.center,
      style: const TextStyle(color: CartelColors.muted, height: 1.6),
    ),
  );
}

class ManagerPreviewPage extends StatelessWidget {
  const ManagerPreviewPage({super.key});

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: const EdgeInsets.all(32),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const PageHeading(
          'MANAGER WORKSPACE',
          'See the whole restaurant.',
          'Administration and oversight. Billing stays with the Cashier.',
        ),
        const SizedBox(height: 28),
        Panel(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.flag_outlined, color: CartelColors.yellow),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Start with a strong foundation.',
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'The setup guide covers accounts, recipes and the first business day. Live management tools will be added in the next development chunks.',
                      style: TextStyle(color: CartelColors.muted),
                    ),
                    const SizedBox(height: 20),
                    FilledButton(
                      onPressed: () => context.go('/setup'),
                      child: const Text('View setup guide'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 28),
        const Text(
          'YOUR MANAGEMENT TOOLKIT',
          style: TextStyle(
            fontSize: 11,
            color: CartelColors.muted,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth > 850
                ? (constraints.maxWidth - 32) / 3
                : (constraints.maxWidth - 16) / 2;
            return Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                for (final item in const [
                  (
                    Icons.restaurant_menu,
                    'Menu & recipes',
                    'Products, deals and ingredients',
                  ),
                  (
                    Icons.inventory_2_outlined,
                    'Stock & suppliers',
                    'Purchases, balances and Khata',
                  ),
                  (
                    Icons.badge_outlined,
                    'People & access',
                    'Staff accounts, PINs and payroll',
                  ),
                  (
                    Icons.account_balance_wallet_outlined,
                    'Cash & expenses',
                    'Business days and reconciliation',
                  ),
                  (
                    Icons.bar_chart_rounded,
                    'Reports',
                    'Sales, costs and source records',
                  ),
                  (
                    Icons.backup_outlined,
                    'Backup & recovery',
                    'Protect and restore local records',
                  ),
                ])
                  SizedBox(
                    width: width,
                    child: Panel(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(item.$1, color: CartelColors.yellow),
                          const SizedBox(height: 16),
                          Text(
                            item.$2,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            item.$3,
                            style: const TextStyle(
                              color: CartelColors.muted,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'PLANNED',
                            style: TextStyle(
                              fontSize: 10,
                              letterSpacing: 1.4,
                              color: CartelColors.muted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    ),
  );
}

class SetupPreviewPage extends StatelessWidget {
  const SetupPreviewPage({super.key});

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: const EdgeInsets.all(32),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const PageHeading(
          'BEFORE YOUR FIRST SALE',
          'A clear path to opening.',
          'This is a guide. The setup wizard is not available in this preview.',
        ),
        const SizedBox(height: 28),
        for (final step in const [
          (
            '01',
            'Make it yours',
            'Confirm Crunch Cartel, PKR, local storage and backup location. Initial prices include tax at 0% until the Manager configures a verified rate.',
          ),
          (
            '02',
            'Create your Manager',
            'Set a unique Manager PIN for menu, staff, stock, settings and oversight.',
          ),
          (
            '03',
            'Create your primary Cashier counter profile and 4-digit PIN.',
            'A separate enabled Cashier is required. The Manager account cannot take customer orders or payments.',
          ),
          (
            '04',
            'Build a menu with recipes',
            'Each sellable item and deal needs a complete recipe. Menu setup can be deferred, but incomplete items cannot be sold.',
          ),
          (
            '05',
            'Open the day, then the counter',
            'The Manager opens the business day. Switch to the Cashier, sign in and open a shift with its starting float.',
          ),
        ])
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Panel(
              padding: const EdgeInsets.all(20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    step.$1,
                    style: const TextStyle(
                      fontSize: 22,
                      color: CartelColors.yellow,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          step.$2,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          step.$3,
                          style: const TextStyle(color: CartelColors.muted),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    ),
  );
}
