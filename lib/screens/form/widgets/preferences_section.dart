import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../providers/biodata_provider.dart';
// ADD THIS IMPORT
import '../../../providers/field_visibility_provider.dart';
import 'form_section_wrapper.dart';

class PreferencesSection extends ConsumerWidget {
  const PreferencesSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final biodata  = ref.watch(biodataProvider);
    final notifier = ref.read(biodataProvider.notifier);

    // WATCH THE VISIBILITY STATE
    final visibility = ref.watch(fieldVisibilityProvider);

    return FormSectionWrapper(
      title: AppStrings.sectionPreference,
      icon: Icons.tune_rounded,
      children: [
        // WRAPPED NOTES FIELD
        if (visibility['notes'] ?? true)
          _buildTextField(
            label: 'Additional Notes / Preferences',
            initialValue: biodata.notes,
            onChanged: notifier.updateNotes,
            maxLines: 3,
            hint: 'Any special preferences or additional info...',
          ),

        // WRAPPED WHATSAPP FIELD
        if (visibility['whatsappNumber'] ?? true)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSizes.md),
            child: TextFormField(
              initialValue: biodata.whatsappNumber,
              onChanged: notifier.updateWhatsappNumber,
              keyboardType: TextInputType.phone,
              decoration: _inputDecoration('WhatsApp Number (optional)').copyWith(
                prefixIcon: const Padding(
                  padding: EdgeInsets.all(12),
                  child: Icon(Icons.qr_code_rounded,
                      color: AppColors.primary, size: 22),
                ),
                helperText: 'Adds a QR code to your card. e.g. 03001234567',
                helperStyle: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textMuted,
                ),
              ),
            ),
          ),
      ],
    );
  }

  // ... (Keep _buildTextField and _inputDecoration exactly as they were)
  Widget _buildTextField({
    required String label,
    required String initialValue,
    required Function(String) onChanged,
    int maxLines = 1,
    String? hint,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.md),
      child: TextFormField(
        initialValue: initialValue,
        onChanged: onChanged,
        maxLines: maxLines,
        decoration: _inputDecoration(label).copyWith(
          hintText: hint,
          hintStyle: const TextStyle(fontSize: 12, color: AppColors.textMuted),
        ),
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