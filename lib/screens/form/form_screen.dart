import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/utils/permission_handler.dart';
import '../../providers/biodata_provider.dart';
import '../../providers/template_provider.dart';
import '../../services/image_service.dart';

// ── Static dropdown options ───────────────────────────────────────────────────
const _complexions     = ['Fair', 'Wheatish', 'Brown', 'Dark Brown'];
const _motherTongues   = ['Urdu', 'Punjabi', 'Sindhi', 'Pashto', 'Balochi', 'Saraiki', 'Kashmiri', 'English', 'Other'];
const _maritalStatuses = ['Never Married', 'Divorced', 'Widowed'];
const _qualifications  = ['Matric', 'Intermediate', 'BA / BSc', 'MA / MSc', 'MBA', 'MBBS', 'BDS', 'Engineering', 'LLB', 'PhD', 'Other'];
const _salaryRanges    = ['Prefer not to say', 'Below 50,000 PKR', '50,000 - 100,000 PKR', '100,000 - 150,000 PKR', '150,000 - 250,000 PKR', '250,000+ PKR'];
const _countOptions    = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10+'];
const _familyTypes     = ['Joint Family', 'Separate Family'];
const _religiousness   = ['Very Religious', 'Moderate', 'Liberal'];
const _religions       = ['Islam', 'Christianity', 'Hinduism', 'Sikhism', 'Other'];

Color _getTemplateColor(int templateId) {
  switch (templateId) {
    case 2:  return const Color(0xFFAD1457);
    case 4:  return const Color(0xFF0D47A1);
    case 5:  return const Color(0xFF424242);
    case 6:  return const Color(0xFF6A0DAD);
    case 7:  return const Color(0xFF00695C);
    case 8:  return const Color(0xFF1C1C1E);
    case 9:  return const Color(0xFF4A0828);
    case 10: return const Color(0xFF283593);
    default: return const Color(0xFF6A1B1B);
  }
}

