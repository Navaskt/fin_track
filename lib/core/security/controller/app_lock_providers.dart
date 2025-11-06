import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../app_lock_service.dart';

final appLockServiceProvider = Provider<AppLockService>(
  (ref) => AppLockService(),
);

enum LockState { locked, unlocked, setupRequired }

class AppLockController extends StateNotifier<LockState> {
  AppLockController(this._service) : super(LockState.locked) {
    _init();
  }

  final AppLockService _service;
  bool _busy = false;

  Future<void> _init() async {
    try {
      final hasPin = await _service.hasPin();
      if (!mounted) return;
      state = hasPin ? LockState.locked : LockState.setupRequired;
    } catch (_) {
      // Stay conservative if something fails
      if (!mounted) return;
      state = LockState.locked;
    }
  }

  Future<void> refresh() => _init();

  Future<bool> unlockWithPin(String pin) async {
    if (_busy) return false;
    final p = pin.trim();
    if (p.isEmpty) return false;

    _busy = true;
    try {
      final ok = await _service.verifyPin(p);
      if (ok && mounted) state = LockState.unlocked;
      return ok;
    } catch (_) {
      return false;
    } finally {
      _busy = false;
    }
  }

  Future<bool> unlockWithBiometrics() async {
    if (_busy) return false;

    _busy = true;
    try {
      final canBio = await _service.canCheckBiometrics();
      final enabled = await _service.isBiometricsEnabled();
      if (!canBio || !enabled) return false;

      final ok = await _service.tryBiometricAuth();
      if (ok && mounted) state = LockState.unlocked;
      return ok;
    } catch (_) {
      return false;
    } finally {
      _busy = false;
    }
  }

  Future<void> setPin(String pin) async {
    final p = pin.trim();
    if (p.length < 4) {
      throw ArgumentError('pin too short');
    }
    try {
      await _service.setPin(p);
      if (mounted) state = LockState.unlocked;
    } catch (_) {
      // Keep current state if set fails
    }
  }

  Future<void> lock() async {
    if (!mounted) return;
    state = LockState.locked;
  }
}

final appLockControllerProvider =
    StateNotifierProvider<AppLockController, LockState>((ref) {
      final service = ref.read(appLockServiceProvider);
      return AppLockController(service);
    });
