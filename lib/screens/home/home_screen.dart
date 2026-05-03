import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../core/constants/app_sizes.dart';
import '../../providers/biodata_provider.dart';
import '../../providers/saved_designs_provider.dart';
import '../../providers/template_provider.dart';
import '../select_template/template_select_screen.dart';
import '../form/form_screen.dart';
import 'widgets/design_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count =
    ref.watch(savedDesignsProvider.select((d) => d.length));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        centerTitle: false,
        title: const Text(
          'Rishta Biodata Maker',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          if (count > 0)
            IconButton(
              onPressed: () => _showClearAllDialog(context, ref),
              icon: const Icon(Icons.delete_sweep_rounded,
                  color: Colors.white70, size: 22),
              tooltip: 'Clear All',
            ),
        ],
      ),
      body: count == 0
          ? _EmptyState(onCreate: () => _startNewBiodata(context, ref))
          : _DesignsList(
          onCreate: () => _startNewBiodata(context, ref)),
      floatingActionButton: count > 0
          ? FloatingActionButton.extended(
        onPressed: () => _startNewBiodata(context, ref),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 3,
        icon: const Icon(Icons.add_rounded),
        label: const Text(
          'Create Biodata',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      )
          : null,
    );
  }

  // ── Consistent Navigator.push flow for template → form ────────────────────
  // We intentionally use Navigator.push (not go_router) for the create flow
  // because it's a multi-step wizard that should stack correctly and share
  // the same back-button behaviour. go_router is used for tab-level navigation.
  void _startNewBiodata(BuildContext context, WidgetRef ref) {
    ref.read(biodataProvider.notifier).resetForm();

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => TemplateSelectScreen(
          onSelect: (templateId) {
            ref.read(selectedTemplateProvider.notifier).state = templateId;
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const FormScreen()),
            );
          },
        ),
      ),
    );
  }

  void _showClearAllDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusMd)),
        title: const Row(
          children: [
            Icon(Icons.delete_sweep_rounded, color: AppColors.error),
            SizedBox(width: 8),
            Text('Clear All'),
          ],
        ),
        content: const Text(
            'This will delete ALL saved biodatas. This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(savedDesignsProvider.notifier).deleteAll();
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(AppSizes.radiusSm)),
            ),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }
}

// ── Designs list ──────────────────────────────────────────────────────────────
class _DesignsList extends ConsumerWidget {
  final VoidCallback onCreate;
  const _DesignsList({required this.onCreate});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final designs = ref.watch(savedDesignsProvider);

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
      itemCount: designs.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppSizes.sm),
      itemBuilder: (context, index) {
        final design = designs[index];
        return DesignCard(
          key: ValueKey(design.id),
          biodata: design,
          index: index,
          onTap: () {
            ref.read(biodataProvider.notifier).loadFromSaved(design);
            ref.read(selectedTemplateProvider.notifier).state =
                design.templateId;
            context.push(AppRoutes.cardPreview);
          },
          onEdit: () {
            ref.read(biodataProvider.notifier).loadFromSaved(design);
            ref.read(selectedTemplateProvider.notifier).state =
                design.templateId;
            // Use Navigator.push so back from form returns to home correctly
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const FormScreen()),
            );
          },
          onDelete: () => _showDeleteDialog(context, ref, design.id),
          onDuplicate: () {
            final dup = design.copyWith(
              newId: DateTime.now().millisecondsSinceEpoch.toString(),
              newCreatedAt: DateTime.now(),
            );
            ref.read(savedDesignsProvider.notifier).save(dup);
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: const Text('✅ Biodata duplicated!'),
                  backgroundColor: AppColors.primary,
                  behavior: SnackBarBehavior.floating,
                  duration: const Duration(seconds: 2),
                  margin: const EdgeInsets.fromLTRB(16, 0, 16, 90),
                  shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(AppSizes.radiusSm)),
                ),
              );
          },
        );
      },
    );
  }

  void _showDeleteDialog(BuildContext context, WidgetRef ref, String id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusMd)),
        title: const Row(
          children: [
            Icon(Icons.delete_outline_rounded, color: AppColors.error),
            SizedBox(width: 8),
            Text('Delete Biodata'),
          ],
        ),
        content:
        const Text('Are you sure you want to delete this biodata?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(savedDesignsProvider.notifier).delete(id);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusSm)),
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

// ── Empty state ───────────────────────────────────────────────────────────────
class _EmptyState extends StatelessWidget {
  final VoidCallback onCreate;
  const _EmptyState({required this.onCreate});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const _EmptyIcon(),
            const SizedBox(height: 24),
            const Text(
              'No Biodatas Yet',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Create your first biodata and share it instantly.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textMuted,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: onCreate,
              icon: const Icon(Icons.add_rounded),
              label: const Text('Create Biodata'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                    horizontal: 28, vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(AppSizes.radiusMd)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyIcon extends StatelessWidget {
  const _EmptyIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: const BoxDecoration(
        color: Color(0x146A1B1B),
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.article_outlined,
        size: 48,
        color: AppColors.primary,
      ),
    );
  }
}