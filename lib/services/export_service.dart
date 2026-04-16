import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'package:gal/gal.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../models/biodata_model.dart';

class ExportService {

  // ── Capture widget as PNG ────────────────────────────────────────────────
  Future<Uint8List?> captureAsImage(GlobalKey key) async {
    try {
      final context = key.currentContext;
      if (context == null) {
        debugPrint('ExportService: GlobalKey context is null');
        return null;
      }

      final renderObject = context.findRenderObject();
      if (renderObject == null) {
        debugPrint('ExportService: RenderObject is null');
        return null;
      }

      if (renderObject is! RenderRepaintBoundary) {
        debugPrint('ExportService: RenderObject is not RenderRepaintBoundary');
        return null;
      }

      // Wait for any pending paint operations
      if (renderObject.debugNeedsPaint) {
        await Future.delayed(const Duration(milliseconds: 100));
      }

      final image     = await renderObject.toImage(pixelRatio: 2.0);
      final byteData  = await image.toByteData(format: ui.ImageByteFormat.png);
      image.dispose();

      return byteData?.buffer.asUint8List();
    } catch (e, st) {
      debugPrint('ExportService.captureAsImage error: $e\n$st');
      return null;
    }
  }

  // ── Save PNG to gallery ──────────────────────────────────────────────────
  Future<String?> saveToGallery(Uint8List bytes) async {
    try {
      final hasAccess = await Gal.hasAccess(toAlbum: false);
      if (!hasAccess) {
        final granted = await Gal.requestAccess(toAlbum: false);
        if (!granted) {
          debugPrint('ExportService: Gallery access denied');
          return null;
        }
      }

      final fileName = 'biodata_${DateTime.now().millisecondsSinceEpoch}';
      await Gal.putImageBytes(bytes, name: fileName);
      return 'saved';
    } catch (e, st) {
      debugPrint('ExportService.saveToGallery error: $e\n$st');
      return null;
    }
  }

  // ── Generate PDF ─────────────────────────────────────────────────────────
  Future<Uint8List?> exportAsPdf(Biodata biodata) async {
    try {
      final pdf   = pw.Document();
      final color = _getTemplateColor(biodata.templateId);

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(32),
          build: (pw.Context context) => pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header
              pw.Container(
                width: double.infinity,
                padding: const pw.EdgeInsets.all(16),
                decoration: pw.BoxDecoration(color: color),
                child: pw.Column(
                  children: [
                    pw.Text(
                      'RISHTA BIODATA',
                      style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold, color: PdfColors.white),
                    ),
                    pw.SizedBox(height: 4),
                    pw.Text('Rishta Biodata Maker', style: const pw.TextStyle(fontSize: 11, color: PdfColors.white)),
                  ],
                ),
              ),
              pw.SizedBox(height: 16),

              if (biodata.name.isNotEmpty)
                pw.Text(biodata.name, style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold, color: color)),
              pw.SizedBox(height: 12),

              _pdfSection('Personal Information', color, [
                _pdfPair('Age',            biodata.age),
                _pdfPair('Height',         biodata.height),
                _pdfPair('City',           biodata.city),
                _pdfPair('Complexion',     biodata.complexion),
                _pdfPair('Mother Tongue',  biodata.motherTongue),
                _pdfPair('Marital Status', biodata.maritalStatus),
              ]),

              _pdfSection('Education & Career', color, [
                _pdfPair('Education',  biodata.education),
                _pdfPair('Institute',  biodata.institute),
                _pdfPair('Profession', biodata.profession),
                _pdfPair('Salary',     biodata.salary),
              ]),

              _pdfSection('Family Information', color, [
                _pdfPair("Father's Name", biodata.fatherName),
                _pdfPair("Father's Job",  biodata.fatherProfession),
                _pdfPair("Mother's Name", biodata.motherName),
                _pdfPair('Brothers',      biodata.brothers),
                _pdfPair('Sisters',       biodata.sisters),
                _pdfPair('Family Type',   biodata.familyType),
                _pdfPair('Caste',         biodata.caste),
              ]),

              _pdfSection('Religious Information', color, [
                _pdfPair('Sect',          biodata.sect),
                _pdfPair('Religiousness', biodata.religiousness),
              ]),

              if (biodata.notes.isNotEmpty) ...[
                _pdfSectionTitle('Additional Notes', color),
                pw.Text(biodata.notes, style: const pw.TextStyle(fontSize: 11)),
              ],

              pw.Spacer(),
              pw.Divider(),
              pw.Center(
                child: pw.Text(
                  'Made with Rishta Biodata Maker',
                  style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey),
                ),
              ),
            ],
          ),
        ),
      );

      return pdf.save();
    } catch (e, st) {
      debugPrint('ExportService.exportAsPdf error: $e\n$st');
      return null;
    }
  }

  // ── Save PDF to documents ─────────────────────────────────────────────────
  Future<String?> saveAsPdf(Uint8List bytes) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final fileName  = 'biodata_${DateTime.now().millisecondsSinceEpoch}.pdf';
      final file      = File('${directory.path}/$fileName');
      await file.writeAsBytes(bytes);
      return file.path;
    } catch (e) {
      debugPrint('ExportService.saveAsPdf error: $e');
      return null;
    }
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  PdfColor _getTemplateColor(int templateId) {
    switch (templateId) {
      case 2: return PdfColor.fromHex('AD1457');
      case 3: return PdfColor.fromHex('6A1B1B');
      case 4: return PdfColor.fromHex('0D47A1');
      case 5: return PdfColor.fromHex('424242');
      default: return PdfColor.fromHex('1B5E20');
    }
  }

  pw.Widget _pdfSection(String title, PdfColor color, List<pw.Widget> rows) {
    final nonEmpty = rows.whereType<pw.Widget>().toList();
    if (nonEmpty.isEmpty) return pw.SizedBox();
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [_pdfSectionTitle(title, color), ...rows],
    );
  }

  pw.Widget _pdfSectionTitle(String title, PdfColor color) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(top: 12, bottom: 4),
      child: pw.Text(
        title.toUpperCase(),
        style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold, color: color),
      ),
    );
  }

  pw.Widget _pdfPair(String label, String value) {
    if (value.trim().isEmpty) return pw.SizedBox();
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 4),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.SizedBox(
            width: 130,
            child: pw.Text(label, style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold)),
          ),
          pw.Text(': ', style: const pw.TextStyle(fontSize: 11)),
          pw.Expanded(
            child: pw.Text(value, style: const pw.TextStyle(fontSize: 11)),
          ),
        ],
      ),
    );
  }
}