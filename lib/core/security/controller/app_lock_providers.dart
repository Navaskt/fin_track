import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../app_lock_service.dart';

final appLockServiceProvider = Provider<AppLockService>(
  (ref) => AppLockService(),
);

enum LockState { locked, unlocked, setupRequired }

class AppLockController extends StateNotifier<LockState> {
  AppLockController(this._service) : super(LockState.locked);

  final AppLockService _service;

  Future<void> refresh() async {
    final hasPin = await _service.hasPin();
    state = hasPin ? LockState.locked : LockState.setupRequired;
  }

  Future<bool> unlockWithPin(String pin) async {
    final ok = await _service.verifyPin(pin);
    if (ok) state = LockState.unlocked;
    return ok;
  }

  Future<bool> unlockWithBiometrics() async {
    if (!await _service.isBiometricsEnabled()) return false;
    final ok = await _service.tryBiometricAuth();
    if (ok) state = LockState.unlocked;
    return ok;
  }

  Future<void> setPin(String pin) async {
    await _service.setPin(pin);
    state = LockState.unlocked;
  }

  Future<void> lock() async {
    state = LockState.locked;
  }
}

final appLockControllerProvider =
    StateNotifierProvider<AppLockController, LockState>((ref) {
      final service = ref.read(appLockServiceProvider);
      final c = AppLockController(service);
      // Kick initial state
      c.refresh();
      return c;
    });
