import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../core/constants/app_sizes.dart';
import '../../providers/biodata_provider.dart';
import '../../providers/template_provider.dart';
import '../../providers/saved_designs_provider.dart';
import '../../providers/ad_provider.dart';
import '../../services/export_service.dart';
import '../../services/share_service.dart';
import '../../services/ad_service.dart';
import '../../templates/template_1_islamic.dart';
import '../../templates/template_2_floral.dart';
import '../../templates/template_3_royal.dart';
import '../../templates/template_4_modern.dart';
import '../../templates/template_5_simple.dart';
import 'widgets/action_bar.dart';

class CardPreviewScreen extends ConsumerStatefulWidget {
  const CardPreviewScreen({super.key});

  @override
  ConsumerState<CardPreviewScreen> createState() => _CardPreviewScreenState();
}

class _CardPreviewScreenState extends ConsumerState<CardPreviewScreen> {
  final GlobalKey _repaintKey = GlobalKey();
  bool _isExporting = false;
  String? _savedImagePath;

  @override
  Widget build(BuildContext context) {
    final biodata = ref.watch(biodataProvider);
    final selectedTemplate = ref.watch(selectedTemplateProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.white),
        ),
        title: const Text(
          'Your Biodata Card',
          style: TextStyle(
            color: AppColors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _isExporting ? null : _saveDesign,
            icon: const Icon(Icons.bookmark_rounded, color: AppColors.white),
            tooltip: 'Save Design',
          ),
        ],
      ),
      body: Column(
        children: [
          // Card preview
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSizes.md),
              child: Column(
                children: [
                  // Info banner
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.md,
                      vertical: AppSizes.sm,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.info_outline_rounded,
                          size: 16,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: AppSizes.sm),
                        Expanded(
                          child: Text(
                            AppStrings.adWatchMsg,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppSizes.md),

                  // The actual biodata card wrapped in RepaintBoundary
                  RepaintBoundary(
                    key: _repaintKey,
                    child: _buildTemplate(selectedTemplate),
                  ),
                ],
              ),
            ),
          ),

          // Action bar at bottom
          ActionBar(
            isExporting: _isExporting,
            onDownload: _handleDownload,
            onEdit: () => context.pop(),
            onShare: _handleShare,
          ),
        ],
      ),
    );
  }

  // ── Template router ─────────────────────────────────────────────────────────

  Widget _buildTemplate(int templateId) {
    final biodata = ref.watch(biodataProvider);

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

  // ── Actions ──────────────────────────────────────────────────────────────────

  Future<void> _handleDownload() async {
    final adReady = ref.read(rewardedAdReadyProvider);

    if (adReady) {
      // Show rewarded ad then download
      AdService().showRewardedAd(
        onRewarded: () async {
          await _captureAndSave();
        },
      );
    } else {
      // No ad ready — download directly
      await _captureAndSave();
    }
  }

  Future<void> _captureAndSave() async {
    if (_isExporting) return;

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
        _savedImagePath = path;
        _saveDesign();
        _showSnackBar('Biodata saved to gallery!');
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
    if (_savedImagePath != null) {
      await ShareService().shareImage(_savedImagePath!);
    } else {
      // Capture first then share
      setState(() => _isExporting = true);
      try {
        final Uint8List? imageBytes =
        await ExportService().captureAsImage(_repaintKey);
        if (imageBytes == null) {
          _showSnackBar('Failed to capture card.');
          return;
        }
        final String? path = await ExportService().saveToGallery(imageBytes);
        if (path != null) {
          _savedImagePath = path;
          await ShareService().shareImage(path);
        }
      } finally {
        if (mounted) setState(() => _isExporting = false);
      }
    }
  }

  void _saveDesign() {
    final biodata = ref.read(biodataProvider);
    ref.read(savedDesignsProvider.notifier).save(biodata);
  }

  void _showSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusSm),
        ),
      ),
    );
  }
}