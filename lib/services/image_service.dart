import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import '../core/utils/permission_handler.dart';

/// Returned by pick methods so the UI can show the right message.
enum ImagePickResult {
  success,
  cancelled,
  permissionDenied,
  permissionPermanentlyDenied,
  error,
}

class ImagePickOutcome {
  final ImagePickResult result;
  final File? file;
  const ImagePickOutcome(this.result, {this.file});
}

class ImageService {
  final _picker = ImagePicker();

  Future<ImagePickOutcome> pickFromGallery() async {
    final perm = await PermissionService.requestPhotos();
    if (perm == PermissionResult.permanentlyDenied) {
      return const ImagePickOutcome(ImagePickResult.permissionPermanentlyDenied);
    }
    if (perm == PermissionResult.denied) {
      return const ImagePickOutcome(ImagePickResult.permissionDenied);
    }

    final XFile? picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (picked == null) return const ImagePickOutcome(ImagePickResult.cancelled);

    final dest = await _copyToPermanentStorage(File(picked.path));
    if (dest == null) return const ImagePickOutcome(ImagePickResult.error);
    return ImagePickOutcome(ImagePickResult.success, file: dest);
  }

  Future<ImagePickOutcome> pickFromCamera() async {
    final perm = await PermissionService.requestCamera();
    if (perm == PermissionResult.permanentlyDenied) {
      return const ImagePickOutcome(ImagePickResult.permissionPermanentlyDenied);
    }
    if (perm == PermissionResult.denied) {
      return const ImagePickOutcome(ImagePickResult.permissionDenied);
    }

    final XFile? picked = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 85,
    );
    if (picked == null) return const ImagePickOutcome(ImagePickResult.cancelled);

    final dest = await _copyToPermanentStorage(File(picked.path));
    if (dest == null) return const ImagePickOutcome(ImagePickResult.error);
    return ImagePickOutcome(ImagePickResult.success, file: dest);
  }

  /// Copies to app documents directory — survives reboots and cache clears.
  Future<File?> _copyToPermanentStorage(File source) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final photosDir = Directory('${dir.path}/biodata_photos');
      if (!photosDir.existsSync()) {
        photosDir.createSync(recursive: true);
      }
      final fileName = 'photo_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final dest = File('${photosDir.path}/$fileName');
      await source.copy(dest.path);
      try {
        if (source.path != dest.path && source.existsSync()) {
          source.deleteSync();
        }
      } catch (_) {}
      return dest;
    } catch (e) {
      debugPrint('ImageService._copyToPermanentStorage error: $e');
      return source;
    }
  }
}