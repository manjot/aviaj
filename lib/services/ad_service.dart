import 'dart:async';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'ad_mobile_bridge_stub.dart'
    if (dart.library.io) 'ad_mobile_bridge_io.dart';

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

  // Official Google AdMob IDs (configured for immediate testing + editable in console)
  String admobAndroidAppId = 'ca-app-pub-3940256099942544~3347511713';
  String admobIosAppId = 'ca-app-pub-3940256099942544~1458002511';
  String admobBannerUnitId = 'ca-app-pub-3940256099942544/6300978111';
  String admobInterstitialUnitId = 'ca-app-pub-3940256099942544/1033173712';
  String admobRewardedUnitId = 'ca-app-pub-3940256099942544/5224354917';

  // Official Unity Ads Game IDs & Placements
  String unityAndroidGameId = '5719482';
  String unityIosGameId = '5719483';
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
      testMode: true,
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
      admobIosUnitId: admobInterstitialUnitId,
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

  /// Triggers a Rewarded Video Ad via Unity Ads or Google AdMob and grants Super Boarding Passes + Spotlight.
  Future<void> showRewardedAd(
    BuildContext context, {
    String rewardDescription =
        '+3 Super Boarding Passes & 30m Bumble Spotlight',
  }) async {
    final preferUnity = activeProvider != AdNetworkProvider.googleAdMob;

    final shownNatively = await NativeAdBridge.showNativeRewarded(
      admobAndroidUnitId: admobRewardedUnitId,
      admobIosUnitId: admobRewardedUnitId,
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
          backgroundColor: AviajTheme.obsidian,
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
                              ? AviajTheme.bumbleHoney
                              : AviajTheme.passportBlue,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          isUnity
                              ? 'UNITY ADS INTERSTITIAL • SPONSORED'
                              : 'GOOGLE ADMOB INTERSTITIAL • SPONSORED',
                          style: TextStyle(
                            color:
                                isUnity ? AviajTheme.obsidian : Colors.white,
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
                      color: AviajTheme.loveCrimson,
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
                          '2-for-1 Romantic Flights to Santorini & Kyoto',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 21,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          'Book with your Aviaj match and get 35% off boutique cliffside villas + zero single supplement.',
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
                        backgroundColor: AviajTheme.bumbleHoney,
                        foregroundColor: AviajTheme.obsidian,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text(
                        'Continue Swiping on Aviaj',
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
              backgroundColor: AviajTheme.obsidian,
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
                                  ? AviajTheme.bumbleHoney
                                  : AviajTheme.passportBlue,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              isUnity
                                  ? 'UNITY REWARDED VIDEO AD'
                                  : 'GOOGLE ADMOB REWARDED VIDEO AD',
                              style: TextStyle(
                                color: isUnity
                                    ? AviajTheme.obsidian
                                    : Colors.white,
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
                          color: AviajTheme.loveCrimson,
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
                              'Unlock VIP Airport Lounge Access & Priority Matchmaking on your next international flight.',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13.5,
                              ),
                            ),
                            const SizedBox(height: 12),
                            LinearProgressIndicator(
                              value: (3 - secondsRemaining) / 3,
                              backgroundColor: Colors.white24,
                              color: AviajTheme.bumbleHoney,
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
                          color: AviajTheme.bumbleHoney,
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
                            backgroundColor: AviajTheme.bumbleHoney,
                            foregroundColor: AviajTheme.obsidian,
                            disabledBackgroundColor: Colors.white12,
                            disabledForegroundColor: Colors.white54,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                          ),
                          icon: const Icon(Icons.card_giftcard_rounded),
                          label: Text(
                            completed
                                ? 'Claim +3 Super Passes & 30m Boost'
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
            color: AviajTheme.obsidian,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AviajTheme.bumbleHoney, width: 1.5),
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
                      color: AviajTheme.bumbleHoney,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'AD • $badgeText',
                      style: const TextStyle(
                        color: AviajTheme.obsidian,
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
                          'Get +3 Free Super Likes & 30m Bumble Spotlight!',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 13.5,
                          ),
                        ),
                        Text(
                          'Credits: ${adService.superBoardingPassCredits} Super Passes • ${adService.spotlightBoostMinutes}m Spotlight Active',
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
                      backgroundColor: AviajTheme.loveCrimson,
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
                  OutlinedButton.icon(
                    onPressed: () => showAdMobUnityConsoleModal(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AviajTheme.bumbleHoney,
                      side: const BorderSide(color: AviajTheme.bumbleHoney),
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
                            color: AviajTheme.obsidian,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.monetization_on_rounded,
                                color: AviajTheme.bumbleHoney,
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
                        color: AviajTheme.obsidian,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Integrated with google_mobile_ads & unity_ads_plugin • Super Credits Earned: ${adService.superBoardingPassCredits} • Rewarded Views: ${adService.rewardedVideosCompleted}',
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
                          selectedColor: AviajTheme.loveCrimson,
                          labelStyle: TextStyle(
                            color: selected ? Colors.white : AviajTheme.obsidian,
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
                              backgroundColor: AviajTheme.obsidian,
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
                              backgroundColor: AviajTheme.loveCrimson,
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
                    const Text(
                      'GOOGLE ADMOB CONFIGURATION',
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w900,
                        color: AviajTheme.loveCrimson,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: admobAppCtrl,
                      decoration: const InputDecoration(
                        labelText: 'AdMob App ID (Android / iOS)',
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: admobBannerCtrl,
                            decoration: const InputDecoration(
                              labelText: 'AdMob Banner Unit ID',
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: admobRewardCtrl,
                            decoration: const InputDecoration(
                              labelText: 'AdMob Rewarded Unit ID',
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'UNITY ADS CONFIGURATION',
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w900,
                        color: AviajTheme.obsidian,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: unityAndroidCtrl,
                            decoration: const InputDecoration(
                              labelText: 'Unity Ads Android Game ID',
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: unityIosCtrl,
                            decoration: const InputDecoration(
                              labelText: 'Unity Ads iOS Game ID',
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
                            newUnityAndroidGameId:
                                unityAndroidCtrl.text.trim(),
                            newUnityIosGameId: unityIosCtrl.text.trim(),
                          );
                          Navigator.of(ctx).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              backgroundColor: AviajTheme.obsidian,
                              content: Text(
                                'Google AdMob & Unity Ads SDK configuration saved!',
                              ),
                            ),
                          );
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: AviajTheme.bumbleHoney,
                          foregroundColor: AviajTheme.obsidian,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                        ),
                        icon: const Icon(Icons.save_rounded),
                        label: const Text(
                          'Save AdMob & Unity Ads Config',
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

