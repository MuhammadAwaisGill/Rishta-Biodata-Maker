import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

class ExportService {

  Future<Uint8List?> captureAsImage(GlobalKey key) async {
    try {
      final boundary = key.currentContext?.findRenderObject()
      as RenderRepaintBoundary?;
      if (boundary == null) return null;

      final image = await boundary.toImage(pixelRatio: 2.0);
      final byteData = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );
      return byteData?.buffer.asUint8List();
    } catch (e) {
      return null;
    }
  }

  Future<String?> saveToGallery(Uint8List bytes) async {
    try {
      final result = await ImageGallerySaver.saveImage(
        bytes,
        quality: 95,
        name: 'biodata_${DateTime.now().millisecondsSinceEpoch}',
      );
      if (result['isSuccess'] == true) {
        return result['filePath'] as String?;
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}