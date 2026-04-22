import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../providers/biodata_provider.dart';
// ADD THIS IMPORT
import '../../../providers/field_visibility_provider.dart';
import 'form_section_wrapper.dart';

class FamilySection extends ConsumerWidget {
  const FamilySection({super.key});

  static const _countOptions = [
    '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10+',
  ];

  static const _familyTypes = ['Joint Family', 'Separate Family'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final biodata  = ref.watch(biodataProvider);
    final notifier = ref.read(biodataProvider.notifier);

    // WATCH THE VISIBILITY STATE
    final visibility = ref.watch(fieldVisibilityProvider);

    return FormSectionWrapper(
      title: AppStrings.sectionFamily,
      icon: Icons.family_restroom_rounded,
      children: [
        _buildTextField(
          label: "Father's Name",
          initialValue: biodata.fatherName,
          onChanged: notifier.updateFatherName,
        ),

        // WRAPPED FATHER'S PROFESSION
        if (visibility['fatherProfession'] ?? true)
          _buildTextField(
            label: "Father's Profession",
            initialValue: biodata.fatherProfession,
            onChanged: notifier.updateFatherProfession,
            hint: 'e.g. Business, Teacher',
          ),

        // WRAPPED MOTHER'S NAME
        if (visibility['motherName'] ?? true)
          _buildTextField(
            label: "Mother's Name",
            initialValue: biodata.motherName,
            onChanged: notifier.updateMotherName,
          ),

        // WRAPPED BROTHERS
        if (visibility['brothers'] ?? true)
          _buildDropdown(
            label: 'Number of Brothers',
            value: biodata.brothers.isEmpty ? null : biodata.brothers,
            items: _countOptions,
            onChanged: (v) => notifier.updateBrothers(v ?? ''),
          ),

        // WRAPPED SISTERS
        if (visibility['sisters'] ?? true)
          _buildDropdown(
            label: 'Number of Sisters',
            value: biodata.sisters.isEmpty ? null : biodata.sisters,
            items: _countOptions,
            onChanged: (v) => notifier.updateSisters(v ?? ''),
          ),

        // WRAPPED FAMILY TYPE
        if (visibility['familyType'] ?? true)
          _buildDropdown(
            label: 'Family Type',
            value: biodata.familyType.isEmpty ? null : biodata.familyType,
            items: _familyTypes,
            onChanged: (v) => notifier.updateFamilyType(v ?? ''),
          ),

        // WRAPPED CASTE
        if (visibility['caste'] ?? true)
          _buildTextField(
            label: 'Caste / Biradari (optional)',
            initialValue: biodata.caste,
            onChanged: notifier.updateCaste,
            hint: 'e.g. Rajput, Ansari, Arain',
          ),
      ],
    );
  }

  // ... (Keep _buildTextField, _buildDropdown, and _inputDecoration exactly as they were)
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