import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/biodata_model.dart';

class BiodataNotifier extends StateNotifier<Biodata> {
  BiodataNotifier() : super(Biodata.empty());

  // ── Personal ─────────────────────────────────────────────────────────────
  void updateName(String v)             => state = state.copyWith(name: v);
  void updateAge(String v)              => state = state.copyWith(age: v);
  void updateHeight(String v)           => state = state.copyWith(height: v);
  void updateCity(String v)             => state = state.copyWith(city: v);
  void updateComplexion(String v)       => state = state.copyWith(complexion: v);
  void updateMotherTongue(String v)     => state = state.copyWith(motherTongue: v);
  void updateMaritalStatus(String v)    => state = state.copyWith(maritalStatus: v);

  // ── Education ─────────────────────────────────────────────────────────────
  void updateEducation(String v)        => state = state.copyWith(education: v);
  void updateInstitute(String v)        => state = state.copyWith(institute: v);
  void updateProfession(String v)       => state = state.copyWith(profession: v);
  void updateSalary(String v)           => state = state.copyWith(salary: v);

  // ── Family ────────────────────────────────────────────────────────────────
  void updateFatherName(String v)       => state = state.copyWith(fatherName: v);
  void updateFatherProfession(String v) => state = state.copyWith(fatherProfession: v);
  void updateMotherName(String v)       => state = state.copyWith(motherName: v);
  void updateBrothers(String v)         => state = state.copyWith(brothers: v);
  void updateSisters(String v)          => state = state.copyWith(sisters: v);
  void updateFamilyType(String v)       => state = state.copyWith(familyType: v);
  void updateCaste(String v)            => state = state.copyWith(caste: v);

  // ── Religious ─────────────────────────────────────────────────────────────
  void updateSect(String v)             => state = state.copyWith(sect: v);
  void updateReligiousness(String v)    => state = state.copyWith(religiousness: v);

  // ── Preferences / Misc ───────────────────────────────────────────────────
  void updateNotes(String v)            => state = state.copyWith(notes: v);
  void updateWhatsappNumber(String v)   => state = state.copyWith(whatsappNumber: v);

  // ── Photo & Template ─────────────────────────────────────────────────────
  void updatePhotoPath(String v)        => state = state.copyWith(photoPath: v);
  void updateTemplateId(int v)          => state = state.copyWith(templateId: v);

  // ── Lifecycle ────────────────────────────────────────────────────────────
  void loadFromSaved(Biodata biodata)   => state = biodata;
  void resetForm()                      => state = Biodata.empty();
}

final biodataProvider = StateNotifierProvider<BiodataNotifier, Biodata>(
      (ref) => BiodataNotifier(),
);