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
import '../../core/constants/app_strings.dart';
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
import '../home/widgets/template_card.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../templates/urdu/template_6_urdu.dart';
import '../../templates/two_column/template_7_two_column.dart';
import '../../templates/dark/template_8_dark.dart';
import '../../templates/mughal/template_9_mughal.dart';
import '../../templates/photo/template_10_photo.dart';
import 'widgets/action_bar.dart';

class CardPreviewScreen extends ConsumerStatefulWidget {
  const CardPreviewScreen({super.key});

  @override
  ConsumerState<CardPreviewScreen> createState() => _CardPreviewScreenState();
}

class _CardPreviewScreenState extends ConsumerState<CardPreviewScreen>
    with TickerProviderStateMixin {
  // RepaintBoundary key — must be stable across rebuilds (not in build())
  final GlobalKey _repaintKey = GlobalKey();

  bool _isExporting = false;
  bool _designSaved = false;

  // Zoom state
  final TransformationController _transformController = TransformationController();
  bool _isZoomed = false;

  // Animation for the success checkmark
  late AnimationController _checkAnimController;
  late Animation<double> _checkScaleAnim;

  static const List<TemplateInfo> _templates = [
    TemplateInfo(id: 1, name: 'Islamic Green',  description: '', color: Color(0xFF1B5E20)),
    TemplateInfo(id: 2, name: 'Floral Pink',    description: '', color: Color(0xFFAD1457)),
    TemplateInfo(id: 3, name: 'Royal Maroon',   description: '', color: Color(0xFF6A1B1B)),
    TemplateInfo(id: 4, name: 'Modern Navy',    description: '', color: Color(0xFF0D47A1)),
    TemplateInfo(id: 5, name: 'Simple White',   description: '', color: Color(0xFF424242)),
  ];

  @override
  void initState() {
    super.initState();
    _checkAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _checkScaleAnim = CurvedAnimation(
      parent: _checkAnimController,
      curve: Curves.elasticOut,
    );
    // Pre-load rewarded ad
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

  @override
  void dispose() {
    _transformController.dispose();
    _checkAnimController.dispose();
    super.dispose();
  }

  void _resetZoom() {
    _transformController.value = Matrix4.identity();
    setState(() => _isZoomed = false);
  }

  Widget _buildTemplate(int templateId, Biodata biodata) {
    switch (templateId) {
      case 1: return Template1Islamic(biodata: biodata);
      case 2: return Template2Floral(biodata: biodata);
      case 3: return Template3Royal(biodata: biodata);
      case 4: return Template4Modern(biodata: biodata);
      case 5: return Template5Simple(biodata: biodata);
      case 6: return Template6Urdu(biodata: biodata);
      case 7: return Template7TwoColumn(biodata: biodata);
      case 8: return Template8Dark(biodata: biodata);
      case 9: return Template9Mughal(biodata: biodata);
      case 10: return Template10Photo(biodata: biodata);
      default: return Template1Islamic(biodata: biodata);
    }
  }

  @override
  Widget build(BuildContext context) {
    final biodata         = ref.watch(biodataProvider);
    final selectedTemplate = ref.watch(selectedTemplateProvider);
    final currentTemplate = _templates.firstWhere(
          (t) => t.id == selectedTemplate,
      orElse: () => _templates.first,
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0),
      body: CustomScrollView(
        // Disable scroll when zoomed so pan gesture works correctly
        physics: _isZoomed
            ? const NeverScrollableScrollPhysics()
            : const ClampingScrollPhysics(),
        slivers: [
          // ── AppBar ──────────────────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 0,
            pinned: true,
            backgroundColor: currentTemplate.color,
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
                fontWeight: FontWeight.w600,
              ),
            ),
            actions: [
              if (_isZoomed)
                IconButton(
                  onPressed: _resetZoom,
                  icon: const Icon(Icons.zoom_out_map_rounded, color: Colors.white),
                  tooltip: 'Reset zoom',
                ),
              _designSaved
                  ? const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Icon(Icons.bookmark_rounded, color: Colors.white70),
              )
                  : IconButton(
                onPressed: _isExporting ? null : _saveDesignManually,
                icon: const Icon(Icons.bookmark_add_rounded, color: Colors.white),
                tooltip: 'Save Design',
              ),
            ],
          ),

          SliverToBoxAdapter(
            child: Column(
              children: [
                // ── Info banner ────────────────────────────────────────────
                Container(
                  color: currentTemplate.color,
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.pinch_rounded, color: Colors.white, size: 16),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _isZoomed
                                ? 'Tap 🔍 to reset zoom'
                                : AppStrings.adWatchMsg,
                            style: const TextStyle(color: Colors.white, fontSize: 12),
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

                // ── Template label row ─────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Container(
                        width: 4, height: 16,
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
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: currentTemplate.color.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: currentTemplate.color.withOpacity(0.2)),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.swap_horiz_rounded, size: 14, color: currentTemplate.color),
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

                // ── Zoomable card ──────────────────────────────────────────
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
                        final scale = _transformController.value.getMaxScaleOnAxis();
                        setState(() => _isZoomed = scale > 1.05);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: currentTemplate.color.withOpacity(0.2),
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
                        // RepaintBoundary must wrap the exact widget to capture
                        child: RepaintBoundary(
                          key: _repaintKey,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: _buildTemplate(selectedTemplate, biodata),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                if (!_isZoomed) ...[
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.06),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.pinch_rounded, size: 14, color: AppColors.textMuted),
                        const SizedBox(width: 6),
                        Text(
                          'Pinch to zoom',
                          style: TextStyle(fontSize: 11, color: AppColors.textMuted),
                        ),
                      ],
                    ),
                  ),
                ],

                // Extra space for bottom sheet
                const SizedBox(height: 140),
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
        onWhatsApp: _handleWhatsAppShare,
        onPdf: _handlePdfExport,
      ),
    );
  }



  // ── Action handlers ────────────────────────────────────────────────────────

  Future<void> _handleWhatsAppShare() async {
    if (_isExporting) return;

    if (_isZoomed) {
      _resetZoom();
      await Future.delayed(const Duration(milliseconds: 150));
    }

    setState(() => _isExporting = true);
    try {
      await Future.delayed(const Duration(milliseconds: 80));
      final Uint8List? imageBytes = await ExportService().captureAsImage(_repaintKey);
      if (imageBytes == null) {
        _showSnackBar('❌ Failed to capture card.', isError: true);
        return;
      }

      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/biodata_whatsapp_${DateTime.now().millisecondsSinceEpoch}.png');
      await file.writeAsBytes(imageBytes);

      // Try WhatsApp direct, fall back to normal share
      final whatsappUri = Uri.parse('whatsapp://send');
      if (await canLaunchUrl(whatsappUri)) {
        await ShareService().shareImage(file.path);
      } else {
        _showSnackBar('WhatsApp not installed.', isError: true);
      }

      Future.delayed(const Duration(minutes: 2), () {
        if (file.existsSync()) file.deleteSync();
      });
    } catch (e) {
      _showSnackBar('❌ Something went wrong.', isError: true);
    } finally {
      if (mounted) setState(() => _isExporting = false);
    }
  }

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

    // Reset zoom first so the full card is visible for capture
    if (_isZoomed) {
      _resetZoom();
      // Wait for zoom animation to complete
      await Future.delayed(const Duration(milliseconds: 150));
    }

    setState(() => _isExporting = true);
    try {
      // Extra frame to ensure RepaintBoundary is fully painted
      await Future.delayed(const Duration(milliseconds: 80));

      final Uint8List? imageBytes = await ExportService().captureAsImage(_repaintKey);

      if (imageBytes == null) {
        _showSnackBar('❌ Failed to capture card. Please try again.', isError: true);
        return;
      }

      final String? result = await ExportService().saveToGallery(imageBytes);

      if (result != null) {
        if (!_designSaved) {
          _saveDesign();
          setState(() => _designSaved = true);
        }
        _showSnackBar('✅ Saved to gallery!');
        _requestReview();
        _checkAnimController.forward(from: 0);
      } else {
        _showSnackBar('❌ Failed to save. Check storage permission.', isError: true);
      }
    } catch (e) {
      _showSnackBar('❌ Something went wrong. Please try again.', isError: true);
      debugPrint('Download error: $e');
    } finally {
      if (mounted) setState(() => _isExporting = false);
    }
  }

  Future<void> _requestReview() async {
    final inAppReview = InAppReview.instance;
    if (await inAppReview.isAvailable()) {
      inAppReview.requestReview();
    }
  }

  Future<void> _handleShare() async {
    if (_isExporting) return;

    if (_isZoomed) {
      _resetZoom();
      await Future.delayed(const Duration(milliseconds: 150));
    }

    setState(() => _isExporting = true);
    try {
      await Future.delayed(const Duration(milliseconds: 80));

      final Uint8List? imageBytes = await ExportService().captureAsImage(_repaintKey);
      if (imageBytes == null) {
        _showSnackBar('❌ Failed to capture card.', isError: true);
        return;
      }

      final dir  = await getTemporaryDirectory();
      final file = File('${dir.path}/biodata_share_${DateTime.now().millisecondsSinceEpoch}.png');
      await file.writeAsBytes(imageBytes);
      await ShareService().shareImage(file.path);

      // Clean up temp file after a delay
      Future.delayed(const Duration(minutes: 2), () {
        if (file.existsSync()) file.deleteSync();
      });
    } catch (e) {
      _showSnackBar('❌ Something went wrong.', isError: true);
      debugPrint('Share error: $e');
    } finally {
      if (mounted) setState(() => _isExporting = false);
    }
  }

  Future<void> _handlePdfExport() async {
    if (_isExporting) return;

    setState(() => _isExporting = true);
    try {
      final biodata    = ref.read(biodataProvider);
      final Uint8List? pdfBytes = await ExportService().exportAsPdf(biodata);

      if (pdfBytes == null) {
        _showSnackBar('❌ Failed to generate PDF.', isError: true);
        return;
      }

      await Printing.sharePdf(
        bytes: pdfBytes,
        filename: '${biodata.displayName.replaceAll(' ', '_')}_biodata.pdf',
      );
      _showSnackBar('📄 PDF ready!');
    } catch (e) {
      _showSnackBar('❌ Something went wrong.', isError: true);
      debugPrint('PDF error: $e');
    } finally {
      if (mounted) setState(() => _isExporting = false);
    }
  }

  void _saveDesign() {
    final biodata = ref.read(biodataProvider);
    ref.read(savedDesignsProvider.notifier).save(biodata);
  }

  void _saveDesignManually() {
    _saveDesign();
    setState(() => _designSaved = true);
    _showSnackBar('💾 Design saved!');
  }

  void _showSnackBar(String message, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: isError ? AppColors.error : AppColors.primary,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 3),
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 110),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusSm),
          ),
        ),
      );
  }
}