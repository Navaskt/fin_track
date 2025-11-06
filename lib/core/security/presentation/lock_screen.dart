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

    return Scaffold(
      appBar: AppBar(title: Text(isSetup ? loc.setPinTitle : loc.unlockTitle)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (!isSetup)
              TextField(
                controller: _pin,
                obscureText: true,
                keyboardType: TextInputType.number,
                maxLength: 6,
                decoration: InputDecoration(labelText: loc.enterPin),
                onChanged: (_) => safeSetState(() => _err = null),
              ),
            if (_err != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  _err!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
            const Spacer(),
            if (!isSetup)
              ElevatedButton(
                onPressed: () async {
                  final ok = await ref
                      .read(appLockControllerProvider.notifier)
                      .unlockWithPin(_pin.text.trim());
                  if (!ok) safeSetState(() => _err = loc.incorrectPin);
                },
                child: Text(loc.unlockButton),
              ),
            if (_biometricAvailable)
              TextButton(
                onPressed: () async {
                  final ok = await ref
                      .read(appLockControllerProvider.notifier)
                      .unlockWithBiometrics();
                  if (!ok) safeSetState(() => _err = loc.biometricFailed);
                },
                child: Text(loc.useBiometrics),
              ),
            if (isSetup)
              ElevatedButton(
                onPressed: () => context.push('/set-pin'),
                child: Text(loc.setPinTitle),
              ),
          ],
        ),
      ),
    );
  }
}
