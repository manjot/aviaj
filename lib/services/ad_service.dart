import 'dart:async';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'ad_mobile_bridge_stub.dart'
    if (dart.library.io) 'ad_mobile_bridge_io.dart';
import 'stripe_service.dart';

enum AdNetworkProvider {
  googleAdMob,
  unityAds,
  autoMediation,
}

extension AdNetworkProviderX on AdNetworkProvider {
  String get label {
    switch (this) {
      case AdNetworkProvider.googleAdMob:
        return 'Google AdMob';
      case AdNetworkProvider.unityAds:
        return 'Unity Ads';
      case AdNetworkProvider.autoMediation:
        return 'AdMob + Unity Mediation';
    }
  }
}

/// Centralized Google AdMob + Unity Ads Monetization & Mediation Service.
class AviajAdService extends ChangeNotifier {
  static final AviajAdService instance = AviajAdService._();

  AviajAdService._();

  // Production Google AdMob IDs (Publisher ID: ca-app-pub-4106606850293358)
  String admobPublisherId = const String.fromEnvironment(
    'ADMOB_PUBLISHER_ID',
    defaultValue: 'ca-app-pub-4106606850293358',
  );
  String admobAndroidAppId = const String.fromEnvironment(
    'ADMOB_ANDROID_APP_ID',
    defaultValue: 'ca-app-pub-4106606850293358~4259580608',
  );
  String admobIosAppId = const String.fromEnvironment(
    'ADMOB_IOS_APP_ID',
    defaultValue: 'ca-app-pub-4106606850293358~1715188645',
  );
  String admobBannerUnitId = const String.fromEnvironment(
    'ADMOB_BANNER_UNIT_ID',
    defaultValue: 'ca-app-pub-4106606850293358/9928720582',
  );
  String admobInterstitialUnitId = const String.fromEnvironment(
    'ADMOB_INTERSTITIAL_UNIT_ID',
    defaultValue: 'ca-app-pub-4106606850293358/7901770150',
  );
  String admobRewardedUnitId = const String.fromEnvironment(
    'ADMOB_REWARDED_UNIT_ID',
    defaultValue: 'ca-app-pub-4106606850293358/7512429907',
  );
  String admobIosBannerUnitId = const String.fromEnvironment(
    'ADMOB_IOS_BANNER_UNIT_ID',
    defaultValue: 'ca-app-pub-4106606850293358/5816204854',
  );
  String admobIosInterstitialUnitId = const String.fromEnvironment(
    'ADMOB_IOS_INTERSTITIAL_UNIT_ID',
    defaultValue: 'ca-app-pub-4106606850293358/5189518897',
  );
  String admobIosRewardedUnitId = const String.fromEnvironment(
    'ADMOB_IOS_REWARDED_UNIT_ID',
    defaultValue: 'ca-app-pub-4106606850293358/9922970826',
  );

  // Production Unity Cloud Organization (13469047611046) & Aviaj Project (d8385613-98a1-4ca9-abb2-076401c353b9)
  // Aviaj Android App UUID: b9022463-f3c2-4989-a1ed-bad5d115d91d -> Game ID: 800419265
  // Aviaj iOS App UUID:     10cb14c8-4e39-4acb-95ee-e008c22f370e -> Game ID: 800419268
  String unityOrganizationId = '13469047611046';
  String unityProjectId = 'd8385613-98a1-4ca9-abb2-076401c353b9';
  String unityAndroidGameId = const String.fromEnvironment(
    'UNITY_ANDROID_GAME_ID',
    defaultValue: '800419265',
  );
  String unityIosGameId = const String.fromEnvironment(
    'UNITY_IOS_GAME_ID',
    defaultValue: '800419268',
  );
  String unityBannerPlacement = 'Banner_Android';
  String unityInterstitialPlacement = 'Interstitial_Android';
  String unityRewardedPlacement = 'Rewarded_Android';

  AdNetworkProvider activeProvider = AdNetworkProvider.autoMediation;
  bool isAdMobInitialized = false;
  bool isUnityInitialized = false;
  bool adsEnabled = true;

  // Monetization & Reward Counters
  int bannerImpressions = 1;
  int interstitialImpressions = 0;
  int rewardedVideosCompleted = 0;
  int superBoardingPassCredits = 3;
  int spotlightBoostMinutes = 0;

