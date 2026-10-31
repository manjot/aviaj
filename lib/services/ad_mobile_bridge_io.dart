import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:unity_ads_plugin/unity_ads_plugin.dart';

/// Native Android & iOS implementation for Google AdMob + Unity Ads Mediation in Production.
class NativeAdBridge {
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

  /// Renders a native AdMob `AdWidget(ad: BannerAd)` or `UnityBannerAd` on iOS & Android.
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
    if (preferUnity) {
      return Padding(
        padding: const EdgeInsets.only(top: 8),
        child: SizedBox(
          height: 50,
          child: UnityBannerAd(
            placementId:
                Platform.isIOS ? unityIosPlacement : unityAndroidPlacement,
          ),
        ),
      );
    }
    return _NativeAdMobBannerSlot(
      adUnitId: Platform.isIOS ? admobIosUnitId : admobAndroidUnitId,
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
    if (preferUnity) {
      final shown = await _showUnityVideo(
        Platform.isIOS ? unityIosPlacement : unityAndroidPlacement,
      );
      if (shown) return true;
    }
    return _showAdMobInterstitial(
      Platform.isIOS ? admobIosUnitId : admobAndroidUnitId,
    );
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
    if (preferUnity) {
      final shown = await _showUnityVideo(
        Platform.isIOS ? unityIosPlacement : unityAndroidPlacement,
        onCompleted: () => onRewardEarned(3, 'Priority Boarding Passes'),
      );
      if (shown) return true;
    }
    return _showAdMobRewarded(
      Platform.isIOS ? admobIosUnitId : admobAndroidUnitId,
      onRewardEarned: onRewardEarned,
    );
  }

  static Future<bool> _showUnityVideo(
    String placementId, {
    void Function()? onCompleted,
  }) async {
    final completer = Completer<bool>();
    try {
      await UnityAds.load(
        placementId: placementId,
        onComplete: (pid) async {
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
        },
        onFailed: (pid, err, msg) {
          if (!completer.isCompleted) completer.complete(false);
        },
      );
      return await completer.future.timeout(
        const Duration(seconds: 5),
        onTimeout: () => false,
      );
    } catch (_) {
      return false;
    }
  }

  static Future<bool> _showAdMobInterstitial(String adUnitId) async {
    final completer = Completer<bool>();
    try {
      await InterstitialAd.load(
        adUnitId: adUnitId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (ad) {
            ad.fullScreenContentCallback = FullScreenContentCallback(
              onAdDismissedFullScreenContent: (ad) => ad.dispose(),
              onAdFailedToShowFullScreenContent: (ad, err) => ad.dispose(),
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
    final completer = Completer<bool>();
    try {
      await RewardedAd.load(
        adUnitId: adUnitId,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (ad) {
            ad.fullScreenContentCallback = FullScreenContentCallback(
              onAdDismissedFullScreenContent: (ad) => ad.dispose(),
              onAdFailedToShowFullScreenContent: (ad, err) => ad.dispose(),
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

  const _NativeAdMobBannerSlot({required this.adUnitId});

  @override
  State<_NativeAdMobBannerSlot> createState() => _NativeAdMobBannerSlotState();
}

class _NativeAdMobBannerSlotState extends State<_NativeAdMobBannerSlot> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;

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
