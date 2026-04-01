import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../core/constants/app_sizes.dart';
import '../../providers/biodata_provider.dart';
import '../../providers/saved_designs_provider.dart';
import '../../providers/template_provider.dart';
import 'widgets/design_list_item.dart';

class SavedDesignsScreen extends ConsumerWidget {
  const SavedDesignsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final designs = ref.watch(savedDesignsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 110,
            pinned: true,
            automaticallyImplyLeading: false,
            backgroundColor: AppColors.primary,
            actions: [
              if (designs.isNotEmpty)
                TextButton(
                  onPressed: () => _showClearAllDialog(context, ref),
                  child: const Text('Clear All', style: TextStyle(color: Colors.white70, fontSize: 13)),
                ),
            ],
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
                        const Text('My Designs', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text(
                          designs.isEmpty ? 'No designs yet' : '${designs.length} saved ${designs.length == 1 ? 'design' : 'designs'}',
                          style: const TextStyle(color: Colors.white70, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          if (designs.isEmpty)
            SliverFillRemaining(
              child: _EmptyState(onTap: () {
                ref.read(biodataProvider.notifier).resetForm();
                context.go(AppRoutes.home);
              }),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.all(AppSizes.md),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    final design = designs[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: AppSizes.sm),
                      child: DesignListItem(
                        biodata: design,
                        onTap: () {
                          ref.read(biodataProvider.notifier).loadFromSaved(design);
                          ref.read(selectedTemplateProvider.notifier).state = design.templateId;
                          context.push(AppRoutes.cardPreview);
                        },
                        onDelete: () => _showDeleteDialog(context, ref, design.id),
                      ),
                    );
                  },
                  childCount: designs.length,
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ref.read(biodataProvider.notifier).resetForm();
          context.go(AppRoutes.home);
        },
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: const Text('New Biodata', style: TextStyle(fontWeight: FontWeight.w600)),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, WidgetRef ref, String id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.radiusMd)),
        title: const Text('Delete Design'),
        content: const Text('Are you sure you want to delete this design?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              ref.read(savedDesignsProvider.notifier).delete(id);
              Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }

  void _showClearAllDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.radiusMd)),
        title: const Text('Clear All Designs'),
        content: const Text('This will delete all your saved designs. This cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              final designs = ref.read(savedDesignsProvider);
              for (final d in designs) {
                ref.read(savedDesignsProvider.notifier).delete(d.id);
              }
              Navigator.pop(context);
            },
            child: const Text('Clear All', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onTap;
  const _EmptyState({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.bookmark_border_rounded, size: 50, color: AppColors.primary),
            ),
            const SizedBox(height: 24),
            const Text('No Designs Yet', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textDark)),
            const SizedBox(height: 10),
            const Text(
              'Create your first biodata by choosing a template from the Home screen.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: AppColors.textMuted, height: 1.6),
            ),
            const SizedBox(height: 28),
            ElevatedButton.icon(
              onPressed: onTap,
              icon: const Icon(Icons.add_rounded),
              label: const Text('Create Biodata'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.radiusMd)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}