import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';
import 'package:in_app_review/in_app_review.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../models/biodata_model.dart';
import '../../providers/biodata_provider.dart';
import '../../providers/template_provider.dart';
import '../../providers/saved_designs_provider.dart';
import '../../providers/ad_provider.dart';
import '../../services/export_service.dart';
import '../../services/share_service.dart';
import '../../templates/islamic/template_1_islamic.dart';
import '../../templates/floral/template_2_floral.dart';
import '../../templates/royal/template_3_royal.dart';
import '../../templates/modern/template_4_modern.dart';
import '../../templates/simple/template_5_simple.dart';
import '../../templates/urdu/template_6_urdu.dart';
import '../../templates/two_column/template_7_two_column.dart';
import '../../templates/dark/template_8_dark.dart';
import '../../templates/mughal/template_9_mughal.dart';
import '../../templates/photo/template_10_photo.dart';

class CardPreviewScreen extends ConsumerStatefulWidget {
  const CardPreviewScreen({super.key});

  @override
  ConsumerState<CardPreviewScreen> createState() => _CardPreviewScreenState();
}

class _CardPreviewScreenState extends ConsumerState<CardPreviewScreen> {
  final _repaintKey = GlobalKey();
  bool _isExporting = false;
  bool _designSaved = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _preloadAd());
  }

  void _preloadAd() {
    final adService = ref.read(adServiceProvider);
    adService.loadRewardedAd(onLoaded: () {
      if (mounted) {
        ref.read(rewardedAdReadyProvider.notifier).state = true;
      }
    });
  }

  Widget _buildTemplate(int id, Biodata b) {
    switch (id) {
      case 1:  return Template1Islamic(biodata: b);
      case 2:  return Template2Floral(biodata: b);
      case 3:  return Template3Royal(biodata: b);
      case 4:  return Template4Modern(biodata: b);
      case 5:  return Template5Simple(biodata: b);
      case 6:  return Template6Urdu(biodata: b);
      case 7:  return Template7TwoColumn(biodata: b);
      case 8:  return Template8Dark(biodata: b);
      case 9:  return Template9Mughal(biodata: b);
      case 10: return Template10Photo(biodata: b);
      default: return Template1Islamic(biodata: b);
    }
  }

  @override
  Widget build(BuildContext context) {
    final biodata   = ref.watch(biodataProvider);
    final templateId= ref.watch(selectedTemplateProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFEEEEEE),
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
        ),
        title: const Text(
          'Your Biodata Card',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          // Save icon — manual save
          IconButton(
            onPressed: _isExporting ? null : _saveDesignManually,
            icon: Icon(
              _designSaved
                  ? Icons.bookmark_rounded
                  : Icons.bookmark_add_outlined,
              color: Colors.white,
            ),
            tooltip: _designSaved ? 'Saved' : 'Save Design',
          ),
        ],
      ),
      body: Column(
        children: [
          // ── Card preview — scrollable ─────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSizes.md),
              child: RepaintBoundary(
                key: _repaintKey,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: _buildTemplate(templateId, biodata),
                ),
              ),
            ),
          ),

          // ── Action bar ────────────────────────────────────────────────
          _ActionBar(
            isExporting: _isExporting,
            onDownload: _handleDownload,
            onShare: _handleShare,
            onPdf: _handlePdf,
            onEdit: () => context.pop(),
          ),
        ],
      ),
    );
  }

  // ── Handlers ──────────────────────────────────────────────────────────────

  Future<void> _handleDownload() async {
    final adReady   = ref.read(rewardedAdReadyProvider);
    final adService = ref.read(adServiceProvider);
    if (adReady) {
      adService.showRewardedAd(onRewarded: () async {
        ref.read(rewardedAdReadyProvider.notifier).state = false;
        await _captureAndSave();
      });
    } else {
      await _captureAndSave();
    }
  }

  Future<void> _captureAndSave() async {
    if (_isExporting) return;
    setState(() => _isExporting = true);
    try {
      final bytes = await ExportService().captureAsImage(_repaintKey);
      if (bytes == null) {
        _snack('Failed to capture card. Please try again.', error: true);
        return;
      }
      final result = await ExportService().saveToGallery(bytes);
      if (result != null) {
        if (!_designSaved) {
          _saveDesign();
          setState(() => _designSaved = true);
        }
        _snack('✅ Saved to gallery!');
        _requestReview();
      } else {
        _snack('Failed to save. Check storage permission.', error: true);
      }
    } catch (e) {
      _snack('Something went wrong.', error: true);
    } finally {
      if (mounted) setState(() => _isExporting = false);
    }
  }

  Future<void> _handleShare() async {
    if (_isExporting) return;
    setState(() => _isExporting = true);
    try {
      final bytes = await ExportService().captureAsImage(_repaintKey);
      if (bytes == null) {
        _snack('Failed to capture card.', error: true);
        return;
      }
      final dir  = await getTemporaryDirectory();
      final file = File(
          '${dir.path}/biodata_${DateTime.now().millisecondsSinceEpoch}.png');
      await file.writeAsBytes(bytes);
      await ShareService().shareImage(file.path);
      // Clean up temp file after 2 min
      Future.delayed(const Duration(minutes: 2), () {
        if (file.existsSync()) file.deleteSync();
      });
    } catch (e) {
      _snack('Something went wrong.', error: true);
    } finally {
      if (mounted) setState(() => _isExporting = false);
    }
  }

  Future<void> _handlePdf() async {
    if (_isExporting) return;
    setState(() => _isExporting = true);
    try {
      final biodata  = ref.read(biodataProvider);
      final pdfBytes = await ExportService().exportAsPdf(biodata);
      if (pdfBytes == null) {
        _snack('Failed to generate PDF.', error: true);
        return;
      }
      await Printing.sharePdf(
        bytes: pdfBytes,
        filename: '${biodata.displayName.replaceAll(' ', '_')}_biodata.pdf',
      );
    } catch (e) {
      _snack('Something went wrong.', error: true);
    } finally {
      if (mounted) setState(() => _isExporting = false);
    }
  }

  void _saveDesign() {
    final biodata = ref.read(biodataProvider);
    ref.read(savedDesignsProvider.notifier).save(biodata);
  }

  void _saveDesignManually() {
    if (_designSaved) return;
    _saveDesign();
    setState(() => _designSaved = true);
    _snack('💾 Design saved!');
  }

  Future<void> _requestReview() async {
    try {
      final r = InAppReview.instance;
      if (await r.isAvailable()) r.requestReview();
    } catch (_) {}
  }

  void _snack(String msg, {bool error = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text(msg),
        backgroundColor: error ? AppColors.error : AppColors.primary,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 90),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusSm)),
      ));
  }
}

