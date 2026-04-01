import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_strings.dart';
import '../../providers/template_provider.dart';
import 'widgets/template_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  // Template data — extend this list to add more templates later
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTemplate = ref.watch(selectedTemplateProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        title: const Text(
          AppStrings.appName,
          style: TextStyle(
            color: AppColors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => context.push(AppRoutes.settings),
            icon: const Icon(
              Icons.settings_rounded,
              color: AppColors.white,
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header section
          Container(
            width: double.infinity,
            color: AppColors.primary,
            padding: const EdgeInsets.only(
              left: AppSizes.lg,
              right: AppSizes.lg,
              bottom: AppSizes.lg,
            ),
            child: const Text(
              'Choose a Template',
              style: TextStyle(
                color: AppColors.white,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),

          // Template grid
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(AppSizes.md),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: AppSizes.md,
                mainAxisSpacing: AppSizes.md,
                childAspectRatio: 0.72,
              ),
              itemCount: _templates.length,
              itemBuilder: (context, index) {
                final template = _templates[index];
                final isSelected = selectedTemplate == template.id;

                return TemplateCard(
                  templateInfo: template,
                  isSelected: isSelected,
                  onTap: () {
                    ref
                        .read(selectedTemplateProvider.notifier)
                        .state = template.id;
                    context.push(
                      AppRoutes.templatePreview,
                      extra: template.id,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),

      // Bottom navigation
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textMuted,
        backgroundColor: AppColors.surface,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        onTap: (index) {
          switch (index) {
            case 0:
              break; // already on home
            case 1:
              context.push(AppRoutes.savedDesigns);
              break;
            case 2:
              context.push(AppRoutes.settings);
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: AppStrings.navHome,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark_rounded),
            label: AppStrings.navSaved,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_rounded),
            label: AppStrings.navSettings,
          ),
        ],
      ),
    );
  }
}
