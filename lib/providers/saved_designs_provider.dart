import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/biodata_model.dart';
import '../services/hive_service.dart';

final hiveServiceProvider = Provider<HiveService>((ref) => HiveService());

class SavedDesignsNotifier extends StateNotifier<List<Biodata>> {
  final HiveService _hive;

  SavedDesignsNotifier(this._hive) : super([]) {
    load();
  }

  void load() {
    state = _hive.getAllDesigns();
  }

  void save(Biodata biodata) {
    _hive.saveDesign(biodata);
    load();
  }

  void update(Biodata biodata) {
    _hive.updateDesign(biodata);
    load();
  }

  void delete(String id) {
    _hive.deleteDesign(id);
    load();
  }

  /// Deletes all saved designs in one operation — avoids multiple rebuilds
  void deleteAll() {
    _hive.deleteAll();
    state = [];
  }

  bool containsId(String id) => state.any((b) => b.id == id);
}

final savedDesignsProvider =
StateNotifierProvider<SavedDesignsNotifier, List<Biodata>>(
      (ref) => SavedDesignsNotifier(ref.read(hiveServiceProvider)),
);