import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdService {

  static const _rewardedAdUnitId     = 'ca-app-pub-7701409180488122/1342527511';
  static const _interstitialAdUnitId = 'ca-app-pub-7701409180488122/6730585560';

  RewardedAd?     _rewardedAd;
  InterstitialAd? _interstitialAd;

  static Future<void> initialize() async {
    await MobileAds.instance.initialize();
  }

  bool get isRewardedAdReady     => _rewardedAd != null;
  bool get isInterstitialAdReady => _interstitialAd != null;

  // ── Rewarded Ad ───────────────────────────────────────────────────────────
  Future<void> loadRewardedAd({required VoidCallback onLoaded}) async {
    await RewardedAd.load(
      adUnitId: _rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          onLoaded();
          debugPrint('Rewarded ad loaded');
        },
        onAdFailedToLoad: (error) {
          _rewardedAd = null;
          debugPrint('Rewarded ad failed to load: $error');
        },
      ),
    );
  }

  void showRewardedAd({required VoidCallback onRewarded}) {
    if (_rewardedAd == null) {
      // Ad not ready — reward anyway so UX is never blocked
      onRewarded();
      return;
    }

    final ad = _rewardedAd!;
    _rewardedAd = null; // clear immediately to prevent double-show

    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (a) => a.dispose(),
      onAdFailedToShowFullScreenContent: (a, error) {
        a.dispose();
        onRewarded(); // reward on failure so download never gets stuck
      },
    );
    ad.show(onUserEarnedReward: (_, __) => onRewarded());
  }

  // ── Interstitial Ad ───────────────────────────────────────────────────────
  Future<void> loadInterstitialAd() async {
    await InterstitialAd.load(
      adUnitId: _interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          debugPrint('Interstitial ad loaded');
        },
        onAdFailedToLoad: (error) {
          _interstitialAd = null;
          debugPrint('Interstitial ad failed: $error');
        },
      ),
    );
  }

  void showInterstitialAd({VoidCallback? onDismissed}) {
    if (_interstitialAd == null) {
      onDismissed?.call();
      return;
    }

    final ad = _interstitialAd!;
    _interstitialAd = null; // clear immediately to prevent double-show

    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (a) {
        a.dispose();
        onDismissed?.call();
      },
      onAdFailedToShowFullScreenContent: (a, error) {
        a.dispose();
        onDismissed?.call();
      },
    );
    ad.show();
  }

  void dispose() {
    _rewardedAd?.dispose();
    _interstitialAd?.dispose();
    _rewardedAd = null;
    _interstitialAd = null;
  }
}