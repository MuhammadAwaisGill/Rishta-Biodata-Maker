import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdService {

  static const _rewardedAdUnitId     = 'ca-app-pub-7701409180488122/1342527511';
  static const _interstitialAdUnitId = 'ca-app-pub-7701409180488122/6730585560';

  RewardedAd?     _rewardedAd;
  InterstitialAd? _interstitialAd;

  bool isRewardedAdReady     = false;
  bool isInterstitialAdReady = false;

  static Future<void> initialize() async {
    await MobileAds.instance.initialize();
  }

  // ── Rewarded Ad (shown before download) ──────────────────────────────────
  Future<void> loadRewardedAd({required VoidCallback onLoaded}) async {
    await RewardedAd.load(
      adUnitId: _rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          isRewardedAdReady = true;
          onLoaded();
          debugPrint('Rewarded ad loaded');
        },
        onAdFailedToLoad: (error) {
          isRewardedAdReady = false;
          debugPrint('Rewarded ad failed to load: $error');
        },
      ),
    );
  }

  void showRewardedAd({required VoidCallback onRewarded}) {
    if (_rewardedAd == null || !isRewardedAdReady) {
      onRewarded();
      return;
    }
    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _rewardedAd = null;
        isRewardedAdReady = false;
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        _rewardedAd = null;
        isRewardedAdReady = false;
        onRewarded(); // Still reward on failure
      },
    );
    _rewardedAd!.show(onUserEarnedReward: (_, __) => onRewarded());
    isRewardedAdReady = false;
    _rewardedAd = null;
  }

  // ── Interstitial Ad (shown after saving a design) ─────────────────────────
  // Called from card_preview_screen.dart after _saveDesign() succeeds.
  Future<void> loadInterstitialAd() async {
    await InterstitialAd.load(
      adUnitId: _interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          isInterstitialAdReady = true;
          debugPrint('Interstitial ad loaded');
        },
        onAdFailedToLoad: (error) {
          isInterstitialAdReady = false;
          debugPrint('Interstitial ad failed: $error');
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
        _interstitialAd = null;
        isInterstitialAdReady = false;
        onDismissed?.call();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        _interstitialAd = null;
        isInterstitialAdReady = false;
        onDismissed?.call();
      },
    );
    _interstitialAd!.show();
    isInterstitialAdReady = false;
    _interstitialAd = null;
  }

  void dispose() {
    _rewardedAd?.dispose();
    _interstitialAd?.dispose();
    _rewardedAd = null;
    _interstitialAd = null;
  }
}