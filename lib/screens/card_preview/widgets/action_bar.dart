import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';

class ActionBar extends StatelessWidget {
  final bool isExporting;
  final VoidCallback onDownload;
  final VoidCallback onEdit;
  final VoidCallback onShare;
  final VoidCallback onWhatsApp;
  final VoidCallback onPdf;

  const ActionBar({
    super.key,
    required this.isExporting,
    required this.onDownload,
    required this.onEdit,
    required this.onShare,
    required this.onWhatsApp,
    required this.onPdf,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.10),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 36,
            height: 4,
            margin: const EdgeInsets.only(bottom: 14),
            decoration: BoxDecoration(
              color: AppColors.textMuted.withOpacity(0.2),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // ── Download button (primary, full width) ──────────────────────
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              onPressed: isExporting ? null : onDownload,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                disabledBackgroundColor: AppColors.primary.withOpacity(0.6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                ),
                elevation: 0,
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
                isExporting
                    ? 'Saving...'
                    : '${AppStrings.btnDownload} to Gallery',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),

          // ── Second row — 4 actions evenly spaced ──────────────────────
          Row(
            children: [
              Expanded(
                child: _secondaryButton(
                  icon: Icons.edit_rounded,
                  label: AppStrings.btnEdit,
                  color: AppColors.primary,
                  onTap: onEdit,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _secondaryButton(
                  icon: Icons.chat_rounded,
                  label: 'WhatsApp',
                  color: const Color(0xFF25D366),
                  onTap: onWhatsApp,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _secondaryButton(
                  icon: Icons.picture_as_pdf_rounded,
                  label: 'Save PDF',
                  color: AppColors.error,
                  onTap: isExporting ? () {} : onPdf,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _secondaryButton(
                  icon: Icons.share_rounded,
                  label: AppStrings.btnShare,
                  color: const Color(0xFF0D47A1),
                  onTap: isExporting ? () {} : onShare,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _secondaryButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(AppSizes.radiusSm),
          border: Border.all(color: color.withOpacity(0.25)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: color,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}