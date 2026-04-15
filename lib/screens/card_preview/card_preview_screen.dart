import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_strings.dart';
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
import '../home/widgets/template_card.dart';
import 'widgets/action_bar.dart';

class CardPreviewScreen extends ConsumerStatefulWidget {
  const CardPreviewScreen({super.key});

  @override
  ConsumerState<CardPreviewScreen> createState() => _CardPreviewScreenState();
}

class _CardPreviewScreenState extends ConsumerState<CardPreviewScreen> {
  final GlobalKey _repaintKey = GlobalKey();
  bool _isExporting = false;
  bool _designSaved = false; // Track if already saved to avoid duplicates

  final TransformationController _transformController =
  TransformationController();
  bool _isZoomed = false;

  static const List<TemplateInfo> _templates = [
    TemplateInfo(
        id: 1,
        name: 'Islamic Green',
        description: '',
        color: Color(0xFF1B5E20)),
    TemplateInfo(
        id: 2,
        name: 'Floral Pink',
        description: '',
        color: Color(0xFFAD1457)),
    TemplateInfo(
        id: 3,
        name: 'Royal Maroon',
        description: '',
        color: Color(0xFF6A1B1B)),
    TemplateInfo(
        id: 4,
        name: 'Modern Navy',
        description: '',
        color: Color(0xFF0D47A1)),
    TemplateInfo(
        id: 5,
        name: 'Simple White',
        description: '',
        color: Color(0xFF424242)),
  ];

  @override
  void dispose() {
    _transformController.dispose();
    super.dispose();
  }

  void _resetZoom() {
    _transformController.value = Matrix4.identity();
    setState(() => _isZoomed = false);
  }

