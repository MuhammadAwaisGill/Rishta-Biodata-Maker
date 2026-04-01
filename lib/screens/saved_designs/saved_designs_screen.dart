import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_strings.dart';
import '../../providers/biodata_provider.dart';
import '../../providers/saved_designs_provider.dart';
import '../../providers/template_provider.dart';
import 'widgets/design_list_item.dart';
import 'widgets/empty_state.dart';

class SavedDesignsScreen extends ConsumerWidget {
  const SavedDesignsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final designs = ref.watch(savedDesignsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.white),
        ),
        title: const Text(
          'My Designs',
          style: TextStyle(
            color: AppColors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          if (designs.isNotEmpty)
            TextButton(
              onPressed: () => _showClearAllDialog(context, ref),
              child: const Text(
                'Clear All',
                style: TextStyle(color: AppColors.white, fontSize: 13),
              ),
            ),
        ],
      ),
      body: designs.isEmpty
          ? const EmptyState()
          : ListView.separated(
        padding: const EdgeInsets.all(AppSizes.md),
        itemCount: designs.length,
        separatorBuilder: (_, __) =>
        const SizedBox(height: AppSizes.sm),
        itemBuilder: (context, index) {
          final design = designs[index];
          return DesignListItem(
            biodata: design,
            onTap: () {
              // Load this design into provider then go to preview
              ref
                  .read(biodataProvider.notifier)
                  .loadFromSaved(design);
              ref
                  .read(selectedTemplateProvider.notifier)
                  .state = design.templateId;
              context.push(AppRoutes.cardPreview);
            },
            onDelete: () => _showDeleteDialog(context, ref, design.id),
          );
        },
      ),

      // FAB to create new design
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ref.read(biodataProvider.notifier).resetForm();
          context.push(AppRoutes.home);
        },
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        icon: const Icon(Icons.add_rounded),
        label: const Text('New Biodata'),
      ),
    );
  }

  void _showDeleteDialog(
      BuildContext context, WidgetRef ref, String id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        ),
        title: const Text('Delete Design'),
        content: const Text(
            'Are you sure you want to delete this design?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ref.read(savedDesignsProvider.notifier).delete(id);
              Navigator.pop(context);
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }

  void _showClearAllDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        ),
        title: const Text('Clear All Designs'),
        content: const Text(
            'This will delete all your saved designs. This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final designs = ref.read(savedDesignsProvider);
              for (final d in designs) {
                ref.read(savedDesignsProvider.notifier).delete(d.id);
              }
              Navigator.pop(context);
            },
            child: const Text(
              'Clear All',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}