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

  void delete(String id) {
    _hive.deleteDesign(id);
    load();
  }
}

final savedDesignsProvider =
StateNotifierProvider<SavedDesignsNotifier, List<Biodata>>(
      (ref) => SavedDesignsNotifier(ref.read(hiveServiceProvider)),
);