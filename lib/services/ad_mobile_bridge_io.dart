import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:unity_ads_plugin/unity_ads_plugin.dart';

/// Native Android & iOS implementation for Google AdMob + Unity Ads Mediation in Production.
class NativeAdBridge {
  static InterstitialAd? _preloadedInterstitial;
  static RewardedAd? _preloadedRewarded;
  static bool _unityInterstitialReady = false;
  static bool _unityRewardedReady = false;

  static Future<bool> initializeAdMob() async {
    if (!Platform.isAndroid && !Platform.isIOS) return true;
    try {
      await MobileAds.instance.initialize();
      return true;
    } catch (_) {
      return false;
    }
  }

  static Future<bool> initializeUnityAds({
    required String androidGameId,
    required String iosGameId,
    bool testMode = false,
  }) async {
    if (!Platform.isAndroid && !Platform.isIOS) return true;
    final completer = Completer<bool>();
    try {
      await UnityAds.init(
        gameId: Platform.isIOS ? iosGameId : androidGameId,
        testMode: testMode && !kReleaseMode,
        onComplete: () {
          if (!completer.isCompleted) completer.complete(true);
        },
        onFailed: (error, message) {
          if (!completer.isCompleted) completer.complete(false);
        },
      );
      return await completer.future.timeout(
        const Duration(seconds: 4),
        onTimeout: () => true,
      );
    } catch (_) {
      return false;
    }
  }

  /// Preloads AdMob & Unity Ads Interstitial and Rewarded placements for instant display.
  static Future<void> preloadAds({
    required String admobAndroidInterstitialId,
    required String admobIosInterstitialId,
    required String admobAndroidRewardedId,
    required String admobIosRewardedId,
    required String unityAndroidInterstitialPlacement,
    required String unityIosInterstitialPlacement,
    required String unityAndroidRewardedPlacement,
    required String unityIosRewardedPlacement,
  }) async {
    if (!Platform.isAndroid && !Platform.isIOS) return;
    final interUnitId =
        Platform.isIOS ? admobIosInterstitialId : admobAndroidInterstitialId;
    final rewUnitId =
        Platform.isIOS ? admobIosRewardedId : admobAndroidRewardedId;
    final unityInterPid = Platform.isIOS
        ? unityIosInterstitialPlacement
        : unityAndroidInterstitialPlacement;
    final unityRewPid = Platform.isIOS
        ? unityIosRewardedPlacement
        : unityAndroidRewardedPlacement;

    try {
      await InterstitialAd.load(
        adUnitId: interUnitId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (ad) {
            _preloadedInterstitial = ad;
          },
          onAdFailedToLoad: (_) {
            _preloadedInterstitial = null;
          },
        ),
      );
    } catch (_) {}

