import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/ad_service.dart';

/// AdService is created once and disposed when the ProviderScope is torn down.
/// ref.onDispose ensures _rewardedAd and _interstitialAd are always cleaned up.
final adServiceProvider = Provider<AdService>((ref) {
  final service = AdService();
  ref.onDispose(service.dispose);
  return service;
});

final rewardedAdReadyProvider = StateProvider<bool>((ref) => false);

final interstitialAdReadyProvider = StateProvider<bool>((ref) => false);