class FormScreen extends ConsumerWidget {
  const FormScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier    = ref.read(biodataProvider.notifier);
    final pct         = ref.watch(biodataProvider.select((b) => b.completionPercent));
    final templateId  = ref.watch(selectedTemplateProvider);
    final color       = _getTemplateColor(templateId);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: color,
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
            onPressed: () => _confirmReset(context, ref),
            child: const Text('Reset',
                style: TextStyle(color: Colors.white70, fontSize: 13)),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: _CompletionBar(percent: pct),
        ),
      ),
      body: _FormBody(notifier: notifier),
    );
  }

  void _confirmReset(BuildContext context, WidgetRef ref) {
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

// ── Completion progress bar ───────────────────────────────────────────────────
// Sits at the bottom of the AppBar. Fills gold as key fields are completed.
// Uses completionPercent from the model — animates smoothly via TweenAnimation.
class _CompletionBar extends StatelessWidget {
  final double percent;
  const _CompletionBar({required this.percent});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        return SizedBox(
          height: 4,
          width: constraints.maxWidth,
          child: Stack(
            children: [
              // Track
              Container(
                color: Colors.white.withOpacity(0.2),
                width: constraints.maxWidth,
              ),
              // Fill — animates on every rebuild
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
                color: const Color(0xFFD4AF37),
                width: constraints.maxWidth * percent.clamp(0.0, 1.0),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ── Form body ─────────────────────────────────────────────────────────────────
class _FormBody extends StatefulWidget {
  final BiodataNotifier notifier;
  const _FormBody({required this.notifier});

  @override
  State<_FormBody> createState() => _FormBodyState();
}

class _FormBodyState extends State<_FormBody> {
  final _formKey = GlobalKey<FormState>();

  Future<void> _generate() async {
    if (_formKey.currentState?.validate() ?? false) {
      // Flush the debounced draft write immediately so it does not fire
      // after navigation against a potentially disposed provider context.
      await widget.notifier.flushDraft();
      if (!mounted) return;
      context.push(AppRoutes.cardPreview);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(AppSizes.md),
        cacheExtent: 600,
        children: [
          // ── Photo ────────────────────────────────────────────────────────
          _PhotoField(notifier: widget.notifier),
          const SizedBox(height: AppSizes.lg),

          // ── Personal ─────────────────────────────────────────────────────
          const _SectionHeader('Personal Information'),
          _NameField(notifier: widget.notifier),
          _AgeField(notifier: widget.notifier),
          _HeightField(notifier: widget.notifier),
          _MaritalStatusField(notifier: widget.notifier),
          _ComplexionField(notifier: widget.notifier),
          _CityField(notifier: widget.notifier),
          _MotherTongueField(notifier: widget.notifier),
          _PersonalNotesField(notifier: widget.notifier),
          const SizedBox(height: AppSizes.md),

          // ── Education & Career ───────────────────────────────────────────
          const _SectionHeader('Education & Career'),
          _EducationField(notifier: widget.notifier),
          _InstituteField(notifier: widget.notifier),
          _ProfessionField(notifier: widget.notifier),
          _SalaryField(notifier: widget.notifier),
          _EducationNotesField(notifier: widget.notifier),
          const SizedBox(height: AppSizes.md),

          // ── Family ───────────────────────────────────────────────────────
          const _SectionHeader('Family Information'),
          _FatherNameField(notifier: widget.notifier),
          _FatherProfessionField(notifier: widget.notifier),
          _BrothersField(notifier: widget.notifier),
          _BrothersMarriedField(notifier: widget.notifier),
          _SistersField(notifier: widget.notifier),
          _SistersMarriedField(notifier: widget.notifier),
          _FamilyTypeField(notifier: widget.notifier),
          _CasteField(notifier: widget.notifier),
          _FamilyNotesField(notifier: widget.notifier),
          const SizedBox(height: AppSizes.md),

          // ── Religious ────────────────────────────────────────────────────
          const _SectionHeader('Religious Information'),
          _ReligionField(notifier: widget.notifier),   // ← was missing
          _SectField(notifier: widget.notifier),
          _ReligiousnessField(notifier: widget.notifier),
          _ReligiousNotesField(notifier: widget.notifier),
          const SizedBox(height: AppSizes.md),

          // ── Additional ───────────────────────────────────────────────────
          const _SectionHeader('Additional'),
          _WhatsAppField(notifier: widget.notifier),
          _NotesField(notifier: widget.notifier),
          const SizedBox(height: AppSizes.xl),

          // ── Generate button ───────────────────────────────────────────────
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
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: AppSizes.xl),
        ],
      ),
    );
  }
}

// ── Photo field ───────────────────────────────────────────────────────────────
class _PhotoField extends ConsumerWidget {
  final BiodataNotifier notifier;
  const _PhotoField({required this.notifier});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final photoPath = ref.watch(biodataProvider.select((b) => b.photoPath));
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
                border: Border.all(color: const Color(0x336A1B1B), width: 2),
                image: photoPath.isNotEmpty
                    ? DecorationImage(
                  image: FileImage(File(photoPath)),
                  fit: BoxFit.cover,
                )
                    : null,
              ),
              child: photoPath.isEmpty
                  ? const Icon(Icons.add_a_photo_rounded,
                  size: 32, color: AppColors.primary)
                  : null,
            ),
          ),
          const SizedBox(height: AppSizes.sm),
          Text(
            photoPath.isEmpty ? 'Add Photo (optional)' : 'Change Photo',
            style: const TextStyle(
                color: AppColors.primary,
                fontSize: 13,
                fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  void _pick(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
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
                final outcome = await ImageService().pickFromCamera();
                if (!context.mounted) return;
                _handlePickOutcome(context, outcome);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_rounded,
                  color: AppColors.primary),
              title: const Text('Choose from Gallery'),
              onTap: () async {
                Navigator.pop(context);
                final outcome = await ImageService().pickFromGallery();
                if (!context.mounted) return;
                _handlePickOutcome(context, outcome);
              },
            ),
            const SizedBox(height: AppSizes.sm),
          ],
        ),
      ),
    );
  }

  void _handlePickOutcome(BuildContext context, ImagePickOutcome outcome) {
    switch (outcome.result) {
      case ImagePickResult.success:
        notifier.updatePhotoPath(outcome.file!.path);
        break;
      case ImagePickResult.permissionPermanentlyDenied:
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSizes.radiusMd)),
            title: const Text('Permission Required'),
            content: const Text(
                'Camera/photo access was permanently denied. '
                    'Please enable it in your device Settings to add a photo.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  PermissionService.openSettings();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Open Settings'),
              ),
            ],
          ),
        );
        break;
      case ImagePickResult.permissionDenied:
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Permission denied. Please allow access and try again.'),
          behavior: SnackBarBehavior.floating,
        ));
        break;
      case ImagePickResult.cancelled:
      case ImagePickResult.error:
        break;
    }
  }
}

// ── Individual field widgets ───────────────────────────────────────────────────

