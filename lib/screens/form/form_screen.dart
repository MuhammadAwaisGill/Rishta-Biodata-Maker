import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_strings.dart';
import '../../providers/biodata_provider.dart';
import '../../providers/template_provider.dart';
import '../home/widgets/template_card.dart';
import 'widgets/personal_section.dart';
import 'widgets/education_section.dart';
import 'widgets/family_section.dart';
import 'widgets/religious_section.dart';
import 'widgets/field_visibility_sheet.dart';
import 'widgets/preferences_section.dart';
import 'widgets/photo_picker_widget.dart';

class FormScreen extends ConsumerStatefulWidget {
  const FormScreen({super.key});

  @override
  ConsumerState<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends ConsumerState<FormScreen> {
  // ✅ formKey as a field — NEVER create GlobalKey in build()
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  static const List<TemplateInfo> _templates = [
    TemplateInfo(id: 1, name: 'Islamic Green', description: '', color: Color(0xFF6A1B1B)),
    TemplateInfo(id: 2, name: 'Floral Pink',   description: '', color: Color(0xFFAD1457)),
    TemplateInfo(id: 3, name: 'Royal Maroon',  description: '', color: Color(0xFF6A1B1B)),
    TemplateInfo(id: 4, name: 'Modern Navy',   description: '', color: Color(0xFF0D47A1)),
    TemplateInfo(id: 5, name: 'Simple White',  description: '', color: Color(0xFF424242)),
  ];

  void _showResetDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        ),
        title: const Row(
          children: [
            Icon(Icons.refresh_rounded, color: AppColors.primary),
            SizedBox(width: 8),
            Text('Reset Form?'),
          ],
        ),
        content: const Text('All your entered data will be cleared. Are you sure?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ref.read(biodataProvider.notifier).resetForm();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedTemplate = ref.watch(selectedTemplateProvider);
    final biodataId        = ref.watch(biodataProvider.select((b) => b.id));
    final completion = ref.watch(biodataProvider.select((b) => b.completionPercent));
    final currentTemplate  = _templates.firstWhere(
          (t) => t.id == selectedTemplate,
      orElse: () => _templates.first,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // ── AppBar ────────────────────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 130,
            pinned: true,
            backgroundColor: currentTemplate.color,
            elevation: 0,
            leading: IconButton(
              onPressed: () => context.pop(),
              icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
            ),
            actions: [
              TextButton.icon(
                onPressed: _showResetDialog,
                icon: const Icon(Icons.refresh_rounded, color: Colors.white70, size: 16),
                label: const Text('Reset', style: TextStyle(color: Colors.white70, fontSize: 13)),
              ),
              IconButton(
                onPressed: () => showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  builder: (_) => const FieldVisibilitySheet(),
                ),
                icon: const Icon(Icons.tune_rounded, color: Colors.white70, size: 20),
                tooltip: 'Customize Fields',
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [currentTemplate.color, currentTemplate.color.withOpacity(0.8)],
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
                        const SizedBox(height: 44),
                        const Text(
                          'Fill Your Biodata',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                currentTemplate.name,
                                style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w500),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'template selected',
                              style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 11),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // ── Form body ──────────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(AppSizes.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Photo picker — keyed to biodataId so it clears on reset
                    Container(
                      key: ValueKey('photo_$biodataId'),
                      width: double.infinity,
                      padding: const EdgeInsets.all(AppSizes.lg),
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
                        children: [
                          const PhotoPickerWidget(),
                          const SizedBox(height: AppSizes.sm),
                          Text(
                            'Add your photo for a more personal touch',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textMuted.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: AppSizes.md),

                    // Progress bar
                    Container(
                      padding: const EdgeInsets.all(AppSizes.md),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Profile Completion',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textDark,
                                ),
                              ),
                              Text(
                                '${(completion * 100).toInt()}%',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: currentTemplate.color,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: completion,
                              minHeight: 6,
                              backgroundColor: AppColors.textMuted.withOpacity(0.15),
                              valueColor: AlwaysStoppedAnimation<Color>(currentTemplate.color),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: AppSizes.md),
                    // Tip banner
                    Container(
                      padding: const EdgeInsets.all(AppSizes.md),
                      decoration: BoxDecoration(
                        color: currentTemplate.color.withOpacity(0.06),
                        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                        border: Border.all(color: currentTemplate.color.withOpacity(0.2)),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.lightbulb_rounded, color: currentTemplate.color, size: 18),
                          const SizedBox(width: AppSizes.sm),
                          Expanded(
                            child: Text(
                              'Only Name & Age are required. All other fields are optional.',
                              style: TextStyle(
                                fontSize: 12,
                                color: currentTemplate.color,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: AppSizes.md),

                    _sectionLabel('Your Information'),
                    const SizedBox(height: AppSizes.sm),

                    // ── Form sections — keyed to biodataId for reset support ──
                    PersonalSection(key: ValueKey('personal_$biodataId')),
                    const SizedBox(height: AppSizes.sm),
                    EducationSection(key: ValueKey('education_$biodataId')),
                    const SizedBox(height: AppSizes.sm),
                    FamilySection(key: ValueKey('family_$biodataId')),
                    const SizedBox(height: AppSizes.sm),
                    ReligiousSection(key: ValueKey('religious_$biodataId')),
                    const SizedBox(height: AppSizes.sm),
                    PreferencesSection(key: ValueKey('prefs_$biodataId')),

                    const SizedBox(height: AppSizes.xl),

                    // ── Generate button ────────────────────────────────────
                    _buildGenerateButton(currentTemplate),

                    const SizedBox(height: AppSizes.xl),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenerateButton(TemplateInfo template) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [template.color, template.color.withOpacity(0.85)],
        ),
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        boxShadow: [
          BoxShadow(
            color: template.color.withOpacity(0.4),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: () {
          if (_formKey.currentState?.validate() ?? false) {
            context.push(AppRoutes.cardPreview);
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          ),
        ),
        icon: const Icon(Icons.auto_awesome_rounded, size: 22, color: Colors.white),
        label: const Text(
          AppStrings.btnGenerate,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }

  Widget _sectionLabel(String label) {
    return Row(
      children: [
        const Icon(Icons.info_outline_rounded, size: 15, color: AppColors.textMuted),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textMuted,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}