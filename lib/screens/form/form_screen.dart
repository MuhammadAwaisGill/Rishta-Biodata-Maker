import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../core/constants/app_sizes.dart';
import '../../providers/biodata_provider.dart';
import '../../providers/template_provider.dart';
import '../../services/image_service.dart';

// ── Static dropdown options — defined once ────────────────────────────────────
const _complexions    = ['Fair', 'Wheatish', 'Brown', 'Dark Brown'];
const _motherTongues  = ['Urdu', 'Punjabi', 'Sindhi', 'Pashto', 'Balochi', 'Saraiki', 'Kashmiri', 'English', 'Other'];
const _maritalStatuses= ['Never Married', 'Divorced', 'Widowed'];
const _qualifications = ['Matric', 'Intermediate', 'BA / BSc', 'MA / MSc', 'MBA', 'MBBS', 'BDS', 'Engineering', 'LLB', 'PhD', 'Other'];
const _salaryRanges   = ['Prefer not to say', 'Below 50,000 PKR', '50,000 - 100,000 PKR', '100,000 - 150,000 PKR', '150,000 - 250,000 PKR', '250,000+ PKR'];
const _countOptions   = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10+'];
const _familyTypes    = ['Joint Family', 'Separate Family'];
const _sects          = ['Sunni', 'Shia', 'Deobandi', 'Barelvi', 'Ahl-e-Hadith', 'Other'];
const _religiousness  = ['Very Religious', 'Moderate', 'Liberal'];

class FormScreen extends ConsumerStatefulWidget {
  const FormScreen({super.key});