class _NameField extends ConsumerWidget {
  final BiodataNotifier notifier;
  const _NameField({required this.notifier});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final v = ref.watch(biodataProvider.select((b) => b.name));
    return _TextField(
      label: 'Full Name *',
      initialValue: v,
      onChanged: notifier.updateName,
      validator: (v) =>
      (v == null || v.trim().isEmpty) ? 'Name is required' : null,
      keyboardType: TextInputType.name,
      textCapitalization: TextCapitalization.words,
    );
  }
}

class _AgeField extends ConsumerWidget {
  final BiodataNotifier notifier;
  const _AgeField({required this.notifier});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final v = ref.watch(biodataProvider.select((b) => b.age));
    return _TextField(
      label: 'Age *',
      initialValue: v,
      onChanged: notifier.updateAge,
      validator: (v) {
        if (v == null || v.trim().isEmpty) return 'Age is required';
        final n = int.tryParse(v.trim());
        if (n == null || n < 18 || n > 60) return 'Enter valid age (18–60)';
        return null;
      },
      keyboardType: TextInputType.number,
    );
  }
}

class _HeightField extends ConsumerWidget {
  final BiodataNotifier notifier;
  const _HeightField({required this.notifier});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final v = ref.watch(biodataProvider.select((b) => b.height));
    return _TextField(
        label: 'Height',
        initialValue: v,
        onChanged: notifier.updateHeight,
        hint: "e.g. 5'7\" or 170 cm");
  }
}

class _MaritalStatusField extends ConsumerWidget {
  final BiodataNotifier notifier;
  const _MaritalStatusField({required this.notifier});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final v = ref.watch(biodataProvider.select((b) => b.maritalStatus));
    return _Dropdown(
      label: 'Marital Status',
      value: v.isEmpty ? null : v,
      items: _maritalStatuses,
      onChanged: (s) => notifier.updateMaritalStatus(s ?? ''),
    );
  }
}

class _ComplexionField extends ConsumerWidget {
  final BiodataNotifier notifier;
  const _ComplexionField({required this.notifier});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final v = ref.watch(biodataProvider.select((b) => b.complexion));
    return _Dropdown(
      label: 'Complexion',
      value: v.isEmpty ? null : v,
      items: _complexions,
      onChanged: (s) => notifier.updateComplexion(s ?? ''),
    );
  }
}

class _CityField extends ConsumerWidget {
  final BiodataNotifier notifier;
  const _CityField({required this.notifier});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final v = ref.watch(biodataProvider.select((b) => b.city));
    return _TextField(
        label: 'City',
        initialValue: v,
        onChanged: notifier.updateCity,
        hint: 'e.g. Lahore, Karachi');
  }
}

class _MotherTongueField extends ConsumerWidget {
  final BiodataNotifier notifier;
  const _MotherTongueField({required this.notifier});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final v = ref.watch(biodataProvider.select((b) => b.motherTongue));
    return _Dropdown(
      label: 'Mother Tongue',
      value: v.isEmpty ? null : v,
      items: _motherTongues,
      onChanged: (s) => notifier.updateMotherTongue(s ?? ''),
    );
  }
}

class _PersonalNotesField extends ConsumerWidget {
  final BiodataNotifier notifier;
  const _PersonalNotesField({required this.notifier});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final v = ref.watch(biodataProvider.select((b) => b.personalNotes));
    return _TextField(
      label: 'Personal Notes',
      initialValue: v,
      onChanged: notifier.updatePersonalNotes,
      hint: 'Any personal details to add...',
      maxLines: 2,
    );
  }
}

class _EducationField extends ConsumerWidget {
  final BiodataNotifier notifier;
  const _EducationField({required this.notifier});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final v = ref.watch(biodataProvider.select((b) => b.education));
    return _Dropdown(
      label: 'Qualification',
      value: v.isEmpty ? null : v,
      items: _qualifications,
      onChanged: (s) => notifier.updateEducation(s ?? ''),
    );
  }
}

class _InstituteField extends ConsumerWidget {
  final BiodataNotifier notifier;
  const _InstituteField({required this.notifier});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final v = ref.watch(biodataProvider.select((b) => b.institute));
    return _TextField(
        label: 'Institute / University',
        initialValue: v,
        onChanged: notifier.updateInstitute,
        hint: 'e.g. University of Punjab');
  }
}

class _ProfessionField extends ConsumerWidget {
  final BiodataNotifier notifier;
  const _ProfessionField({required this.notifier});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final v = ref.watch(biodataProvider.select((b) => b.profession));
    return _TextField(
        label: 'Profession / Job',
        initialValue: v,
        onChanged: notifier.updateProfession,
        hint: 'e.g. Software Engineer');
  }
}

