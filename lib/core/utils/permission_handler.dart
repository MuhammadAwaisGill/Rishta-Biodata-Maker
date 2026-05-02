import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  PermissionService._();

  static Future<PermissionResult> requestCamera() async {
    final status = await Permission.camera.request();
    return _toResult(status);
  }

  static Future<PermissionResult> requestStorage() async {
    final status = await Permission.storage.request();
    return _toResult(status);
  }

  static Future<PermissionResult> requestPhotos() async {
    // Android 13+ uses READ_MEDIA_IMAGES; older uses storage/photos.
    // The gal package handles its own runtime permission on Android 13+,
    // so this is only called for camera/gallery picker flows.
    if (await Permission.photos.isGranted) return PermissionResult.granted;
    if (await Permission.mediaLibrary.isGranted) return PermissionResult.granted;

    final status = await Permission.photos.request();
    if (status.isGranted) return PermissionResult.granted;
    if (status.isPermanentlyDenied) return PermissionResult.permanentlyDenied;

    final status2 = await Permission.mediaLibrary.request();
    if (status2.isGranted) return PermissionResult.granted;
    if (status2.isPermanentlyDenied) return PermissionResult.permanentlyDenied;

    return PermissionResult.denied;
  }

  static Future<void> openSettings() async {
    await openAppSettings();
  }

  static PermissionResult _toResult(PermissionStatus status) {
    if (status.isGranted)           return PermissionResult.granted;
    if (status.isPermanentlyDenied) return PermissionResult.permanentlyDenied;
    return PermissionResult.denied;
  }
}

enum PermissionResult {
  granted,
  denied,
  permanentlyDenied,
}