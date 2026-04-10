import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'package:gal/gal.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../models/biodata_model.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class ExportService {

  Future<Uint8List?> exportAsPdf(Biodata biodata) async {
    try {
      final pdf = pw.Document();

      // Template color based on templateId
      final color = _getTemplateColor(biodata.templateId);

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(32),
          build: (pw.Context context) {
            return pw.Column(
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
                        style: pw.TextStyle(
                          fontSize: 22,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.white,
                        ),
                      ),
                      pw.SizedBox(height: 4),
                      pw.Text(
                        'Rishta Biodata Maker',
                        style: const pw.TextStyle(
                          fontSize: 11,
                          color: PdfColors.white,
                        ),
                      ),
                    ],
                  ),
                ),

                pw.SizedBox(height: 16),

                // Name + basic info
                if (biodata.name.isNotEmpty)
                  pw.Text(
                    biodata.name,
                    style: pw.TextStyle(
                      fontSize: 18,
                      fontWeight: pw.FontWeight.bold,
                      color: color,
                    ),
                  ),

                pw.SizedBox(height: 12),

                // Personal
                _pdfSectionTitle('Personal Information', color),
                _pdfRow('Age', biodata.age),
                _pdfRow('Height', biodata.height),
                _pdfRow('City', biodata.city),

                // Education
                _pdfSectionTitle('Education & Career', color),
                _pdfRow('Education', biodata.education),
                _pdfRow('Profession', biodata.profession),

                // Family
                _pdfSectionTitle('Family Information', color),
                _pdfRow("Father's Name", biodata.fatherName),
                _pdfRow("Mother's Name", biodata.motherName),
                _pdfRow('Brothers', biodata.brothers),
                _pdfRow('Sisters', biodata.sisters),
                _pdfRow('Family Type', biodata.familyType),

                // Religious
                _pdfSectionTitle('Religious Information', color),
                _pdfRow('Sect', biodata.sect),
                _pdfRow('Religiousness', biodata.religiousness),

                // Notes
                if (biodata.notes.isNotEmpty) ...[
                  _pdfSectionTitle('Notes', color),
                  pw.Text(biodata.notes,
                      style: const pw.TextStyle(fontSize: 11)),
                ],

                pw.Spacer(),

                // Footer
                pw.Divider(),
                pw.Center(
                  child: pw.Text(
                    'Made with Rishta Biodata Maker',
                    style: const pw.TextStyle(
                        fontSize: 10, color: PdfColors.grey),
                  ),
                ),
              ],
            );
          },
        ),
      );

      return pdf.save();
    } catch (e) {
      return null;
    }
  }

  Future<String?> saveAsPdf(Uint8List bytes) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final fileName = 'biodata_${DateTime.now().millisecondsSinceEpoch}.pdf';
      final file = File('${directory.path}/$fileName');
      await file.writeAsBytes(bytes);
      return file.path;
    } catch (e) {
      return null;
    }
  }

  PdfColor _getTemplateColor(int templateId) {
    switch (templateId) {
      case 2: return PdfColor.fromHex('AD1457');
      case 3: return PdfColor.fromHex('6A1B1B');
      case 4: return PdfColor.fromHex('0D47A1');
      case 5: return PdfColor.fromHex('424242');
      default: return PdfColor.fromHex('1B5E20'); // green
    }
  }

  pw.Widget _pdfSectionTitle(String title, PdfColor color) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(top: 12, bottom: 4),
      child: pw.Text(
        title.toUpperCase(),
        style: pw.TextStyle(
          fontSize: 10,
          fontWeight: pw.FontWeight.bold,
          color: color,
        ),
      ),
    );
  }

  pw.Widget _pdfRow(String label, String value) {
    if (value.isEmpty) return pw.SizedBox();
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 4),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.SizedBox(
            width: 120,
            child: pw.Text(label,
                style: pw.TextStyle(
                    fontSize: 11, fontWeight: pw.FontWeight.bold)),
          ),
          pw.Text(': ', style: const pw.TextStyle(fontSize: 11)),
          pw.Expanded(
            child: pw.Text(value,
                style: const pw.TextStyle(fontSize: 11)),
          ),
        ],
      ),
    );
  }

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
      await Gal.putImageBytes(bytes, name: 'biodata_${DateTime.now().millisecondsSinceEpoch}');
      return 'saved';
    } catch (e) {
      return null;
    }
  }}