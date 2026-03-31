import 'dart:io';
import 'package:image_picker/image_picker.dart';
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
    return File(picked.path);
  }

  Future<File?> pickFromCamera() async {
    final granted = await PermissionService.requestCamera();
    if (!granted) return null;

    final XFile? picked = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 85,
    );

    if (picked == null) return null;
    return File(picked.path);
  }
}