// ── Action bar ────────────────────────────────────────────────────────────────

class _ActionBar extends StatelessWidget {
  final bool isExporting;
  final VoidCallback onDownload;
  final VoidCallback onShare;
  final VoidCallback onPdf;
  final VoidCallback onEdit;

  const _ActionBar({
    required this.isExporting,
    required this.onDownload,
    required this.onShare,
    required this.onPdf,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Color(0x18000000),
            blurRadius: 12,
            offset: Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Primary — Download
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: isExporting ? null : onDownload,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: const Color(0x996A1B1B),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                  ),
                ),
                icon: isExporting
                    ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
                    : const Icon(Icons.download_rounded, size: 20),
                label: Text(
                  isExporting ? 'Saving...' : 'Download to Gallery',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            // Secondary row — 3 buttons
            Row(
              children: [
                Expanded(
                  child: _SecondaryBtn(
                    icon: Icons.edit_rounded,
                    label: 'Edit',
                    color: AppColors.primary,
                    onTap: onEdit,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _SecondaryBtn(
                    icon: Icons.picture_as_pdf_rounded,
                    label: 'PDF',
                    color: AppColors.error,
                    onTap: isExporting ? null : onPdf,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _SecondaryBtn(
                    icon: Icons.share_rounded,
                    label: 'Share',
                    color: const Color(0xFF0D47A1),
                    onTap: isExporting ? null : onShare,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SecondaryBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback? onTap;

  const _SecondaryBtn({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Color.fromRGBO(color.red, color.green, color.blue, 0.08),
          borderRadius: BorderRadius.circular(AppSizes.radiusSm),
          border: Border.all(
            color: Color.fromRGBO(color.red, color.green, color.blue, 0.25),
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: onTap == null ? AppColors.textMuted : color,
                size: 20),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: onTap == null ? AppColors.textMuted : color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}