import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';

// All template data — static, defined once
const _templates = [
  _TInfo(1,  '☪️', 'Islamic',      Color(0xFF6A1B1B)),
  _TInfo(2,  '🌸', 'Floral Pink',  Color(0xFFAD1457)),
  _TInfo(3,  '👑', 'Royal',        Color(0xFF6A1B1B)),
  _TInfo(4,  '💼', 'Modern Navy',  Color(0xFF0D47A1)),
  _TInfo(5,  '📄', 'Simple',       Color(0xFF424242)),
  _TInfo(6,  '🕌', 'Urdu',         Color(0xFF6A0DAD)),
  _TInfo(7,  '📊', 'Two Column',   Color(0xFF00695C)),
  _TInfo(8,  '🌙', 'Dark',         Color(0xFF1C1C1E)),
  _TInfo(9,  '⚜️', 'Mughal',       Color(0xFF4A0828)),
  _TInfo(10, '📸', 'Photo Focus',  Color(0xFF283593)),
];

class TemplatePickerSheet extends StatelessWidget {
  final void Function(int templateId) onSelect;
  const TemplatePickerSheet({super.key, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          const SizedBox(height: 10),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.textMuted,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),

          // Title
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Text(
                  'Choose a Template',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '10 designs available',
                style: TextStyle(fontSize: 12, color: AppColors.textMuted),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Grid
          SizedBox(
            height: 340,
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              physics: const BouncingScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.85,
              ),
              itemCount: _templates.length,
              itemBuilder: (context, index) {
                final t = _templates[index];
                return _TemplateCell(info: t, onTap: () => onSelect(t.id));
              },
            ),
          ),

          const SizedBox(height: 16),
          SafeArea(child: const SizedBox.shrink()),
        ],
      ),
    );
  }
}

class _TemplateCell extends StatelessWidget {
  final _TInfo info;
  final VoidCallback onTap;
  const _TemplateCell({required this.info, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Color.fromRGBO(
              info.color.red, info.color.green, info.color.blue, 0.08),
          borderRadius: BorderRadius.circular(AppSizes.radiusSm),
          border: Border.all(
            color: Color.fromRGBO(
                info.color.red, info.color.green, info.color.blue, 0.2),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: info.color,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(info.emoji,
                    style: const TextStyle(fontSize: 20)),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              info.name,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: info.color,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

// Simple data class — const constructible
class _TInfo {
  final int id;
  final String emoji;
  final String name;
  final Color color;
  const _TInfo(this.id, this.emoji, this.name, this.color);
}