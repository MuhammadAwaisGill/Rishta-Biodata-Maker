import 'dart:io';
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../models/biodata_model.dart';

// Static maps — defined once, never rebuilt
const _templateColors = {
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

const _templateNames = {
  1:  'Islamic',
  2:  'Floral',
  3:  'Royal',
  4:  'Modern',
  5:  'Simple',
  6:  'Urdu',
  7:  'Two Column',
  8:  'Dark',
  9:  'Mughal',
  10: 'Photo',
};

const _templateEmojis = {
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

class DesignCard extends StatelessWidget {
  final Biodata biodata;
  final int index;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onDuplicate;

  const DesignCard({
    super.key,
    required this.biodata,
    required this.index,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
    required this.onDuplicate,
  });

  @override
  Widget build(BuildContext context) {
    final color = _templateColors[biodata.templateId] ?? AppColors.primary;
    final name = _templateNames[biodata.templateId] ?? 'Template';
    final emoji = _templateEmojis[biodata.templateId] ?? '📄';

    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
      elevation: 1,
      shadowColor: const Color(0x14000000),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Avatar
              _Avatar(
                photoPath: biodata.photoPath,
                emoji: emoji,
                color: color,
              ),

              const SizedBox(width: 14),

              // Info
              Expanded(
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
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      _subtitle(),
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textMuted,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    _TemplateBadge(name: name, color: color),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              // Actions
              _Actions(
                color: color,
                onTap: onTap,
                onEdit: onEdit,
                onDuplicate: onDuplicate,
                onDelete: onDelete,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _subtitle() {
    final parts = <String>[];
    if (biodata.age.isNotEmpty) parts.add('Age ${biodata.age}');
    if (biodata.city.isNotEmpty) parts.add(biodata.city);
    if (biodata.profession.isNotEmpty) parts.add(biodata.profession);
    return parts.isEmpty ? 'Tap to view' : parts.join(' • ');
  }
}

// ── Sub-widgets (all const-friendly) ─────────────────────────────────────────

class _Avatar extends StatelessWidget {
  final String photoPath;
  final String emoji;
  final Color color;

  const _Avatar({
    required this.photoPath,
    required this.emoji,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: Color.fromRGBO(
          color.red, color.green, color.blue, 0.1,
        ),
        shape: BoxShape.circle,
        border: Border.all(
          color: Color.fromRGBO(color.red, color.green, color.blue, 0.25),
          width: 1.5,
        ),
      ),
      child: photoPath.isNotEmpty
          ? ClipOval(
        child: Image.file(
          File(photoPath),
          width: 56,
          height: 56,
          fit: BoxFit.cover,
          // Cache at display size — big perf win
          cacheWidth: 112,
          cacheHeight: 112,
        ),
      )
          : Center(
        child: Text(emoji, style: const TextStyle(fontSize: 24)),
      ),
    );
  }
}

class _TemplateBadge extends StatelessWidget {
  final String name;
  final Color color;
  const _TemplateBadge({required this.name, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: Color.fromRGBO(color.red, color.green, color.blue, 0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: Color.fromRGBO(color.red, color.green, color.blue, 0.2),
        ),
      ),
      child: Text(
        name,
        style: TextStyle(
          fontSize: 10,
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _Actions extends StatelessWidget {
  final Color color;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDuplicate;
  final VoidCallback onDelete;

  const _Actions({
    required this.color,
    required this.onTap,
    required this.onEdit,
    required this.onDuplicate,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _IconBtn(icon: Icons.visibility_rounded, color: color, onTap: onTap),
        _IconBtn(icon: Icons.edit_rounded, color: AppColors.primary, onTap: onEdit),
        _IconBtn(icon: Icons.copy_rounded, color: AppColors.textMuted, onTap: onDuplicate),
        _IconBtn(icon: Icons.delete_outline_rounded, color: AppColors.error, onTap: onDelete),
      ],
    );
  }
}

class _IconBtn extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  const _IconBtn({required this.icon, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Icon(icon, color: color, size: 18),
      ),
    );
  }
}