// lib/app/presentation/widgets/receipt_viewer.dart
import 'dart:io';
import 'package:flutter/material.dart';

void showFullReceipt(BuildContext context, String path) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Receipt',
    barrierColor: Colors.black87,
    transitionDuration: const Duration(milliseconds: 350),
    pageBuilder: (_, __, ___) => const SizedBox.shrink(),
    transitionBuilder: (context, anim, __, ___) {
      return FadeTransition(
        opacity: anim,
        child: ScaleTransition(
          scale: CurvedAnimation(parent: anim, curve: Curves.easeOutBack),
          child: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: Center(
                child: InteractiveViewer(
                  minScale: 0.5,
                  maxScale: 4,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(File(path)),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}