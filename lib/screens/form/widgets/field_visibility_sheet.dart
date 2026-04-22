import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../providers/field_visibility_provider.dart';

class FieldVisibilitySheet extends ConsumerWidget {
  const FieldVisibilitySheet({super.key});

  static const _labels = {
    'height': 'Height',
    'complexion': 'Complexion',
    'motherTongue': 'Mother Tongue',
    'maritalStatus': 'Marital Status',
    'institute': 'Institute / University',
    'salary': 'Salary',
    'fatherProfession': "Father's Profession",
    'motherName': "Mother's Name",
    'brothers': 'Brothers',
    'sisters': 'Sisters',
    'familyType': 'Family Type',
    'caste': 'Caste / Biradari',
    'sect': 'Sect',
    'religiousness': 'Religiousness',
    'whatsappNumber': 'WhatsApp Number',
    'notes': 'Additional Notes',
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final visibility = ref.watch(fieldVisibilityProvider);
    final notifier = ref.read(fieldVisibilityProvider.notifier);

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40, height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Customize Fields',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Text(
            'Toggle fields to show or hide in your biodata',
            style: TextStyle(fontSize: 12, color: AppColors.textMuted),
          ),
          const SizedBox(height: 12),
          Flexible(
            child: ListView(
              shrinkWrap: true,
              children: _labels.entries.map((entry) {
                final isVisible = visibility[entry.key] ?? true;
                return SwitchListTile(
                  dense: true,
                  title: Text(entry.value,
                      style: const TextStyle(fontSize: 14)),
                  value: isVisible,
                  activeColor: AppColors.primary,
                  onChanged: (_) => notifier.toggle(entry.key),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}