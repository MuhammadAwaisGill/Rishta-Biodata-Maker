import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/ad_service.dart';

/// AdService is created once and disposed when the ProviderScope is torn down.
final adServiceProvider = Provider<AdService>((ref) {
  final service = AdService();
  ref.onDispose(service.dispose);
  return service;
});