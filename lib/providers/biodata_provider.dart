import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/biodata_model.dart';

class BiodataNotifier extends StateNotifier<Biodata> {
  BiodataNotifier() : super(Biodata.empty());

  void updateName(String v)          => state = state.copyWith(name: v);
  void updateAge(String v)           => state = state.copyWith(age: v);
  void updateHeight(String v)        => state = state.copyWith(height: v);
  void updateCity(String v)          => state = state.copyWith(city: v);
  void updateEducation(String v)     => state = state.copyWith(education: v);
  void updateProfession(String v)    => state = state.copyWith(profession: v);
  void updateFatherName(String v)    => state = state.copyWith(fatherName: v);
  void updateMotherName(String v)    => state = state.copyWith(motherName: v);
  void updateBrothers(String v)      => state = state.copyWith(brothers: v);
  void updateSisters(String v)       => state = state.copyWith(sisters: v);
  void updateFamilyType(String v)    => state = state.copyWith(familyType: v);
  void updateSect(String v)          => state = state.copyWith(sect: v);
  void updateReligiousness(String v) => state = state.copyWith(religiousness: v);
  void updatePhotoPath(String v)     => state = state.copyWith(photoPath: v);
  void updateTemplateId(int v)       => state = state.copyWith(templateId: v);
  void updateNotes(String v)         => state = state.copyWith(notes: v);

  void resetForm() => state = Biodata.empty();
}

final biodataProvider =
StateNotifierProvider<BiodataNotifier, Biodata>(
      (ref) => BiodataNotifier(),
);