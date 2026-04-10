import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  PermissionService._();

  static Future<bool> requestCamera() async {
    final status = await Permission.camera.request();
    return status.isGranted;
  }

  static Future<bool> requestStorage() async {
    final status = await Permission.storage.request();
    return status.isGranted;
  }

  static Future<void> openSettings() async {
    await openAppSettings();
  }

  static Future<bool> requestPhotos() async {
    if (await Permission.photos.isGranted) return true;
    if (await Permission.mediaLibrary.isGranted) return true;

    final status = await Permission.photos.request();
    if (status.isGranted) return true;

    final status2 = await Permission.mediaLibrary.request();
    return status2.isGranted;
  }
}