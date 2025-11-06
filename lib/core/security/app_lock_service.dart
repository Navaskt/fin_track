import 'dart:convert';
import 'dart:math';
import 'package:cryptography/cryptography.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';

class AppLockService {
  AppLockService({
    FlutterSecureStorage? storage,
    LocalAuthentication? localAuth,
  }) : _storage = storage ?? const FlutterSecureStorage(),
       _localAuth = localAuth ?? LocalAuthentication();

  static const _kPinHash = 'app_pin_hash';
  static const _kPinSalt = 'app_pin_salt';
  static const _kBiometricsEnabled = 'biometrics_enabled';
  static const _iterations = 150000; // PBKDF2 rounds

  final FlutterSecureStorage _storage;
  final LocalAuthentication _localAuth;

  Future<bool> hasPin() async {
    final hash = await _storage.read(key: _kPinHash);
    return hash != null && hash.isNotEmpty;
    // If you need a forced-lock without a PIN set, handle at caller.
  }

  // Create or change PIN
  Future<void> setPin(String pin) async {
    final salt = _randomBytes(16);
    final hash = await _pbkdf2Hash(pin, salt);
    await _storage.write(key: _kPinSalt, value: base64Encode(salt));
    await _storage.write(key: _kPinHash, value: base64Encode(hash));
  }

  // Verify user input PIN
  Future<bool> verifyPin(String pin) async {
    final saltB64 = await _storage.read(key: _kPinSalt);
    final hashB64 = await _storage.read(key: _kPinHash);
    if (saltB64 == null || hashB64 == null) return false;

    final salt = base64Decode(saltB64);
    final storedHash = base64Decode(hashB64);
    final candidate = await _pbkdf2Hash(pin, salt);

    // constant-time compare
    if (candidate.length != storedHash.length) return false;
    var diff = 0;
    for (var i = 0; i < candidate.length; i++) {
      diff |= candidate[i] ^ storedHash[i];
    }
    return diff == 0;
  }

  Future<void> clearPin() async {
    await _storage.delete(key: _kPinSalt);
    await _storage.delete(key: _kPinHash);
  }

  Future<bool> canCheckBiometrics() async {
    try {
      return await _localAuth.canCheckBiometrics ||
          await _localAuth.isDeviceSupported();
    } on PlatformException {
      return false;
    }
  }

  Future<void> setBiometricsEnabled(bool enabled) async {
    await _storage.write(key: _kBiometricsEnabled, value: enabled ? '1' : '0');
  }

  Future<bool> isBiometricsEnabled() async {
    return (await _storage.read(key: _kBiometricsEnabled)) == '1';
  }

  Future<bool> tryBiometricAuth({String reason = 'Unlock FinTrack'}) async {
    try {
      final ok = await _localAuth.authenticate(
        localizedReason: reason,
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
          useErrorDialogs: true,
        ),
      );
      return ok;
    } on PlatformException {
      return false;
    }
  }

  // --- internals ---
  List<int> _randomBytes(int length) {
    final rng = Random.secure();
    return List<int>.generate(length, (_) => rng.nextInt(256));
  }

  Future<List<int>> _pbkdf2Hash(String pin, List<int> salt) async {
    final algo = Pbkdf2(
      macAlgorithm: Hmac.sha256(),
      iterations: _iterations,
      bits: 256,
    );
    final secretKey = SecretKey(utf8.encode(pin));
    final newKey = await algo.deriveKey(secretKey: secretKey, nonce: salt);
    return await newKey.extractBytes();
  }
}