  // Build the correct template widget based on templateId.
  // NOTE: biodata is passed as a parameter (read from provider in build())
  // to avoid calling ref.watch() inside a non-build method.
  Widget _buildTemplate(int templateId, biodata) {
    switch (templateId) {
      case 1:
        return Template1Islamic(biodata: biodata);
      case 2:
        return Template2Floral(biodata: biodata);
      case 3:
        return Template3Royal(biodata: biodata);
      case 4:
        return Template4Modern(biodata: biodata);
      case 5:
        return Template5Simple(biodata: biodata);
      default:
        return Template1Islamic(biodata: biodata);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Read all provider data here in build() — the correct place
    final biodata = ref.watch(biodataProvider);
    final selectedTemplate = ref.watch(selectedTemplateProvider);
    final currentTemplate =
    _templates.firstWhere((t) => t.id == selectedTemplate);

    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0),
      body: CustomScrollView(
        physics: _isZoomed
            ? const NeverScrollableScrollPhysics()
            : const ClampingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 0,
            pinned: true,
            backgroundColor: currentTemplate.color,
            elevation: 0,
            leading: IconButton(
              onPressed: () => context.pop(),
              icon:
              const Icon(Icons.arrow_back_rounded, color: Colors.white),
            ),
            title: const Text(
              'Your Biodata Card',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            actions: [
              if (_isZoomed)
                IconButton(
                  onPressed: _resetZoom,
                  icon: const Icon(Icons.zoom_out_map_rounded,
                      color: Colors.white),
                  tooltip: 'Reset zoom',
                ),
              // Manual save button — only shown if not already auto-saved
              if (!_designSaved)
                IconButton(
                  onPressed: _isExporting ? null : _saveDesignManually,
                  icon: const Icon(Icons.bookmark_add_rounded,
                      color: Colors.white),
                  tooltip: 'Save Design',
                )
              else
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Icon(Icons.bookmark_rounded,
                      color: Colors.white70),
                ),
            ],
          ),

          SliverToBoxAdapter(
            child: Column(
              children: [
                // Top info banner
                Container(
                  color: currentTemplate.color,
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.pinch_rounded,
                            color: Colors.white, size: 16),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _isZoomed
                                ? 'Pinch to zoom out • Tap 🔍 to reset'
                                : 'Pinch to zoom in • ${AppStrings.adWatchMsg}',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Curved transition
                Container(
                  height: 20,
                  decoration: BoxDecoration(
                    color: currentTemplate.color,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(24),
                      bottomRight: Radius.circular(24),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Card label row
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Container(
                        width: 4,
                        height: 16,
                        decoration: BoxDecoration(
                          color: currentTemplate.color,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${currentTemplate.name} Template',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: currentTemplate.color,
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () => context.pop(),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color:
                            currentTemplate.color.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color:
                              currentTemplate.color.withOpacity(0.2),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.swap_horiz_rounded,
                                  size: 14, color: currentTemplate.color),
                              const SizedBox(width: 4),
                              Text(
                                'Change',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: currentTemplate.color,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // Zoomable card with RepaintBoundary inside
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: InteractiveViewer(
                      transformationController: _transformController,
                      minScale: 0.8,
                      maxScale: 4.0,
                      clipBehavior: Clip.none,
                      onInteractionEnd: (details) {
                        final scale =
                        _transformController.value.getMaxScaleOnAxis();
                        setState(() => _isZoomed = scale > 1.05);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color:
                              currentTemplate.color.withOpacity(0.2),
                              blurRadius: 24,
                              offset: const Offset(0, 8),
                            ),
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: RepaintBoundary(
                          key: _repaintKey,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            // Pass biodata directly — no ref.watch in method
                            child:
                            _buildTemplate(selectedTemplate, biodata),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                if (!_isZoomed)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.06),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.pinch_rounded,
                              size: 14, color: AppColors.textMuted),
                          const SizedBox(width: 6),
                          Text(
                            'Pinch to zoom',
                            style:
                            TextStyle(fontSize: 11, color: AppColors.textMuted),
                          ),
                        ],
                      ),
                    ),
                  ),

                const SizedBox(height: 120),
              ],
            ),
          ),
        ],
      ),

      bottomSheet: ActionBar(
        isExporting: _isExporting,
        onDownload: _handleDownload,
        onEdit: () => context.pop(),
        onShare: _handleShare,
        onPdf: _handlePdfExport,
      ),
    );
  }

  Future<void> _handleDownload() async {
    final adReady = ref.read(rewardedAdReadyProvider);
    if (adReady) {
      ref.read(adServiceProvider).showRewardedAd(onRewarded: () async {
        await _captureAndSave();
      });
    } else {
      await _captureAndSave();
    }
  }

  Future<void> _captureAndSave() async {
    if (_isExporting) return;

    if (_isZoomed) _resetZoom();
    await Future.delayed(const Duration(milliseconds: 80));

    setState(() => _isExporting = true);
    try {
      final Uint8List? imageBytes =
      await ExportService().captureAsImage(_repaintKey);
      if (imageBytes == null) {
        _showSnackBar('Failed to capture card. Please try again.');
        return;
      }
      final String? path = await ExportService().saveToGallery(imageBytes);
      if (path != null) {
        // Auto-save design once on first download — avoid duplicates
        if (!_designSaved) {
          _saveDesign();
          setState(() => _designSaved = true);
        }
        _showSnackBar('✅ Biodata saved to gallery!');
      } else {
        _showSnackBar('Failed to save. Check storage permission.');
      }
    } catch (e) {
      _showSnackBar('Something went wrong. Please try again.');
    } finally {
      if (mounted) setState(() => _isExporting = false);
    }
  }

  Future<void> _handleShare() async {
    if (_isZoomed) _resetZoom();
    await Future.delayed(const Duration(milliseconds: 80));

    setState(() => _isExporting = true);
    try {
      final Uint8List? imageBytes =
      await ExportService().captureAsImage(_repaintKey);
      if (imageBytes == null) {
        _showSnackBar('Failed to capture card.');
        return;
      }
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/biodata_share.png');
      await file.writeAsBytes(imageBytes);
      await ShareService().shareImage(file.path);
    } catch (e) {
      _showSnackBar('Something went wrong. Please try again.');
    } finally {
      if (mounted) setState(() => _isExporting = false);
    }
  }

  Future<void> _handlePdfExport() async {
    if (_isExporting) return;
    setState(() => _isExporting = true);
    try {
      final biodata = ref.read(biodataProvider);
      final Uint8List? pdfBytes = await ExportService().exportAsPdf(biodata);
      if (pdfBytes == null) {
        _showSnackBar('Failed to generate PDF.');
        return;
      }
      await Printing.sharePdf(bytes: pdfBytes, filename: 'biodata.pdf');
      _showSnackBar('📄 PDF ready!');
    } catch (e) {
      _showSnackBar('Something went wrong.');
    } finally {
      if (mounted) setState(() => _isExporting = false);
    }
  }

  // Auto-save (internal — no snackbar)
  void _saveDesign() {
    final biodata = ref.read(biodataProvider);
    ref.read(savedDesignsProvider.notifier).save(biodata);
  }

  // Manual save via bookmark button (with snackbar)
  void _saveDesignManually() {
    _saveDesign();
    setState(() => _designSaved = true);
    _showSnackBar('💾 Design saved!');
  }

  void _showSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 100),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusSm),
        ),
      ),
    );
  }
}