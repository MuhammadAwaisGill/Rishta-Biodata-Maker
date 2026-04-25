import 'dart:io';
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../models/biodata_model.dart';

class DesignListItem extends StatelessWidget {
  final Biodata biodata;
  final int index;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final VoidCallback onDuplicate;

  const DesignListItem({
    super.key,
    required this.biodata,
    required this.index,
    required this.onTap,
    required this.onDelete,
    required this.onDuplicate,
  });

  // ── All 10 templates mapped ──────────────────────────────────────────────
  static const _templateColors = {
    1:  Color(0xFF6A1B1B),
    2:  Color(0xFFAD1457),
    3:  Color(0xFF6A1B1B),
    4:  Color(0xFF0D47A1),
    5:  Color(0xFF424242),
    6:  Color(0xFF6A0DAD),
    7:  Color(0xFF00695C),
    8:  Color(0xFF1C1C1E),
    9:  Color(0xFF4A0828),
    10: Color(0xFF283593),
  };

  static const _templateNames = {
    1:  'Islamic Green',
    2:  'Floral Pink',
    3:  'Royal Maroon',
    4:  'Modern Navy',
    5:  'Simple White',
    6:  'Urdu Calligraphy',
    7:  'Two Column',
    8:  'Minimalist Dark',
    9:  'Mughal Royal',
    10: 'Photo Focused',
  };

  static const _templateEmojis = {
    1:  '☪️',
    2:  '🌸',
    3:  '👑',
    4:  '💼',
    5:  '📄',
    6:  '🕌',
    7:  '📊',
    8:  '🌙',
    9:  '⚜️',
    10: '📸',
  };

  @override
  Widget build(BuildContext context) {
    final color        = _templateColors[biodata.templateId] ?? AppColors.primary;
    final templateName = _templateNames[biodata.templateId] ?? 'Template ${biodata.templateId}';
    final emoji        = _templateEmojis[biodata.templateId] ?? '📄';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // ── Colored left panel ───────────────────────────────────────
            Container(
              width: 72,
              height: 90,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    color.withOpacity(0.15),
                    color.withOpacity(0.08),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(AppSizes.radiusMd),
                  bottomLeft: Radius.circular(AppSizes.radiusMd),
                ),
                border: Border(
                  left: BorderSide(color: color, width: 3),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  biodata.photoPath.isNotEmpty
                      ? CircleAvatar(
                    radius: 22,
                    backgroundImage:
                    FileImage(File(biodata.photoPath)),
                  )
                      : Text(emoji,
                      style: const TextStyle(fontSize: 26)),
                  const SizedBox(height: 4),
                  Text(
                    '#${index + 1}',
                    style: TextStyle(
                      fontSize: 10,
                      color: color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 12),

            // ── Info ─────────────────────────────────────────────────────
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      biodata.name.isEmpty ? 'Unnamed Biodata' : biodata.name,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
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
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                        border:
                        Border.all(color: color.withOpacity(0.2)),
                      ),
                      child: Text(
                        templateName,
                        style: TextStyle(
                          fontSize: 10,
                          color: color,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── Actions ──────────────────────────────────────────────────
            Column(
              children: [
                IconButton(
                  onPressed: onTap,
                  icon: Icon(Icons.visibility_rounded, color: color, size: 20),
                  tooltip: 'View',
                ),
                IconButton(
                  onPressed: onDuplicate,
                  icon: const Icon(Icons.copy_rounded,
                      color: AppColors.primary, size: 20),
                  tooltip: 'Duplicate',
                ),
                IconButton(
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete_outline_rounded,
                      color: AppColors.error, size: 20),
                  tooltip: 'Delete',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _buildSubtitle() {
    final parts = <String>[];
    if (biodata.age.isNotEmpty) parts.add('Age ${biodata.age}');
    if (biodata.city.isNotEmpty) parts.add(biodata.city);
    if (biodata.education.isNotEmpty) parts.add(biodata.education);
    return parts.isEmpty ? 'No details added' : parts.join(' • ');
  }
}