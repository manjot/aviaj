import 'dart:async';
import 'dart:io';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:unity_ads_plugin/unity_ads_plugin.dart';

/// Native Android & iOS implementation for Google AdMob + Unity Ads Mediation.
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
    bool testMode = true,
  }) async {
    if (!Platform.isAndroid && !Platform.isIOS) return true;
    final completer = Completer<bool>();
    try {
      await UnityAds.init(
        gameId: Platform.isIOS ? iosGameId : androidGameId,
        testMode: testMode,
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
        onCompleted: () => onRewardEarned(3, 'Super Boarding Passes'),
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

