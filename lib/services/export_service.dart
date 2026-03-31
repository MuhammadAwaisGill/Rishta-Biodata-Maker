import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';

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
      final directory = await getExternalStorageDirectory();
      if (directory == null) return null;

      final fileName =
          'biodata_${DateTime.now().millisecondsSinceEpoch}.png';
      final file = File('${directory.path}/$fileName');
      await file.writeAsBytes(bytes);

      return file.path;
    } catch (e) {
      return null;
    }
  }
}