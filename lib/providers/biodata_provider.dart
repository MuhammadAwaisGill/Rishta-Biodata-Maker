import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/biodata_model.dart';

const _draftKey = 'biodata_draft';

class BiodataNotifier extends StateNotifier<Biodata> {
  BiodataNotifier() : super(Biodata.empty());

  // ── Draft persistence ─────────────────────────────────────────────────────
  Future<void> saveDraft() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_draftKey, jsonEncode(state.toJson()));
  }

  Future<bool> hasDraft() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_draftKey);
    if (raw == null) return false;
    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      final b = Biodata.fromJson(map);
      // Only count as a real draft if something meaningful was filled
      return b.name.isNotEmpty || b.age.isNotEmpty || b.profession.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  Future<void> loadDraft() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_draftKey);
    if (raw == null) return;
    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      state = Biodata.fromJson(map);
    } catch (_) {}
  }

  Future<void> clearDraft() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_draftKey);
  }

  // ── Internal helper — saves draft after every update ─────────────────────
  void _update(Biodata updated) {
    state = updated;
    saveDraft(); // fire-and-forget, no await needed
  }

  // ── Personal ──────────────────────────────────────────────────────────────
  void updateName(String v)             => _update(state.copyWith(name: v));
  void updateAge(String v)              => _update(state.copyWith(age: v));
  void updateHeight(String v)           => _update(state.copyWith(height: v));
  void updateCity(String v)             => _update(state.copyWith(city: v));
  void updateComplexion(String v)       => _update(state.copyWith(complexion: v));
  void updateMotherTongue(String v)     => _update(state.copyWith(motherTongue: v));
  void updateMaritalStatus(String v)    => _update(state.copyWith(maritalStatus: v));

  // ── Education ─────────────────────────────────────────────────────────────
  void updateEducation(String v)        => _update(state.copyWith(education: v));
  void updateInstitute(String v)        => _update(state.copyWith(institute: v));
  void updateProfession(String v)       => _update(state.copyWith(profession: v));
  void updateSalary(String v)           => _update(state.copyWith(salary: v));

  // ── Family ────────────────────────────────────────────────────────────────
  void updateFatherName(String v)       => _update(state.copyWith(fatherName: v));
  void updateFatherProfession(String v) => _update(state.copyWith(fatherProfession: v));
  void updateMotherName(String v)       => _update(state.copyWith(motherName: v));
  void updateBrothers(String v)         => _update(state.copyWith(brothers: v));
  void updateSisters(String v)          => _update(state.copyWith(sisters: v));
  void updateFamilyType(String v)       => _update(state.copyWith(familyType: v));
  void updateCaste(String v)            => _update(state.copyWith(caste: v));

  // ── Religious ─────────────────────────────────────────────────────────────
  void updateSect(String v)             => _update(state.copyWith(sect: v));
  void updateReligiousness(String v)    => _update(state.copyWith(religiousness: v));

  // ── Preferences ───────────────────────────────────────────────────────────
  void updateNotes(String v)            => _update(state.copyWith(notes: v));
  void updateWhatsappNumber(String v)   => _update(state.copyWith(whatsappNumber: v));

  // ── Photo & Template ──────────────────────────────────────────────────────
  void updatePhotoPath(String v)        => _update(state.copyWith(photoPath: v));
  void updateTemplateId(int v)          => _update(state.copyWith(templateId: v));

  // ── Lifecycle ─────────────────────────────────────────────────────────────
  void loadFromSaved(Biodata biodata)   { state = biodata; }

  Future<void> resetForm() async {
    state = Biodata.empty();
    await clearDraft();
  }
}

final biodataProvider = StateNotifierProvider<BiodataNotifier, Biodata>(
      (ref) => BiodataNotifier(),
);