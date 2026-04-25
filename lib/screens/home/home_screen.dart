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

  // Use AppTemplates.all for all 10 templates
  static final List<TemplateInfo> _templates = AppTemplates.all;

  static const Map<int, String> _templateEmojis = {
    1: '☪️',
    2: '🌸',
    3: '👑',
    4: '💼',
    5: '📄',
    6: '🕌',
    7: '📊',
    8: '🌙',
    9: '⚜️',
    10: '📸',
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTemplate = ref.watch(selectedTemplateProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // Enhanced SliverAppBar
          SliverAppBar(
            expandedHeight: 190,
            floating: false,
            pinned: true,
            backgroundColor: AppColors.primary,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF3B0A0A),
                      Color(0xFF6A1B1B),
                      Color(0xFF8B2020)
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Stack(
                  children: [
                    // Decorative circles
                    Positioned(
                      top: -20,
                      right: -20,
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.05),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 30,
                      right: 60,
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.06),
                        ),
                      ),
                    ),
                    SafeArea(
                      child: Padding(
                        padding:
                        const EdgeInsets.fromLTRB(20, 12, 20, 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Top row
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 38,
                                      height: 38,
                                      decoration: BoxDecoration(
                                        color:
                                        Colors.white.withOpacity(0.15),
                                        borderRadius:
                                        BorderRadius.circular(11),
                                        border: Border.all(
                                          color:
                                          Colors.white.withOpacity(0.2),
                                        ),
                                      ),
                                      child: const Icon(
                                        Icons.favorite_rounded,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    const Text(
                                      'Rishta Biodata Maker',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFFD700)
                                        .withOpacity(0.2),
                                    borderRadius:
                                    BorderRadius.circular(20),
                                    border: Border.all(
                                      color: const Color(0xFFFFD700)
                                          .withOpacity(0.5),
                                    ),
                                  ),
                                  child: const Row(
                                    children: [
                                      Icon(Icons.star_rounded,
                                          color: Color(0xFFFFD700),
                                          size: 14),
                                      SizedBox(width: 4),
                                      Text(
                                        'Free',
                                        style: TextStyle(
                                          color: Color(0xFFFFD700),
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            const Spacer(),

                            const Text(
                              'Assalam o Alaikum! 👋',
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 13),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Choose a Template',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 2),
                            const Text(
                              'Create your perfect rishta biodata in minutes',
                              style: TextStyle(
                                  color: Colors.white60, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Stats row
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              padding:
              const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius:
                BorderRadius.circular(AppSizes.radiusMd),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  _statItem(Icons.article_rounded, '10', 'Templates',
                      AppColors.primary),
                  _divider(),
                  _statItem(Icons.download_rounded, 'Free', 'Download',
                      const Color(0xFF0D47A1)),
                  _divider(),
                  _statItem(Icons.picture_as_pdf_rounded, 'PDF',
                      'Export', AppColors.error),
                  _divider(),
                  _statItem(Icons.qr_code_rounded, 'QR', 'Code',
                      const Color(0xFF6A0DAD)),
                ],
              ),
            ),
          ),

          // Section label
          SliverToBoxAdapter(
            child: Padding(
              padding:
              const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Row(
                children: [
                  Container(
                    width: 4,
                    height: 18,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Available Templates',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${_templates.length} designs',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Template grid — ALL 10 templates
          SliverPadding(
            padding:
            const EdgeInsets.fromLTRB(16, 4, 16, 24),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  final template = _templates[index];
                  final isSelected = selectedTemplate == template.id;
                  final emoji = _templateEmojis[template.id] ?? '📄';
                  return TemplateCard(
                    templateInfo: template,
                    isSelected: isSelected,
                    emoji: emoji,
                    onTap: () {
                      ref
                          .read(selectedTemplateProvider.notifier)
                          .state = template.id;
                      context.push(AppRoutes.templatePreview,
                          extra: template.id);
                    },
                  );
                },
                childCount: _templates.length,
              ),
              gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
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

  Widget _statItem(
      IconData icon, String value, String label, Color color) {
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return Container(
      width: 1,
      height: 40,
      color: AppColors.textMuted.withOpacity(0.15),
    );
  }
}