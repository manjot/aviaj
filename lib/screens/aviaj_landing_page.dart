import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' show lerpDouble;
import 'package:flutter/material.dart';
import '../data/regional_data.dart';
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

  void _selectRegion(AviajRegion region) {
    setState(() {
      _selectedHeroIndex = 0;
    });
    widget.state.setRegion(region);
    _replayBannerAnimation();
  }

  Widget _buildRegionSelectorPill({
    required bool isDarkPill,
    required bool showFullLanguageLabel,
  }) {
    final activeRegion = widget.state.activeRegion;
    return PopupMenuButton<AviajRegion>(
      tooltip: 'Switch Location / Region Imagery',
      onSelected: _selectRegion,
      offset: const Offset(0, 48),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      color: Colors.white,
      itemBuilder: (context) => AviajRegion.values.map((region) {
        final isSelected = region == activeRegion;
        return PopupMenuItem<AviajRegion>(
          value: region,
          child: Row(
            children: [
              Text(
                region.flag,
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  '${region.label} (${region.code})',
                  style: TextStyle(
                    color: AviajTheme.midnightNavy,
                    fontWeight: isSelected ? FontWeight.w900 : FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
              if (isSelected)
                const Icon(
                  Icons.check_circle_rounded,
                  color: AviajTheme.loveRed,
                  size: 18,
                ),
            ],
          ),
        );
      }).toList(),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: isDarkPill ? const Color(0xFF220207) : Colors.white,
          borderRadius: BorderRadius.circular(40),
          border: isDarkPill
              ? Border.all(color: Colors.white24, width: 1)
              : Border.all(color: AviajTheme.midnightNavy.withValues(alpha: 0.22), width: 1.2),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.language_rounded,
              color: isDarkPill ? Colors.white : AviajTheme.midnightNavy,
              size: 18,
            ),
            const SizedBox(width: 6),
            Text(
              '${activeRegion.flag} ${showFullLanguageLabel ? activeRegion.languageLabel : activeRegion.label}',
              style: TextStyle(
                color: isDarkPill ? Colors.white : AviajTheme.midnightNavy,
                fontWeight: FontWeight.w800,
                fontSize: 13,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              color: isDarkPill ? Colors.white : AviajTheme.midnightNavy,
              size: 19,
            ),
          ],
        ),
      ),
    );
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

            // SECTION 2: MISSION HEADLINE + 3 STEPPED CARDS WITH VERTICAL PILLS
            _buildBelowBannerIntroStrip(context, isDesktop),

            // SECTION 3: LIFESTYLE PHOTO + CIRCULAR STAMP EMBLEM + "SHARE YOUR NEXT ITINERARY"
            Container(
              key: _radarKey,
              child: _buildDepartureCircleSection(context, isDesktop),
            ),

            // SECTION 4: TWO SIDE-BY-SIDE SOLID RED LOVE SHOWCASE CARDS (AVIAJ ROMANCE & CO-PILOT)
            Container(
              key: _modesKey,
              child: _buildThreeModesPillarSection(context, isDesktop),
            ),

            // SECTION 5: EDITORIAL QUOTE TESTIMONIAL + MONOCHROME COUPLE PORTRAIT
            Container(
              key: _storiesKey,
              child: _buildStoriesSection(context, isDesktop),
            ),

            // SECTION 6: "GET THE APP" QR CODE + 3 FANNED IPHONE MOCKUPS BANNER
            _buildGetTheAppQrPhonesBanner(context, isDesktop),

            // SECTION 7: MINIMAL CABIN CLASS UPGRADES (STRIPE acct_1TNTVyJD1U0jWVOT)
            Container(
              key: _pricingKey,
              child: _buildMinimalCabinUpgradesSection(context, isDesktop),
            ),

            // SECTION 8: MULTI-COLUMN SITEMAP FOOTER
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
                      _buildRegionSelectorPill(
                        isDarkPill: false,
                        showFullLanguageLabel: false,
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
                        ? (screenWidth * 0.25).clamp(210.0, 355.0)
                        : (screenWidth * 0.26).clamp(92.0, 145.0);
                    const brandSegments = ['Av', 'i', 'aj'];

                    return Stack(
                      alignment: Alignment.center,
                      clipBehavior: Clip.hardEdge,
                      children: [
                        // STEP 1: GIANT EDGE-TO-EDGE "Aviaj" WORDMARK ANIMATION
                        Positioned(
                          left: isDesktop ? 36 : 12,
                          right: isDesktop ? 36 : 12,
                          bottom: isDesktop ? 62 : 70,
                          child: IgnorePointer(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: List.generate(
                                brandSegments.length,
                                (index) {
                                  final start = (index * 0.11).clamp(0.0, 0.4);
                                  final end =
                                      (0.48 + index * 0.11).clamp(0.0, 1.0);
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
                                          brandSegments[index],
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: giantFontSize,
                                            fontWeight: FontWeight.w900,
                                            height: 0.88,
                                            letterSpacing: -10,
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
                          shadows: const [
                            Shadow(
                              color: Colors.black54,
                              blurRadius: 12,
                              offset: Offset(0, 2),
                            ),
                          ],
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

  /// SECTION 2 (Screenshot 2): Mission Headline on Left + 3 Stepped Portrait Cards with Vertical Rotated Pill Badges on Right
  Widget _buildBelowBannerIntroStrip(BuildContext context, bool isDesktop) {
    final copyColumn = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Meet your next co-pilot.\nBring every journey\ncloser to love.',
          style: TextStyle(
            color: AviajTheme.midnightNavy,
            fontSize: 54,
            fontWeight: FontWeight.w900,
            height: 1.04,
            letterSpacing: -1.6,
          ),
        ),
        const SizedBox(height: 22),
        const Text(
          'We want our travellers to find meaningful vacation romance, lifelong relationship partners, and travel buddies that ignite confidence and joy.',
          style: TextStyle(
            color: Color(0xFF3E3035),
            fontSize: 18,
            fontWeight: FontWeight.w500,
            height: 1.45,
          ),
        ),
        const SizedBox(height: 28),
        Wrap(
          spacing: 14,
          runSpacing: 14,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            FilledButton(
              onPressed: () => showMobileAppDownloadModal(context),
              style: FilledButton.styleFrom(
                backgroundColor: AviajTheme.midnightNavy,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 18,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
              ),
              child: const Text(
                'Download Aviaj',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                ),
              ),
            ),
            OutlinedButton.icon(
              onPressed: widget.onOpenFullMobilePreview,
              style: OutlinedButton.styleFrom(
                foregroundColor: AviajTheme.loveRed,
                side: const BorderSide(color: AviajTheme.loveRed, width: 1.8),
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 17,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
              ),
              icon: const Icon(Icons.smartphone_rounded, size: 18),
              label: const Text(
                'Open App Demo',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 14.5,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        const AppStoreDownloadBadges(lightOnDark: false),
      ],
    );

    final pack = widget.state.regionalPack;
    final steppedCardsPane = SizedBox(
      width: isDesktop ? 550 : 350,
      height: isDesktop ? 450 : 340,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Back Card (Rightmost, smallest)
          Positioned(
            right: 0,
            top: isDesktop ? 76 : 54,
            width: isDesktop ? 195 : 130,
            height: isDesktop ? 295 : 210,
            child: _buildVerticalPillSteppedCard(
              imageUrl: pack.steppedCards[2].imageUrl,
              verticalTag: pack.steppedCards[2].tag,
              tagFontSize: isDesktop ? 14 : 11,
            ),
          ),
          // Middle Card (Center-right, medium)
          Positioned(
            left: isDesktop ? 196 : 118,
            top: isDesktop ? 40 : 28,
            width: isDesktop ? 235 : 155,
            height: isDesktop ? 365 : 260,
            child: _buildVerticalPillSteppedCard(
              imageUrl: pack.steppedCards[1].imageUrl,
              verticalTag: pack.steppedCards[1].tag,
              tagFontSize: isDesktop ? 17 : 13,
            ),
          ),
          // Front Card (Leftmost, largest)
          Positioned(
            left: 0,
            top: 0,
            width: isDesktop ? 305 : 205,
            height: isDesktop ? 440 : 320,
            child: _buildVerticalPillSteppedCard(
              imageUrl: pack.steppedCards[0].imageUrl,
              verticalTag: pack.steppedCards[0].tag,
              tagFontSize: isDesktop ? 22 : 16,
            ),
          ),
        ],
      ),
    );

    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 72 : 24,
        vertical: isDesktop ? 88 : 52,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1220),
          child: isDesktop
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(flex: 5, child: copyColumn),
                    const SizedBox(width: 48),
                    Expanded(
                      flex: 6,
                      child: Center(child: steppedCardsPane),
                    ),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    copyColumn,
                    const SizedBox(height: 36),
                    Center(child: steppedCardsPane),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildVerticalPillSteppedCard({
    required String imageUrl,
    required String verticalTag,
    required double tagFontSize,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Stack(
        fit: StackFit.expand,
        children: [
          AviajNetworkImage(
            imageUrl: imageUrl,
            width: double.infinity,
            height: double.infinity,
            fallbackLabel: verticalTag,
          ),
          Positioned(
            top: 16,
            right: 14,
            child: RotatedBox(
              quarterTurns: 1,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AviajTheme.loveRed,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  verticalTag,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: tagFontSize,
                    letterSpacing: -0.3,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// SECTION 3 (Screenshot 3): Large Rounded Photo + Circular Stamp Badge at Bottom-Left + "Share your next itinerary"
  Widget _buildDepartureCircleSection(BuildContext context, bool isDesktop) {
    final pack = widget.state.regionalPack;
    final photoWithStamp = ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: SizedBox(
        height: isDesktop ? 485 : 340,
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            AviajNetworkImage(
              imageUrl: pack.departureCirclePhotoUrl,
              width: double.infinity,
              height: double.infinity,
              fallbackLabel: 'Departure Lounge Circle',
            ),
            // Circular Member/Departure Lounge Stamp Emblem at Bottom-Left
            Positioned(
              left: 24,
              bottom: 24,
              child: Container(
                width: isDesktop ? 152 : 120,
                height: isDesktop ? 152 : 120,
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AviajTheme.loveRed,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AviajTheme.midnightNavy,
                    width: 3,
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'DEPARTURE CIRCLE',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                fontSize: 8.5,
                                letterSpacing: 1.1,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Container(
                              width: isDesktop ? 56 : 42,
                              height: isDesktop ? 56 : 42,
                              decoration: const BoxDecoration(
                                color: AviajTheme.midnightNavy,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.flight_takeoff_rounded,
                                color: Colors.white,
                                size: 26,
                              ),
                            ),
                            const SizedBox(height: 5),
                            const Text(
                              '• AVIAJ CLUB •',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                fontSize: 8.5,
                                letterSpacing: 1.1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    final rightCopy = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Share your next itinerary',
          style: TextStyle(
            color: AviajTheme.midnightNavy,
            fontSize: 52,
            fontWeight: FontWeight.w900,
            height: 1.06,
            letterSpacing: -1.5,
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'Help shape your next adventure by joining the Aviaj Departure Circle. This verified community of solo travellers shares live flight routes, destination pins, and first-night plans directly before boarding.',
          style: TextStyle(
            color: Color(0xFF3E3035),
            fontSize: 17.5,
            fontWeight: FontWeight.w500,
            height: 1.48,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Members get early access to Destination Radar™ matches, sneak peeks at curated 6-person villa crews in ${pack.region.sampleDestinations}, and Boarding Date Invites.',
          style: const TextStyle(
            color: Color(0xFF3E3035),
            fontSize: 17.5,
            fontWeight: FontWeight.w500,
            height: 1.48,
          ),
        ),
        const SizedBox(height: 28),
        FilledButton(
          onPressed: () => showMobileAppDownloadModal(context),
          style: FilledButton.styleFrom(
            backgroundColor: AviajTheme.midnightNavy,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(
              horizontal: 34,
              vertical: 18,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40),
            ),
          ),
          child: const Text(
            'Sign up',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 15,
            ),
          ),
        ),
      ],
    );

    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 72 : 24,
        vertical: isDesktop ? 72 : 48,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1220),
          child: isDesktop
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(flex: 6, child: photoWithStamp),
                    const SizedBox(width: 64),
                    Expanded(flex: 5, child: rightCopy),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    photoWithStamp,
                    const SizedBox(height: 32),
                    rightCopy,
                  ],
                ),
        ),
      ),
    );
  }

  /// SECTION 4 (Screenshot 4): Two Side-by-Side Solid Red Love Showcase Cards (`Aviaj Romance` & `Aviaj Co-Pilot`)
  /// with White Inner Stage & Phone Mockups
  Widget _buildThreeModesPillarSection(BuildContext context, bool isDesktop) {
    final pack = widget.state.regionalPack;
    final romanceCard = Container(
      padding: const EdgeInsets.all(26),
      decoration: BoxDecoration(
        color: AviajTheme.loveRed,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // White Inner Stage with Row of Verified Portraits + Center iPhone Mockup
          Container(
            height: 295,
            width: double.infinity,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Background row of 4 verified traveller portraits
                Positioned(
                  left: -10,
                  right: -10,
                  top: 48,
                  height: 195,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildMiniVerifiedPortrait(
                        pack.romanceVerifiedPortraitUrls[0],
                      ),
                      _buildMiniVerifiedPortrait(
                        pack.romanceVerifiedPortraitUrls[1],
                      ),
                      const SizedBox(width: 140),
                      _buildMiniVerifiedPortrait(
                        pack.romanceVerifiedPortraitUrls[2],
                      ),
                      _buildMiniVerifiedPortrait(
                        pack.romanceVerifiedPortraitUrls[3],
                      ),
                    ],
                  ),
                ),
                // Center iPhone Mockup rising from bottom
                Positioned(
                  top: 22,
                  bottom: -16,
                  width: 175,
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(8, 10, 8, 0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(26),
                      border: Border.all(
                        color: AviajTheme.midnightNavy,
                        width: 2.5,
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Aviaj',
                              style: TextStyle(
                                color: AviajTheme.midnightNavy,
                                fontWeight: FontWeight.w900,
                                fontSize: 13,
                              ),
                            ),
                            Icon(
                              Icons.tune_rounded,
                              size: 14,
                              color: Colors.grey.shade700,
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Expanded(
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(16),
                            ),
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                AviajNetworkImage(
                                  imageUrl: pack.romancePhoneImageUrl,
                                  width: double.infinity,
                                  height: double.infinity,
                                  fallbackLabel: pack.romancePhoneLabel,
                                ),
                                Positioned(
                                  left: 10,
                                  bottom: 20,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        pack.romancePhoneLabel,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w900,
                                          fontSize: 14,
                                        ),
                                      ),
                                      const SizedBox(height: 3),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 7,
                                          vertical: 3,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AviajTheme.loveRed,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: const Text(
                                          '✓ ID verified',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w800,
                                            fontSize: 9,
                                          ),
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
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Aviaj Romance',
            style: TextStyle(
              color: Colors.white,
              fontSize: 34,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.9,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Whether you’re seeking a spontaneous vacation romance or ready to meet a lifelong travel partner, Aviaj Romance is built to bring you closer to love safely and meaningfully.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.5,
              fontWeight: FontWeight.w500,
              height: 1.44,
            ),
          ),
          const SizedBox(height: 20),
          InkWell(
            onTap: widget.onOpenFullMobilePreview,
            child: const Text(
              'Find your person',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 15.5,
                decoration: TextDecoration.underline,
                decorationColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );

    final coPilotCard = Container(
      padding: const EdgeInsets.all(26),
      decoration: BoxDecoration(
        color: AviajTheme.loveRed,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // White Inner Stage with Tilted Crew Card + Floating Pills on Left & Phone Mockup on Right
          Container(
            height: 295,
            width: double.infinity,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Stack(
              children: [
                // Tilted Crew Photo + Floating Pills on Left
                Positioned(
                  left: 34,
                  top: 32,
                  width: 175,
                  height: 225,
                  child: Transform.rotate(
                    angle: -0.05,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: AviajNetworkImage(
                        imageUrl: pack.coPilotCrewImageUrl,
                        width: 175,
                        height: 225,
                        fallbackLabel: 'Island Crew',
                      ),
                    ),
                  ),
                ),
                // Floating Pill Tags ("Villa crew", "Route chat", "Departures")
                Positioned(
                  left: 16,
                  top: 118,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AviajTheme.warmSand,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'Villa crew',
                          style: TextStyle(
                            color: AviajTheme.loveRed,
                            fontWeight: FontWeight.w900,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Text(
                          '● Route chat',
                          style: TextStyle(
                            color: AviajTheme.midnightNavy,
                            fontWeight: FontWeight.w800,
                            fontSize: 11,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Text(
                          '🗓️ Departures',
                          style: TextStyle(
                            color: AviajTheme.midnightNavy,
                            fontWeight: FontWeight.w800,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Emblem Badge at Bottom-Center of Crew Card
                Positioned(
                  left: 158,
                  bottom: 34,
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: AviajTheme.loveRed,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.groups_rounded,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                ),
                // Right iPhone Mockup
                Positioned(
                  right: 26,
                  top: 22,
                  bottom: -16,
                  width: 170,
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(8, 10, 8, 0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(26),
                      border: Border.all(
                        color: AviajTheme.midnightNavy,
                        width: 2.5,
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          pack.region.coPilotLocationHeader,
                          style: const TextStyle(
                            color: AviajTheme.midnightNavy,
                            fontWeight: FontWeight.w800,
                            fontSize: 10,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Expanded(
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(16),
                            ),
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                AviajNetworkImage(
                                  imageUrl: pack.coPilotPhoneImageUrl,
                                  width: double.infinity,
                                  height: double.infinity,
                                  fallbackLabel: pack.coPilotPhoneLabel,
                                ),
                                Positioned(
                                  left: 10,
                                  top: 12,
                                  child: Text(
                                    pack.coPilotPhoneLabel,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w900,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  right: 10,
                                  bottom: 22,
                                  child: Container(
                                    width: 32,
                                    height: 32,
                                    decoration: const BoxDecoration(
                                      color: AviajTheme.loveRed,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.waving_hand_rounded,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Aviaj Co-Pilot',
            style: TextStyle(
              color: Colors.white,
              fontSize: 34,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.9,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Whether you’ve landed in a new city solo or want to split a villa with a 6-person crew, Co-Pilot makes it easy to meet like-minded travellers who match your vibe.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.5,
              fontWeight: FontWeight.w500,
              height: 1.44,
            ),
          ),
          const SizedBox(height: 20),
          InkWell(
            onTap: widget.onOpenFullMobilePreview,
            child: const Text(
              'Find your people',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 15.5,
                decoration: TextDecoration.underline,
                decorationColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );

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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: romanceCard),
                    const SizedBox(width: 28),
                    Expanded(child: coPilotCard),
                  ],
                )
              : Column(
                  children: [
                    romanceCard,
                    const SizedBox(height: 24),
                    coPilotCard,
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildMiniVerifiedPortrait(String imageUrl) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: SizedBox(
        width: 84,
        height: 185,
        child: Stack(
          fit: StackFit.expand,
          children: [
            AviajNetworkImage(
              imageUrl: imageUrl,
              width: 84,
              height: 185,
              fallbackLabel: 'Verified',
            ),
            Positioned(
              left: 6,
              bottom: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AviajTheme.loveRed,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  '✓ ID verified',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 8,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// SECTION 5 (Screenshot 5): Editorial Quotation Testimonial on Left + Monochrome Couple Portrait on Right
  Widget _buildStoriesSection(BuildContext context, bool isDesktop) {
    final pack = widget.state.regionalPack;
    final quoteColumn = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '""',
          style: TextStyle(
            color: AviajTheme.midnightNavy,
            fontSize: 48,
            fontWeight: FontWeight.w900,
            height: 0.9,
            letterSpacing: -2,
          ),
        ),
        const SizedBox(height: 18),
        Text(
          pack.storyQuote,
          style: const TextStyle(
            color: AviajTheme.midnightNavy,
            fontSize: 42,
            fontWeight: FontWeight.w900,
            height: 1.12,
            letterSpacing: -1.3,
          ),
        ),
        const SizedBox(height: 22),
        Text(
          pack.storyAttribution,
          style: const TextStyle(
            color: Color(0xFF4A3B40),
            fontSize: 16.5,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 28),
        FilledButton(
          onPressed: widget.onOpenFullMobilePreview,
          style: FilledButton.styleFrom(
            backgroundColor: AviajTheme.midnightNavy,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(
              horizontal: 28,
              vertical: 18,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40),
            ),
          ),
          child: const Text(
            'Read more stories',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 15,
            ),
          ),
        ),
      ],
    );

    final monochromePortrait = ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: ColorFiltered(
        colorFilter: const ColorFilter.matrix(<double>[
          0.2126, 0.7152, 0.0722, 0, 0, //
          0.2126, 0.7152, 0.0722, 0, 0, //
          0.2126, 0.7152, 0.0722, 0, 0, //
          0, 0, 0, 1, 0, //
        ]),
        child: AviajNetworkImage(
          imageUrl: pack.storyCoupleImageUrl,
          height: isDesktop ? 490 : 350,
          width: double.infinity,
          fallbackLabel: pack.storyAttribution,
        ),
      ),
    );

    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 72 : 24,
        vertical: isDesktop ? 76 : 48,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1220),
          child: isDesktop
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(flex: 6, child: quoteColumn),
                    const SizedBox(width: 64),
                    Expanded(flex: 5, child: monochromePortrait),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    quoteColumn,
                    const SizedBox(height: 32),
                    monochromePortrait,
                  ],
                ),
        ),
      ),
    );
  }

  /// SECTION 6 (Screenshot 6): Rounded "Get the app" Banner with QR Code Card on Left & 3 Fanned iPhones on Right
  Widget _buildGetTheAppQrPhonesBanner(BuildContext context, bool isDesktop) {
    final leftQrPane = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Get the app',
          style: TextStyle(
            color: Colors.white,
            fontSize: 54,
            fontWeight: FontWeight.w900,
            letterSpacing: -1.5,
            height: 1.05,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'Just scan the QR code to get started.',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 28),
        InkWell(
          onTap: () => showMobileAppDownloadModal(context),
          borderRadius: BorderRadius.circular(20),
          child: Container(
            width: 182,
            height: 182,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                const Icon(
                  Icons.qr_code_2_rounded,
                  size: 154,
                  color: AviajTheme.midnightNavy,
                ),
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.favorite_rounded,
                    color: AviajTheme.loveRed,
                    size: 22,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );

    final pack = widget.state.regionalPack;
    final rightFannedPhones = SizedBox(
      width: isDesktop ? 560 : 340,
      height: isDesktop ? 420 : 320,
      child: Stack(
        alignment: Alignment.bottomCenter,
        clipBehavior: Clip.none,
        children: [
          // Left Tilted Phone
          Positioned(
            left: isDesktop ? 36 : 8,
            bottom: -36,
            width: isDesktop ? 210 : 145,
            height: isDesktop ? 340 : 240,
            child: Transform.rotate(
              angle: -0.09,
              child: _buildMockupPhoneFrame(
                imageUrl: pack.fannedPhoneImageUrls[0],
                headerTitle: '9:41',
                showBrandHeader: false,
              ),
            ),
          ),
          // Right Tilted Phone
          Positioned(
            right: isDesktop ? 36 : 8,
            bottom: -36,
            width: isDesktop ? 210 : 145,
            height: isDesktop ? 340 : 240,
            child: Transform.rotate(
              angle: 0.09,
              child: _buildMockupPhoneFrame(
                imageUrl: pack.fannedPhoneImageUrls[2],
                headerTitle: '9:41',
                showBrandHeader: false,
              ),
            ),
          ),
          // Center Upright Phone
          Positioned(
            bottom: -24,
            width: isDesktop ? 255 : 185,
            height: isDesktop ? 405 : 295,
            child: _buildMockupPhoneFrame(
              imageUrl: pack.fannedPhoneImageUrls[1],
              headerTitle: 'Aviaj',
              showBrandHeader: true,
            ),
          ),
        ],
      ),
    );

    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 72 : 24,
        vertical: isDesktop ? 36 : 24,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1220),
          child: Container(
            width: double.infinity,
            clipBehavior: Clip.hardEdge,
            padding: EdgeInsets.fromLTRB(
              isDesktop ? 56 : 24,
              isDesktop ? 48 : 36,
              isDesktop ? 40 : 24,
              0,
            ),
            decoration: BoxDecoration(
              color: AviajTheme.loveRed,
              borderRadius: BorderRadius.circular(32),
            ),
            child: isDesktop
                ? SizedBox(
                    height: 420,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 5,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 48),
                            child: leftQrPane,
                          ),
                        ),
                        Expanded(
                          flex: 6,
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: rightFannedPhones,
                          ),
                        ),
                      ],
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      leftQrPane,
                      const SizedBox(height: 28),
                      Center(child: rightFannedPhones),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildMockupPhoneFrame({
    required String imageUrl,
    required String headerTitle,
    required bool showBrandHeader,
  }) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 12, 10, 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(34),
        border: Border.all(
          color: AviajTheme.midnightNavy,
          width: 5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '9:41',
                style: TextStyle(
                  color: AviajTheme.midnightNavy,
                  fontWeight: FontWeight.w800,
                  fontSize: 11,
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(
                    Icons.signal_cellular_alt_rounded,
                    size: 12,
                    color: AviajTheme.midnightNavy,
                  ),
                  SizedBox(width: 3),
                  Icon(
                    Icons.wifi_rounded,
                    size: 12,
                    color: AviajTheme.midnightNavy,
                  ),
                  SizedBox(width: 3),
                  Icon(
                    Icons.battery_full_rounded,
                    size: 12,
                    color: AviajTheme.midnightNavy,
                  ),
                ],
              ),
            ],
          ),
          if (showBrandHeader) ...[
            const SizedBox(height: 6),
            Text(
              headerTitle,
              style: const TextStyle(
                color: AviajTheme.midnightNavy,
                fontWeight: FontWeight.w900,
                fontSize: 18,
                letterSpacing: -0.6,
              ),
            ),
          ],
          const SizedBox(height: 8),
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
              child: AviajNetworkImage(
                imageUrl: imageUrl,
                width: double.infinity,
                height: double.infinity,
                fallbackLabel: headerTitle,
              ),
            ),
          ),
        ],
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

  /// SECTION 8: Two-Tier Editorial Footer:
  ///   1) Upper White Footer (`Aviaj` wordmark + rounded solid Red Love QR card on left, 3 link columns + social icons + region selector pill on right)
  ///   2) Lower Deep Dark Crimson (`#3B040C`) Footer (Multi-column links + region pill + Colossal Full-Bleed Bright Red `AVIAJ` wordmark spanning 100% width)
  Widget _buildConversionBannerAndFooter(
    BuildContext context,
    bool isDesktop,
  ) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Column(
      children: [
        // TIER 1: UPPER WHITE EDITORIAL FOOTER (Reference Screenshot 1: Giant Wordmark + QR Box Left, 3 Link Columns + Social + Region Pill Right)
        Container(
          width: double.infinity,
          color: Colors.white,
          padding: EdgeInsets.symmetric(
            horizontal: isDesktop ? 72 : 24,
            vertical: isDesktop ? 76 : 48,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1220),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  isDesktop
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Left Column: Giant "Aviaj" Wordmark + Solid Red Love QR Code Box
                            Expanded(
                              flex: 5,
                              child: _buildUpperFooterLeftBrandQr(context),
                            ),
                            const SizedBox(width: 48),
                            // Right Column: 3 Sitemap Link Columns ("Our apps", "Company", "Legal")
                            Expanded(
                              flex: 7,
                              child: _buildUpperFooterRightLinks(context),
                            ),
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildUpperFooterLeftBrandQr(context),
                            const SizedBox(height: 40),
                            _buildUpperFooterRightLinks(context),
                          ],
                        ),
                  const SizedBox(height: 36),
                  // Bottom Row of Upper White Footer: Social Media Icons + Region Selector Pill
                  Wrap(
                    spacing: 24,
                    runSpacing: 16,
                    alignment: WrapAlignment.spaceBetween,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildSocialIconCircle(Icons.camera_alt_outlined),
                          const SizedBox(width: 12),
                          _buildSocialIconCircle(Icons.facebook_rounded),
                          const SizedBox(width: 12),
                          _buildSocialIconCircle(Icons.close_rounded),
                          const SizedBox(width: 12),
                          _buildSocialIconCircle(Icons.business_center_rounded),
                          const SizedBox(width: 12),
                          _buildSocialIconCircle(Icons.push_pin_outlined),
                          const SizedBox(width: 12),
                          _buildSocialIconCircle(Icons.play_circle_fill_rounded),
                          const SizedBox(width: 12),
                          _buildSocialIconCircle(Icons.music_note_rounded),
                        ],
                      ),
                      _buildRegionSelectorPill(
                        isDarkPill: false,
                        showFullLanguageLabel: false,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),

        // TIER 2: LOWER DEEP DARK CRIMSON FOOTER + COLOSSAL FULL-BLEED BRIGHT RED "AVIAJ" WORDMARK (Reference Screenshot 2)
        Container(
          width: double.infinity,
          color: const Color(0xFF3B040C),
          padding: EdgeInsets.only(
            top: isDesktop ? 64 : 44,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isDesktop ? 72 : 24,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1220),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          spacing: 48,
                          runSpacing: 36,
                          children: [
                            // Left Editorial Description + Dark Region Selector Pill
                            SizedBox(
                              width: isDesktop ? 300 : double.infinity,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Aviaj is where travel connections actually start, whether you’re looking for a lifelong relationship partner, a spontaneous vacation romance, or a verified travel co-pilot. Available in 190 countries with Destination Radar™, Departure Prompts™, and Crew Villas built for every kind of connection. Download free on iOS and Android.',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13.5,
                                      fontWeight: FontWeight.w500,
                                      height: 1.5,
                                    ),
                                  ),
                                  const SizedBox(height: 22),
                                  _buildRegionSelectorPill(
                                    isDarkPill: true,
                                    showFullLanguageLabel: true,
                                  ),
                                ],
                              ),
                            ),
                            _FooterColumn(
                              title: 'LEGAL & PRIVACY',
                              items: const [
                                'Consumer Health Data Privacy Policy',
                                'Terms',
                                'Cookie Policy',
                                'Intellectual Property',
                                'Community Guidelines',
                                'Safety Policy Information',
                                'Community Information',
                                'Accessibility Statement',
                              ],
                              onTap: () => showMobileAppDownloadModal(context),
                            ),
                            _FooterColumn(
                              title: 'DESTINATIONS',
                              items: const [
                                'Destinations',
                                'Departure Stories',
                                'Press Room',
                                'Contact',
                                'Promo Code',
                                'Support',
                                'Gift Cards',
                              ],
                              onTap: () => _scrollToSection(_storiesKey),
                            ),
                            _FooterColumn(
                              title: 'CAREERS',
                              items: const [
                                'Careers Portal',
                                'Tech Blog',
                                'Stripe (${AviajStripeService.defaultStripeAccountId})',
                                'AdMob & Unity Ads',
                              ],
                              onTap: () => _scrollToSection(_pricingKey),
                            ),
                            _FooterColumn(
                              title: 'GET THE APP',
                              items: const [
                                'App Store (iOS)',
                                'Google Play Store',
                                'Instagram',
                                'TikTok',
                                'YouTube',
                                'X',
                              ],
                              onTap: () => showMobileAppDownloadModal(context),
                            ),
                          ],
                        ),
                        const SizedBox(height: 36),
                      ],
                    ),
                  ),
                ),
              ),
              // COLOSSAL FULL-BLEED BRIGHT LOVE RED "AVIAJ" WORDMARK SPANNING 100% WIDTH AT THE VERY BOTTOM
              SizedBox(
                width: screenWidth,
                child: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      'AVIAJ',
                      style: TextStyle(
                        color: AviajTheme.loveRed,
                        fontSize: 320,
                        fontWeight: FontWeight.w900,
                        height: 0.84,
                        letterSpacing: -12,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildUpperFooterLeftBrandQr(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Aviaj',
          style: TextStyle(
            color: AviajTheme.midnightNavy,
            fontSize: 64,
            fontWeight: FontWeight.w900,
            letterSpacing: -2.2,
            height: 1.0,
          ),
        ),
        const SizedBox(height: 64),
        InkWell(
          onTap: () => showMobileAppDownloadModal(context),
          borderRadius: BorderRadius.circular(22),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 335),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AviajTheme.loveRed,
              borderRadius: BorderRadius.circular(22),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 118,
                  height: 118,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      const Icon(
                        Icons.qr_code_2_rounded,
                        size: 100,
                        color: AviajTheme.midnightNavy,
                      ),
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Icon(
                          Icons.favorite_rounded,
                          color: AviajTheme.loveRed,
                          size: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 18),
                const Expanded(
                  child: Text(
                    'Scan the QR\ncode to get the\nAviaj app',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 16.5,
                      height: 1.28,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUpperFooterRightLinks(BuildContext context) {
    return Wrap(
      spacing: 56,
      runSpacing: 32,
      children: [
        _LightFooterColumn(
          title: 'Our apps',
          items: const [
            'Aviaj Romance',
            'Aviaj Co-Pilot',
            'Aviaj Crew ↗',
          ],
          boldItems: true,
          onTap: () => _scrollToSection(_modesKey),
        ),
        _LightFooterColumn(
          title: 'Company',
          items: const [
            'About',
            'Contact us',
            'Careers ↗',
            'Investors ↗',
            'The Lounge ↗',
            'Departure Stories ↗',
            'Support',
          ],
          boldItems: true,
          onTap: widget.onOpenFullMobilePreview,
        ),
        _LightFooterColumn(
          title: 'Legal',
          items: const [
            'Guidelines',
            'Manage cookies',
            'Privacy policy',
            'Terms and conditions',
            'Accessibility at Aviaj',
            'Notice at collection',
            'Modern Safety Act',
            'Consumer Health Privacy Policy',
          ],
          boldItems: false,
          onTap: () => showMobileAppDownloadModal(context),
        ),
      ],
    );
  }

  Widget _buildSocialIconCircle(IconData icon) {
    return InkWell(
      onTap: widget.onOpenFullMobilePreview,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: AviajTheme.midnightNavy.withValues(alpha: 0.08),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 17,
          color: AviajTheme.midnightNavy,
        ),
      ),
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

class _LightFooterColumn extends StatelessWidget {
  final String title;
  final List<String> items;
  final bool boldItems;
  final VoidCallback onTap;

  const _LightFooterColumn({
    required this.title,
    required this.items,
    required this.boldItems,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: boldItems ? 160 : 210,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF5C4B51),
              fontWeight: FontWeight.w500,
              fontSize: 13.5,
            ),
          ),
          const SizedBox(height: 16),
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: InkWell(
                onTap: onTap,
                child: Text(
                  item,
                  style: TextStyle(
                    color: AviajTheme.midnightNavy,
                    fontWeight: boldItems ? FontWeight.w800 : FontWeight.w600,
                    fontSize: boldItems ? 18 : 13.5,
                    height: 1.25,
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