    try {
      await RewardedAd.load(
        adUnitId: rewUnitId,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (ad) {
            _preloadedRewarded = ad;
          },
          onAdFailedToLoad: (_) {
            _preloadedRewarded = null;
          },
        ),
      );
    } catch (_) {}

    try {
      await UnityAds.load(
        placementId: unityInterPid,
        onComplete: (_) {
          _unityInterstitialReady = true;
        },
        onFailed: (_, _, _) {
          _unityInterstitialReady = false;
        },
      );
      await UnityAds.load(
        placementId: unityRewPid,
        onComplete: (_) {
          _unityRewardedReady = true;
        },
        onFailed: (_, _, _) {
          _unityRewardedReady = false;
        },
      );
    } catch (_) {}
  }

  /// Renders a native AdMob `AdWidget(ad: BannerAd)` with automatic mediation fallback to `UnityBannerAd`.
  static Widget buildNativeBannerWidget({
    required String admobAndroidUnitId,
    required String admobIosUnitId,
    required String unityAndroidPlacement,
    required String unityIosPlacement,
    required bool preferUnity,
  }) {
    if (!Platform.isAndroid && !Platform.isIOS) {
      return const SizedBox.shrink();
    }
    final unityPlacement =
        Platform.isIOS ? unityIosPlacement : unityAndroidPlacement;
    final admobUnit = Platform.isIOS ? admobIosUnitId : admobAndroidUnitId;

    if (preferUnity) {
      return Padding(
        padding: const EdgeInsets.only(top: 8),
        child: SizedBox(
          height: 50,
          child: UnityBannerAd(placementId: unityPlacement),
        ),
      );
    }
    return _NativeAdMobBannerSlot(
      adUnitId: admobUnit,
      fallbackUnityPlacementId: unityPlacement,
    );
  }

  static Future<bool> showNativeInterstitial({
    required String admobAndroidUnitId,
    required String admobIosUnitId,
    required String unityAndroidPlacement,
    required String unityIosPlacement,
    required bool preferUnity,
  }) async {
    if (!Platform.isAndroid && !Platform.isIOS) return false;
    final unityPid = Platform.isIOS ? unityIosPlacement : unityAndroidPlacement;
    final admobId = Platform.isIOS ? admobIosUnitId : admobAndroidUnitId;

    if (preferUnity) {
      final shownUnity = await _showUnityVideo(unityPid, isInterstitial: true);
      if (shownUnity) return true;
      return _showAdMobInterstitial(admobId);
    } else {
      final shownAdMob = await _showAdMobInterstitial(admobId);
      if (shownAdMob) return true;
      return _showUnityVideo(unityPid, isInterstitial: true);
    }
  }

  static Future<bool> showNativeRewarded({
    required String admobAndroidUnitId,
    required String admobIosUnitId,
    required String unityAndroidPlacement,
    required String unityIosPlacement,
    required bool preferUnity,
    required void Function(int amount, String type) onRewardEarned,
  }) async {
    if (!Platform.isAndroid && !Platform.isIOS) return false;
    final unityPid = Platform.isIOS ? unityIosPlacement : unityAndroidPlacement;
    final admobId = Platform.isIOS ? admobIosUnitId : admobAndroidUnitId;

    if (preferUnity) {
      final shownUnity = await _showUnityVideo(
        unityPid,
        isInterstitial: false,
        onCompleted: () => onRewardEarned(3, 'Priority Boarding Passes'),
      );
      if (shownUnity) return true;
      return _showAdMobRewarded(admobId, onRewardEarned: onRewardEarned);
    } else {
      final shownAdMob = await _showAdMobRewarded(
        admobId,
        onRewardEarned: onRewardEarned,
      );
      if (shownAdMob) return true;
      return _showUnityVideo(
        unityPid,
        isInterstitial: false,
        onCompleted: () => onRewardEarned(3, 'Priority Boarding Passes'),
      );
    }
  }

  static Future<bool> _showUnityVideo(
    String placementId, {
    required bool isInterstitial,
    void Function()? onCompleted,
  }) async {
    final completer = Completer<bool>();
    try {
      Future<void> triggerShow(String pid) async {
        await UnityAds.showVideoAd(
          placementId: pid,
          onComplete: (p) {
            onCompleted?.call();
            if (!completer.isCompleted) completer.complete(true);
          },
          onSkipped: (p) {
            if (!completer.isCompleted) completer.complete(true);
          },
          onFailed: (p, err, msg) {
            if (!completer.isCompleted) completer.complete(false);
          },
        );
      }

      if ((isInterstitial && _unityInterstitialReady) ||
          (!isInterstitial && _unityRewardedReady)) {
        if (isInterstitial) {
          _unityInterstitialReady = false;
        } else {
          _unityRewardedReady = false;
        }
        await triggerShow(placementId);
      } else {
        await UnityAds.load(
          placementId: placementId,
          onComplete: (pid) async {
            await triggerShow(pid);
          },
          onFailed: (pid, err, msg) {
            if (!completer.isCompleted) completer.complete(false);
          },
        );
      }
      return await completer.future.timeout(
        const Duration(seconds: 5),
        onTimeout: () => false,
      );
    } catch (_) {
      return false;
    }
  }

  static Future<bool> _showAdMobInterstitial(String adUnitId) async {
    if (_preloadedInterstitial != null) {
      final ad = _preloadedInterstitial!;
      _preloadedInterstitial = null;
      ad.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (a) => a.dispose(),
        onAdFailedToShowFullScreenContent: (a, err) => a.dispose(),
      );
      await ad.show();
      return true;
    }

    final completer = Completer<bool>();
    try {
      await InterstitialAd.load(
        adUnitId: adUnitId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (ad) {
            ad.fullScreenContentCallback = FullScreenContentCallback(
              onAdDismissedFullScreenContent: (a) => a.dispose(),
              onAdFailedToShowFullScreenContent: (a, err) => a.dispose(),
            );
            ad.show();
            if (!completer.isCompleted) completer.complete(true);
          },
          onAdFailedToLoad: (err) {
            if (!completer.isCompleted) completer.complete(false);
          },
        ),
      );
      return await completer.future.timeout(
        const Duration(seconds: 5),
        onTimeout: () => false,
      );
    } catch (_) {
      return false;
    }
  }

  static Future<bool> _showAdMobRewarded(
    String adUnitId, {
    required void Function(int amount, String type) onRewardEarned,
  }) async {
    if (_preloadedRewarded != null) {
      final ad = _preloadedRewarded!;
      _preloadedRewarded = null;
      ad.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (a) => a.dispose(),
        onAdFailedToShowFullScreenContent: (a, err) => a.dispose(),
      );
      await ad.show(
        onUserEarnedReward: (adWithoutView, reward) {
          onRewardEarned(reward.amount.toInt(), reward.type);
        },
      );
      return true;
    }

    final completer = Completer<bool>();
    try {
      await RewardedAd.load(
        adUnitId: adUnitId,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (ad) {
            ad.fullScreenContentCallback = FullScreenContentCallback(
              onAdDismissedFullScreenContent: (a) => a.dispose(),
              onAdFailedToShowFullScreenContent: (a, err) => a.dispose(),
            );
            ad.show(
              onUserEarnedReward: (adWithoutView, reward) {
                onRewardEarned(reward.amount.toInt(), reward.type);
              },
            );
            if (!completer.isCompleted) completer.complete(true);
          },
          onAdFailedToLoad: (err) {
            if (!completer.isCompleted) completer.complete(false);
          },
        ),
      );
      return await completer.future.timeout(
        const Duration(seconds: 5),
        onTimeout: () => false,
      );
    } catch (_) {
      return false;
    }
  }
}

