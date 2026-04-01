import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../core/constants/app_sizes.dart';
import '../../providers/template_provider.dart';
import 'widgets/template_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  static const List<TemplateInfo> _templates = [
    TemplateInfo(id: 1, name: 'Islamic Green', description: 'Classic green & gold Islamic border', color: Color(0xFF1B5E20)),
    TemplateInfo(id: 2, name: 'Floral Pink', description: 'Soft pink floral design for girls', color: Color(0xFFAD1457)),
    TemplateInfo(id: 3, name: 'Royal Maroon', description: 'Deep maroon mughal pattern', color: Color(0xFF6A1B1B)),
    TemplateInfo(id: 4, name: 'Modern Navy', description: 'Clean minimal navy design', color: Color(0xFF0D47A1)),
    TemplateInfo(id: 5, name: 'Simple White', description: 'Professional clean white card', color: Color(0xFF424242)),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTemplate = ref.watch(selectedTemplateProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // Polished SliverAppBar
          SliverAppBar(
            expandedHeight: 130,
            floating: false,
            pinned: true,
            backgroundColor: AppColors.primary,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF1B5E20), Color(0xFF2E7D32)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(Icons.favorite_rounded, color: Colors.white, size: 18),
                                ),
                                const SizedBox(width: 10),
                                const Text(
                                  'Rishta Biodata Maker',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Choose a template to get started',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Section label
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
              child: Row(
                children: [
                  Container(width: 4, height: 18, decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(2))),
                  const SizedBox(width: 8),
                  const Text(
                    'Available Templates',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textDark),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${_templates.length} designs',
                      style: const TextStyle(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Template grid
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  final template = _templates[index];
                  final isSelected = selectedTemplate == template.id;
                  return TemplateCard(
                    templateInfo: template,
                    isSelected: isSelected,
                    onTap: () {
                      ref.read(selectedTemplateProvider.notifier).state = template.id;
                      context.push(AppRoutes.templatePreview, extra: template.id);
                    },
                  );
                },
                childCount: _templates.length,
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: AppSizes.md,
                mainAxisSpacing: AppSizes.md,
                childAspectRatio: 0.72,
              ),
            ),
          ),
        ],
      ),
    );
  }
}