import 'package:fin_track/app/extension/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/security/controller/app_lock_providers.dart';

class BiometricsTile extends ConsumerWidget {
  const BiometricsTile({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = context.loc;
    return FutureBuilder<bool>(
      future: ref.read(appLockServiceProvider).isBiometricsEnabled(),
      builder: (context, snap) {
        final enabled = snap.data ?? false;
        return SwitchListTile(
          title: Text(loc.biometricsTitle),
          value: enabled,
          onChanged: (v) async {
            final svc = ref.read(appLockServiceProvider);
            if (v && !(await svc.canCheckBiometrics())) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(loc.biometricsNotAvailable)),
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
