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

  // ── Capture widget as PNG — with retry + timeout ─────────────────────────
  Future<Uint8List?> captureAsImage(GlobalKey key,
      {int retries = 3}) async {
    for (int attempt = 0; attempt < retries; attempt++) {
      try {
        if (attempt > 0) {
          await Future.delayed(Duration(milliseconds: 100 * attempt));
        }

        final context = key.currentContext;
        if (context == null) continue;

        final renderObject = context.findRenderObject();
        if (renderObject == null) continue;
        if (renderObject is! RenderRepaintBoundary) continue;

        if (renderObject.debugNeedsPaint) {
          await Future.delayed(const Duration(milliseconds: 100));
        }

        final image = await renderObject.toImage(pixelRatio: 2.5);
        final byteData =
        await image.toByteData(format: ui.ImageByteFormat.png);
        image.dispose();

        if (byteData != null) {
          return byteData.buffer.asUint8List();
        }
      } catch (e, st) {
        debugPrint('captureAsImage attempt $attempt error: $e\n$st');
        if (attempt == retries - 1) return null;
      }
    }
    return null;
  }

  // ── Save PNG to gallery ───────────────────────────────────────────────────
  Future<String?> saveToGallery(Uint8List bytes) async {
    try {
      final hasAccess = await Gal.hasAccess(toAlbum: false);
      if (!hasAccess) {
        final granted = await Gal.requestAccess(toAlbum: false);
        if (!granted) return null;
      }
      final fileName =
          'biodata_${DateTime.now().millisecondsSinceEpoch}';
      await Gal.putImageBytes(bytes, name: fileName);
      return 'saved';
    } catch (e, st) {
      debugPrint('saveToGallery error: $e\n$st');
      return null;
    }
  }

  // ── Generate designed PDF ─────────────────────────────────────────────────
  Future<Uint8List?> exportAsPdf(Biodata biodata) async {
    try {
      final pdf     = pw.Document();
      final colors  = _getTemplateColors(biodata.templateId);
      final primary   = colors[0];
      final secondary = colors[1];

      pw.ImageProvider? photoImage;
      if (biodata.photoPath.isNotEmpty) {
        try {
          final file = File(biodata.photoPath);
          if (file.existsSync()) {
            photoImage = pw.MemoryImage(file.readAsBytesSync());
          }
        } catch (_) {}
      }

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          margin: pw.EdgeInsets.zero,
          build: (pw.Context ctx) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Decorative top bar
                pw.Container(
                  height: 8,
                  width: double.infinity,
                  decoration: pw.BoxDecoration(
                    gradient: pw.LinearGradient(
                      colors: [secondary, primary, secondary],
                    ),
                  ),
                ),

                // Header block
                pw.Container(
                  width: double.infinity,
                  color: primary,
                  padding: const pw.EdgeInsets.symmetric(
                      vertical: 20, horizontal: 36),
                  child: pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    children: [
                      if (photoImage != null)
                        pw.Container(
                          width: 80,
                          height: 80,
                          decoration: pw.BoxDecoration(
                            shape: pw.BoxShape.circle,
                            border: pw.Border.all(
                                color: secondary, width: 2.5),
                          ),
                          child: pw.ClipOval(
                            child: pw.Image(photoImage,
                                width: 80,
                                height: 80,
                                fit: pw.BoxFit.cover),
                          ),
                        )
                      else
                        pw.Container(
                          width: 80,
                          height: 80,
                          decoration: pw.BoxDecoration(
                            shape: pw.BoxShape.circle,
                            color: PdfColors.white,
                            border: pw.Border.all(
                                color: secondary, width: 2),
                          ),
                        ),
                      pw.SizedBox(width: 20),
                      pw.Expanded(
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(
                              'RISHTA BIODATA',
                              style: pw.TextStyle(
                                fontSize: 9,
                                color: secondary,
                                letterSpacing: 3,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                            pw.SizedBox(height: 4),
                            if (biodata.name.isNotEmpty)
                              pw.Text(
                                // Truncate name to prevent header overflow
                                biodata.name.length > 40
                                    ? '${biodata.name.substring(0, 40)}…'
                                    : biodata.name,
                                style: pw.TextStyle(
                                  fontSize: 22,
                                  color: PdfColors.white,
                                  fontWeight: pw.FontWeight.bold,
                                ),
                              ),
                            pw.SizedBox(height: 6),
                            pw.Wrap(
                              spacing: 8,
                              runSpacing: 4,
                              children: [
                                if (biodata.age.isNotEmpty)
                                  _pdfChip('Age ${biodata.age}', secondary),
                                if (biodata.city.isNotEmpty)
                                  _pdfChip(biodata.city, secondary),
                                if (biodata.maritalStatus.isNotEmpty)
                                  _pdfChip(biodata.maritalStatus, secondary),
                                if (biodata.profession.isNotEmpty)
                                  _pdfChip(biodata.profession, secondary),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Gold divider
                pw.Container(height: 3, color: secondary),

                // Body — two columns
                pw.Expanded(
                  child: pw.Container(
                    color: const PdfColor.fromInt(0xFFFFF8F0),
                    padding: const pw.EdgeInsets.all(28),
                    child: pw.Row(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        // Left column
                        pw.Expanded(
                          child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              _pdfSection('Personal Information',
                                  primary, secondary, [
                                    _pdfPair('Full Name', biodata.name, primary),
                                    _pdfPair('Age', biodata.age, primary),
                                    _pdfPair('Height', biodata.height, primary),
                                    _pdfPair('Complexion', biodata.complexion, primary),
                                    _pdfPair('City', biodata.city, primary),
                                    _pdfPair('Mother Tongue', biodata.motherTongue, primary),
                                    _pdfPair('Marital Status', biodata.maritalStatus, primary),
                                    if (biodata.personalNotes.isNotEmpty)
                                      _pdfPair('Notes', biodata.personalNotes, primary),
                                  ]),
                              pw.SizedBox(height: 12),
                              _pdfSection('Education & Career',
                                  primary, secondary, [
                                    _pdfPair('Education', biodata.education, primary),
                                    _pdfPair('Institute', biodata.institute, primary),
                                    _pdfPair('Profession', biodata.profession, primary),
                                    _pdfPair('Salary', biodata.salary, primary),
                                    if (biodata.educationNotes.isNotEmpty)
                                      _pdfPair('Notes', biodata.educationNotes, primary),
                                  ]),
                            ],
                          ),
                        ),

                        // Vertical separator
                        pw.Container(
                          width: 1,
                          margin: const pw.EdgeInsets.symmetric(
                              horizontal: 16),
                          color: secondary,
                        ),

                        // Right column
                        pw.Expanded(
                          child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              _pdfSection('Family Information',
                                  primary, secondary, [
                                    _pdfPair("Father's Name", biodata.fatherName, primary),
                                    _pdfPair("Father's Job", biodata.fatherProfession, primary),
                                    _pdfPairSiblings('Brothers', biodata.brothers, biodata.brothersMarried, primary),
                                    _pdfPairSiblings('Sisters', biodata.sisters, biodata.sistersMarried, primary),
                                    _pdfPair('Family Type', biodata.familyType, primary),
                                    _pdfPair('Caste', biodata.caste, primary),
                                    if (biodata.familyNotes.isNotEmpty)
                                      _pdfPair('Notes', biodata.familyNotes, primary),
                                  ]),
                              pw.SizedBox(height: 12),
                              _pdfSection('Religious', primary, secondary, [
                                _pdfPair('Religion', biodata.religion, primary),
                                _pdfPair('Sect', biodata.sect, primary),
                                _pdfPair('Religiousness', biodata.religiousness, primary),
                                if (biodata.religiousNotes.isNotEmpty)
                                  _pdfPair('Notes', biodata.religiousNotes, primary),
                              ]),
                              if (biodata.notes.isNotEmpty) ...[
                                pw.SizedBox(height: 12),
                                _pdfSection('Additional Notes',
                                    primary, secondary, [
                                      // Clamp notes to 300 chars — long text overflows A4
                                      pw.Text(
                                        biodata.notes.length > 300
                                            ? '${biodata.notes.substring(0, 300)}…'
                                            : biodata.notes,
                                        style: const pw.TextStyle(
                                            fontSize: 9,
                                            color: PdfColors.black),
                                        maxLines: 6,
                                        overflow: pw.TextOverflow.clip,
                                      ),
                                    ]),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Footer
                pw.Container(height: 3, color: secondary),
                pw.Container(
                  width: double.infinity,
                  color: primary,
                  padding:
                  const pw.EdgeInsets.symmetric(vertical: 10),
                  child: pw.Center(
                    child: pw.Text(
                      '✦  Made with Rishta Biodata Maker  ✦',
                      style: pw.TextStyle(
                          fontSize: 10,
                          color: secondary,
                          fontWeight: pw.FontWeight.bold),
                    ),
                  ),
                ),
                pw.Container(
                  height: 6,
                  decoration: pw.BoxDecoration(
                    gradient: pw.LinearGradient(
                      colors: [secondary, primary, secondary],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      );

      return pdf.save();
    } catch (e, st) {
      debugPrint('exportAsPdf error: $e\n$st');
      return null;
    }
  }

  Future<String?> saveAsPdf(Uint8List bytes) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final fileName =
          'biodata_${DateTime.now().millisecondsSinceEpoch}.pdf';
      final file = File('${directory.path}/$fileName');
      await file.writeAsBytes(bytes);
      return file.path;
    } catch (e) {
      debugPrint('saveAsPdf error: $e');
      return null;
    }
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  List<PdfColor> _getTemplateColors(int templateId) {
    switch (templateId) {
      case 2:  return [PdfColor.fromHex('AD1457'), PdfColor.fromHex('F8BBD0')];
      case 3:  return [PdfColor.fromHex('4A0E0E'), PdfColor.fromHex('D4AF37')];
      case 4:  return [PdfColor.fromHex('0D47A1'), PdfColor.fromHex('90CAF9')];
      case 5:  return [PdfColor.fromHex('424242'), PdfColor.fromHex('BDBDBD')];
      case 6:  return [PdfColor.fromHex('1A0A2E'), PdfColor.fromHex('D4AF37')];
      case 7:  return [PdfColor.fromHex('00695C'), PdfColor.fromHex('80CBC4')];
      case 8:  return [PdfColor.fromHex('1C1C1E'), PdfColor.fromHex('FF9500')];
      case 9:  return [PdfColor.fromHex('4A0828'), PdfColor.fromHex('D4AF37')];
      case 10: return [PdfColor.fromHex('283593'), PdfColor.fromHex('64B5F6')];
      default: return [PdfColor.fromHex('6A1B1B'), PdfColor.fromHex('D4AF37')];
    }
  }

  pw.Widget _pdfChip(String text, PdfColor color) {
    // Truncate chip text so header chips never overflow
    final display = text.length > 20 ? '${text.substring(0, 20)}…' : text;
    return pw.Container(
      padding:
      const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: pw.BoxDecoration(
        color: PdfColors.white,
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(10)),
      ),
      child: pw.Text(display,
          style: pw.TextStyle(
              fontSize: 8,
              color: color,
              fontWeight: pw.FontWeight.bold)),
    );
  }

  pw.Widget _pdfSection(String title, PdfColor primary,
      PdfColor secondary, List<pw.Widget> rows) {
    final nonEmpty =
    rows.where((w) => w is! pw.SizedBox).toList();
    if (nonEmpty.isEmpty) return pw.SizedBox();
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Row(
          children: [
            pw.Container(width: 3, height: 12, color: secondary),
            pw.SizedBox(width: 6),
            pw.Text(
              title.toUpperCase(),
              style: pw.TextStyle(
                fontSize: 8,
                color: primary,
                fontWeight: pw.FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
            pw.SizedBox(width: 6),
            pw.Expanded(
              child: pw.Divider(color: secondary, thickness: 0.8),
            ),
          ],
        ),
        pw.SizedBox(height: 6),
        ...rows,
      ],
    );
  }

  pw.Widget _pdfPair(String label, String value, PdfColor labelColor) {
    if (value.trim().isEmpty) return pw.SizedBox();
    // Clamp value to 60 chars — prevents long text overflowing the column
    final display = value.length > 60 ? '${value.substring(0, 60)}…' : value;
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 4),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.SizedBox(
            width: 90,
            child: pw.Text(label,
                style: pw.TextStyle(
                    fontSize: 9,
                    fontWeight: pw.FontWeight.bold,
                    color: labelColor)),
          ),
          pw.Text(': ', style: const pw.TextStyle(fontSize: 9)),
          pw.Expanded(
            child: pw.Text(
              display,
              style: pw.TextStyle(fontSize: 9, color: PdfColors.black),
              maxLines: 2,
              overflow: pw.TextOverflow.clip,
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _pdfPairSiblings(String label, String count,
      String married, PdfColor labelColor) {
    if (count.isEmpty) return pw.SizedBox();
    final display =
    married.isEmpty ? count : '$count ($married)';
    return _pdfPair(label, display, labelColor);
  }
}