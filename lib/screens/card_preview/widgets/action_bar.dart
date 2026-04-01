import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';

class ActionBar extends StatelessWidget {
  final bool isExporting;
  final VoidCallback onDownload;
  final VoidCallback onEdit;
  final VoidCallback onShare;

  const ActionBar({
    super.key,
    required this.isExporting,
    required this.onDownload,
    required this.onEdit,
    required this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.md,
        vertical: AppSizes.md,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        children: [
          // Edit button
          Expanded(
            child: OutlinedButton.icon(
              onPressed: onEdit,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.primary),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              icon: const Icon(Icons.edit_rounded, size: 18),
              label: const Text(AppStrings.btnEdit),
            ),
          ),

          const SizedBox(width: AppSizes.sm),

          // Download button
          Expanded(
            flex: 2,
            child: ElevatedButton.icon(
              onPressed: isExporting ? null : onDownload,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              icon: isExporting
                  ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.white,
                ),
              )
                  : const Icon(Icons.download_rounded, size: 18),
              label: Text(
                isExporting ? 'Saving...' : AppStrings.btnDownload,
              ),
            ),
          ),

          const SizedBox(width: AppSizes.sm),

          // Share button
          Expanded(
            child: OutlinedButton.icon(
              onPressed: isExporting ? null : onShare,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.primary),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              icon: const Icon(Icons.share_rounded, size: 18),
              label: const Text(AppStrings.btnShare),
            ),
          ),
        ],
      ),
    );
  }
}