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
    'MBA', 'MBBS', 'BDS', 'Engineering', 'LLB', 'PhD', 'Other',
  ];

  static const _salaryRanges = [
    'Prefer not to say',
    'Below 30,000 PKR',
    '30,000 - 50,000 PKR',
    '50,000 - 80,000 PKR',
    '80,000 - 1,20,000 PKR',
    '1,20,000 - 2,00,000 PKR',
    'Above 2,00,000 PKR',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final biodata  = ref.watch(biodataProvider);
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
          label: 'Institute / University',
          initialValue: biodata.institute,
          onChanged: notifier.updateInstitute,
          hint: 'e.g. University of Punjab',
        ),
        _buildTextField(
          label: 'Profession / Job',
          initialValue: biodata.profession,
          onChanged: notifier.updateProfession,
          hint: 'e.g. Software Engineer',
        ),
        _buildDropdown(
          label: 'Monthly Salary (optional)',
          value: biodata.salary.isEmpty ? null : biodata.salary,
          items: _salaryRanges,
          onChanged: (v) => notifier.updateSalary(v ?? ''),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required String initialValue,
    required Function(String) onChanged,
    String? hint,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.md),
      child: TextFormField(
        initialValue: initialValue,
        onChanged: onChanged,
        decoration: _inputDecoration(label).copyWith(
          hintText: hint,
          hintStyle: const TextStyle(fontSize: 12, color: AppColors.textMuted),
        ),
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
        isExpanded: true,
        decoration: _inputDecoration(label),
        items: items
            .map((e) => DropdownMenuItem(value: e, child: Text(e, overflow: TextOverflow.ellipsis)))
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