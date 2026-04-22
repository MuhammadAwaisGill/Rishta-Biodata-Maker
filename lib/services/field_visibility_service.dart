import 'package:shared_preferences/shared_preferences.dart';

class FieldVisibilityService {
  static const _prefix = 'field_visible_';

  static const allFields = [
    'height', 'complexion', 'motherTongue', 'maritalStatus',
    'institute', 'salary', 'fatherProfession', 'motherName',
    'brothers', 'sisters', 'familyType', 'caste',
    'sect', 'religiousness', 'whatsappNumber', 'notes',
  ];

  Future<Map<String, bool>> loadAll() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      for (final f in allFields)
        f: prefs.getBool('$_prefix$f') ?? true,
    };
  }

  Future<void> setVisible(String field, bool visible) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('$_prefix$field', visible);
  }
}