import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pos_domain/access_policy.dart';
import '../../app/theme.dart';
import 'access_controller.dart';

class AccessPage extends ConsumerStatefulWidget {
  const AccessPage({super.key});
  @override
  ConsumerState<AccessPage> createState() => _AccessPageState();
}

class _AccessPageState extends ConsumerState<AccessPage>
    with WidgetsBindingObserver {
  late final AccessController controller;
  final managerName = TextEditingController();
  final cashierName = TextEditingController();
  final managerPin = TextEditingController();
  final managerConfirmation = TextEditingController();
  final cashierPin = TextEditingController();
  final cashierConfirmation = TextEditingController();
  final loginPin = TextEditingController();
  String? selectedStaff;
  bool revealRecovery = false;

  @override
  void initState() {
    super.initState();
    controller = ref.read(accessControllerProvider);
    WidgetsBinding.instance.addObserver(this);
    unawaited(controller.start());
  }

  void clearPins() {
    for (final field in [
      managerPin,
      managerConfirmation,
      cashierPin,
      cashierConfirmation,
      loginPin,
    ]) {
      field.clear();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) {
      clearPins();
      revealRecovery = false;
      controller.lock();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    controller.lock();
    for (final field in [
      managerName,
      cashierName,
      managerPin,
      managerConfirmation,
      cashierPin,
      cashierConfirmation,
      loginPin,
    ]) {
      field.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: controller,
    builder: (context, _) => Listener(
      onPointerDown: (_) => unawaited(controller.inspect(activity: true)),
      child: Focus(
        onKeyEvent: (_, event) {
          if (event is KeyDownEvent)
            unawaited(controller.inspect(activity: true));
          return KeyEventResult.ignored;
        },
        child: Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(32),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 880),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Row(
                        children: [
                          Icon(
                            Icons.bolt,
                            size: 42,
                            color: CartelColors.yellow,
                          ),
                          SizedBox(width: 12),
                          Text(
                            'CRUNCH CARTEL',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'WINDOWS  /  PRIVATE LOCAL WORKSPACE',
                        style: TextStyle(
                          color: CartelColors.muted,
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 32),
                      if (controller.busy) const LinearProgressIndicator(),
                      if (controller.error != null)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Semantics(
                            liveRegion: true,
                            child: Text(
                              controller.error!,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.error,
                              ),
                            ),
                          ),
                        ),
                      ...content(),
                      const SizedBox(height: 32),
                      const Divider(),
                      const Text(
                        'Early access • Setup and sign-in are available. Sales, shifts and day opening are not enabled yet.',
                        style: TextStyle(color: CartelColors.muted),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );

  Widget heading(String title, String description) => Padding(
    padding: const EdgeInsets.only(bottom: 24),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.headlineLarge),
        const SizedBox(height: 12),
        Text(description),
      ],
    ),
  );
  Widget card(List<Widget> children) => Container(
    padding: const EdgeInsets.all(24),
    margin: const EdgeInsets.only(bottom: 16),
    decoration: BoxDecoration(
      color: CartelColors.panel,
      border: Border.all(color: CartelColors.line),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Material(color: Colors.transparent, child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: children,
    )),
  );
  Widget field(
    String label,
    TextEditingController value, {
    int? pinLength,
    VoidCallback? submit,
  }) => Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: TextField(
      controller: value,
      enabled: !controller.busy,
      obscureText: pinLength != null,
      autocorrect: false,
      enableSuggestions: false,
      maxLength: pinLength ?? 100,
      keyboardType: pinLength == null
          ? TextInputType.name
          : TextInputType.number,
      inputFormatters: pinLength == null
          ? null
          : [FilteringTextInputFormatter.digitsOnly],
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        counterText: '',
      ),
      onSubmitted: submit == null ? null : (_) => submit(),
    ),
  );

  List<Widget> content() {
    switch (controller.stage) {
      case AccessStage.loading:
        return [
          heading(
            'Opening your workspace.',
            'Checking protected storage and installation identity.',
          ),
        ];
      case AccessStage.storageError:
        return [
          heading(
            'Storage needs attention.',
            'Close Crunch Cartel and contact your support person. Keep the existing data folder and recovery kit safe. There is no automatic reset.',
          ),
        ];
      case AccessStage.recovery:
        return recoveryContent();
      case AccessStage.accounts:
        return [
          heading(
            'Two profiles. Clear responsibilities.',
            'Create your Manager first, then the required primary Cashier. PINs must be different.',
          ),
          card([
            Text(
              'Create your first Manager',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            field('Manager name', managerName),
            field('Manager PIN (4–8 digits)', managerPin, pinLength: 8),
            field('Confirm Manager PIN', managerConfirmation, pinLength: 8),
          ]),
          card([
            Text(
              'Create your primary Cashier counter profile and 4-digit PIN.',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            field('Cashier name', cashierName),
            field('Cashier PIN (4 digits)', cashierPin, pinLength: 4),
            field(
              'Confirm Cashier PIN',
              cashierConfirmation,
              pinLength: 4,
              submit: saveAccounts,
            ),
          ]),
          FilledButton(
            onPressed: controller.busy ? null : saveAccounts,
            child: const Text('Create profiles and continue to sign-in'),
          ),
        ];
      case AccessStage.login:
        final profiles = controller.overview!.profiles;
        if (!profiles.any((staff) => staff.id == selectedStaff))
          selectedStaff = profiles.firstOrNull?.id;
        return [
          heading(
            'Your shift starts with you.',
            'Choose your profile and enter your PIN. Manager access stays separate from the counter.',
          ),
          card([
            DropdownButtonFormField<String>(
              key: ValueKey(selectedStaff),
              initialValue: selectedStaff,
              decoration: const InputDecoration(
                labelText: 'Staff profile',
                border: OutlineInputBorder(),
              ),
              isExpanded: true,
              items: profiles
                  .map(
                    (staff) => DropdownMenuItem(
                      value: staff.id,
                      child: Text(
                        '${staff.displayName} · ${staff.role == StaffRole.manager ? 'Manager' : 'Cashier'}',
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  )
                  .toList(),
              onChanged: controller.busy
                  ? null
                  : (value) => setState(() {
                      selectedStaff = value;
                      loginPin.clear();
                    }),
            ),
            const SizedBox(height: 24),
            field('PIN', loginPin, pinLength: 8, submit: signIn),
            FilledButton(
              onPressed: controller.busy || selectedStaff == null
                  ? null
                  : signIn,
              child: const Text('Sign in'),
            ),
            if (profiles.isEmpty)
              const Text(
                'No enabled profiles. Contact support using your secured recovery procedure.',
              ),
          ]),
        ];
      case AccessStage.workspace:
        final access = controller.workspace!;
        final manager = access.staff.role == StaffRole.manager;
        return [
          heading(
            'Welcome, ${access.staff.displayName}.',
            manager
                ? 'MANAGER • Restaurant readiness'
                : 'CASHIER • Counter readiness',
          ),
          if (manager && !access.hasEnabledCashier)
            card([
              const Text('No active cashier — create one'),
              const Text(
                'Credential administration is not available in this build.',
              ),
            ]),
          card([
            Text(
              manager
                  ? 'Prepare the restaurant for service.'
                  : 'Your counter is waiting for setup.',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            const Text('01  Menu and validated recipes — pending'),
            const SizedBox(height: 12),
            const Text('02  Manager opens a business day — pending'),
            const SizedBox(height: 12),
            const Text(
              '03  Cashier opens a shift and records opening float — pending',
            ),
            const SizedBox(height: 16),
            const Text(
              'These workflows arrive in the next implementation chunks. No saleable items or transactions have been created.',
            ),
          ]),
          if (!manager)
            const FilledButton(
              onPressed: null,
              child: Text('Billing unavailable until readiness is complete'),
            ),
          OutlinedButton(
            onPressed: controller.lock,
            child: Text(
              manager ? 'Switch to Cashier' : 'Lock and switch profile',
            ),
          ),
        ];
    }
  }

  List<Widget> recoveryContent() {
    final recovery = controller.recovery;
    return [
      heading(
        'Make this your restaurant.',
        'Confirm the installation details and secure your recovery kit before creating staff profiles.',
      ),
      card([
        Text('Crunch Cartel', style: Theme.of(context).textTheme.titleLarge),
        const Text('Business currency: PKR  •  Initial tax: inclusive, 0%'),
        const SizedBox(height: 16),
        SelectableText(
          'Protected local storage\n${controller.overview!.storagePath}',
        ),
        const SizedBox(height: 12),
        SelectableText(
          'Local migration backups\n${controller.overview!.backupPath}',
        ),
        const SizedBox(height: 12),
        const Text(
          'Local snapshots do not protect against drive loss. External encrypted backups and restore setup are still pending.',
        ),
      ]),
      card([
        Text(
          'Keep your recovery kit offline.',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        const Text(
          'Save both values separately from the computer and its backups. Anyone with the kit can recover the installation key. This is not a staff PIN or a PIN-reset shortcut.',
        ),
        const SizedBox(height: 16),
        if (recovery == null)
          OutlinedButton(
            onPressed: controller.busy ? null : controller.prepareRecovery,
            child: const Text('Prepare recovery kit'),
          ),
        if (recovery?.alreadySaved == true)
          const Text(
            'Setup was interrupted after the key was saved. Confirm you still have the original recovery kit. It cannot be displayed again; do not continue if it is lost.',
          ),
        if (recovery != null && !recovery.alreadySaved) ...[
          OutlinedButton(
            onPressed: () => setState(() => revealRecovery = !revealRecovery),
            child: Text(
              revealRecovery ? 'Hide recovery kit' : 'Reveal recovery kit',
            ),
          ),
          if (revealRecovery) ...[
            const SizedBox(height: 16),
            SelectableText(
              'Recovery code\n${recovery.code}\n\nEncrypted key envelope\n${recovery.envelope}',
            ),
          ],
        ],
        CheckboxListTile(
          contentPadding: EdgeInsets.zero,
          value: controller.acknowledged,
          onChanged: controller.busy || recovery == null
              ? null
              : (value) => controller.acknowledge(value ?? false),
          title: const Text(
            'I saved both recovery values securely, away from this computer.',
          ),
        ),
      ]),
      FilledButton(
        onPressed: controller.busy || !controller.acknowledged
            ? null
            : controller.continueSetup,
        child: const Text('Continue to staff profiles'),
      ),
    ];
  }

  void saveAccounts() {
    final manager = managerPin.text, managerCheck = managerConfirmation.text;
    final cashier = cashierPin.text, cashierCheck = cashierConfirmation.text;
    clearPins();
    unawaited(
      controller.finishSetup(
        managerName: managerName.text,
        managerPin: manager,
        managerConfirmation: managerCheck,
        cashierName: cashierName.text,
        cashierPin: cashier,
        cashierConfirmation: cashierCheck,
      ),
    );
  }

  void signIn() {
    final pin = loginPin.text;
    loginPin.clear();
    if (selectedStaff != null)
      unawaited(controller.signIn(selectedStaff!, pin));
  }
}
