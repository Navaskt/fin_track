import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app_lock_providers.dart';

class AppLockLifecycle with WidgetsBindingObserver {
  AppLockLifecycle(this.ref);
  final Ref ref;

  Timer? _timer;
  static const _timeout = Duration(minutes: 3);

  void start() {
    WidgetsBinding.instance.addObserver(this);
    _arm();
  }

  void stop() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
  }

  void _arm() {
    _timer?.cancel();
    _timer = Timer(
      _timeout,
      () => ref.read(appLockControllerProvider.notifier).lock(),
    );
  }

  // Call this from any user interaction to reset timer
  void poke() => _arm();

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ref.read(appLockControllerProvider.notifier).lock();
    }
  }
}
