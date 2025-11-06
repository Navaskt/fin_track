import 'package:fin_track/app/extension/context_extension.dart';
import 'package:flutter/material.dart' hide LockState;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/widgets/safe_set_state_mixin.dart';
import '../controller/app_lock_providers.dart';

class LockScreen extends ConsumerStatefulWidget {
  const LockScreen({super.key});
  @override
  ConsumerState<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends ConsumerState<LockScreen> with SafeSetState {
  final _pin = TextEditingController();
  String? _err;
  bool _biometricAvailable = false;

  @override
  void initState() {
    super.initState();
    _initBio();
  }

  Future<void> _initBio() async {
    final svc = ref.read(appLockServiceProvider);
    final canBio = await svc.canCheckBiometrics();
    final enabled = await svc.isBiometricsEnabled();
    safeSetState(() => _biometricAvailable = canBio && enabled);
  }

  @override
  void dispose() {
    _pin.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lockState = ref.watch(appLockControllerProvider);
    final isSetup = lockState == LockState.setupRequired;
    final loc = context.loc;
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(isSetup ? loc.setPinTitle : loc.unlockTitle),
        toolbarHeight: 64,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header
                  if (!isSetup) ...[
                    Text(
                      loc.enterPin,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      loc.unlockSubtitle, // add this key in your l10n, e.g. "Enter your 6-digit PIN"
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // PIN field
                  if (!isSetup)
                    TextField(
                      controller: _pin,
                      obscureText: true,
                      obscuringCharacter: '•',
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                      maxLength: 6,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineSmall,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.lock_outline),
                        labelText: loc.enterPin,
                        hintText: '••••••',
                        counterText: '',
                        helperText: loc.pinHelper, // e.g. "6 digits"
                        errorText: _err, // show error inside the field
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: cs.primary, width: 2),
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                      ),
                      onChanged: (_) => safeSetState(() => _err = null),
                    ),

                  const SizedBox(height: 12),

                  // Primary action
                  if (!isSetup)
                    Semantics(
                      button: true,
                      label: loc.unlockButton,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                        onPressed: () async {
                          final ok = await ref
                              .read(appLockControllerProvider.notifier)
                              .unlockWithPin(_pin.text.trim());
                          if (!ok) safeSetState(() => _err = loc.incorrectPin);
                        },
                        child: Text(loc.unlockButton),
                      ),
                    ),

                  // Biometric action
                  if (_biometricAvailable) ...[
                    const SizedBox(height: 8),
                    Semantics(
                      button: true,
                      label: loc.useBiometrics,
                      child: TextButton.icon(
                        icon: const Icon(Icons.fingerprint),
                        onPressed: () async {
                          final ok = await ref
                              .read(appLockControllerProvider.notifier)
                              .unlockWithBiometrics();
                          if (!ok) safeSetState(() => _err = loc.biometricFailed);
                        },
                        label: Text(loc.useBiometrics),
                      ),
                    ),
                  ],

                  // Setup state
                  if (isSetup) ...[
                    const SizedBox(height: 8),
                    Text(
                      loc.setPinSubtitle, // add this key, e.g. "Secure your app with a PIN"
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
                    ),
                    const SizedBox(height: 24),
                    Semantics(
                      button: true,
                      label: loc.setPinTitle,
                      child: FilledButton.tonal(
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                        onPressed: () => context.push('/set-pin'),
                        child: Text(loc.setPinTitle),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
