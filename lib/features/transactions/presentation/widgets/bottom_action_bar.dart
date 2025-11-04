import 'package:flutter/material.dart';

class BottomActionBar extends StatelessWidget {
  const BottomActionBar({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(top: BorderSide(color: cs.outlineVariant)),
        boxShadow: const [
          BoxShadow(
            blurRadius: 8,
            spreadRadius: 0,
            offset: Offset(0, -2),
            color: Color(0x14000000),
          ),
        ],
      ),
      child: SafeArea(top: false, child: child),
    );
  }
}
