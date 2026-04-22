import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/field_visibility_service.dart';

class FieldVisibilityNotifier extends StateNotifier<Map<String, bool>> {
  final FieldVisibilityService _service;

  FieldVisibilityNotifier(this._service) : super({
    for (final f in FieldVisibilityService.allFields) f: true,
  }) {
    _load();
  }

  Future<void> _load() async {
    state = await _service.loadAll();
  }

  Future<void> toggle(String field) async {
    final newVal = !(state[field] ?? true);
    state = {...state, field: newVal};
    await _service.setVisible(field, newVal);
  }

  bool isVisible(String field) => state[field] ?? true;
}

final fieldVisibilityProvider =
StateNotifierProvider<FieldVisibilityNotifier, Map<String, bool>>(
      (ref) => FieldVisibilityNotifier(FieldVisibilityService()),
);