class _SalaryField extends ConsumerWidget {
  final BiodataNotifier notifier;
  const _SalaryField({required this.notifier});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final v = ref.watch(biodataProvider.select((b) => b.salary));
    return _Dropdown(
      label: 'Monthly Salary',
      value: v.isEmpty ? null : v,
      items: _salaryRanges,
      onChanged: (s) => notifier.updateSalary(s ?? ''),
    );
  }
}

class _EducationNotesField extends ConsumerWidget {
  final BiodataNotifier notifier;
  const _EducationNotesField({required this.notifier});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final v = ref.watch(biodataProvider.select((b) => b.educationNotes));
    return _TextField(
      label: 'Education Notes',
      initialValue: v,
      onChanged: notifier.updateEducationNotes,
      hint: 'Any additional education/career details...',
      maxLines: 2,
    );
  }
}

class _FatherNameField extends ConsumerWidget {
  final BiodataNotifier notifier;
  const _FatherNameField({required this.notifier});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final v = ref.watch(biodataProvider.select((b) => b.fatherName));
    return _TextField(
        label: "Father's Name",
        initialValue: v,
        onChanged: notifier.updateFatherName,
        textCapitalization: TextCapitalization.words);
  }
}

class _FatherProfessionField extends ConsumerWidget {
  final BiodataNotifier notifier;
  const _FatherProfessionField({required this.notifier});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final v = ref.watch(biodataProvider.select((b) => b.fatherProfession));
    return _TextField(
        label: "Father's Profession",
        initialValue: v,
        onChanged: notifier.updateFatherProfession,
        hint: 'e.g. Business, Teacher');
  }
}

class _BrothersField extends ConsumerWidget {
  final BiodataNotifier notifier;
  const _BrothersField({required this.notifier});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final v = ref.watch(biodataProvider.select((b) => b.brothers));
    return _Dropdown(
      label: 'Brothers',
      value: v.isEmpty ? null : v,
      items: _countOptions,
      onChanged: (s) => notifier.updateBrothers(s ?? ''),
    );
  }
}

class _BrothersMarriedField extends ConsumerWidget {
  final BiodataNotifier notifier;
  const _BrothersMarriedField({required this.notifier});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final v = ref.watch(biodataProvider.select((b) => b.brothersMarried));
    return _TextField(
      label: 'Brothers Married',
      initialValue: v,
      onChanged: notifier.updateBrothersMarried,
      hint: 'e.g. 2 married',
      keyboardType: TextInputType.text,
    );
  }
}

class _SistersField extends ConsumerWidget {
  final BiodataNotifier notifier;
  const _SistersField({required this.notifier});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final v = ref.watch(biodataProvider.select((b) => b.sisters));
    return _Dropdown(
      label: 'Sisters',
      value: v.isEmpty ? null : v,
      items: _countOptions,
      onChanged: (s) => notifier.updateSisters(s ?? ''),
    );
  }
}

class _SistersMarriedField extends ConsumerWidget {
  final BiodataNotifier notifier;
  const _SistersMarriedField({required this.notifier});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final v = ref.watch(biodataProvider.select((b) => b.sistersMarried));
    return _TextField(
      label: 'Sisters Married',
      initialValue: v,
      onChanged: notifier.updateSistersMarried,
      hint: 'e.g. 1 married',
      keyboardType: TextInputType.text,
    );
  }
}

class _FamilyTypeField extends ConsumerWidget {
  final BiodataNotifier notifier;
  const _FamilyTypeField({required this.notifier});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final v = ref.watch(biodataProvider.select((b) => b.familyType));
    return _Dropdown(
      label: 'Family Type',
      value: v.isEmpty ? null : v,
      items: _familyTypes,
      onChanged: (s) => notifier.updateFamilyType(s ?? ''),
    );
  }
}

class _CasteField extends ConsumerWidget {
  final BiodataNotifier notifier;
  const _CasteField({required this.notifier});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final v = ref.watch(biodataProvider.select((b) => b.caste));
    return _TextField(
        label: 'Caste / Biradari',
        initialValue: v,
        onChanged: notifier.updateCaste,
        hint: 'e.g. Rajput, Ansari, Arain');
  }
}

