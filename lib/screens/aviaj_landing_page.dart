import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' show lerpDouble;
import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/ad_service.dart';
import '../services/stripe_service.dart';
import '../state/aviaj_state.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';

/// Lengthy, spacious, editorial Marketing Landing Page for Web (`aviaj.com`).
/// Features the two-stage animated full-bleed Red Love hero banner:
///   1) Giant edge-to-edge `Aviaj` brand name staggered entrance animation
///   2) 3D angled perspective Profiles Slider fan-out + continuous smooth carousel
class AviajLandingPage extends StatefulWidget {
  final AviajState state;
  final VoidCallback onOpenFullMobilePreview;

  const AviajLandingPage({
    super.key,
    required this.state,
    required this.onOpenFullMobilePreview,
  });

  @override
  State<AviajLandingPage> createState() => _AviajLandingPageState();
}

class _AviajLandingPageState extends State<AviajLandingPage>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _modesKey = GlobalKey();
  final GlobalKey _radarKey = GlobalKey();
  final GlobalKey _storiesKey = GlobalKey();
  final GlobalKey _pricingKey = GlobalKey();
  int _selectedHeroIndex = 0;

  late final AnimationController _bannerIntroController;
  late final AnimationController _profileSliderController;
  Timer? _autoSlideTimer;

  @override
  void initState() {
    super.initState();
    // Phase 1 (0.0 -> 0.55): Giant "Aviaj" display letters animate in.
    // Phase 2 (0.42 -> 1.00): 3D angled profile cards fan out over the center.
    _bannerIntroController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1650),
    )..forward();

    // Phase 3: Continuous smooth 3D profile slider morphing Slot 3 -> 2 -> 1 -> 0 -> -1.
    _profileSliderController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 850),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed && mounted) {
          setState(() {
            _selectedHeroIndex =
                (_selectedHeroIndex + 1) % widget.state.allProfiles.length;
          });
          _profileSliderController.reset();
        }
      });

    // Automatically advance the 3D profiles slider after the banner intro completes.
    _autoSlideTimer = Timer.periodic(
      const Duration(milliseconds: 2900),
      (_) {
        if (!mounted) return;
        if (_bannerIntroController.isCompleted &&
            !_profileSliderController.isAnimating) {
          _profileSliderController.forward(from: 0);
        }
      },
    );
  }

  void _triggerNextProfileSlide() {
    if (_profileSliderController.isAnimating) return;
    _profileSliderController.forward(from: 0);
  }

  void _replayBannerAnimation() {
    _profileSliderController.reset();
    _bannerIntroController.forward(from: 0);
  }

  @override
  void dispose() {
    _autoSlideTimer?.cancel();
    _bannerIntroController.dispose();
    _profileSliderController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToSection(GlobalKey key) {
    final ctx = key.currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 980;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            // SECTION 1: FULL-BLEED ANIMATED BANNER (GIANT NAME + 3D PROFILES SLIDER)
            _buildSpaciousHeroSection(context, isDesktop),

            // SECTION 1B: CONCISE EDITORIAL HEADLINE + APP STORE & GOOGLE PLAY STRIP
            _buildBelowBannerIntroStrip(context, isDesktop),

            // SECTION 2: THREE CORE TRAVEL MODES (AVIAJ ROMANCE • CO-PILOT • CREW)
            Container(
              key: _modesKey,
              child: _buildThreeModesPillarSection(context, isDesktop),
            ),

            // SECTION 3: EDITORIAL 50/50 SPLIT #1 — DESTINATION RADAR
            Container(
              key: _radarKey,
              child: _buildEditorialSplitSection(
                context: context,
                isDesktop: isDesktop,
                imageFirst: true,
                bgColor: Colors.white,
                pillLabel: 'DESTINATION RADAR™',
                pillColor: AviajTheme.horizonTeal,
                headline: 'Match before your flight departs.',
                subtitle:
                    'Drop your pin in Kyoto, Amalfi, or Bali weeks ahead and land with sunset plans already made.',
                ctaLabel: 'Explore Destination Radar',
                onCtaTap: widget.onOpenFullMobilePreview,
                imageUrl:
                    'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1100&q=80',
                overlayBadgeTop: '✈️ Boarding Radar • Amalfi & Kyoto',
                overlayBadgeBottom: '98% Co-Pilot Chemistry Match',
              ),
            ),

            // SECTION 4: EDITORIAL 50/50 SPLIT #2 — DEPARTURE PROMPTS
            _buildEditorialSplitSection(
              context: context,
              isDesktop: isDesktop,
              imageFirst: false,
              bgColor: AviajTheme.warmSand,
              pillLabel: 'DEPARTURE PROMPTS™',
              pillColor: AviajTheme.sunsetTerracotta,
              headline: 'Skip small talk.\nStart with an itinerary.',
              subtitle:
                  'Answer a travel icebreaker and send a Boarding Date Card for rooftop cocktails or a coastal roadtrip.',
              ctaLabel: 'Try Departure Prompts',
              onCtaTap: widget.onOpenFullMobilePreview,
              imageUrl:
                  'https://images.unsplash.com/photo-1529156069898-49953e39b3ac?auto=format&fit=crop&w=1100&q=80',
              overlayBadgeTop: '💬 “Best sunset rooftop in Lisbon?”',
              overlayBadgeBottom: '🎟️ Boarding Date Invite Sent',
            ),

            // SECTION 5: EDITORIAL 50/50 SPLIT #3 — VERIFIED PASSPORTS & SAFETY
            _buildEditorialSplitSection(
              context: context,
              isDesktop: isDesktop,
              imageFirst: true,
              bgColor: Colors.white,
              pillLabel: 'VERIFIED TRAVEL PASSPORTS™',
              pillColor: AviajTheme.solidEmerald,
              headline: 'Verified travellers.\nReal departures.',
              subtitle:
                  'Selfie verification, shared trip check-ins, and verified route badges so solo travellers connect with confidence.',
              ctaLabel: 'Get the Verified App',
              onCtaTap: () => showMobileAppDownloadModal(context),
              imageUrl:
                  'https://images.unsplash.com/photo-1539635278303-d4002c07eae3?auto=format&fit=crop&w=1100&q=80',
              overlayBadgeTop: '✓ Photo & Route Verified',
              overlayBadgeBottom: '🛡️ 24/7 Solo Traveller Safety Shield',
            ),

            // SECTION 6: "THE HORIZON" — REAL TRAVEL ROMANCE & CO-PILOT STORIES
            Container(
              key: _storiesKey,
              child: _buildStoriesSection(context, isDesktop),
            ),

            // SECTION 7: MINIMAL CABIN CLASS UPGRADES (STRIPE acct_1TNTVyJD1U0jWVOT)
            Container(
              key: _pricingKey,
              child: _buildMinimalCabinUpgradesSection(context, isDesktop),
            ),

            // SECTION 8: FULL-WIDTH CONVERSION BANNER + MULTI-COLUMN SITEMAP FOOTER
            _buildConversionBannerAndFooter(context, isDesktop),
          ],
        ),
      ),
    );
  }

  /// SECTION 1: Full-Bleed Solid Red Love Animated Hero Banner
  /// Phase 1: Giant edge-to-edge "Aviaj" wordmark animates in (staggered letters).
  /// Phase 2: 3D angled perspective profile cards fan out over the center ("Av" [cards] "aj").
  /// Phase 3: Continuous & interactive 3D profiles slider morphs cards right-to-left.
  Widget _buildSpaciousHeroSection(BuildContext context, bool isDesktop) {
    final screenWidth = MediaQuery.of(context).size.width;
    final profiles = widget.state.allProfiles;
    final stageHeight = isDesktop ? 610.0 : 460.0;
    final cardScale = isDesktop ? 1.0 : 0.64;

    return Container(
      width: double.infinity,
      color: AviajTheme.loveRed,
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Top Integrated Navigation Bar (Wordmark Left • Floating White Pill Center • Pill Right)
            Padding(
              padding: EdgeInsets.fromLTRB(
                isDesktop ? 48 : 20,
                isDesktop ? 22 : 14,
                isDesktop ? 48 : 20,
                8,
              ),
              child: Row(
                children: [
                  // Brand Wordmark on Left
                  InkWell(
                    onTap: _replayBannerAnimation,
                    borderRadius: BorderRadius.circular(12),
                    child: const Text(
                      'Aviaj',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 36,
                        letterSpacing: -1.4,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const Spacer(),
                  // Center Floating White Stadium Pill Navigation Bar
                  if (isDesktop)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 22,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _NavbarLink(
                            label: 'Romance',
                            onTap: () => _scrollToSection(_modesKey),
                          ),
                          _NavbarLink(
                            label: 'Co-Pilot',
                            onTap: () => _scrollToSection(_modesKey),
                          ),
                          _NavbarLink(
                            label: 'Stories',
                            onTap: () => _scrollToSection(_storiesKey),
                          ),
                          _NavbarLink(
                            label: 'Safety',
                            onTap: () => _scrollToSection(_radarKey),
                          ),
                          _NavbarLink(
                            label: 'Support',
                            onTap: () => _scrollToSection(_pricingKey),
                          ),
                        ],
                      ),
                    ),
                  const Spacer(),
                  // Right Floating White Stadium Pills
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isDesktop) ...[
                        InkWell(
                          onTap: widget.onOpenFullMobilePreview,
                          borderRadius: BorderRadius.circular(40),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 11,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.18),
                              borderRadius: BorderRadius.circular(40),
                            ),
                            child: const Text(
                              'App Demo',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                fontSize: 13.5,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                      ],
                      InkWell(
                        onTap: () => showMobileAppDownloadModal(context),
                        borderRadius: BorderRadius.circular(40),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 11,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(40),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.language_rounded,
                                color: AviajTheme.midnightNavy,
                                size: 20,
                              ),
                              SizedBox(width: 6),
                              Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color: AviajTheme.midnightNavy,
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Main Animated Stage: Giant "Aviaj" Name + 3D Angled Profiles Slider
            ClipRect(
              child: SizedBox(
                width: double.infinity,
                height: stageHeight,
                child: AnimatedBuilder(
                  animation: Listenable.merge([
                    _bannerIntroController,
                    _profileSliderController,
                  ]),
                  builder: (context, _) {
                    final giantFontSize = isDesktop
                        ? (screenWidth * 0.255).clamp(215.0, 365.0)
                        : (screenWidth * 0.27).clamp(96.0, 150.0);
                    const brandLetters = ['A', 'v', 'i', 'a', 'j'];

                    return Stack(
                      alignment: Alignment.center,
                      clipBehavior: Clip.hardEdge,
                      children: [
                        // STEP 1: GIANT EDGE-TO-EDGE "Aviaj" WORDMARK ANIMATION
                        Positioned(
                          left: isDesktop ? 34 : 12,
                          right: isDesktop ? 34 : 12,
                          bottom: isDesktop ? 62 : 70,
                          child: IgnorePointer(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: List.generate(
                                brandLetters.length,
                                (index) {
                                  final start = (index * 0.065).clamp(0.0, 0.4);
                                  final end =
                                      (0.48 + index * 0.065).clamp(0.0, 1.0);
                                  final rawT = ((_bannerIntroController.value -
                                              start) /
                                          (end - start))
                                      .clamp(0.0, 1.0);
                                  final curvedT =
                                      Curves.easeOutBack.transform(rawT);
                                  final opacityT =
                                      Curves.easeOut.transform(rawT);

                                  return Transform.translate(
                                    offset: Offset(0, (1.0 - curvedT) * 145.0),
                                    child: Transform.scale(
                                      scale: 0.78 + (0.22 * curvedT),
                                      child: Opacity(
                                        opacity: opacityT,
                                        child: Text(
                                          brandLetters[index],
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: giantFontSize,
                                            fontWeight: FontWeight.w900,
                                            height: 0.88,
                                            letterSpacing: -8,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),

                        // STEP 2 & 3: 3D ANGLED PERSPECTIVE PROFILES SLIDER
                        // Render back-to-front (Slot 3 -> Slot 2 -> Slot 1 -> Slot 0 -> Outgoing)
                        for (final slotIndex in [3, 2, 1, 0])
                          _buildAnimatedPerspectiveProfileCard(
                            context: context,
                            profiles: profiles,
                            slotIndex: slotIndex,
                            cardScale: cardScale,
                            stageWidth: screenWidth,
                            stageHeight: stageHeight,
                          ),

                        // Subtle Bottom-Right Interactive Slider Controls
                        Positioned(
                          right: isDesktop ? 44 : 16,
                          bottom: 18,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 7,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.92),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                InkWell(
                                  onTap: _replayBannerAnimation,
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 2,
                                    ),
                                    child: Icon(
                                      Icons.replay_rounded,
                                      size: 16,
                                      color: AviajTheme.midnightNavy,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 4),
                                GestureDetector(
                                  onTap: _triggerNextProfileSlide,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        '${profiles[_selectedHeroIndex % profiles.length].name.split(' ').first}, ${profiles[_selectedHeroIndex % profiles.length].age}',
                                        style: const TextStyle(
                                          color: AviajTheme.midnightNavy,
                                          fontWeight: FontWeight.w900,
                                          fontSize: 12.5,
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: const BoxDecoration(
                                          color: AviajTheme.loveRed,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.arrow_forward_rounded,
                                          size: 13,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds a single 3D perspective angled profile slab at [slotIndex] (0=Front, 1=Middle, 2=Back, 3=Incoming)
  /// and interpolates smoothly toward `slotIndex - 1` as `_profileSliderController` runs from 0 -> 1.
  Widget _buildAnimatedPerspectiveProfileCard({
    required BuildContext context,
    required List<TravellerProfile> profiles,
    required int slotIndex,
    required double cardScale,
    required double stageWidth,
    required double stageHeight,
  }) {
    final profile =
        profiles[(_selectedHeroIndex + slotIndex) % profiles.length];
    final firstName = profile.name.split(' ').first;

    // Entrance animation for Phase 2 ("THEN ANIMATE PROFILES SLIDER" after "Aviaj" name)
    final introStart = (0.42 + slotIndex * 0.08).clamp(0.0, 0.85);
    final introEnd = (0.86 + slotIndex * 0.045).clamp(0.0, 1.0);
    final rawIntro =
        ((_bannerIntroController.value - introStart) / (introEnd - introStart))
            .clamp(0.0, 1.0);
    final introCurve = Curves.easeOutCubic.transform(rawIntro);

    // Continuous slider transition t (0.0 -> 1.0 moves slotIndex -> slotIndex - 1)
    final slideT =
        Curves.easeInOutCubic.transform(_profileSliderController.value);

    // Define the 5 perspective slots: [-1: Outgoing, 0: Front, 1: Middle, 2: Back, 3: Incoming]
    ({
      double dx,
      double top,
      double width,
      double height,
      double slant,
      double opacity,
      double fontSize,
    }) metricsForSlot(int s) {
      switch (s) {
        case -1:
          return (
            dx: -360.0 * cardScale,
            top: 0.0 * cardScale,
            width: 315.0 * cardScale,
            height: 605.0 * cardScale,
            slant: 44.0 * cardScale,
            opacity: 0.0,
            fontSize: 22.0 * cardScale,
          );
        case 0:
          return (
            dx: -118.0 * cardScale,
            top: 12.0 * cardScale,
            width: 300.0 * cardScale,
            height: 598.0 * cardScale,
            slant: 42.0 * cardScale,
            opacity: 1.0,
            fontSize: 21.0 * cardScale,
          );
        case 1:
          return (
            dx: 76.0 * cardScale,
            top: 84.0 * cardScale,
            width: 192.0 * cardScale,
            height: 440.0 * cardScale,
            slant: 30.0 * cardScale,
            opacity: 1.0,
            fontSize: 15.5 * cardScale,
          );
        case 2:
          return (
            dx: 222.0 * cardScale,
            top: 150.0 * cardScale,
            width: 146.0 * cardScale,
            height: 320.0 * cardScale,
            slant: 22.0 * cardScale,
            opacity: 1.0,
            fontSize: 13.0 * cardScale,
          );
        default: // case 3 (Incoming from right)
          return (
            dx: 335.0 * cardScale,
            top: 205.0 * cardScale,
            width: 108.0 * cardScale,
            height: 225.0 * cardScale,
            slant: 16.0 * cardScale,
            opacity: 0.0,
            fontSize: 11.0 * cardScale,
          );
      }
    }

    final from = metricsForSlot(slotIndex);
    final to = metricsForSlot(slotIndex - 1);

    final targetDx = lerpDouble(from.dx, to.dx, slideT)!;
    final targetTop = lerpDouble(from.top, to.top, slideT)!;
    final width = lerpDouble(from.width, to.width, slideT)!;
    final height = lerpDouble(from.height, to.height, slideT)!;
    final slant = lerpDouble(from.slant, to.slant, slideT)!;
    final baseOpacity = lerpDouble(from.opacity, to.opacity, slideT)!;
    final fontSize = lerpDouble(from.fontSize, to.fontSize, slideT)!;

    // Fan-out from center during Phase 2 intro
    final currentDx = lerpDouble(0.0, targetDx, introCurve)!;
    final currentTop = targetTop + (1.0 - introCurve) * 110.0;
    final effectiveOpacity = (baseOpacity * introCurve).clamp(0.0, 1.0);

    if (effectiveOpacity <= 0.01) {
      return const SizedBox.shrink();
    }

    final centerLeft = (stageWidth / 2) + currentDx - (width / 2);

    return Positioned(
      left: centerLeft,
      top: currentTop,
      width: width,
      height: height,
      child: Opacity(
        opacity: effectiveOpacity,
        child: GestureDetector(
          onTap: _triggerNextProfileSlide,
          onHorizontalDragEnd: (_) => _triggerNextProfileSlide(),
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: ClipPath(
              clipper: _PerspectiveSlabClipper(
                slant: slant,
                radius: 22.0 * cardScale,
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  AviajNetworkImage(
                    imageUrl: profile.imageUrl,
                    width: width,
                    height: height,
                    fallbackLabel: profile.name,
                  ),
                  // Subtle solid bottom contrast veil so angled white text pops cleanly
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    height: height * 0.28,
                    child: ColoredBox(
                      color: Colors.black.withValues(alpha: 0.18),
                    ),
                  ),
                  // Angled "Name, Age" caption aligned to the 3D bottom perspective edge
                  Positioned(
                    left: 12,
                    right: 12,
                    bottom: slant * 0.62 + 16,
                    child: Transform.rotate(
                      angle: 0.19,
                      child: Text(
                        '$firstName, ${profile.age}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: fontSize.clamp(11.0, 22.0),
                          letterSpacing: -0.3,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// SECTION 1B: Concise Editorial Headline & App Store / Google Play Strip directly below the animated banner
  Widget _buildBelowBannerIntroStrip(BuildContext context, bool isDesktop) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 72 : 24,
        vertical: isDesktop ? 64 : 44,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1220),
          child: isDesktop
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 6,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: AviajTheme.loveRed,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: const Text(
                                  'aviaj',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              const Text(
                                'THE TRAVEL DATING & CO-PILOT APP',
                                style: TextStyle(
                                  color: AviajTheme.loveRed,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 12,
                                  letterSpacing: 1.0,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 18),
                          const Text(
                            'Meet your next co-pilot.\nTravel better, together.',
                            style: TextStyle(
                              color: AviajTheme.midnightNavy,
                              fontSize: 52,
                              fontWeight: FontWeight.w900,
                              height: 1.06,
                              letterSpacing: -1.5,
                            ),
                          ),
                          const SizedBox(height: 14),
                          const Text(
                            'Find vacation romance, a lifelong relationship partner, or a solo travel buddy before you board.',
                            style: TextStyle(
                              color: Color(0xFF5C4B51),
                              fontSize: 19,
                              fontWeight: FontWeight.w500,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 48),
                    Expanded(
                      flex: 5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const AppStoreDownloadBadges(lightOnDark: false),
                          const SizedBox(height: 16),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            alignment: WrapAlignment.end,
                            children: [
                              OutlinedButton.icon(
                                onPressed: () =>
                                    showMobileAppDownloadModal(context),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: AviajTheme.midnightNavy,
                                  side: const BorderSide(
                                    color: AviajTheme.midnightNavy,
                                    width: 1.5,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 18,
                                    vertical: 14,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                icon: const Icon(
                                  Icons.qr_code_2_rounded,
                                  size: 19,
                                ),
                                label: const Text(
                                  'Scan QR for iOS & Android',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                              FilledButton.icon(
                                onPressed: widget.onOpenFullMobilePreview,
                                style: FilledButton.styleFrom(
                                  backgroundColor: AviajTheme.loveRed,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 14,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                icon: const Icon(
                                  Icons.smartphone_rounded,
                                  size: 18,
                                ),
                                label: const Text(
                                  'Open Interactive App',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'aviaj',
                      style: TextStyle(
                        color: AviajTheme.loveRed,
                        fontWeight: FontWeight.w900,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Meet your next co-pilot.\nTravel better, together.',
                      style: TextStyle(
                        color: AviajTheme.midnightNavy,
                        fontSize: 38,
                        fontWeight: FontWeight.w900,
                        height: 1.08,
                        letterSpacing: -1.2,
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'Find vacation romance, a lifelong relationship partner, or a solo travel buddy before you board.',
                      style: TextStyle(
                        color: Color(0xFF5C4B51),
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const AppStoreDownloadBadges(lightOnDark: false),
                  ],
                ),
        ),
      ),
    );
  }

  /// SECTION 2: Three Core Travel Modes — Clean 3-Card Pillar Section with minimal copy
  Widget _buildThreeModesPillarSection(BuildContext context, bool isDesktop) {
    final pillars = [
      (
        badge: 'AVIAJ ROMANCE',
        title: 'Fall in love on the road.',
        subtitle: 'Spontaneous sunset dates or a lifelong travel partner.',
        bgColor: AviajTheme.sunsetTerracotta,
        ctaLabel: 'Explore Romance',
        imageUrl:
            'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?auto=format&fit=crop&w=800&q=80',
      ),
      (
        badge: 'AVIAJ CO-PILOT',
        title: 'Never pay the solo tax.',
        subtitle: 'Platonic travel buddies to split villas, 4x4s, and treks.',
        bgColor: AviajTheme.horizonTeal,
        ctaLabel: 'Find a Co-Pilot',
        imageUrl:
            'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=800&q=80',
      ),
      (
        badge: 'AVIAJ CREW',
        title: 'Join a 6-person crew.',
        subtitle: 'Curated small-group villas in Amalfi, Kyoto, and Bali.',
        bgColor: AviajTheme.midnightNavy,
        ctaLabel: 'Browse Crews',
        imageUrl:
            'https://images.unsplash.com/photo-1533105079780-92b9be482077?auto=format&fit=crop&w=800&q=80',
      ),
    ];

    return Container(
      width: double.infinity,
      color: AviajTheme.warmSand,
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 72 : 24,
        vertical: 92,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1220),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Three ways to share the horizon.',
                style: TextStyle(
                  color: AviajTheme.midnightNavy,
                  fontSize: 44,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1.2,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 12),
              // Subtle intent keyword tags for quick scanning
              Wrap(
                spacing: 10,
                runSpacing: 8,
                children: ConnectionIntent.values
                    .map(
                      (i) => Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: const Color(0xFFE2DAD0)),
                        ),
                        child: Text(
                          i.label,
                          style: const TextStyle(
                            color: AviajTheme.midnightNavy,
                            fontWeight: FontWeight.w800,
                            fontSize: 12.5,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 40),
              Wrap(
                spacing: 24,
                runSpacing: 24,
                children: pillars.map((p) {
                  return SizedBox(
                    width: isDesktop ? 384 : double.infinity,
                    child: Container(
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        color: p.bgColor,
                        borderRadius: BorderRadius.circular(36),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AviajNetworkImage(
                            imageUrl: p.imageUrl,
                            height: 250,
                            width: double.infinity,
                            fallbackLabel: p.badge,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(28),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  p.badge,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 11.5,
                                    letterSpacing: 1.0,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  p.title,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 28,
                                    fontWeight: FontWeight.w900,
                                    height: 1.15,
                                    letterSpacing: -0.5,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  p.subtitle,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 15,
                                    height: 1.4,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 22),
                                FilledButton(
                                  onPressed: () =>
                                      showMobileAppDownloadModal(context),
                                  style: FilledButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: AviajTheme.midnightNavy,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 14,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                  child: Text(
                                    p.ctaLabel,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w900,
                                      fontSize: 13.5,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// SECTIONS 3, 4, 5: Alternating 50/50 Editorial Split Sections with generous vertical rhythm
  Widget _buildEditorialSplitSection({
    required BuildContext context,
    required bool isDesktop,
    required bool imageFirst,
    required Color bgColor,
    required String pillLabel,
    required Color pillColor,
    required String headline,
    required String subtitle,
    required String ctaLabel,
    required VoidCallback onCtaTap,
    required String imageUrl,
    required String overlayBadgeTop,
    required String overlayBadgeBottom,
  }) {
    final imagePane = ClipRRect(
      borderRadius: BorderRadius.circular(36),
      child: Stack(
        children: [
          AviajNetworkImage(
            imageUrl: imageUrl,
            height: isDesktop ? 460 : 320,
            width: double.infinity,
            fallbackLabel: pillLabel,
          ),
          Positioned(
            top: 20,
            left: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
              decoration: BoxDecoration(
                color: AviajTheme.midnightNavy,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                overlayBadgeTop,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 12.5,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
              decoration: BoxDecoration(
                color: pillColor,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                overlayBadgeBottom,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 12.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );

    final copyPane = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: pillColor,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Text(
            pillLabel,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: 11,
              letterSpacing: 0.9,
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          headline,
          style: const TextStyle(
            color: AviajTheme.midnightNavy,
            fontSize: 46,
            fontWeight: FontWeight.w900,
            height: 1.08,
            letterSpacing: -1.3,
          ),
        ),
        const SizedBox(height: 18),
        Text(
          subtitle,
          style: const TextStyle(
            color: Color(0xFF475569),
            fontSize: 18.5,
            height: 1.45,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 28),
        FilledButton.icon(
          onPressed: onCtaTap,
          style: FilledButton.styleFrom(
            backgroundColor: AviajTheme.midnightNavy,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          icon: const Icon(Icons.arrow_forward_rounded, size: 18),
          label: Text(
            ctaLabel,
            style: const TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 14.5,
            ),
          ),
        ),
      ],
    );

    return Container(
      width: double.infinity,
      color: bgColor,
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 72 : 24,
        vertical: 92,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1220),
          child: isDesktop
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: imageFirst
                      ? [
                          Expanded(flex: 6, child: imagePane),
                          const SizedBox(width: 64),
                          Expanded(flex: 5, child: copyPane),
                        ]
                      : [
                          Expanded(flex: 5, child: copyPane),
                          const SizedBox(width: 64),
                          Expanded(flex: 6, child: imagePane),
                        ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    imagePane,
                    const SizedBox(height: 32),
                    copyPane,
                  ],
                ),
        ),
      ),
    );
  }

  /// SECTION 6: "The Horizon" — Real Co-Pilot Love & Travel Stories
  Widget _buildStoriesSection(BuildContext context, bool isDesktop) {
    final stories = [
      (
        route: 'KYOTO, JAPAN 🇯🇵',
        quote:
            '“Matched on Destination Radar 10 days before our flights. Engaged in Arashiyama.”',
        names: 'Elena & Aarav',
        imageUrl:
            'https://images.unsplash.com/photo-1516589178581-6cd7833ae3b2?auto=format&fit=crop&w=800&q=80',
      ),
      (
        route: 'AMALFI COAST, ITALY 🇮🇹',
        quote:
            '“Split a cliffside villa and a vintage boat in Positano with four solo travellers.”',
        names: 'Liam & Sofia',
        imageUrl:
            'https://images.unsplash.com/photo-1522673607200-164d1b6ce486?auto=format&fit=crop&w=800&q=80',
      ),
      (
        route: 'ULUWATU, BALI 🇮🇩',
        quote:
            '“Turned a solo surf layover into a two-week island romance and our next 3 trips.”',
        names: 'Maya & Noah',
        imageUrl:
            'https://images.unsplash.com/photo-1518199266791-5375a83190b7?auto=format&fit=crop&w=800&q=80',
      ),
    ];

    return Container(
      width: double.infinity,
      color: AviajTheme.midnightNavy,
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 72 : 24,
        vertical: 92,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1220),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: AviajTheme.compassAmber,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Text(
                  'THE HORIZON • REAL STORIES',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 11,
                    letterSpacing: 0.9,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Stories from the Departure Lounge.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 44,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1.2,
                ),
              ),
              const SizedBox(height: 40),
              Wrap(
                spacing: 24,
                runSpacing: 24,
                children: stories.map((s) {
                  return SizedBox(
                    width: isDesktop ? 384 : double.infinity,
                    child: Container(
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E293B),
                        borderRadius: BorderRadius.circular(32),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AviajNetworkImage(
                            imageUrl: s.imageUrl,
                            height: 230,
                            width: double.infinity,
                            fallbackLabel: s.names,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(26),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  s.route,
                                  style: const TextStyle(
                                    color: AviajTheme.compassAmber,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 11.5,
                                    letterSpacing: 0.8,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  s.quote,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 19,
                                    fontWeight: FontWeight.w800,
                                    height: 1.3,
                                  ),
                                ),
                                const SizedBox(height: 14),
                                Text(
                                  '— ${s.names}',
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// SECTION 7: Minimal Cabin Class Upgrades (`acct_1TNTVyJD1U0jWVOT`)
  Widget _buildMinimalCabinUpgradesSection(
    BuildContext context,
    bool isDesktop,
  ) {
    return Container(
      width: double.infinity,
      color: AviajTheme.warmSand,
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 72 : 24,
        vertical: 92,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1220),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 12,
                runSpacing: 8,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(
                      color: AviajTheme.loveRed,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'STRIPE CHECKOUT • acct_1TNTVyJD1U0jWVOT',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 11,
                      ),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () => showAdMobUnityConsoleModal(context),
                    icon: const Icon(
                      Icons.monetization_on_rounded,
                      size: 16,
                      color: AviajTheme.horizonTeal,
                    ),
                    label: const Text(
                      'Or earn free passes via AdMob & Unity Ads',
                      style: TextStyle(
                        color: AviajTheme.horizonTeal,
                        fontWeight: FontWeight.w800,
                        fontSize: 12.5,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              const Text(
                'Upgrade your cabin class.',
                style: TextStyle(
                  color: AviajTheme.midnightNavy,
                  fontSize: 44,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1.2,
                ),
              ),
              const SizedBox(height: 36),
              Wrap(
                spacing: 24,
                runSpacing: 24,
                children: AviajStripeService.plans.map((plan) {
                  return SizedBox(
                    width: isDesktop ? 384 : double.infinity,
                    child: Container(
                      padding: const EdgeInsets.all(28),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(32),
                        border: Border.all(color: plan.badgeColor, width: 2),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: plan.badgeColor,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              plan.subtitle,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                fontSize: 11,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            plan.name,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              color: AviajTheme.midnightNavy,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            plan.interval == 'month'
                                ? '\$${plan.amountUsd.toStringAsFixed(2)} / mo'
                                : '\$${plan.amountUsd.toStringAsFixed(2)} pack',
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w900,
                              color: AviajTheme.sunsetTerracotta,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ...plan.perks.take(3).map(
                                (p) => Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.check_circle_rounded,
                                        color: AviajTheme.solidEmerald,
                                        size: 16,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          p,
                                          style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w700,
                                            color: AviajTheme.midnightNavy,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            child: FilledButton(
                              onPressed: () => showStripeStorefrontModal(
                                context,
                                customTripPlan: plan,
                              ),
                              style: FilledButton.styleFrom(
                                backgroundColor: AviajTheme.loveRed,
                                foregroundColor: Colors.white,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                              ),
                              child: const Text(
                                'Upgrade with Stripe',
                                style: TextStyle(fontWeight: FontWeight.w900),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// SECTION 8: Full-Width Sunset Terracotta Conversion Banner + Multi-Column Sitemap Footer
  Widget _buildConversionBannerAndFooter(
    BuildContext context,
    bool isDesktop,
  ) {
    return Column(
      children: [
        // Full-Width Conversion Banner
        Container(
          width: double.infinity,
          color: AviajTheme.sunsetTerracotta,
          padding: EdgeInsets.symmetric(
            horizontal: isDesktop ? 72 : 24,
            vertical: 84,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1220),
              child: Wrap(
                spacing: 40,
                runSpacing: 28,
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 640),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Your next horizon is boarding now.',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 48,
                            fontWeight: FontWeight.w900,
                            height: 1.08,
                            letterSpacing: -1.3,
                          ),
                        ),
                        SizedBox(height: 12),
                        Text(
                          'Download the Aviaj mobile app on iOS and Android.',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const AppStoreDownloadBadges(lightOnDark: true),
                ],
              ),
            ),
          ),
        ),
        // Editorial Multi-Column Sitemap Footer
        Container(
          width: double.infinity,
          color: AviajTheme.midnightNavy,
          padding: EdgeInsets.symmetric(
            horizontal: isDesktop ? 72 : 24,
            vertical: 64,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1220),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 64,
                    runSpacing: 32,
                    children: [
                      const SizedBox(
                        width: 260,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'aviaj',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 34,
                                fontWeight: FontWeight.w900,
                                letterSpacing: -1.0,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Travel Romance, Solo Co-Pilots & Curated Group Departures.',
                              style: TextStyle(
                                color: Colors.white60,
                                fontSize: 13.5,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                      _FooterColumn(
                        title: 'TRAVEL MODES',
                        items: const [
                          'Aviaj Romance',
                          'Aviaj Co-Pilot',
                          'Aviaj Crew Villas',
                          'Destination Radar',
                        ],
                        onTap: () => _scrollToSection(_modesKey),
                      ),
                      _FooterColumn(
                        title: 'TOP HORIZONS',
                        items: const [
                          'Kyoto & Tokyo',
                          'Amalfi & Capri',
                          'Uluwatu, Bali',
                          'Patagonia & Andes',
                        ],
                        onTap: widget.onOpenFullMobilePreview,
                      ),
                      _FooterColumn(
                        title: 'TRUST & CABIN',
                        items: const [
                          'Passport Verification',
                          'Business Class™',
                          'First Class™ VIP',
                          'Mobile App Demo',
                        ],
                        onTap: () => _scrollToSection(_pricingKey),
                      ),
                    ],
                  ),
                  const Divider(height: 48, color: Colors.white12),
                  Wrap(
                    spacing: 20,
                    runSpacing: 10,
                    alignment: WrapAlignment.spaceBetween,
                    children: [
                      const Text(
                        '© 2026 Aviaj Inc. All rights reserved.',
                        style: TextStyle(color: Colors.white54, fontSize: 12.5),
                      ),
                      Text(
                        'Stripe (${AviajStripeService.defaultStripeAccountId}) • Google AdMob • Unity Ads',
                        style: const TextStyle(
                          color: AviajTheme.compassAmber,
                          fontWeight: FontWeight.w800,
                          fontSize: 12.5,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _NavbarLink extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _NavbarLink({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: TextButton(
        onPressed: onTap,
        child: Text(
          label,
          style: const TextStyle(
            color: AviajTheme.midnightNavy,
            fontWeight: FontWeight.w800,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

class _FooterColumn extends StatelessWidget {
  final String title;
  final List<String> items;
  final VoidCallback onTap;

  const _FooterColumn({
    required this.title,
    required this.items,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 170,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AviajTheme.compassAmber,
              fontWeight: FontWeight.w900,
              fontSize: 11.5,
              letterSpacing: 0.9,
            ),
          ),
          const SizedBox(height: 12),
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: InkWell(
                onTap: onTap,
                child: Text(
                  item,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontWeight: FontWeight.w600,
                    fontSize: 13.5,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Custom 3D perspective trapezoid clipper with smooth rounded corners.
/// Top edge slopes UP from left `(0, slant)` to right `(width, 0)`.
/// Bottom edge slopes DOWN from left `(0, height - slant)` to right `(width, height)`.
class _PerspectiveSlabClipper extends CustomClipper<Path> {
  final double slant;
  final double radius;

  const _PerspectiveSlabClipper({
    required this.slant,
    required this.radius,
  });

  @override
  Path getClip(Size size) {
    final w = size.width;
    final h = size.height;
    final s = slant.clamp(0.0, h * 0.28);
    final r = math.min(radius, math.min(w, h) * 0.16);

    final points = <Offset>[
      Offset(0, s), // Top-left
      Offset(w, 0), // Top-right
      Offset(w, h), // Bottom-right
      Offset(0, h - s), // Bottom-left
    ];

    final path = Path();
    for (int i = 0; i < points.length; i++) {
      final prev = points[(i - 1 + points.length) % points.length];
      final curr = points[i];
      final next = points[(i + 1) % points.length];

      final vIn = prev - curr;
      final vOut = next - curr;
      final lenIn = vIn.distance;
      final lenOut = vOut.distance;

      if (lenIn == 0 || lenOut == 0) continue;

      final pStart = curr + (vIn / lenIn) * r;
      final pEnd = curr + (vOut / lenOut) * r;

      if (i == 0) {
        path.moveTo(pStart.dx, pStart.dy);
      } else {
        path.lineTo(pStart.dx, pStart.dy);
      }
      path.quadraticBezierTo(curr.dx, curr.dy, pEnd.dx, pEnd.dy);
    }
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant _PerspectiveSlabClipper oldClipper) {
    return oldClipper.slant != slant || oldClipper.radius != radius;
  }
}
