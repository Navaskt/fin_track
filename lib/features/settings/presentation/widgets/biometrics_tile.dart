import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/security/controller/app_lock_providers.dart';

class BiometricsTile extends ConsumerWidget {
  const BiometricsTile({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<bool>(
      future: ref.read(appLockServiceProvider).isBiometricsEnabled(),
      builder: (context, snap) {
        final enabled = snap.data ?? false;
        return SwitchListTile(
          title: const Text('Use biometrics to unlock'),
          value: enabled,
          onChanged: (v) async {
            final svc = ref.read(appLockServiceProvider);
            if (v && !(await svc.canCheckBiometrics())) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Biometrics not available')),
              );
              return;
            }
            await svc.setBiometricsEnabled(v);
          },
        );
      },
    );
  }
}