  @override
  ConsumerState<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends ConsumerState<FormScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final biodata  = ref.watch(biodataProvider);
    final notifier = ref.read(biodataProvider.notifier);
    // Watch only id so form doesn't rebuild on every keystroke
    final biodataId = ref.watch(biodataProvider.select((b) => b.id));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
        ),
        title: const Text(
          'Fill Your Biodata',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          TextButton(
            onPressed: _confirmReset,
            child: const Text(
              'Reset',
              style: TextStyle(color: Colors.white70, fontSize: 13),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppSizes.md),
          children: [
            // ── Photo ──────────────────────────────────────────────────
            _PhotoPicker(
              key: ValueKey('photo_$biodataId'),
              photoPath: biodata.photoPath,
              onPicked: notifier.updatePhotoPath,
            ),

            const SizedBox(height: AppSizes.lg),

            // ── Personal ───────────────────────────────────────────────
            _SectionHeader('Personal Information'),
            _TextField(
              label: 'Full Name *',
              initialValue: biodata.name,
              onChanged: notifier.updateName,
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? 'Name is required'
                  : null,
              keyboardType: TextInputType.name,
              textCapitalization: TextCapitalization.words,
            ),
            _TextField(
              label: 'Age *',
              initialValue: biodata.age,
              onChanged: notifier.updateAge,
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Age is required';
                final n = int.tryParse(v.trim());
                if (n == null || n < 18 || n > 60) return 'Enter valid age (18-60)';
                return null;
              },
              keyboardType: TextInputType.number,
            ),
            _TextField(
              label: 'Height',
              initialValue: biodata.height,
              onChanged: notifier.updateHeight,
              hint: "e.g. 5'7\" or 170 cm",
            ),
            _Dropdown(
              label: 'Marital Status',
              value: biodata.maritalStatus.isEmpty ? null : biodata.maritalStatus,
              items: _maritalStatuses,
              onChanged: (v) => notifier.updateMaritalStatus(v ?? ''),
            ),
            _Dropdown(
              label: 'Complexion',
              value: biodata.complexion.isEmpty ? null : biodata.complexion,
              items: _complexions,
              onChanged: (v) => notifier.updateComplexion(v ?? ''),
            ),
            _TextField(
              label: 'City',
              initialValue: biodata.city,
              onChanged: notifier.updateCity,
              hint: 'e.g. Lahore, Karachi',
            ),
            _Dropdown(
              label: 'Mother Tongue',
              value: biodata.motherTongue.isEmpty ? null : biodata.motherTongue,
              items: _motherTongues,
              onChanged: (v) => notifier.updateMotherTongue(v ?? ''),
            ),

            const SizedBox(height: AppSizes.md),

            // ── Education & Career ─────────────────────────────────────
            _SectionHeader('Education & Career'),
            _Dropdown(
              label: 'Qualification',
              value: biodata.education.isEmpty ? null : biodata.education,
              items: _qualifications,
              onChanged: (v) => notifier.updateEducation(v ?? ''),
            ),
            _TextField(
              label: 'Institute / University',
              initialValue: biodata.institute,
              onChanged: notifier.updateInstitute,
              hint: 'e.g. University of Punjab',
            ),
            _TextField(
              label: 'Profession / Job',
              initialValue: biodata.profession,
              onChanged: notifier.updateProfession,
              hint: 'e.g. Software Engineer',
            ),
            _Dropdown(
              label: 'Monthly Salary',
              value: biodata.salary.isEmpty ? null : biodata.salary,
              items: _salaryRanges,
              onChanged: (v) => notifier.updateSalary(v ?? ''),
            ),

            const SizedBox(height: AppSizes.md),

            // ── Family ─────────────────────────────────────────────────
            _SectionHeader('Family Information'),
            _TextField(
              label: "Father's Name",
              initialValue: biodata.fatherName,
              onChanged: notifier.updateFatherName,
              textCapitalization: TextCapitalization.words,
            ),
            _TextField(
              label: "Father's Profession",
              initialValue: biodata.fatherProfession,
              onChanged: notifier.updateFatherProfession,
              hint: 'e.g. Business, Teacher',
            ),
            _Dropdown(
              label: 'Brothers',
              value: biodata.brothers.isEmpty ? null : biodata.brothers,
              items: _countOptions,
              onChanged: (v) {
                notifier.updateBrothers(v ?? '');
                notifier.updateBrothersMarried('');
              },
            ),
            _Dropdown(
              label: 'Sisters',
              value: biodata.sisters.isEmpty ? null : biodata.sisters,
              items: _countOptions,
              onChanged: (v) {
                notifier.updateSisters(v ?? '');
                notifier.updateSistersMarried('');
              },
            ),
            _Dropdown(
              label: 'Family Type',
              value: biodata.familyType.isEmpty ? null : biodata.familyType,
              items: _familyTypes,
              onChanged: (v) => notifier.updateFamilyType(v ?? ''),
            ),
            _TextField(
              label: 'Caste / Biradari',
              initialValue: biodata.caste,
              onChanged: notifier.updateCaste,
              hint: 'e.g. Rajput, Ansari, Arain',
            ),

            const SizedBox(height: AppSizes.md),

            // ── Religious ──────────────────────────────────────────────
            _SectionHeader('Religious Information'),
            _Dropdown(
              label: 'Sect',
              value: biodata.sect.isEmpty ? null : biodata.sect,
              items: _sects,
              onChanged: (v) => notifier.updateSect(v ?? ''),
            ),
            _Dropdown(
              label: 'Religiousness',
              value: biodata.religiousness.isEmpty ? null : biodata.religiousness,
              items: _religiousness,
              onChanged: (v) => notifier.updateReligiousness(v ?? ''),
            ),

            const SizedBox(height: AppSizes.md),

            // ── Additional ─────────────────────────────────────────────
            _SectionHeader('Additional'),
            _TextField(
              label: 'WhatsApp Number',
              initialValue: biodata.whatsappNumber,
              onChanged: notifier.updateWhatsappNumber,
              hint: 'e.g. 03001234567  (adds QR code to card)',
              keyboardType: TextInputType.phone,
            ),
            _TextField(
              label: 'Notes / Preferences',
              initialValue: biodata.notes,
              onChanged: notifier.updateNotes,
              hint: 'Any additional info or partner preferences...',
              maxLines: 3,
            ),

            const SizedBox(height: AppSizes.xl),

            // ── Generate button ────────────────────────────────────────
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton.icon(
                onPressed: _generate,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                  ),
                ),
                icon: const Icon(Icons.auto_awesome_rounded, size: 20),
                label: const Text(
                  'Generate Biodata',
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

  void _generate() {
    if (_formKey.currentState?.validate() ?? false) {
      context.push(AppRoutes.cardPreview);
    }
  }

  void _confirmReset() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusMd)),
        title: const Text('Reset Form?'),
        content: const Text('All entered data will be cleared.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(biodataProvider.notifier).resetForm();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }
}

