import 'dart:async';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/biodata_model.dart';

const _draftKey = 'biodata_draft';

class BiodataNotifier extends StateNotifier<Biodata> {
  BiodataNotifier() : super(Biodata.empty());

  Timer? _debounce;
  // Track last saved JSON to avoid redundant SharedPreferences writes
  String? _lastSavedJson;

  void _update(Biodata updated) {
    state = updated;
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 800), _writeDraft);
  }

  Future<void> _writeDraft() async {
    try {
      final json = jsonEncode(state.toJson());
      // Dirty check — only write if actually changed
      if (json == _lastSavedJson) return;
      _lastSavedJson = json;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_draftKey, json);
    } catch (_) {}
  }

  Future<bool> hasDraft() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_draftKey);
      if (raw == null) return false;
      final map = jsonDecode(raw) as Map<String, dynamic>;
      final b = Biodata.fromJson(map);
      return b.name.isNotEmpty || b.age.isNotEmpty || b.profession.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  Future<void> loadDraft() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_draftKey);
      if (raw == null) return;
      final map = jsonDecode(raw) as Map<String, dynamic>;
      state = Biodata.fromJson(map);
      _lastSavedJson = raw; // Sync dirty tracker
    } catch (_) {}
  }

  Future<void> clearDraft() async {
    try {
      _lastSavedJson = null;
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_draftKey);
    } catch (_) {}
  }

  // ── Personal ──────────────────────────────────────────────────────────────
  void updateName(String v)           => _update(state.copyWith(name: v));
  void updateAge(String v)            => _update(state.copyWith(age: v));
  void updateHeight(String v)         => _update(state.copyWith(height: v));
  void updateCity(String v)           => _update(state.copyWith(city: v));
  void updateComplexion(String v)     => _update(state.copyWith(complexion: v));
  void updateMotherTongue(String v)   => _update(state.copyWith(motherTongue: v));
  void updateMaritalStatus(String v)  => _update(state.copyWith(maritalStatus: v));
  void updatePersonalNotes(String v)  => _update(state.copyWith(personalNotes: v));

  // ── Education ─────────────────────────────────────────────────────────────
  void updateEducation(String v)      => _update(state.copyWith(education: v));
  void updateInstitute(String v)      => _update(state.copyWith(institute: v));
  void updateProfession(String v)     => _update(state.copyWith(profession: v));
  void updateSalary(String v)         => _update(state.copyWith(salary: v));
  void updateEducationNotes(String v) => _update(state.copyWith(educationNotes: v));

  // ── Family ────────────────────────────────────────────────────────────────
  void updateFatherName(String v)        => _update(state.copyWith(fatherName: v));
  void updateFatherProfession(String v)  => _update(state.copyWith(fatherProfession: v));
  void updateMotherName(String v)        => _update(state.copyWith(motherName: v));
  void updateBrothers(String v)          => _update(state.copyWith(brothers: v));
  void updateSisters(String v)           => _update(state.copyWith(sisters: v));
  void updateFamilyType(String v)        => _update(state.copyWith(familyType: v));
  void updateCaste(String v)             => _update(state.copyWith(caste: v));
  void updateBrothersMarried(String v)   => _update(state.copyWith(brothersMarried: v));
  void updateSistersMarried(String v)    => _update(state.copyWith(sistersMarried: v));
  void updateFamilyNotes(String v)       => _update(state.copyWith(familyNotes: v));

  // ── Religious ─────────────────────────────────────────────────────────────
  void updateSect(String v)           => _update(state.copyWith(sect: v));
  void updateReligiousness(String v)  => _update(state.copyWith(religiousness: v));
  void updateReligiousNotes(String v) => _update(state.copyWith(religiousNotes: v));

  // ── Preferences ───────────────────────────────────────────────────────────
  void updateNotes(String v)          => _update(state.copyWith(notes: v));
  void updateWhatsappNumber(String v) => _update(state.copyWith(whatsappNumber: v));

  // ── Photo & Template ──────────────────────────────────────────────────────
  void updatePhotoPath(String v)      => _update(state.copyWith(photoPath: v));
  void updateTemplateId(int v)        => _update(state.copyWith(templateId: v));

  void loadFromSaved(Biodata biodata) {
    state = biodata;
    // Sync dirty tracker so editing a saved design doesn't force a draft write
    _lastSavedJson = jsonEncode(biodata.toJson());
  }

  Future<void> resetForm() async {
    _debounce?.cancel();
    _lastSavedJson = null;
    state = Biodata.empty();
    await clearDraft();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}

final biodataProvider = StateNotifierProvider<BiodataNotifier, Biodata>(
      (ref) => BiodataNotifier(),
);