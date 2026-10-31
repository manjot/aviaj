/// Web / non-IO bridge stub for Google AdMob & Unity Ads SDKs.
class NativeAdBridge {
  static Future<bool> initializeAdMob() async => true;

  static Future<bool> initializeUnityAds({
    required String androidGameId,
    required String iosGameId,
    bool testMode = true,
  }) async =>
      true;

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

