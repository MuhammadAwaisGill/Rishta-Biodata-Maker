import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import '../core/utils/permission_handler.dart';

class ImageService {
  final _picker = ImagePicker();

  Future<File?> pickFromGallery() async {
    final granted = await PermissionService.requestPhotos();
    if (!granted) return null;

    final XFile? picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );

    if (picked == null) return null;
    return _copyToPermanentStorage(File(picked.path));
  }

  Future<File?> pickFromCamera() async {
    final granted = await PermissionService.requestCamera();
    if (!granted) return null;

    final XFile? picked = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 85,
    );

    if (picked == null) return null;
    return _copyToPermanentStorage(File(picked.path));
  }

  /// Copies image from cache/temp to app's permanent documents directory.
  /// This ensures the photo survives device reboots and app cache clears.
  Future<File?> _copyToPermanentStorage(File source) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final photosDir = Directory('${dir.path}/biodata_photos');
      if (!photosDir.existsSync()) {
        photosDir.createSync(recursive: true);
      }

      final fileName =
          'photo_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final dest = File('${photosDir.path}/$fileName');
      await source.copy(dest.path);
      return dest;
    } catch (e) {
      debugPrint('ImageService._copyToPermanentStorage error: $e');
      // Fall back to original path if copy fails
      return source;
    }
  }
}