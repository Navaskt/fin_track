// lib/core/widgets/safe_set_state_mixin.dart
import 'package:flutter/material.dart';

mixin SafeSetState<T extends StatefulWidget> on State<T> {
  void safeSetState(VoidCallback fn) {
    if (!mounted) return;
    setState(fn);
  }
}
