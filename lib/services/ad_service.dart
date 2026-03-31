import 'dart:ui';

import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdService {
  // Test IDs — replace with real AdMob IDs before release
  static const _rewardedAdUnitId = 'ca-app-pub-3940256099942544/5224354917';
  static const _interstitialAdUnitId = 'ca-app-pub-3940256099942544/1033173712';

  RewardedAd? _rewardedAd;
  InterstitialAd? _interstitialAd;

  bool isRewardedAdReady = false;
  bool isInterstitialAdReady = false;

  static Future<void> initialize() async {
    await MobileAds.instance.initialize();
  }

  // ── Rewarded Ad (shown before download/share) ──────────────────
  Future<void> loadRewardedAd({required VoidCallback onLoaded}) async {
    await RewardedAd.load(
      adUnitId: _rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          isRewardedAdReady = true;
          onLoaded();
        },
        onAdFailedToLoad: (_) {
          isRewardedAdReady = false;
        },
      ),
    );
  }

  void showRewardedAd({required VoidCallback onRewarded}) {
    if (_rewardedAd == null || !isRewardedAdReady) {
      onRewarded(); // if ad not ready, still let user download
      return;
    }
    _rewardedAd!.show(
      onUserEarnedReward: (_, __) => onRewarded(),
    );
    isRewardedAdReady = false;
    _rewardedAd = null;
  }

  // ── Interstitial Ad (shown at ~50% form completion) ────────────
  Future<void> loadInterstitialAd() async {
    await InterstitialAd.load(
      adUnitId: _interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          isInterstitialAdReady = true;
        },
        onAdFailedToLoad: (_) {
          isInterstitialAdReady = false;
        },
      ),
    );
  }

  void showInterstitialAd({VoidCallback? onDismissed}) {
    if (_interstitialAd == null || !isInterstitialAdReady) {
      onDismissed?.call();
      return;
    }
    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        onDismissed?.call();
      },
    );
    _interstitialAd!.show();
    isInterstitialAdReady = false;
    _interstitialAd = null;
  }
}