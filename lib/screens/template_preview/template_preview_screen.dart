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

  static const Map<int, String> _templateEmojis = {
    1: '☪️',
    2: '🌸',
    3: '👑',
    4: '💼',
    5: '📄',
  };

  static const Map<int, List<String>> _templateFeatures = {
    1: ['Islamic bismillah header', 'Green & gold theme', 'Urdu-friendly layout'],
    2: ['Floral pink design', 'Perfect for girls', 'Elegant feminine style'],
    3: ['Royal mughal borders', 'Deep maroon theme', 'Premium regal feel'],
    4: ['Clean modern layout', 'Navy blue accents', 'Professional look'],
    5: ['Minimal white design', 'Black & grey tones', 'Simple & clean'],
  };

  TemplateInfo get _current => _templates.firstWhere((t) => t.id == templateId);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = _current;
    final features = _templateFeatures[templateId] ?? [];
    final emoji = _templateEmojis[templateId] ?? '📄';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // AppBar
          SliverAppBar(
            expandedHeight: 0,
            pinned: true,
            backgroundColor: t.color,
            elevation: 0,
            leading: IconButton(
              onPressed: () => context.pop(),
              icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
            ),
            title: Text(
              t.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            actions: [
              Container(
                margin: const EdgeInsets.only(right: 12),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.star_rounded, color: Color(0xFFFFD700), size: 14),
                    SizedBox(width: 4),
                    Text('Free', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          ),

          SliverToBoxAdapter(
            child: Column(
              children: [
                // Hero section
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [t.color, t.color.withOpacity(0.8)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 36),
                  child: Column(
                    children: [
                      // Emoji in circle
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withOpacity(0.4),
                            width: 2,
                          ),
                        ),
                        child: Center(
                          child: Text(emoji, style: const TextStyle(fontSize: 48)),
                        ),
                      ),

                      const SizedBox(height: 16),

                      Text(
                        t.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 6),

                      Text(
                        t.description,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 14,
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Feature pills
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        alignment: WrapAlignment.center,
                        children: features.map((f) => Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.check_circle_rounded,
                                size: 13,
                                color: Color(0xFFFFD700),
                              ),
                              const SizedBox(width: 5),
                              Text(
                                f,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        )).toList(),
                      ),
                    ],
                  ),
                ),

                // Curved transition
                Container(
                  height: 24,
                  decoration: BoxDecoration(
                    color: t.color.withOpacity(0.8),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(28),
                      bottomRight: Radius.circular(28),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Mock biodata preview card
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: t.color.withOpacity(0.15),
                          blurRadius: 20,
                          offset: const Offset(0, 6),
                        ),
                      ],
                      border: Border.all(
                        color: t.color.withOpacity(0.2),
                      ),
                    ),
                    child: Column(
                      children: [
                        // Card header
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: t.color,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15),
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.person_rounded,
                                    color: Colors.white, size: 24),
                              ),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Sample Name',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                  Text(
                                    'Age 25 • Lahore',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.8),
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // Mock rows
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              _mockSection('Personal', t.color),
                              _mockRow('Education', 'BA/BSc', t.color),
                              _mockRow('Profession', 'Software Engineer', t.color),
                              _mockSection('Family', t.color),
                              _mockRow("Father's Name", 'Muhammad Ali', t.color),
                              _mockRow('Family Type', 'Joint Family', t.color),
                              _mockSection('Religious', t.color),
                              _mockRow('Sect', 'Sunni', t.color),
                            ],
                          ),
                        ),

                        // Footer
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: t.color.withOpacity(0.08),
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(15),
                              bottomRight: Radius.circular(15),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'Made with Rishta Biodata Maker',
                              style: TextStyle(
                                fontSize: 11,
                                color: t.color,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Action chips row
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      _actionChip(Icons.download_rounded, 'Download', AppColors.primary),
                      const SizedBox(width: 10),
                      _actionChip(Icons.picture_as_pdf_rounded, 'PDF', AppColors.error),
                      const SizedBox(width: 10),
                      _actionChip(Icons.share_rounded, 'Share', const Color(0xFF0D47A1)),
                    ],
                  ),
                ),

                const SizedBox(height: 100),
              ],
            ),
          ),
        ],
      ),

      // Floating CTA button
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
        decoration: BoxDecoration(
          color: AppColors.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: SizedBox(
          height: 54,
          child: ElevatedButton.icon(
            onPressed: () {
              ref.read(selectedTemplateProvider.notifier).state = templateId;
              context.push(AppRoutes.form);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: t.color,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSizes.radiusMd),
              ),
              elevation: 0,
            ),
            icon: const Icon(Icons.edit_rounded, size: 20),
            label: const Text(
              AppStrings.btnUseTemplate,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ),
    );
  }

  Widget _mockSection(String title, Color color) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 6),
      child: Row(
        children: [
          Container(width: 3, height: 12, color: color),
          const SizedBox(width: 6),
          Text(
            title.toUpperCase(),
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: color,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(child: Divider(color: color.withOpacity(0.2), height: 1)),
        ],
      ),
    );
  }

  Widget _mockRow(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const Text(': ', style: TextStyle(fontSize: 12)),
          Text(
            value,
            style: const TextStyle(fontSize: 12, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  Widget _actionChip(IconData icon, String label, Color color) {
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
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}