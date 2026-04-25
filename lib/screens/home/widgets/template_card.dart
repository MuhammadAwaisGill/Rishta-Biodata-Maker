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

// ── All 10 templates ──────────────────────────────────────────────────────────

class AppTemplates {
  AppTemplates._();

  static const List<TemplateInfo> all = [
    TemplateInfo(id: 1, name: 'Islamic Green', description: 'Classic green & gold Islamic border', color: Color(0xFF6A1B1B)),
    TemplateInfo(id: 2, name: 'Floral Pink',   description: 'Soft pink floral design for girls',  color: Color(0xFFAD1457)),
    TemplateInfo(id: 3, name: 'Royal Maroon',  description: 'Deep maroon mughal pattern',         color: Color(0xFF6A1B1B)),
    TemplateInfo(id: 4, name: 'Modern Navy',   description: 'Clean minimal navy design',          color: Color(0xFF0D47A1)),
    TemplateInfo(id: 5, name: 'Simple White',  description: 'Professional clean white card',      color: Color(0xFF424242)),
    TemplateInfo(id: 6, name: 'Urdu Calligraphy', description: 'Ornate Urdu calligraphy style',   color: Color(0xFF6A0DAD)),
    TemplateInfo(id: 7, name: 'Two Column',    description: 'Compact teal two-column layout',     color: Color(0xFF00695C)),
    TemplateInfo(id: 8, name: 'Minimalist Dark', description: 'Sleek dark with orange accents',   color: Color(0xFF1C1C1E)),
    TemplateInfo(id: 9, name: 'Mughal Royal',  description: 'Ornate gold & burgundy Mughal',      color: Color(0xFF4A0828)),
    TemplateInfo(id: 10, name: 'Photo Focused', description: 'Large photo hero with indigo theme', color: Color(0xFF283593)),
  ];
}

// ── Template card widget ──────────────────────────────────────────────────────

class TemplateCard extends StatelessWidget {
  final TemplateInfo templateInfo;
  final bool isSelected;
  final VoidCallback onTap;
  final String emoji;

  const TemplateCard({
    super.key,
    required this.templateInfo,
    required this.isSelected,
    required this.onTap,
    this.emoji = '📄',
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
            color: isSelected
                ? AppColors.secondary
                : templateInfo.color.withOpacity(0.15),
            width: isSelected ? 3 : 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? templateInfo.color.withOpacity(0.2)
                  : Colors.black.withOpacity(0.07),
              blurRadius: isSelected ? 16 : 8,
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
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        templateInfo.color.withOpacity(0.15),
                        templateInfo.color.withOpacity(0.08),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Background icon (subtle)
                      Positioned(
                        right: -10,
                        bottom: -10,
                        child: Icon(
                          Icons.article_rounded,
                          size: 90,
                          color: templateInfo.color.withOpacity(0.08),
                        ),
                      ),

                      // Center content
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Emoji in colored circle
                          Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              color: templateInfo.color,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: templateInfo.color.withOpacity(0.4),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                emoji,
                                style: const TextStyle(fontSize: 26),
                              ),
                            ),
                          ),
                          const SizedBox(height: AppSizes.sm),
                          Text(
                            templateInfo.name,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: templateInfo.color,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 4),
                          // Template ID badge
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: templateInfo.color.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              'Template ${templateInfo.id}',
                              style: TextStyle(
                                fontSize: 9,
                                color: templateInfo.color,
                                fontWeight: FontWeight.w600,
                              ),
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
                            padding: const EdgeInsets.all(3),
                            decoration: const BoxDecoration(
                              color: AppColors.secondary,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.check_rounded,
                              size: 14,
                              color: Colors.white,
                            ),
                          ),
                        ),

                      // "New" badge for templates 6-10
                      if (templateInfo.id > 5 && !isSelected)
                        Positioned(
                          top: 8,
                          left: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFF6B35),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              'NEW',
                              style: TextStyle(
                                fontSize: 8,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
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
                  vertical: 6,
                ),
                child: Text(
                  templateInfo.description,
                  style: const TextStyle(
                    fontSize: 10,
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