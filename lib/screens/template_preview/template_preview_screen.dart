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
  const TemplatePreviewScreen({super.key, required this.templateId});

  static const List<TemplateInfo> _templates = [
    TemplateInfo(id: 1, name: 'Islamic Green', description: 'Classic green & gold Islamic border', color: Color(0xFF1B5E20)),
    TemplateInfo(id: 2, name: 'Floral Pink', description: 'Soft pink floral design for girls', color: Color(0xFFAD1457)),
    TemplateInfo(id: 3, name: 'Royal Maroon', description: 'Deep maroon mughal pattern', color: Color(0xFF6A1B1B)),
    TemplateInfo(id: 4, name: 'Modern Navy', description: 'Clean minimal navy design', color: Color(0xFF0D47A1)),
    TemplateInfo(id: 5, name: 'Simple White', description: 'Professional clean white card', color: Color(0xFF424242)),
  ];

  TemplateInfo get _current => _templates.firstWhere((t) => t.id == templateId);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = _current;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
        ),
        title: Text(t.name, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSizes.lg),
              child: Column(
                children: [
                  // Large preview card
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [t.color.withOpacity(0.08), t.color.withOpacity(0.15)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: t.color.withOpacity(0.25), width: 1.5),
                    ),
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      children: [
                        Container(
                          width: 80, height: 80,
                          decoration: BoxDecoration(color: t.color, shape: BoxShape.circle),
                          child: Center(
                            child: Text('${t.id}', style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(t.name, style: TextStyle(color: t.color, fontSize: 22, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Text(t.description, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.textMuted, fontSize: 14)),
                        const SizedBox(height: 28),
                        // Mock biodata lines
                        ...[0.75, 0.55, 0.65, 0.45, 0.6].map((w) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Row(
                            children: [
                              Container(width: 80, height: 8, decoration: BoxDecoration(color: t.color.withOpacity(0.35), borderRadius: BorderRadius.circular(4))),
                              const SizedBox(width: 12),
                              Expanded(child: FractionallySizedBox(
                                widthFactor: w, alignment: Alignment.centerLeft,
                                child: Container(height: 8, decoration: BoxDecoration(color: t.color.withOpacity(0.15), borderRadius: BorderRadius.circular(4))),
                              )),
                            ],
                          ),
                        )),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppSizes.lg),

                  // Feature highlights
                  Row(
                    children: [
                      _featureChip(Icons.download_rounded, 'Downloadable', t.color),
                      const SizedBox(width: 8),
                      _featureChip(Icons.share_rounded, 'Shareable', t.color),
                      const SizedBox(width: 8),
                      _featureChip(Icons.edit_rounded, 'Editable', t.color),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Bottom CTA
          Container(
            padding: const EdgeInsets.all(AppSizes.lg),
            decoration: BoxDecoration(
              color: AppColors.surface,
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 10, offset: const Offset(0, -3))],
            ),
            child: SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: () {
                  ref.read(selectedTemplateProvider.notifier).state = templateId;
                  context.push(AppRoutes.form);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.radiusMd)),
                  elevation: 2,
                ),
                icon: const Icon(Icons.edit_rounded, size: 20),
                label: const Text(AppStrings.btnUseTemplate, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _featureChip(IconData icon, String label, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 4),
            Text(label, style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}