class _NativeAdMobBannerSlot extends StatefulWidget {
  final String adUnitId;
  final String fallbackUnityPlacementId;

  const _NativeAdMobBannerSlot({
    required this.adUnitId,
    required this.fallbackUnityPlacementId,
  });

  @override
  State<_NativeAdMobBannerSlot> createState() => _NativeAdMobBannerSlotState();
}

class _NativeAdMobBannerSlotState extends State<_NativeAdMobBannerSlot> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;
  bool _useUnityFallback = false;

  @override
  void initState() {
    super.initState();
    _loadBanner();
  }

  void _loadBanner() {
    final banner = BannerAd(
      adUnitId: widget.adUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          if (mounted) {
            setState(() {
              _isLoaded = true;
            });
          }
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          if (mounted) {
            setState(() {
              _useUnityFallback = true;
            });
          }
        },
      ),
    );
    banner.load();
    _bannerAd = banner;
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_useUnityFallback) {
      return Padding(
        padding: const EdgeInsets.only(top: 8),
        child: SizedBox(
          height: 50,
          child: UnityBannerAd(placementId: widget.fallbackUnityPlacementId),
        ),
      );
    }
    if (!_isLoaded || _bannerAd == null) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: SizedBox(
        width: _bannerAd!.size.width.toDouble(),
        height: _bannerAd!.size.height.toDouble(),
        child: AdWidget(ad: _bannerAd!),
      ),
    );
  }
}
