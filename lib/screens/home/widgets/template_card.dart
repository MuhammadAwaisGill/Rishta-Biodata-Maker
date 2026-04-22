import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';

// ── Template data model ───────────────────────────────────────────────────────

class TemplateInfo {
  final int id;
  final String name;
  final String description;
  final Color color;

  const TemplateInfo({
    required this.id,
    required this.name,
    required this.description,
    required this.color,
  });
}

// ── All templates in one place ────────────────────────────────────────────────

class AppTemplates {
  AppTemplates._();

  static const List<TemplateInfo> all = [
    TemplateInfo(
      id: 1,
      name: 'Islamic Green',
      description: 'Classic green & gold Islamic border',
      color: Color(0xFF1B5E20),
    ),
    TemplateInfo(
      id: 2,
      name: 'Floral Pink',
      description: 'Soft pink floral design for girls',
      color: Color(0xFFAD1457),
    ),
    TemplateInfo(
      id: 3,
      name: 'Royal Maroon',
      description: 'Deep maroon mughal pattern',
      color: Color(0xFF6A1B1B),
    ),
    TemplateInfo(
      id: 4,
      name: 'Modern Navy',
      description: 'Clean minimal navy design',
      color: Color(0xFF0D47A1),
    ),
    TemplateInfo(
      id: 5,
      name: 'Simple White',
      description: 'Professional clean white card',
      color: Color(0xFF424242),
    ),
    TemplateInfo(id: 6, name: 'Urdu Calligraphy', description: 'Classical Urdu style with ornate borders', color: Color(0xFF6A0DAD)),
    TemplateInfo(id: 7, name: 'Two Column', description: 'Compact two-column teal layout', color: Color(0xFF00695C)),
    TemplateInfo(id: 8, name: 'Minimalist Dark', description: 'Sleek dark mode with orange accents', color: Color(0xFF1C1C1E)),
    TemplateInfo(id: 9, name: 'Mughal Royal', description: 'Ornate Mughal-inspired gold & burgundy', color: Color(0xFF4A0828)),
    TemplateInfo(id: 10, name: 'Photo Focused', description: 'Large photo hero with indigo theme', color: Color(0xFF283593)),
  ];
}

// ── Template card widget ──────────────────────────────────────────────────────

class TemplateCard extends StatelessWidget {
  final TemplateInfo templateInfo;
  final bool isSelected;
  final VoidCallback onTap;

  const TemplateCard({
    super.key,
    required this.templateInfo,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          border: Border.all(
            color: isSelected ? AppColors.secondary : Colors.transparent,
            width: 3,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Template preview area
              Expanded(
                child: Container(
                  width: double.infinity,
                  color: templateInfo.color.withOpacity(0.12),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Background icon
                      Icon(
                        Icons.article_rounded,
                        size: 80,
                        color: templateInfo.color.withOpacity(0.15),
                      ),

                      // Center content
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: templateInfo.color,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                '${templateInfo.id}',
                                style: const TextStyle(
                                  color: AppColors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: AppSizes.sm),
                          Text(
                            templateInfo.name,
                            style: TextStyle(
                              color: templateInfo.color,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),

                      // Selected badge
                      if (isSelected)
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: const BoxDecoration(
                              color: AppColors.secondary,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.check_rounded,
                              size: 16,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              // Card footer
              Container(
                width: double.infinity,
                color: AppColors.surface,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.sm,
                  vertical: AppSizes.xs,
                ),
                child: Text(
                  templateInfo.description,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textMuted,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}