import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/validators.dart';
import '../../../providers/biodata_provider.dart';
// ADD THIS IMPORT
import '../../../providers/field_visibility_provider.dart';
import 'form_section_wrapper.dart';

class PersonalSection extends ConsumerWidget {
  const PersonalSection({super.key});

  static const _complexions = ['Fair', 'Wheatish', 'Brown', 'Dark Brown'];

  static const _motherTongues = [
    'Urdu', 'Punjabi', 'Sindhi', 'Pashto', 'Balochi',
    'Saraiki', 'Kashmiri', 'English', 'Other',
  ];

  static const _maritalStatuses = [
    'Never Married', 'Divorced', 'Widowed',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final biodata  = ref.watch(biodataProvider);
    final notifier = ref.read(biodataProvider.notifier);

    // WATCH THE VISIBILITY STATE
    final visibility = ref.watch(fieldVisibilityProvider);

    return FormSectionWrapper(
      title: AppStrings.sectionPersonal,
      icon: Icons.person_rounded,
      initiallyExpanded: true,
      children: [
        // Name & Age are required - No if statement here
        _buildTextField(
          label: 'Full Name *',
          initialValue: biodata.name,
          validator: Validators.validateName,
          onChanged: notifier.updateName,
          keyboardType: TextInputType.name,
          textCapitalization: TextCapitalization.words,
        ),
        _buildTextField(
          label: 'Age *',
          initialValue: biodata.age,
          validator: Validators.validateAge,
          onChanged: notifier.updateAge,
          keyboardType: TextInputType.number,
        ),

        // WRAPPED HEIGHT
        if (visibility['height'] ?? true)
          _buildDropdown(
            label: 'Height',
            value: biodata.height.isEmpty ? null : biodata.height,
            items: _heightOptions(),
            onChanged: (v) => notifier.updateHeight(v ?? ''),
          ),

        // WRAPPED MARITAL STATUS
        if (visibility['maritalStatus'] ?? true)
          _buildDropdown(
            label: 'Marital Status',
            value: biodata.maritalStatus.isEmpty ? null : biodata.maritalStatus,
            items: _maritalStatuses,
            onChanged: (v) => notifier.updateMaritalStatus(v ?? ''),
          ),

        // WRAPPED COMPLEXION
        if (visibility['complexion'] ?? true)
          _buildDropdown(
            label: 'Complexion',
            value: biodata.complexion.isEmpty ? null : biodata.complexion,
            items: _complexions,
            onChanged: (v) => notifier.updateComplexion(v ?? ''),
          ),

        _buildTextField(
          label: 'City / Location',
          initialValue: biodata.city,
          onChanged: notifier.updateCity,
          keyboardType: TextInputType.text,
          hint: 'e.g. Lahore, Karachi',
        ),

        // WRAPPED MOTHER TONGUE
        if (visibility['motherTongue'] ?? true)
          _buildDropdown(
            label: 'Mother Tongue',
            value: biodata.motherTongue.isEmpty ? null : biodata.motherTongue,
            items: _motherTongues,
            onChanged: (v) => notifier.updateMotherTongue(v ?? ''),
          ),
      ],
    );
  }

  // ... (Keep _heightOptions, _buildTextField, _buildDropdown, and _inputDecoration exactly as they were)
  List<String> _heightOptions() {
    final List<String> heights = [];
    for (int feet = 4; feet <= 6; feet++) {
      final int maxInch = feet == 6 ? 5 : 11;
      for (int inch = 0; inch <= maxInch; inch++) {
        heights.add("$feet'$inch\"");
      }
    }
    return heights;
  }

  Widget _buildTextField({
    required String label,
    required String initialValue,
    required Function(String) onChanged,
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
    TextCapitalization textCapitalization = TextCapitalization.none,
    String? hint,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.md),
      child: TextFormField(
        initialValue: initialValue,
        keyboardType: keyboardType,
        textCapitalization: textCapitalization,
        validator: validator,
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
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
        borderSide: const BorderSide(color: AppColors.error, width: 1.5),
      ),
    );
  }
}