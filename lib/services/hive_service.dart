import 'package:hive_flutter/hive_flutter.dart';
import '../models/biodata_model.dart';

class HiveService {
  static const _boxName = 'biodatas';

  Box<Biodata> get _box => Hive.box<Biodata>(_boxName);

  void saveDesign(Biodata biodata) {
    _box.put(biodata.id, biodata);
  }

  List<Biodata> getAllDesigns() {
    return _box.values.toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  Biodata? getDesign(String id) {
    return _box.get(id);
  }

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