  Future<void> initializeAll() async {
    isAdMobInitialized = await NativeAdBridge.initializeAdMob();
    isUnityInitialized = await NativeAdBridge.initializeUnityAds(
      androidGameId: unityAndroidGameId,
      iosGameId: unityIosGameId,
      testMode: false,
    );
    notifyListeners();
  }

  void setProvider(AdNetworkProvider provider) {
    activeProvider = provider;
    notifyListeners();
  }

  void toggleAdsEnabled(bool value) {
    adsEnabled = value;
    notifyListeners();
  }

  void recordBannerImpression() {
    bannerImpressions++;
    notifyListeners();
  }

  void updateIds({
    required String newAdmobAppId,
    required String newAdmobBannerId,
    required String newAdmobInterstitialId,
    required String newAdmobRewardedId,
    required String newUnityAndroidGameId,
    required String newUnityIosGameId,
  }) {
    admobAndroidAppId = newAdmobAppId;
    admobBannerUnitId = newAdmobBannerId;
    admobInterstitialUnitId = newAdmobInterstitialId;
    admobRewardedUnitId = newAdmobRewardedId;
    unityAndroidGameId = newUnityAndroidGameId;
    unityIosGameId = newUnityIosGameId;
    notifyListeners();
  }

  /// Triggers an Interstitial Ad via Google AdMob or Unity Ads (native SDK on mobile, interactive overlay on web).
  Future<void> showInterstitialAd(BuildContext context) async {
    if (!adsEnabled) return;
    final preferUnity = activeProvider == AdNetworkProvider.unityAds ||
        (activeProvider == AdNetworkProvider.autoMediation &&
            interstitialImpressions.isOdd);

    final shownNatively = await NativeAdBridge.showNativeInterstitial(
      admobAndroidUnitId: admobInterstitialUnitId,
      admobIosUnitId: admobIosInterstitialUnitId,
      unityAndroidPlacement: unityInterstitialPlacement,
      unityIosPlacement: 'Interstitial_iOS',
      preferUnity: preferUnity,
    );

    interstitialImpressions++;
    notifyListeners();

    if (!shownNatively && context.mounted) {
      await _showInteractiveInterstitialDialog(
        context,
        isUnity: preferUnity,
      );
    }
  }

  /// Triggers a Rewarded Video Ad via Unity Ads or Google AdMob and grants Priority Boarding Passes + Horizon Radar Boost.
  Future<void> showRewardedAd(
    BuildContext context, {
    String rewardDescription =
        '+3 Priority Boarding Passes & 30m Horizon Radar Boost',
  }) async {
    final preferUnity = activeProvider != AdNetworkProvider.googleAdMob;

    final shownNatively = await NativeAdBridge.showNativeRewarded(
      admobAndroidUnitId: admobRewardedUnitId,
      admobIosUnitId: admobIosRewardedUnitId,
      unityAndroidPlacement: unityRewardedPlacement,
      unityIosPlacement: 'Rewarded_iOS',
      preferUnity: preferUnity,
      onRewardEarned: (amount, type) {
        rewardedVideosCompleted++;
        superBoardingPassCredits += 3;
        spotlightBoostMinutes += 30;
        notifyListeners();
      },
    );

    if (!shownNatively && context.mounted) {
      await _showInteractiveRewardedVideoDialog(
        context,
        isUnity: preferUnity,
        rewardDescription: rewardDescription,
      );
    }
  }

