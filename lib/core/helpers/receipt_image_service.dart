// lib/app/core/receipt_image_service.dart
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class ReceiptImageService {
  static final _picker = ImagePicker();

  static Future<String?> pickAndSave({required bool fromCamera}) async {
    final XFile? picked = await _picker.pickImage(
      source: fromCamera ? ImageSource.camera : ImageSource.gallery,
      imageQuality: 80, // compress a bit, receipts don't need full res
    );
    if (picked == null) return null;

    final dir = await getApplicationDocumentsDirectory();
    final receiptsDir = Directory('${dir.path}/receipts');
    if (!await receiptsDir.exists()) {
      await receiptsDir.create(recursive: true);
    }

    final ext = picked.path.split('.').last;
    final fileName = '${const Uuid().v4()}.$ext';
    final savedPath = '${receiptsDir.path}/$fileName';

    await File(picked.path).copy(savedPath);
    return savedPath;
  }

  static Future<void> deleteIfExists(String? path) async {
    if (path == null) return;
    final file = File(path);
    if (await file.exists()) {
      await file.delete();
    }
  }
}