import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/ad_service.dart';

final adServiceProvider = Provider<AdService>((ref) => AdService());

final rewardedAdReadyProvider = StateProvider<bool>((ref) => false);

final interstitialAdReadyProvider = StateProvider<bool>((ref) => false);