class _FamilyNotesField extends ConsumerWidget {
  final BiodataNotifier notifier;
  const _FamilyNotesField({required this.notifier});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final v = ref.watch(biodataProvider.select((b) => b.familyNotes));
    return _TextField(
      label: 'Family Notes',
      initialValue: v,
      onChanged: notifier.updateFamilyNotes,
      hint: 'Any family background details...',
      maxLines: 2,
    );
  }
}

// ── Religion field — was completely missing from the form ─────────────────────
class _ReligionField extends ConsumerWidget {
  final BiodataNotifier notifier;
  const _ReligionField({required this.notifier});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final v = ref.watch(biodataProvider.select((b) => b.religion));
    return _Dropdown(
      label: 'Religion',
      value: v.isEmpty ? null : v,
      items: _religions,
      onChanged: (s) => notifier.updateReligion(s ?? 'Islam'),
    );
  }
}

List<String> _getSects(String religion) {
  switch (religion) {
    case 'Islam':
      return ['Sunni', 'Shia', 'Deobandi', 'Barelvi', 'Ahl-e-Hadith', 'Other'];
    case 'Christianity':
      return ['Catholic', 'Protestant', 'Orthodox', 'Baptist', 'Other'];
    case 'Hinduism':
      return ['Shaiva', 'Vaishnava', 'Shakta', 'Smarta', 'Other'];
    case 'Sikhism':
      return ['Amritdhari', 'Keshdhari', 'Sahajdhari', 'Other'];
    default:
      return ['Other'];
  }
}

class _SectField extends ConsumerWidget {
  final BiodataNotifier notifier;
  const _SectField({required this.notifier});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sect     = ref.watch(biodataProvider.select((b) => b.sect));
    final religion = ref.watch(biodataProvider.select((b) => b.religion));
    final sects    = _getSects(religion);
    final safeValue = sects.contains(sect) ? sect : null;
    return _Dropdown(
      label: 'Sect',
      value: safeValue,
      items: sects,
      onChanged: (s) => notifier.updateSect(s ?? ''),
    );
  }
}

class _ReligiousnessField extends ConsumerWidget {
  final BiodataNotifier notifier;
  const _ReligiousnessField({required this.notifier});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final v = ref.watch(biodataProvider.select((b) => b.religiousness));
    return _Dropdown(
      label: 'Religiousness',
      value: v.isEmpty ? null : v,
      items: _religiousness,
      onChanged: (s) => notifier.updateReligiousness(s ?? ''),
    );
  }
}

class _ReligiousNotesField extends ConsumerWidget {
  final BiodataNotifier notifier;
  const _ReligiousNotesField({required this.notifier});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final v = ref.watch(biodataProvider.select((b) => b.religiousNotes));
    return _TextField(
      label: 'Religious Notes',
      initialValue: v,
      onChanged: notifier.updateReligiousNotes,
      hint: 'Any religious details or preferences...',
      maxLines: 2,
    );
  }
}

class _WhatsAppField extends ConsumerWidget {
  final BiodataNotifier notifier;
  const _WhatsAppField({required this.notifier});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final v = ref.watch(biodataProvider.select((b) => b.whatsappNumber));
    return _TextField(
      label: 'WhatsApp Number',
      initialValue: v,
      onChanged: notifier.updateWhatsappNumber,
      hint: 'e.g. 03001234567  (adds QR code to card)',
      keyboardType: TextInputType.phone,
    );
  }
}

class _NotesField extends ConsumerWidget {
  final BiodataNotifier notifier;
  const _NotesField({required this.notifier});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final v = ref.watch(biodataProvider.select((b) => b.notes));
    return _TextField(
      label: 'Partner Preferences / Notes',
      initialValue: v,
      onChanged: notifier.updateNotes,
      hint: 'Any partner preferences or additional info...',
      maxLines: 3,
    );
  }
}

// ── Shared stateless input widgets ────────────────────────────────────────────

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
    // Guard: if the stored value is not in the current items list
    // (e.g. after a reset produces '' or a migration renames an option),
    // fall back to null so Flutter never throws "value not in items".
    final safeValue = (value != null && items.contains(value)) ? value : null;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.md),
      child: DropdownButtonFormField<String>(
        value: safeValue,
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

InputDecoration _decor(String label, String? hint) {
  return InputDecoration(
    labelText: label,
    hintText: hint,
    labelStyle: const TextStyle(color: AppColors.textMuted),
    hintStyle: const TextStyle(fontSize: 12, color: AppColors.textMuted),
    filled: true,
    fillColor: AppColors.surface,
    contentPadding:
    const EdgeInsets.symmetric(horizontal: AppSizes.md, vertical: 14),
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