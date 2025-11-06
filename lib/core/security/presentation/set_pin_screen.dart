import 'package:fin_track/app/extension/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controller/app_lock_providers.dart';

class SetPinScreen extends ConsumerStatefulWidget {
  const SetPinScreen({super.key});
  @override
  ConsumerState<SetPinScreen> createState() => _SetPinScreenState();
}

class _SetPinScreenState extends ConsumerState<SetPinScreen> {
  final _c1 = TextEditingController();
  final _c2 = TextEditingController();
  String? _err;

  @override
  Widget build(BuildContext context) {
    final loc = context.loc;
    return Scaffold(
      appBar: AppBar(title: Text(loc.setPinTitle)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _c1,
              obscureText: true,
              keyboardType: TextInputType.number,
              maxLength: 6,
              decoration: InputDecoration(labelText: loc.enterPin),
              onChanged: (_) => setState(() => _err = null),
            ),
            TextField(
              controller: _c2,
              obscureText: true,
              keyboardType: TextInputType.number,
              maxLength: 6,
              decoration: InputDecoration(labelText: loc.confirmPin),
              onChanged: (_) => setState(() => _err = null),
            ),
            const SizedBox(height: 16),
            if (_err != null) Text(_err!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
            const Spacer(),
            ElevatedButton(
              onPressed: () async {
                final a = _c1.text.trim();
                final b = _c2.text.trim();
                if (a.length < 4) {
                  setState(() => _err = loc.pinTooShort);
                  return;
                }
                if (a != b) {
                  setState(() => _err = loc.pinNotMatch);
                  return;
                }
                await ref.read(appLockControllerProvider.notifier).setPin(a);
                if (mounted) Navigator.of(context).pop(); // back to app
              },
              child: Text(loc.savePin),
            ),
          ],
        ),
      ),
    );
  }
}
