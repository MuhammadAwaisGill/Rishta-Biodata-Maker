import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../providers/biodata_provider.dart';
import 'form_section_wrapper.dart';

class ReligiousSection extends ConsumerWidget {
  const ReligiousSection({super.key});

  static const _sects = [
    'Sunni', 'Shia', 'Deobandi', 'Barelvi', 'Ahl-e-Hadith', 'Other',
  ];

  static const _religiousness = [
    'Very Religious', 'Moderate', 'Liberal',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final biodata = ref.watch(biodataProvider);
    final notifier = ref.read(biodataProvider.notifier);

    return FormSectionWrapper(
      title: AppStrings.sectionReligious,
      icon: Icons.mosque_rounded,
      children: [
        _buildDropdown(
          label: 'Sect',
          value: biodata.sect.isEmpty ? null : biodata.sect,
          items: _sects,
          onChanged: (v) => notifier.updateSect(v ?? ''),
        ),
        _buildDropdown(
          label: 'Religiousness',
          value: biodata.religiousness.isEmpty ? null : biodata.religiousness,
          items: _religiousness,
          onChanged: (v) => notifier.updateReligiousness(v ?? ''),
        ),
      ],
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