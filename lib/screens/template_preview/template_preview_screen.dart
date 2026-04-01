import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_strings.dart';
import '../../providers/template_provider.dart';
import '../home/widgets/template_card.dart';

class TemplatePreviewScreen extends ConsumerWidget {
  final int templateId;

  const TemplatePreviewScreen({
    super.key,
    required this.templateId,
  });

  // Same list as home — single source of truth via TemplateInfo
  static const List<TemplateInfo> _templates = [
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
  ];

  TemplateInfo get _currentTemplate =>
      _templates.firstWhere((t) => t.id == templateId);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final template = _currentTemplate;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.white),
        ),
        title: Text(
          template.name,
          style: const TextStyle(
            color: AppColors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(
        children: [
          // Preview area
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSizes.lg),
              child: Column(
                children: [
                  // Template large preview card
                  Container(
                    width: double.infinity,
                    height: 420,
                    decoration: BoxDecoration(
                      color: template.color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                      border: Border.all(
                        color: template.color.withOpacity(0.3),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: template.color.withOpacity(0.15),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            color: template.color,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '${template.id}',
                              style: const TextStyle(
                                color: AppColors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSizes.md),
                        Text(
                          template.name,
                          style: TextStyle(
                            color: template.color,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: AppSizes.sm),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSizes.xl,
                          ),
                          child: Text(
                            template.description,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: AppColors.textMuted,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSizes.xl),
                        // Placeholder lines simulating biodata content
                        _buildPreviewLine(template.color, 0.7),
                        const SizedBox(height: AppSizes.sm),
                        _buildPreviewLine(template.color, 0.5),
                        const SizedBox(height: AppSizes.sm),
                        _buildPreviewLine(template.color, 0.6),
                        const SizedBox(height: AppSizes.sm),
                        _buildPreviewLine(template.color, 0.4),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppSizes.lg),

                  // Template info
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppSizes.md),
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          template.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDark,
                          ),
                        ),
                        const SizedBox(height: AppSizes.xs),
                        Text(
                          template.description,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom action button
          Container(
            padding: const EdgeInsets.all(AppSizes.lg),
            decoration: BoxDecoration(
              color: AppColors.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 10,
                  offset: const Offset(0, -3),
                ),
              ],
            ),
            child: SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: () {
                  ref.read(selectedTemplateProvider.notifier).state =
                      templateId;
                  context.push(AppRoutes.form);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                  ),
                  elevation: 2,
                ),
                icon: const Icon(Icons.edit_rounded, size: 20),
                label: const Text(
                  AppStrings.btnUseTemplate,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewLine(Color color, double widthFactor) {
    return FractionallySizedBox(
      widthFactor: widthFactor,
      child: Container(
        height: 8,
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }
}