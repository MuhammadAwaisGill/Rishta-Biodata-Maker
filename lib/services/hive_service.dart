import 'package:hive_flutter/hive_flutter.dart';
import '../models/biodata_model.dart';

class HiveService {
  static const _boxName = 'biodatas';

  Box<Biodata> get _box => Hive.box<Biodata>(_boxName);

  void saveDesign(Biodata biodata) {
    _box.put(biodata.id, biodata);
  }

  /// Called only once at startup — sorts descending by createdAt.
  /// After that, the provider manages order in memory.
  List<Biodata> getAllDesigns() {
    final list = _box.values.toList();
    list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return list;
  }

  Biodata? getDesign(String id) => _box.get(id);

  void updateDesign(Biodata biodata) {
    _box.put(biodata.id, biodata);
  }

  void deleteDesign(String id) {
    _box.delete(id);
  }

  void deleteAll() {
    _box.clear();
  }
}