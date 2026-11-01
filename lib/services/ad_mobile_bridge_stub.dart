import 'package:flutter/material.dart';

/// Web / non-IO bridge stub for Google AdMob & Unity Ads SDKs.
class NativeAdBridge {
  static Future<bool> initializeAdMob() async => true;

  static Future<bool> initializeUnityAds({
    required String androidGameId,
    required String iosGameId,
    bool testMode = false,
  }) async =>
      true;

  static Future<void> preloadAds({
    required String admobAndroidInterstitialId,
    required String admobIosInterstitialId,
    required String admobAndroidRewardedId,
    required String admobIosRewardedId,
    required String unityAndroidInterstitialPlacement,
    required String unityIosInterstitialPlacement,
    required String unityAndroidRewardedPlacement,
    required String unityIosRewardedPlacement,
  }) async {}

  static Widget buildNativeBannerWidget({
    required String admobAndroidUnitId,
    required String admobIosUnitId,
    required String unityAndroidPlacement,
    required String unityIosPlacement,
    required bool preferUnity,
  }) =>
      const SizedBox.shrink();

  static Future<bool> showNativeInterstitial({
    required String admobAndroidUnitId,
    required String admobIosUnitId,
    required String unityAndroidPlacement,
    required String unityIosPlacement,
    required bool preferUnity,
  }) async =>
      false;

  static Future<bool> showNativeRewarded({
    required String admobAndroidUnitId,
    required String admobIosUnitId,
    required String unityAndroidPlacement,
    required String unityIosPlacement,
    required bool preferUnity,
    required void Function(int amount, String type) onRewardEarned,
  }) async =>
      false;
}
