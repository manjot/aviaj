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
  final GlobalKey _affKey = GlobalKey();
  final GlobalKey _radarKey = GlobalKey();
  final GlobalKey _storiesKey = GlobalKey();
  final GlobalKey _pricingKey = GlobalKey();
  int _selectedHeroIndex = 0;
  bool _showAffMegaMenu = false;
  bool _showStoriesMegaMenu = false;
  bool _showPrivacyBanner = true;
  bool _optOutMarketingPartners = false;

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

    // Immediately detect visitor's live IP / VPN region (e.g. Turbo VPN USA -> Americas)
    _checkLiveIpRegion();

    // Automatically advance the 3D profiles slider and re-check live VPN IP region.
    _autoSlideTimer = Timer.periodic(
      const Duration(milliseconds: 2900),
      (_) {
        if (!mounted) return;
        _checkLiveIpRegion();
        if (_bannerIntroController.isCompleted &&
            !_profileSliderController.isAnimating) {
          _profileSliderController.forward(from: 0);
        }
      },
    );
  }

  Future<void> _checkLiveIpRegion() async {
    final changed = await widget.state.refreshRegionFromLiveIp();
    if (changed && mounted) {
      setState(() {
        _selectedHeroIndex = 0;
      });
      _replayBannerAnimation();
    }
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

    return ListenableBuilder(
      listenable: widget.state,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  children: [
                    // SECTION 1: FULL-BLEED ANIMATED BANNER (GIANT NAME + 3D PROFILES SLIDER)
                    _buildSpaciousHeroSection(context, isDesktop),

                    // SECTION 2: MISSION HEADLINE + 3 STEPPED CARDS WITH VERTICAL PILLS
                    _buildBelowBannerIntroStrip(context, isDesktop),

                    // SECTION 2B: REGIONAL FAMOUS HIKING, TREKKING & BEACH DESTINATIONS SHOWCASE
                    _buildRegionalTreksAndBeachesSection(context, isDesktop),

                    // SECTION 3: LIFESTYLE PHOTO + CIRCULAR STAMP EMBLEM + "SHARE YOUR NEXT ITINERARY"
                    Container(
                      key: _radarKey,
                      child: _buildDepartureCircleSection(context, isDesktop),
                    ),

                    // SECTION 4: TWO SIDE-BY-SIDE SOLID RED LOVE SHOWCASE CARDS (AVIAJ DATE & AFF - AVIAJ FRIENDS FOREVER)
                    Container(
                      key: _modesKey,
                      child: _buildThreeModesPillarSection(context, isDesktop),
                    ),

                    // SECTION 4B: DEDICATED FULL-BLEED "AFF — AVIAJ FRIENDS FOREVER" HERO SECTION
                    Container(
                      key: _affKey,
                      child: _buildAffFriendsForeverSection(context, isDesktop),
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
                      child:
                          _buildMinimalCabinUpgradesSection(context, isDesktop),
                    ),

                    // SECTION 8: MULTI-COLUMN SITEMAP FOOTER
                    _buildConversionBannerAndFooter(context, isDesktop),
                  ],
                ),
              ),
              if (_showPrivacyBanner)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: _buildPrivacyAcknowledgmentBanner(context, isDesktop),
                ),
            ],
          ),
        );
      },
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
                            label: 'Date',
                            onTap: () {
                              setState(() {
                                _showAffMegaMenu = false;
                                _showStoriesMegaMenu = false;
                              });
                              _scrollToSection(_modesKey);
                            },
                          ),
                          _NavbarLink(
                            label: 'AFF',
                            isHighlighted: _showAffMegaMenu,
                            onTap: () {
                              setState(() {
                                _showAffMegaMenu = !_showAffMegaMenu;
                                _showStoriesMegaMenu = false;
                              });
                            },
                          ),
                          _NavbarLink(
                            label: 'Stories',
                            isHighlighted: _showStoriesMegaMenu,
                            onTap: () {
                              setState(() {
                                _showStoriesMegaMenu = !_showStoriesMegaMenu;
                                _showAffMegaMenu = false;
                              });
                            },
                          ),
                          _NavbarLink(
                            label: 'Safety',
                            onTap: () {
                              setState(() {
                                _showAffMegaMenu = false;
                                _showStoriesMegaMenu = false;
                              });
                              _scrollToSection(_radarKey);
                            },
                          ),
                          _NavbarLink(
                            label: 'Support',
                            onTap: () {
                              setState(() {
                                _showAffMegaMenu = false;
                                _showStoriesMegaMenu = false;
                              });
                              _scrollToSection(_pricingKey);
                            },
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

            // Interactive "Explore AFF (Aviaj Friends Forever) ›" Mega-Menu Dropdown Card
            if (_showAffMegaMenu)
              Padding(
                padding: EdgeInsets.fromLTRB(
                  isDesktop ? 48 : 16,
                  8,
                  isDesktop ? 48 : 16,
                  12,
                ),
                child: _buildExploreAffMegaMenuCard(context, isDesktop),
              ),

            // Interactive "Explore Stories ›" Mega-Menu Dropdown Card
            if (_showStoriesMegaMenu)
              Padding(
                padding: EdgeInsets.fromLTRB(
                  isDesktop ? 48 : 16,
                  8,
                  isDesktop ? 48 : 16,
                  12,
                ),
                child: _buildExploreStoriesMegaMenuCard(context, isDesktop),
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
                  // Angled "Name, Age" + Regional Trek/Beach destination badge aligned to the 3D bottom perspective edge
                  Positioned(
                    left: 10,
                    right: 10,
                    bottom: slant * 0.56 + 12,
                    child: Transform.rotate(
                      angle: 0.19,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
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
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.58),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.35),
                                width: 0.8,
                              ),
                            ),
                            child: Text(
                              '📍 ${profile.nextDestination}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                fontSize: (fontSize * 0.54).clamp(8.5, 11.5),
                                letterSpacing: -0.1,
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

  /// SECTION 2B: Regional Famous Hiking, Trekking & Beach Destinations Grid
  /// Showcases iconic treks (e.g. Manali & Hampta Pass, Uttarakhand Kedarkantha & Valley of Flowers)
  /// and beaches (e.g. Goa Palolem & Vagator, Andaman Havelock & Radhanagar Beach) for the active region.
  Widget _buildRegionalTreksAndBeachesSection(
    BuildContext context,
    bool isDesktop,
  ) {
    final pack = widget.state.regionalPack;
    final region = pack.region;
    final destinations = pack.featuredDestinations;

    return Container(
      width: double.infinity,
      color: const Color(0xFFFFF5F6),
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 72 : 20,
        vertical: isDesktop ? 72 : 48,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1220),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 12,
                runSpacing: 12,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: AviajTheme.loveRed,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      '${region.flag} ${region.label.toUpperCase()} HIKING, TREKS & BEACHES',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 12,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: AviajTheme.loveRed.withValues(alpha: 0.25),
                      ),
                    ),
                    child: Text(
                      '📍 ${region.sampleDestinations}',
                      style: const TextStyle(
                        color: AviajTheme.midnightNavy,
                        fontWeight: FontWeight.w800,
                        fontSize: 12.5,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Text(
                region == AviajRegion.india
                    ? 'Famous Indian Treks & Beaches — Manali, Uttarakhand, Goa & Andaman'
                    : 'Famous ${region.label} Hiking Treks & Iconic Beach Escapes',
                style: TextStyle(
                  color: AviajTheme.midnightNavy,
                  fontSize: isDesktop ? 42 : 30,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1.3,
                  height: 1.08,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                region == AviajRegion.india
                    ? 'Match with verified hikers, trekkers, and beach lovers heading to Himachal (Manali, Hampta Pass, Kasol), Uttarakhand (Kedarkantha, Valley of Flowers, Chopta-Tungnath, Rishikesh), Goa (Palolem, Vagator, Cabo de Rama), and Andaman & Nicobar Islands (Havelock & Radhanagar Beach).'
                    : 'Match with verified hikers, trekkers, and island hoppers heading to ${region.sampleDestinations} on your exact travel dates.',
                style: const TextStyle(
                  color: Color(0xFF4A353B),
                  fontSize: 16.5,
                  fontWeight: FontWeight.w500,
                  height: 1.48,
                ),
              ),
              const SizedBox(height: 32),
              isDesktop
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (int i = 0; i < destinations.length; i++) ...[
                          if (i > 0) const SizedBox(width: 20),
                          Expanded(
                            child: _buildRegionalDestinationCard(
                              context,
                              destinations[i],
                            ),
                          ),
                        ],
                      ],
                    )
                  : Column(
                      children: [
                        for (int i = 0; i < destinations.length; i++) ...[
                          if (i > 0) const SizedBox(height: 18),
                          _buildRegionalDestinationCard(
                            context,
                            destinations[i],
                          ),
                        ],
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRegionalDestinationCard(
    BuildContext context,
    ({
      String title,
      String subtitle,
      String categoryBadge,
      String imageUrl,
    }) dest,
  ) {
    return InkWell(
      onTap: widget.onOpenFullMobilePreview,
      borderRadius: BorderRadius.circular(26),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(26),
          border: Border.all(
            color: AviajTheme.loveRed.withValues(alpha: 0.16),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: AviajTheme.loveRed.withValues(alpha: 0.08),
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(25),
              ),
              child: SizedBox(
                height: 220,
                width: double.infinity,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    AviajNetworkImage(
                      imageUrl: dest.imageUrl,
                      width: double.infinity,
                      height: 220,
                      fallbackLabel: dest.title,
                    ),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withValues(alpha: 0.15),
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.65),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: 14,
                      left: 14,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AviajTheme.loveRed,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          dest.categoryBadge,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 11,
                            letterSpacing: 0.4,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 12,
                      left: 14,
                      right: 14,
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.92),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.people_alt_rounded,
                                  size: 13,
                                  color: AviajTheme.loveRed,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  'Date • Co-Pilot • AFF Crews',
                                  style: TextStyle(
                                    color: AviajTheme.midnightNavy,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 10.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dest.title,
                    style: const TextStyle(
                      color: AviajTheme.midnightNavy,
                      fontWeight: FontWeight.w900,
                      fontSize: 19,
                      letterSpacing: -0.4,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    dest.subtitle,
                    style: const TextStyle(
                      color: Color(0xFF5A4348),
                      fontWeight: FontWeight.w600,
                      fontSize: 13.5,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Row(
                    children: [
                      Text(
                        'Join Departure Circle',
                        style: TextStyle(
                          color: AviajTheme.loveRed,
                          fontWeight: FontWeight.w900,
                          fontSize: 13,
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(
                        Icons.arrow_forward_rounded,
                        size: 15,
                        color: AviajTheme.loveRed,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
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
            'Aviaj Date',
            style: TextStyle(
              color: Colors.white,
              fontSize: 34,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.9,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Whether you’re new to travel dating or ready to try again, Aviaj Date is built to bring you closer to love safely and meaningfully.',
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
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 10,
            runSpacing: 6,
            children: [
              const Text(
                'AFF',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 34,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.9,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Text(
                  'AVIAJ FRIENDS FOREVER',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.6,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'Whether you’ve moved to a new city, landed solo abroad, or just want to expand your circle, AFF (Aviaj Friends Forever) makes it easy to meet like-minded people who match your vibe.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.5,
              fontWeight: FontWeight.w500,
              height: 1.44,
            ),
          ),
          const SizedBox(height: 20),
          InkWell(
            onTap: () => _scrollToSection(_affKey),
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

  /// Interactive "Explore AFF (Aviaj Friends Forever) ›" Mega-Menu Card
  Widget _buildExploreAffMegaMenuCard(BuildContext context, bool isDesktop) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 1220),
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 44 : 24,
        vertical: isDesktop ? 36 : 24,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.14),
            blurRadius: 28,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: 0,
            top: 0,
            child: IconButton(
              onPressed: () => setState(() => _showAffMegaMenu = false),
              icon: const Icon(
                Icons.close_rounded,
                color: AviajTheme.midnightNavy,
                size: 24,
              ),
              tooltip: 'Close AFF menu',
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 36),
            child: isDesktop
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 5,
                        child: InkWell(
                          onTap: () {
                            setState(() => _showAffMegaMenu = false);
                            _scrollToSection(_affKey);
                          },
                          child: const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Explore AFF ›',
                                style: TextStyle(
                                  color: AviajTheme.midnightNavy,
                                  fontSize: 28,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: -0.8,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Aviaj Friends Forever — features designed to help you find your people and connect over what you’re into.',
                                style: TextStyle(
                                  color: Color(0xFF3E3034),
                                  fontSize: 15.5,
                                  fontWeight: FontWeight.w500,
                                  height: 1.45,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 40),
                      Expanded(
                        flex: 3,
                        child: InkWell(
                          onTap: () {
                            setState(() => _showAffMegaMenu = false);
                            _scrollToSection(_affKey);
                          },
                          child: const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 6),
                              Row(
                                children: [
                                  Icon(
                                    Icons.calendar_today_outlined,
                                    size: 16,
                                    color: AviajTheme.midnightNavy,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Plans ›',
                                    style: TextStyle(
                                      color: AviajTheme.midnightNavy,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Organize a group meetup, or discover local travel events happening nearby.',
                                style: TextStyle(
                                  color: Color(0xFF4A3B40),
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w500,
                                  height: 1.45,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 32),
                      Expanded(
                        flex: 3,
                        child: InkWell(
                          onTap: () {
                            setState(() => _showAffMegaMenu = false);
                            _scrollToSection(_affKey);
                          },
                          child: const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 6),
                              Row(
                                children: [
                                  Icon(
                                    Icons.favorite_border_rounded,
                                    size: 17,
                                    color: AviajTheme.loveRed,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Community Leaders ›',
                                    style: TextStyle(
                                      color: AviajTheme.midnightNavy,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Our leaders help bring AFF’s values into their communities across the country.',
                                style: TextStyle(
                                  color: Color(0xFF4A3B40),
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w500,
                                  height: 1.45,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() => _showAffMegaMenu = false);
                          _scrollToSection(_affKey);
                        },
                        child: const Text(
                          'Explore AFF (Aviaj Friends Forever) ›',
                          style: TextStyle(
                            color: AviajTheme.midnightNavy,
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Features designed to help you find your people and connect over what you’re into.',
                        style: TextStyle(
                          color: Color(0xFF3E3034),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  /// Interactive "Explore Stories ›" Mega-Menu Card
  Widget _buildExploreStoriesMegaMenuCard(
    BuildContext context,
    bool isDesktop,
  ) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 1220),
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 44 : 24,
        vertical: isDesktop ? 36 : 24,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.14),
            blurRadius: 28,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: 0,
            top: 0,
            child: IconButton(
              onPressed: () => setState(() => _showStoriesMegaMenu = false),
              icon: const Icon(
                Icons.close_rounded,
                color: AviajTheme.midnightNavy,
                size: 24,
              ),
              tooltip: 'Close Stories menu',
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 36),
            child: isDesktop
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 5,
                        child: InkWell(
                          onTap: () {
                            setState(() => _showStoriesMegaMenu = false);
                            _scrollToSection(_storiesKey);
                          },
                          child: const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Explore Stories ›',
                                style: TextStyle(
                                  color: AviajTheme.midnightNavy,
                                  fontSize: 28,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: -0.8,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                'All the guidance and inspiration you need to help you find love and friendship.',
                                style: TextStyle(
                                  color: Color(0xFF3E3034),
                                  fontSize: 15.5,
                                  fontWeight: FontWeight.w500,
                                  height: 1.45,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 40),
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() => _showStoriesMegaMenu = false);
                                _scrollToSection(_storiesKey);
                              },
                              child: const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 6),
                                  Text(
                                    'Love Stories ›',
                                    style: TextStyle(
                                      color: AviajTheme.midnightNavy,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  SizedBox(height: 6),
                                  Text(
                                    'From Tokyo to Toronto, explore the love found on Aviaj around the world.',
                                    style: TextStyle(
                                      color: Color(0xFF4A3B40),
                                      fontSize: 13.5,
                                      fontWeight: FontWeight.w500,
                                      height: 1.45,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 22),
                            InkWell(
                              onTap: () {
                                setState(() => _showStoriesMegaMenu = false);
                                _scrollToSection(_affKey);
                              },
                              child: const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'The Friendship Hub ›',
                                    style: TextStyle(
                                      color: AviajTheme.midnightNavy,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  SizedBox(height: 6),
                                  Text(
                                    'Advice and stories to help you build the AFF friendships you want.',
                                    style: TextStyle(
                                      color: Color(0xFF4A3B40),
                                      fontSize: 13.5,
                                      fontWeight: FontWeight.w500,
                                      height: 1.45,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 32),
                      Expanded(
                        flex: 3,
                        child: InkWell(
                          onTap: () {
                            setState(() => _showStoriesMegaMenu = false);
                            _scrollToSection(_storiesKey);
                          },
                          child: const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 6),
                              Text(
                                'Seasonal Dating Guides ›',
                                style: TextStyle(
                                  color: AviajTheme.midnightNavy,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              SizedBox(height: 6),
                              Text(
                                'Plan the perfect date—no matter when, where or who you’re dating.',
                                style: TextStyle(
                                  color: Color(0xFF4A3B40),
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w500,
                                  height: 1.45,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() => _showStoriesMegaMenu = false);
                          _scrollToSection(_storiesKey);
                        },
                        child: const Text(
                          'Explore Stories ›',
                          style: TextStyle(
                            color: AviajTheme.midnightNavy,
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'All the guidance and inspiration you need to help you find love and friendship.',
                        style: TextStyle(
                          color: Color(0xFF3E3034),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  /// SECTION 4B: Full-Bleed "AFF — Aviaj Friends Forever" Dedicated Lifestyle Hero Section
  Widget _buildAffFriendsForeverSection(BuildContext context, bool isDesktop) {
    final pack = widget.state.regionalPack;
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 48 : 16,
        vertical: isDesktop ? 24 : 16,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1340),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(36),
            child: SizedBox(
              height: isDesktop ? 610 : 520,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  AviajNetworkImage(
                    imageUrl: pack.coPilotCrewImageUrl,
                    width: double.infinity,
                    height: double.infinity,
                    fallbackLabel: 'AFF — Aviaj Friends Forever',
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.28),
                          Colors.black.withValues(alpha: 0.56),
                          Colors.black.withValues(alpha: 0.72),
                        ],
                      ),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 680),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Flower/Heart Emblem + Giant "AFF" Wordmark
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: isDesktop ? 68 : 54,
                                  height: isDesktop ? 68 : 54,
                                  decoration: const BoxDecoration(
                                    color: AviajTheme.loveRed,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.diversity_1_rounded,
                                    color: Colors.white,
                                    size: isDesktop ? 36 : 28,
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Text(
                                  'AFF',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: isDesktop ? 86 : 62,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: -2.4,
                                    height: 0.95,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: AviajTheme.loveRed,
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: const Text(
                                'AVIAJ FRIENDS FOREVER',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 12.5,
                                  letterSpacing: 1.4,
                                ),
                              ),
                            ),
                            const SizedBox(height: 22),
                            Text(
                              'We’ve reimagined AFF (Aviaj Friends Forever) to make finding your people easier, safer, and more fun. Whether you’re settling into a new city, starting a solo adventure, or just looking for friends who get you, our latest features are built to help.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: isDesktop ? 19 : 15.5,
                                fontWeight: FontWeight.w600,
                                height: 1.48,
                              ),
                            ),
                            const SizedBox(height: 28),
                            Wrap(
                              alignment: WrapAlignment.center,
                              spacing: 14,
                              runSpacing: 12,
                              children: [
                                _buildStoreDownloadPill(
                                  icon: Icons.apple_rounded,
                                  topLabel: 'Download on the',
                                  storeName: 'App Store',
                                  onTap: widget.onOpenFullMobilePreview,
                                ),
                                _buildStoreDownloadPill(
                                  icon: Icons.play_arrow_rounded,
                                  topLabel: 'GET IT ON',
                                  storeName: 'Google Play',
                                  onTap: widget.onOpenFullMobilePreview,
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),
                            Text(
                              'Apple and the Apple Logo are trademarks of Apple Inc.\nGoogle Play is a trademark of Google LLC.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.78),
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                height: 1.35,
                              ),
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

  Widget _buildStoreDownloadPill({
    required IconData icon,
    required String topLabel,
    required String storeName,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white24, width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 28),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  topLabel,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  storeName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.3,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// SECTION 5: Editorial Quotation Testimonial + Full Love Stories Hub ("For the Love of Love")
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
          onPressed: () => _openFullLoveStoryModal(
            context,
            coupleName: pack.storyAttribution.split(',').first.trim(),
            metLabel: 'Met on Aviaj in 2023',
            heroImageUrl: pack.storyCoupleImageUrl,
            secondaryImageUrl: pack.departureCirclePhotoUrl,
            locationTag: '${widget.state.activeRegion.label} | First Spark',
            headlineQuote: pack.storyQuote,
          ),
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

    final featuredStories = [
      (
        couple: 'Tosin & Kieron',
        metYear: 'Met on Aviaj in 2020',
        summary: '36 questions later, it was love.',
        cityTag: 'Dublin | Unexpected',
        imageUrl: pack.storyCoupleImageUrl,
        secondImageUrl: pack.departureCirclePhotoUrl,
      ),
      (
        couple: 'Truett & Bimal',
        metYear: 'Met on Aviaj in 2018',
        summary:
            'His friends played virtual Cupid, and it worked like a charm.',
        cityTag: 'Dallas, TX | LGBTQIA+',
        imageUrl: pack.steppedCards[0].imageUrl,
        secondImageUrl: pack.steppedCards[1].imageUrl,
      ),
      (
        couple: 'Nina & Thomas',
        metYear: 'Met on Aviaj in 2022',
        summary: 'As it turned out, love really was just around the corner.',
        cityTag: 'Paris, France | Unexpected',
        imageUrl: pack.departureCirclePhotoUrl,
        secondImageUrl: pack.storyCoupleImageUrl,
      ),
      (
        couple: 'Jayde & Joel',
        metYear: 'Met on Aviaj in 2024',
        summary:
            'A mutual love of fashion and travel led to a connection that fit just right.',
        cityTag: 'New York City, NY | Friends First',
        imageUrl: pack.steppedCards[1].imageUrl,
        secondImageUrl: pack.steppedCards[2].imageUrl,
      ),
      (
        couple: 'Leslie & Thomas',
        metYear: 'Met on Aviaj in 2021',
        summary:
            'From airport masks to a wedding-day adventure, this love story has it all.',
        cityTag: 'Dallas, TX | Unexpected',
        imageUrl: pack.steppedCards[2].imageUrl,
        secondImageUrl: pack.storyCoupleImageUrl,
      ),
      (
        couple: pack.storyAttribution.split(',').first.trim(),
        metYear: 'Met on Aviaj in 2023',
        summary: pack.storyQuote,
        cityTag: '${widget.state.activeRegion.label} | Departure Match',
        imageUrl: pack.romancePhoneImageUrl,
        secondImageUrl: pack.storyCoupleImageUrl,
      ),
    ];

    return Column(
      children: [
        // 5A: Regional Editorial Quote + Monochrome Couple Portrait
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
        ),

        // 5B: Full-Bleed 3-Panel B&W Couple Collage — "For the Love of Love"
        SizedBox(
          width: double.infinity,
          height: isDesktop ? 520 : 360,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Row(
                children: [
                  Expanded(
                    child: _buildMonochromePanel(
                      pack.storyCoupleImageUrl,
                      height: double.infinity,
                    ),
                  ),
                  Expanded(
                    child: _buildMonochromePanel(
                      pack.departureCirclePhotoUrl,
                      height: double.infinity,
                    ),
                  ),
                  if (isDesktop)
                    Expanded(
                      child: _buildMonochromePanel(
                        pack.steppedCards[0].imageUrl,
                        height: double.infinity,
                      ),
                    ),
                ],
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.10),
                      Colors.black.withValues(alpha: 0.62),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 24,
                    right: 24,
                    bottom: isDesktop ? 42 : 26,
                  ),
                  child: Text(
                    'For the Love of Love',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AviajTheme.loveRed,
                      fontSize: isDesktop ? 86 : 44,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -2.4,
                      height: 1.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // 5C: Centered Editorial Intro + "Featured Love Stories" 3-Column Grid
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
                children: [
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 980),
                    child: Text(
                      'Discover real Aviaj love stories from across the world—full of sparks, surprises, second chances, and everything in between.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AviajTheme.midnightNavy,
                        fontSize: isDesktop ? 48 : 30,
                        fontWeight: FontWeight.w900,
                        height: 1.12,
                        letterSpacing: -1.4,
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 14,
                    runSpacing: 12,
                    children: [
                      FilledButton(
                        onPressed: () {
                          final first = featuredStories.first;
                          _openFullLoveStoryModal(
                            context,
                            coupleName: first.couple,
                            metLabel: first.metYear,
                            heroImageUrl: first.imageUrl,
                            secondaryImageUrl: first.secondImageUrl,
                            locationTag: first.cityTag,
                            headlineQuote: first.summary,
                          );
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: AviajTheme.midnightNavy,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 26,
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                        ),
                        child: const Text(
                          'Read the stories',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 14.5,
                          ),
                        ),
                      ),
                      OutlinedButton(
                        onPressed: widget.onOpenFullMobilePreview,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AviajTheme.midnightNavy,
                          side: const BorderSide(
                            color: AviajTheme.midnightNavy,
                            width: 1.4,
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 26,
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                        ),
                        child: const Text(
                          'Start your love story',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 14.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: isDesktop ? 64 : 40),
                  Text(
                    'Featured Love Stories',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AviajTheme.midnightNavy,
                      fontSize: isDesktop ? 52 : 34,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -1.5,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'From Tokyo to Toronto, explore the love found on Aviaj around the world.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF4A3B40),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 36),
                  Wrap(
                    spacing: 24,
                    runSpacing: 24,
                    children: featuredStories.map((story) {
                      final cardWidth = isDesktop ? 380.0 : double.infinity;
                      return SizedBox(
                        width: cardWidth,
                        child: _buildLoveStoryCollectionCard(
                          context,
                          coupleName: story.couple,
                          metYear: story.metYear,
                          summary: story.summary,
                          cityTag: story.cityTag,
                          imageUrl: story.imageUrl,
                          secondImageUrl: story.secondImageUrl,
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
        ),

        // 5D: Full-Bleed Red Love "Share Your Love Story" Banner with 3-Card Stacked B&W Fan
        Container(
          width: double.infinity,
          color: AviajTheme.loveRed,
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
                        Expanded(
                          flex: 5,
                          child: _buildShareYourLoveStoryLeftPane(context),
                        ),
                        const SizedBox(width: 56),
                        Expanded(
                          flex: 6,
                          child: _buildShareYourLoveStoryStackedFan(pack),
                        ),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildShareYourLoveStoryLeftPane(context),
                        const SizedBox(height: 36),
                        _buildShareYourLoveStoryStackedFan(pack),
                      ],
                    ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMonochromePanel(String imageUrl, {required double height}) {
    return ColorFiltered(
      colorFilter: const ColorFilter.matrix(<double>[
        0.2126, 0.7152, 0.0722, 0, 0, //
        0.2126, 0.7152, 0.0722, 0, 0, //
        0.2126, 0.7152, 0.0722, 0, 0, //
        0, 0, 0, 1, 0, //
      ]),
      child: AviajNetworkImage(
        imageUrl: imageUrl,
        width: double.infinity,
        height: height,
        fallbackLabel: 'Aviaj Love Story',
      ),
    );
  }

  Widget _buildLoveStoryCollectionCard(
    BuildContext context, {
    required String coupleName,
    required String metYear,
    required String summary,
    required String cityTag,
    required String imageUrl,
    required String secondImageUrl,
  }) {
    return InkWell(
      onTap: () => _openFullLoveStoryModal(
        context,
        coupleName: coupleName,
        metLabel: metYear,
        heroImageUrl: imageUrl,
        secondaryImageUrl: secondImageUrl,
        locationTag: cityTag,
        headlineQuote: summary,
      ),
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFF6F5F2),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: SizedBox(
                height: 340,
                width: double.infinity,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    _buildMonochromePanel(imageUrl, height: 340),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.72),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      left: 16,
                      right: 16,
                      bottom: 18,
                      child: Column(
                        children: [
                          Text(
                            coupleName,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -0.6,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AviajTheme.loveRed,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Text(
                              metYear,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
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
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    summary,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AviajTheme.midnightNavy,
                      fontSize: 15.5,
                      fontWeight: FontWeight.w600,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    cityTag,
                    style: const TextStyle(
                      color: Color(0xFF6E5D62),
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'Read more',
                    style: TextStyle(
                      color: AviajTheme.midnightNavy,
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  const SizedBox(height: 6),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShareYourLoveStoryLeftPane(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Share Your\nLove Story',
          style: TextStyle(
            color: Colors.white,
            fontSize: 54,
            fontWeight: FontWeight.w900,
            height: 1.04,
            letterSpacing: -1.6,
          ),
        ),
        const SizedBox(height: 18),
        const Text(
          'Whether you found your person on Aviaj Date or finally found your people on AFF (Aviaj Friends Forever), we’d love to share your story and inspire people to find love too.',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.5,
            fontWeight: FontWeight.w500,
            height: 1.48,
          ),
        ),
        const SizedBox(height: 28),
        FilledButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Share your Aviaj or AFF story at stories@aviaj.com — our editorial team reads every submission!',
                ),
                backgroundColor: AviajTheme.midnightNavy,
              ),
            );
          },
          style: FilledButton.styleFrom(
            backgroundColor: AviajTheme.midnightNavy,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40),
            ),
          ),
          child: const Text(
            'Submit your story',
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
          ),
        ),
        const SizedBox(height: 30),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: const BoxDecoration(
                color: AviajTheme.midnightNavy,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.mail_outline_rounded,
                color: Colors.white,
                size: 19,
              ),
            ),
            const SizedBox(width: 14),
            const Expanded(
              child: Text(
                'Prefer pen and paper? Send your story to:\nAviaj Love Stories Desk, P.O. Box 300940 Austin, Texas, 78703\nWe read every letter — and may occasionally even write back.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  height: 1.45,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildShareYourLoveStoryStackedFan(AviajRegionalContentPack pack) {
    return SizedBox(
      height: 410,
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          Positioned(
            left: 250,
            top: 48,
            width: 240,
            height: 315,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(22),
              child: _buildMonochromePanel(
                pack.steppedCards[2].imageUrl,
                height: 315,
              ),
            ),
          ),
          Positioned(
            left: 135,
            top: 26,
            width: 265,
            height: 355,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white, width: 3),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(21),
                child: _buildMonochromePanel(
                  pack.departureCirclePhotoUrl,
                  height: 355,
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            top: 0,
            width: 295,
            height: 400,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(26),
                border: Border.all(color: Colors.white, width: 3),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(23),
                child: _buildMonochromePanel(
                  pack.storyCoupleImageUrl,
                  height: 400,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Full-Screen Editorial Love Story Reader Modal (matches Tosin & Kieron multi-chapter view)
  void _openFullLoveStoryModal(
    BuildContext context, {
    required String coupleName,
    required String metLabel,
    required String heroImageUrl,
    required String secondaryImageUrl,
    required String locationTag,
    required String headlineQuote,
  }) {
    showDialog<void>(
      context: context,
      builder: (ctx) {
        return Dialog(
          insetPadding: const EdgeInsets.all(20),
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1060, maxHeight: 860),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Breadcrumb + Close Bar
                    Padding(
                      padding: const EdgeInsets.fromLTRB(28, 18, 20, 14),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Love Stories  ›  All Stories  ›  $coupleName  ›',
                              style: const TextStyle(
                                color: AviajTheme.midnightNavy,
                                fontSize: 13.5,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () => Navigator.of(ctx).pop(),
                            icon: const Icon(Icons.close_rounded),
                          ),
                        ],
                      ),
                    ),
                    // Giant B&W Hero Banner with Met Year + Couple Name
                    SizedBox(
                      height: 420,
                      width: double.infinity,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          _buildMonochromePanel(heroImageUrl, height: 420),
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.black.withValues(alpha: 0.15),
                                  Colors.black.withValues(alpha: 0.78),
                                ],
                              ),
                            ),
                          ),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AviajTheme.loveRed,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      metLabel,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w900,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    coupleName,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 64,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: -2.0,
                                      height: 1.0,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  ConstrainedBox(
                                    constraints: const BoxConstraints(
                                      maxWidth: 580,
                                    ),
                                    child: Text(
                                      headlineQuote,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        height: 1.45,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 32),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Multi-Chapter Editorial Story Body
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 48,
                        vertical: 40,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'They say timing is everything — and when $coupleName matched on Aviaj ($locationTag), neither of them expected a single route check-in to turn into a lifelong adventure together.',
                            style: const TextStyle(
                              color: AviajTheme.midnightNavy,
                              fontSize: 16.5,
                              fontWeight: FontWeight.w500,
                              height: 1.6,
                            ),
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            'The 10-Hour Second Date',
                            style: TextStyle(
                              color: AviajTheme.midnightNavy,
                              fontSize: 28,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -0.8,
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'What started as curiosity turned into 10 hours of sharing travel stories, favorite cafés, and opening up in ways most people don’t in the first few weeks of dating. Thirty-six questions later, there was no denying their connection had shifted into something extraordinary.',
                            style: TextStyle(
                              color: Color(0xFF3E3034),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              height: 1.6,
                            ),
                          ),
                          const SizedBox(height: 28),
                          // Side-by-side B&W duo portraits
                          Row(
                            children: [
                              Expanded(
                                flex: 6,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: _buildMonochromePanel(
                                    heroImageUrl,
                                    height: 300,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                flex: 4,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: _buildMonochromePanel(
                                    secondaryImageUrl,
                                    height: 300,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 32),
                          Text(
                            '“I didn’t like the idea of waiting for somebody to message me. I’m in charge of my love life here, so I just really always felt empowered by Aviaj.”',
                            style: const TextStyle(
                              color: AviajTheme.midnightNavy,
                              fontSize: 30,
                              fontWeight: FontWeight.w900,
                              height: 1.22,
                              letterSpacing: -0.9,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            coupleName,
                            style: const TextStyle(
                              color: Color(0xFF5A4A4F),
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 28),
                          const Text(
                            'Two Weddings, Two Cultures, One Love',
                            style: TextStyle(
                              color: AviajTheme.midnightNavy,
                              fontSize: 28,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -0.8,
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'One year after moving in together, a proposal overlooking the coast turned into two unforgettable celebrations with friends and family from around the world. What defines their relationship is a sense of partnership — the certainty that no matter what life brings, they can face it together.',
                            style: TextStyle(
                              color: Color(0xFF3E3034),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              height: 1.6,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
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
                                'Do not sell or share my personal information',
                                'Manage cookies',
                                'Consumer Health Data Privacy Policy',
                                'Terms',
                                'Cookie Policy',
                                'Intellectual Property',
                                'Community Guidelines',
                                'Safety Policy Information',
                                'Accessibility Statement',
                              ],
                              onTap: () => _showPrivacyChoicesModal(context),
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
            'Aviaj Date',
            'AFF (Aviaj Friends Forever)',
            'Aviaj Crew ↗',
          ],
          boldItems: true,
          onTap: () => _scrollToSection(_affKey),
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
            'Do not sell or share my personal information',
            'Privacy policy',
            'Terms and conditions',
            'Accessibility at Aviaj',
            'Notice at collection',
            'Modern Safety Act',
            'Consumer Health Privacy Policy',
          ],
          boldItems: false,
          onTap: () => _showPrivacyChoicesModal(context),
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

  /// Bottom-docked Privacy Acknowledgment Banner ("Your privacy choices")
  /// matching the editorial privacy consent design (`=Aviaj | Your privacy choices ... [Continue]`).
  Widget _buildPrivacyAcknowledgmentBanner(
    BuildContext context,
    bool isDesktop,
  ) {
    return Material(
      color: Colors.white,
      elevation: 18,
      shadowColor: Colors.black.withValues(alpha: 0.22),
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: Color(0xFFE6E2E4), width: 1),
          ),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: isDesktop ? 48 : 20,
          vertical: isDesktop ? 28 : 20,
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1020),
            child: isDesktop
                ? IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Left Column: Compact "=Aviaj" Mark
                        Padding(
                          padding: const EdgeInsets.only(top: 4, right: 24),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 11,
                                    height: 2.2,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF2B2B2B),
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),
                                  const SizedBox(height: 2.2),
                                  Container(
                                    width: 14,
                                    height: 2.2,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF2B2B2B),
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),
                                  const SizedBox(height: 2.2),
                                  Container(
                                    width: 11,
                                    height: 2.2,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF2B2B2B),
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 6),
                              const Text(
                                'Aviaj',
                                style: TextStyle(
                                  color: Color(0xFF2B2B2B),
                                  fontWeight: FontWeight.w800,
                                  fontSize: 15.5,
                                  letterSpacing: -0.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Vertical Divider Line
                        Container(
                          width: 1,
                          color: const Color(0xFFE2DEE0),
                          margin: const EdgeInsets.only(right: 28),
                        ),
                        // Right Column: Privacy Copy & "Continue" Pill Button
                        Expanded(
                          child: _buildPrivacyBannerTextAndAction(context),
                        ),
                      ],
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.shield_outlined,
                            size: 18,
                            color: Color(0xFF2B2B2B),
                          ),
                          const SizedBox(width: 6),
                          const Text(
                            'Aviaj',
                            style: TextStyle(
                              color: Color(0xFF2B2B2B),
                              fontWeight: FontWeight.w800,
                              fontSize: 15,
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            onPressed: () =>
                                setState(() => _showPrivacyBanner = false),
                            icon: const Icon(
                              Icons.close_rounded,
                              size: 20,
                              color: Color(0xFF2B2B2B),
                            ),
                            visualDensity: VisualDensity.compact,
                            tooltip: 'Dismiss privacy notice',
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      _buildPrivacyBannerTextAndAction(context),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildPrivacyBannerTextAndAction(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'Your privacy choices',
          style: TextStyle(
            color: Color(0xFF2B2B2B),
            fontSize: 20,
            fontWeight: FontWeight.w500,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            const Text(
              'We use services that help improve marketing campaigns. (Learn more in our ',
              style: TextStyle(
                color: Color(0xFF3B3B3B),
                fontSize: 13.5,
                fontWeight: FontWeight.w400,
                height: 1.45,
              ),
            ),
            InkWell(
              onTap: () => _showPrivacyChoicesModal(context),
              child: const Text(
                'Privacy Policy',
                style: TextStyle(
                  color: Color(0xFF1E1E1E),
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.underline,
                  height: 1.45,
                ),
              ),
            ),
            const Text(
              ').',
              style: TextStyle(
                color: Color(0xFF3B3B3B),
                fontSize: 13.5,
                fontWeight: FontWeight.w400,
                height: 1.45,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        const Text(
          'Under certain privacy laws, this may be considered selling or sharing your personal information with our marketing partners.',
          style: TextStyle(
            color: Color(0xFF3B3B3B),
            fontSize: 13.5,
            fontWeight: FontWeight.w400,
            height: 1.45,
          ),
        ),
        const SizedBox(height: 12),
        InkWell(
          onTap: () => _showPrivacyChoicesModal(context),
          child: const Text(
            'You can view these partners and opt out by clicking “Do not sell or share my personal information” at the bottom of the homepage.',
            style: TextStyle(
              color: Color(0xFF3B3B3B),
              fontSize: 13.5,
              fontWeight: FontWeight.w400,
              height: 1.45,
            ),
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            setState(() {
              _showPrivacyBanner = false;
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2B2B2B),
            foregroundColor: Colors.white,
            elevation: 0,
            minimumSize: const Size(188, 46),
            padding: const EdgeInsets.symmetric(horizontal: 38, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(999),
            ),
          ),
          child: const Text(
            'Continue',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 14.5,
            ),
          ),
        ),
      ],
    );
  }

  void _showPrivacyChoicesModal(BuildContext context) {
    bool localOptOut = _optOutMarketingPartners;
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Dialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 580),
                child: Padding(
                  padding: const EdgeInsets.all(28),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'Your Privacy Choices & Policy',
                            style: TextStyle(
                              color: AviajTheme.midnightNavy,
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            onPressed: () => Navigator.of(dialogContext).pop(),
                            icon: const Icon(Icons.close_rounded),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Aviaj uses essential cookies to keep your account secure and optional analytics & marketing services (including Google AdMob, Unity LevelPlay, and Stripe Checkout) to personalize travel campaigns.',
                        style: TextStyle(
                          color: Color(0xFF4A3B40),
                          fontSize: 14,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 18),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFDF8F7),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFEAE2E4)),
                        ),
                        child: SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          activeThumbColor: AviajTheme.loveRed,
                          title: const Text(
                            'Do not sell or share my personal information',
                            style: TextStyle(
                              color: AviajTheme.midnightNavy,
                              fontWeight: FontWeight.w800,
                              fontSize: 14.5,
                            ),
                          ),
                          subtitle: const Text(
                            'Opt out of sharing personal identifiers with third-party marketing and attribution partners under CPRA/GDPR.',
                            style: TextStyle(
                              color: Color(0xFF5C4B51),
                              fontSize: 12.5,
                            ),
                          ),
                          value: localOptOut,
                          onChanged: (val) {
                            setModalState(() => localOptOut = val);
                          },
                        ),
                      ),
                      const SizedBox(height: 22),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _showPrivacyBanner = true;
                              });
                              Navigator.of(dialogContext).pop();
                            },
                            child: const Text(
                              'Show Banner Again',
                              style: TextStyle(
                                color: Color(0xFF5C4B51),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _optOutMarketingPartners = localOptOut;
                                _showPrivacyBanner = false;
                              });
                              Navigator.of(dialogContext).pop();
                              ScaffoldMessenger.of(this.context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    localOptOut
                                        ? 'Your opt-out preference ("Do not sell or share my personal information") has been saved.'
                                        : 'Your privacy choices have been saved.',
                                  ),
                                  backgroundColor: const Color(0xFF2B2B2B),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2B2B2B),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(999),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 28,
                                vertical: 14,
                              ),
                            ),
                            child: const Text(
                              'Save & Continue',
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                          ),
                        ],
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
}

class _NavbarLink extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool isHighlighted;

  const _NavbarLink({
    required this.label,
    required this.onTap,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: TextButton(
        onPressed: onTap,
        style: isHighlighted
            ? TextButton.styleFrom(
                backgroundColor: AviajTheme.warmSand,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              )
            : null,
        child: Text(
          label,
          style: TextStyle(
            color: isHighlighted ? AviajTheme.loveRed : AviajTheme.midnightNavy,
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
