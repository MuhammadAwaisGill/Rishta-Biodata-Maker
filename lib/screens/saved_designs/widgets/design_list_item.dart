import 'dart:io';
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../models/biodata_model.dart';

class DesignListItem extends StatelessWidget {
  final Biodata biodata;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const DesignListItem({
    super.key,
    required this.biodata,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSizes.md),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Photo thumbnail
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withOpacity(0.1),
                image: biodata.photoPath.isNotEmpty
                    ? DecorationImage(
                  image: FileImage(File(biodata.photoPath)),
                  fit: BoxFit.cover,
                )
                    : null,
              ),
              child: biodata.photoPath.isEmpty
                  ? const Icon(
                Icons.person_rounded,
                color: AppColors.primary,
                size: 28,
              )
                  : null,
            ),

            const SizedBox(width: AppSizes.md),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    biodata.name.isEmpty ? 'Unnamed Biodata' : biodata.name,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _buildSubtitle(),
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Template badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'Template ${biodata.templateId}',
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Delete button
            IconButton(
              onPressed: onDelete,
              icon: const Icon(
                Icons.delete_outline_rounded,
                color: AppColors.error,
                size: 22,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _buildSubtitle() {
    final parts = <String>[];
    if (biodata.age.isNotEmpty) parts.add('Age: ${biodata.age}');
    if (biodata.city.isNotEmpty) parts.add(biodata.city);
    if (biodata.education.isNotEmpty) parts.add(biodata.education);
    return parts.isEmpty ? 'No details added' : parts.join(' • ');
  }
}