// ── Photo picker ──────────────────────────────────────────────────────────────

class _PhotoPicker extends StatelessWidget {
  final String photoPath;
  final void Function(String) onPicked;

  const _PhotoPicker({
    super.key,
    required this.photoPath,
    required this.onPicked,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          GestureDetector(
            onTap: () => _pick(context),
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0x146A1B1B),
                border: Border.all(
                  color: const Color(0x336A1B1B),
                  width: 2,
                ),
                image: photoPath.isNotEmpty
                    ? DecorationImage(
                  image: FileImage(File(photoPath)),
                  fit: BoxFit.cover,
                )
                    : null,
              ),
              child: photoPath.isEmpty
                  ? const Icon(
                Icons.add_a_photo_rounded,
                size: 32,
                color: AppColors.primary,
              )
                  : null,
            ),
          ),
          const SizedBox(height: AppSizes.sm),
          Text(
            photoPath.isEmpty ? 'Add Photo (optional)' : 'Change Photo',
            style: const TextStyle(
              color: AppColors.primary,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _pick(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: AppSizes.sm),
            ListTile(
              leading: const Icon(Icons.camera_alt_rounded,
                  color: AppColors.primary),
              title: const Text('Take Photo'),
              onTap: () async {
                Navigator.pop(context);
                final file = await ImageService().pickFromCamera();
                if (file != null) onPicked(file.path);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_rounded,
                  color: AppColors.primary),
              title: const Text('Choose from Gallery'),
              onTap: () async {
                Navigator.pop(context);
                final file = await ImageService().pickFromGallery();
                if (file != null) onPicked(file.path);
              },
            ),
            const SizedBox(height: AppSizes.sm),
          ],
        ),
      ),
    );
  }
}

// ── Section header ────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.sm),
      child: Row(
        children: [
          Container(
            width: 3,
            height: 14,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Text field ────────────────────────────────────────────────────────────────

class _TextField extends StatelessWidget {
  final String label;
  final String initialValue;
  final void Function(String) onChanged;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final TextCapitalization textCapitalization;
  final String? hint;
  final int maxLines;

  const _TextField({
    required this.label,
    required this.initialValue,
    required this.onChanged,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.textCapitalization = TextCapitalization.none,
    this.hint,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.md),
      child: TextFormField(
        initialValue: initialValue,
        onChanged: onChanged,
        validator: validator,
        keyboardType: keyboardType,
        textCapitalization: textCapitalization,
        maxLines: maxLines,
        decoration: _decor(label, hint),
      ),
    );
  }
}

// ── Dropdown ──────────────────────────────────────────────────────────────────

class _Dropdown extends StatelessWidget {
  final String label;
  final String? value;
  final List<String> items;
  final void Function(String?) onChanged;

  const _Dropdown({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.md),
      child: DropdownButtonFormField<String>(
        value: value,
        isExpanded: true,
        decoration: _decor(label, null),
        items: items
            .map((e) => DropdownMenuItem(
          value: e,
          child: Text(e, overflow: TextOverflow.ellipsis),
        ))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }
}

// ── Shared input decoration — created once per call, not per build ────────────

InputDecoration _decor(String label, String? hint) {
  return InputDecoration(
    labelText: label,
    hintText: hint,
    labelStyle: const TextStyle(color: AppColors.textMuted),
    hintStyle: const TextStyle(fontSize: 12, color: AppColors.textMuted),
    filled: true,
    fillColor: AppColors.surface,
    contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSizes.md, vertical: 14),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSizes.radiusSm),
      borderSide: const BorderSide(color: Color(0x33757575)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSizes.radiusSm),
      borderSide: const BorderSide(color: Color(0x33757575)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSizes.radiusSm),
      borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSizes.radiusSm),
      borderSide: const BorderSide(color: AppColors.error, width: 1.5),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSizes.radiusSm),
      borderSide: const BorderSide(color: AppColors.error, width: 1.5),
    ),
  );
}