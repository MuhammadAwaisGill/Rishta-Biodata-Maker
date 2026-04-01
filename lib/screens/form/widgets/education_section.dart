import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../providers/biodata_provider.dart';
import 'form_section_wrapper.dart';

class EducationSection extends ConsumerWidget {
  const EducationSection({super.key});

  static const _qualifications = [
    'Matric', 'Intermediate', 'BA / BSc', 'MA / MSc',
    'MBA', 'MBBS', 'Engineering', 'PhD', 'Other',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final biodata = ref.watch(biodataProvider);
    final notifier = ref.read(biodataProvider.notifier);

    return FormSectionWrapper(
      title: AppStrings.sectionEducation,
      icon: Icons.school_rounded,
      children: [
        _buildDropdown(
          label: 'Qualification',
          value: biodata.education.isEmpty ? null : biodata.education,
          items: _qualifications,
          onChanged: (v) => notifier.updateEducation(v ?? ''),
        ),
        _buildTextField(
          label: 'Profession / Job',
          initialValue: biodata.profession,
          onChanged: notifier.updateProfession,
        ),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required String initialValue,
    required Function(String) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.md),
      child: TextFormField(
        initialValue: initialValue,
        onChanged: onChanged,
        decoration: _inputDecoration(label),
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.md),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: _inputDecoration(label),
        items: items
            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: AppColors.textMuted),
      filled: true,
      fillColor: AppColors.surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
        borderSide: BorderSide(color: AppColors.textMuted.withOpacity(0.3)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
        borderSide: BorderSide(color: AppColors.textMuted.withOpacity(0.3)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
    );
  }
}