  Future<void> _showInteractiveInterstitialDialog(
    BuildContext context, {
    required bool isUnity,
  }) async {
    await showDialog<void>(
      context: context,
      builder: (ctx) {
        return Dialog(
          backgroundColor: AviajTheme.midnightNavy,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 460),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: isUnity
                              ? AviajTheme.compassAmber
                              : AviajTheme.skyAzure,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          isUnity
                              ? 'UNITY ADS INTERSTITIAL • SPONSORED'
                              : 'GOOGLE ADMOB INTERSTITIAL • SPONSORED',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 10.5,
                          ),
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () => Navigator.of(ctx).pop(),
                        icon: const Icon(
                          Icons.close_rounded,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AviajTheme.horizonTeal,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.flight_takeoff_rounded,
                          color: Colors.white,
                          size: 34,
                        ),
                        SizedBox(height: 10),
                        Text(
                          '2-for-1 Co-Pilot Flights to Santorini & Kyoto',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 21,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          'Book with your Aviaj travel partner and get 35% off boutique cliffside villas + zero single supplement.',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    isUnity
                        ? 'Unity Game ID: $unityAndroidGameId • Placement: $unityInterstitialPlacement'
                        : 'AdMob Unit: $admobInterstitialUnitId',
                    style: const TextStyle(
                      color: Colors.white54,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () => Navigator.of(ctx).pop(),
                      style: FilledButton.styleFrom(
                        backgroundColor: AviajTheme.compassAmber,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text(
                        'Continue Exploring on Aviaj',
                        style: TextStyle(fontWeight: FontWeight.w900),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _showInteractiveRewardedVideoDialog(
    BuildContext context, {
    required bool isUnity,
    required String rewardDescription,
  }) async {
    int secondsRemaining = 3;
    Timer? timer;
    bool timerStarted = false;

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            if (!timerStarted) {
              timerStarted = true;
              timer = Timer.periodic(const Duration(seconds: 1), (t) {
                if (secondsRemaining > 0) {
                  setModalState(() {
                    secondsRemaining--;
                  });
                } else {
                  t.cancel();
                }
              });
            }

            final completed = secondsRemaining == 0;
            return Dialog(
              backgroundColor: AviajTheme.midnightNavy,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: isUnity
                                  ? AviajTheme.compassAmber
                                  : AviajTheme.skyAzure,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              isUnity
                                  ? 'UNITY REWARDED VIDEO AD'
                                  : 'GOOGLE ADMOB REWARDED VIDEO AD',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                fontSize: 10.5,
                              ),
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: completed
                                  ? AviajTheme.solidEmerald
                                  : Colors.white12,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              completed
                                  ? '✓ REWARD UNLOCKED'
                                  : 'Reward in ${secondsRemaining}s...',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                fontSize: 11.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(22),
                        decoration: BoxDecoration(
                          color: AviajTheme.horizonTeal,
                          borderRadius: BorderRadius.circular(22),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.play_circle_fill_rounded,
                                  color: Colors.white,
                                  size: 36,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    isUnity
                                        ? 'Unity Ads Travel Partner Showcase'
                                        : 'Google AdMob Premier Airlines Partner',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w900,
                                      fontSize: 17,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'Unlock VIP Airport Lounge Access & Priority Co-Pilot Matchmaking on your next international flight.',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13.5,
                              ),
                            ),
                            const SizedBox(height: 12),
                            LinearProgressIndicator(
                              value: (3 - secondsRemaining) / 3,
                              backgroundColor: Colors.white24,
                              color: AviajTheme.compassAmber,
                              minHeight: 7,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        'Reward: $rewardDescription',
                        style: const TextStyle(
                          color: AviajTheme.compassAmber,
                          fontWeight: FontWeight.w800,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: completed
                              ? () {
                                  timer?.cancel();
                                  rewardedVideosCompleted++;
                                  superBoardingPassCredits += 3;
                                  spotlightBoostMinutes += 30;
                                  notifyListeners();
                                  Navigator.of(ctx).pop();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor: AviajTheme.solidEmerald,
                                      content: Text(
                                        '🎉 Earned $rewardDescription via ${isUnity ? "Unity Ads" : "Google AdMob"}!',
                                      ),
                                    ),
                                  );
                                }
                              : null,
                          style: FilledButton.styleFrom(
                            backgroundColor: AviajTheme.compassAmber,
                            foregroundColor: Colors.white,
                            disabledBackgroundColor: Colors.white12,
                            disabledForegroundColor: Colors.white54,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                          ),
                          icon: const Icon(Icons.card_giftcard_rounded),
                          label: Text(
                            completed
                                ? 'Claim +3 Boarding Passes & 30m Boost'
                                : 'Watching Ad (${secondsRemaining}s)...',
                            style:
                                const TextStyle(fontWeight: FontWeight.w900),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
    timer?.cancel();
  }
}

/// Solid-color AdMob + Unity Ads Banner Bar displayed in Discover & Trips.
class AviajAdBannerWidget extends StatelessWidget {
  final String placementLabel;

  const AviajAdBannerWidget({
    super.key,
    this.placementLabel = 'Discover Feed',
  });

  @override
  Widget build(BuildContext context) {
    final adService = AviajAdService.instance;
    return ListenableBuilder(
      listenable: adService,
      builder: (context, _) {
        if (!adService.adsEnabled) return const SizedBox.shrink();

        final isUnity =
            adService.activeProvider == AdNetworkProvider.unityAds;
        final badgeText =
            adService.activeProvider == AdNetworkProvider.autoMediation
                ? 'ADMOB + UNITY ADS MEDIATION'
                : (isUnity ? 'UNITY ADS BANNER' : 'GOOGLE ADMOB BANNER');

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          decoration: BoxDecoration(
            color: AviajTheme.midnightNavy,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AviajTheme.compassAmber, width: 1.5),
          ),
          child: Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 12,
            runSpacing: 10,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AviajTheme.compassAmber,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'AD • $badgeText',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 10,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Get +3 Free Priority Boarding Passes & 30m Radar Boost!',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 13.5,
                          ),
                        ),
                        Text(
                          'Credits: ${adService.superBoardingPassCredits} Priority Passes • ${adService.spotlightBoostMinutes}m Radar Active',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  FilledButton.icon(
                    onPressed: () => adService.showRewardedAd(context),
                    style: FilledButton.styleFrom(
                      backgroundColor: AviajTheme.sunsetTerracotta,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                    ),
                    icon: const Icon(Icons.play_circle_fill_rounded, size: 16),
                    label: const Text(
                      'Watch Rewarded Ad (+3)',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  FilledButton.icon(
                    onPressed: () => showStripeStorefrontModal(context),
                    style: FilledButton.styleFrom(
                      backgroundColor: AviajTheme.deepLoveRed,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                    ),
                    icon: const Icon(Icons.credit_card_rounded, size: 16),
                    label: const Text(
                      'Business Class • Stripe (\$14.99)',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  OutlinedButton.icon(
                    onPressed: () => showAdMobUnityConsoleModal(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AviajTheme.compassAmber,
                      side: const BorderSide(color: AviajTheme.compassAmber),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                    ),
                    icon: const Icon(Icons.tune_rounded, size: 15),
                    label: const Text(
                      'Ad SDK Setup',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              NativeAdBridge.buildNativeBannerWidget(
                admobAndroidUnitId: adService.admobBannerUnitId,
                admobIosUnitId: adService.admobIosBannerUnitId,
                unityAndroidPlacement: adService.unityBannerPlacement,
                unityIosPlacement: 'Banner_iOS',
                preferUnity: isUnity,
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Interactive Console Modal to inspect & configure Google AdMob + Unity Ads IDs and test ad formats.
Future<void> showAdMobUnityConsoleModal(BuildContext context) async {
  final adService = AviajAdService.instance;
  final admobAppCtrl = TextEditingController(text: adService.admobAndroidAppId);
  final admobBannerCtrl =
      TextEditingController(text: adService.admobBannerUnitId);
  final admobInterCtrl =
      TextEditingController(text: adService.admobInterstitialUnitId);
  final admobRewardCtrl =
      TextEditingController(text: adService.admobRewardedUnitId);
  final unityAndroidCtrl =
      TextEditingController(text: adService.unityAndroidGameId);
  final unityIosCtrl = TextEditingController(text: adService.unityIosGameId);

  await showDialog<void>(
    context: context,
    builder: (ctx) {
      return ListenableBuilder(
        listenable: adService,
        builder: (context, _) {
          return Dialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 580),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(26),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AviajTheme.midnightNavy,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.monetization_on_rounded,
                                color: AviajTheme.compassAmber,
                                size: 16,
                              ),
                              SizedBox(width: 6),
                              Text(
                                'GOOGLE ADMOB + UNITY ADS MEDIATION SDK',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () => Navigator.of(ctx).pop(),
                          icon: const Icon(Icons.close_rounded),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Ad Network Mediation & SDK Configuration',
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.w900,
                        color: AviajTheme.midnightNavy,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Integrated with google_mobile_ads & unity_ads_plugin • Priority Credits Earned: ${adService.superBoardingPassCredits} • Rewarded Views: ${adService.rewardedVideosCompleted}',
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF555560),
                      ),
                    ),
                    const SizedBox(height: 14),
                    // Active Network Provider Selector
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: AdNetworkProvider.values.map((p) {
                        final selected = adService.activeProvider == p;
                        return ChoiceChip(
                          label: Text(p.label),
                          selected: selected,
                          selectedColor: AviajTheme.horizonTeal,
                          labelStyle: TextStyle(
                            color: selected
                                ? Colors.white
                                : AviajTheme.midnightNavy,
                            fontWeight: FontWeight.w800,
                          ),
                          onSelected: (_) => adService.setProvider(p),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                    // Live Test Ad Triggers
                    Row(
                      children: [
                        Expanded(
                          child: FilledButton.icon(
                            onPressed: () {
                              Navigator.of(ctx).pop();
                              adService.showInterstitialAd(context);
                            },
                            style: FilledButton.styleFrom(
                              backgroundColor: AviajTheme.midnightNavy,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 13),
                            ),
                            icon: const Icon(Icons.fullscreen_rounded, size: 18),
                            label: const Text(
                              'Test Interstitial Ad',
                              style: TextStyle(fontWeight: FontWeight.w800),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: FilledButton.icon(
                            onPressed: () {
                              Navigator.of(ctx).pop();
                              adService.showRewardedAd(context);
                            },
                            style: FilledButton.styleFrom(
                              backgroundColor: AviajTheme.sunsetTerracotta,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 13),
                            ),
                            icon: const Icon(
                              Icons.play_circle_fill_rounded,
                              size: 18,
                            ),
                            label: const Text(
                              'Test Rewarded Video',
                              style: TextStyle(fontWeight: FontWeight.w800),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 28),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text(
                        'Enable AdMob & Unity Banner / Interstitial Ads',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 14,
                        ),
                      ),
                      subtitle: const Text(
                        'Rewarded Video Ads remain available for free Priority Boarding Passes',
                        style: TextStyle(fontSize: 12),
                      ),
                      value: adService.adsEnabled,
                      activeTrackColor: AviajTheme.horizonTeal,
                      onChanged: adService.toggleAdsEnabled,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'GOOGLE ADMOB CONFIGURATION (Android & iOS)',
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.8,
                        color: AviajTheme.horizonTeal,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: admobAppCtrl,
                      decoration: const InputDecoration(
                        labelText: 'AdMob App ID (ca-app-pub-...)',
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: admobBannerCtrl,
                            decoration: const InputDecoration(
                              labelText: 'Banner Ad Unit ID',
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: admobRewardCtrl,
                            decoration: const InputDecoration(
                              labelText: 'Rewarded Video Unit ID',
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'UNITY ADS CONFIGURATION (Game IDs & Placements)',
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.8,
                        color: AviajTheme.midnightNavy,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: unityAndroidCtrl,
                            decoration: const InputDecoration(
                              labelText: 'Unity Android Game ID',
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: unityIosCtrl,
                            decoration: const InputDecoration(
                              labelText: 'Unity iOS Game ID',
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: () {
                          adService.updateIds(
                            newAdmobAppId: admobAppCtrl.text.trim(),
                            newAdmobBannerId: admobBannerCtrl.text.trim(),
                            newAdmobInterstitialId: admobInterCtrl.text.trim(),
                            newAdmobRewardedId: admobRewardCtrl.text.trim(),
                            newUnityAndroidGameId: unityAndroidCtrl.text.trim(),
                            newUnityIosGameId: unityIosCtrl.text.trim(),
                          );
                          Navigator.of(ctx).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              backgroundColor: AviajTheme.midnightNavy,
                              content: Text(
                                'Saved Google AdMob & Unity Ads SDK Configuration!',
                              ),
                            ),
                          );
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: AviajTheme.compassAmber,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                        ),
                        icon: const Icon(Icons.save_rounded),
                        label: const Text(
                          'Save AdMob & Unity Ads Keys',
                          style: TextStyle(fontWeight: FontWeight.w900),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}
