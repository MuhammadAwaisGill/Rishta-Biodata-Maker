import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_strings.dart';
import '../../providers/biodata_provider.dart';
import 'widgets/personal_section.dart';
import 'widgets/education_section.dart';
import 'widgets/family_section.dart';
import 'widgets/religious_section.dart';
import 'widgets/preferences_section.dart';
import 'widgets/photo_picker_widget.dart';

class FormScreen extends ConsumerWidget {
  const FormScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = GlobalKey<FormState>();

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
          'Fill Your Biodata',
          style: TextStyle(
            color: AppColors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              ref.read(biodataProvider.notifier).resetForm();
            },
            child: const Text(
              'Reset',
              style: TextStyle(
                color: AppColors.white,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppSizes.md),
          children: [
            // Photo picker at top
            const PhotoPickerWidget(),

            const SizedBox(height: AppSizes.md),

            // Form sections
            const PersonalSection(),
            const SizedBox(height: AppSizes.sm),
            const EducationSection(),
            const SizedBox(height: AppSizes.sm),
            const FamilySection(),
            const SizedBox(height: AppSizes.sm),
            const ReligiousSection(),
            const SizedBox(height: AppSizes.sm),
            const PreferencesSection(),

            const SizedBox(height: AppSizes.xl),

            // Generate button
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton.icon(
                onPressed: () {
                  if (formKey.currentState?.validate() ?? false) {
                    context.push(AppRoutes.cardPreview);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                  ),
                  elevation: 3,
                ),
                icon: const Icon(Icons.auto_awesome_rounded, size: 22),
                label: const Text(
                  AppStrings.btnGenerate,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: AppSizes.xl),
          ],
        ),
      ),
    );
  }
}