import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/ad_service.dart';

/// AdService is created once and disposed when the ProviderScope is torn down.
/// Always use adService.isRewardedAdReady / isInterstitialAdReady directly —
/// do NOT create separate StateProviders for these; they drift out of sync.
final adServiceProvider = Provider<AdService>((ref) {
  final service = AdService();
  ref.onDispose(service.dispose);
  return service;
});