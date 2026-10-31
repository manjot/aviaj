import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/ad_service.dart';
import '../services/stripe_service.dart';
import '../state/aviaj_state.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';

/// Lengthy, spacious, editorial Marketing Landing Page for Web (`aviaj.com`).
/// Inspired by modern multi-section scroll architecture (minimal copy per section,
/// bold typography, generous whitespace, alternating 50/50 visual splits, story showcase,
/// and full-width conversion banners) while using 100% original Aviaj travel-dating
/// keywords and the solid Aegean Teal + Sunset Terracotta + Compass Amber palette.
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

class _AviajLandingPageState extends State<AviajLandingPage> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _modesKey = GlobalKey();
  final GlobalKey _radarKey = GlobalKey();
  final GlobalKey _storiesKey = GlobalKey();
  final GlobalKey _pricingKey = GlobalKey();
  int _selectedHeroIndex = 0;

  @override
  void dispose() {
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
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(76),
        child: _buildMinimalNavbar(context, isDesktop),
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            // SECTION 1: SPACIOUS ABOVE-THE-FOLD HERO (MINIMAL COPY + VISUAL)
            _buildSpaciousHeroSection(context, isDesktop),

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

  /// Top Global Navigation Header — clean, uncluttered, high-contrast
  Widget _buildMinimalNavbar(BuildContext context, bool isDesktop) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: isDesktop ? 56 : 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Color(0xFFEDE8E0), width: 1.2),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            // Brand Wordmark
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: AviajTheme.sunsetTerracotta,
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: const Icon(
                    Icons.flight_takeoff_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  'aviaj',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 27,
                    letterSpacing: -0.9,
                    color: AviajTheme.midnightNavy,
                  ),
                ),
              ],
            ),
            const Spacer(),
            if (isDesktop) ...[
              _NavbarLink(
                label: 'Romance',
                onTap: () => _scrollToSection(_modesKey),
              ),
              _NavbarLink(
                label: 'Co-Pilot',
                onTap: () => _scrollToSection(_modesKey),
              ),
              _NavbarLink(
                label: 'Group Crew',
                onTap: () => _scrollToSection(_modesKey),
              ),
              _NavbarLink(
                label: 'Destination Radar',
                onTap: () => _scrollToSection(_radarKey),
              ),
              _NavbarLink(
                label: 'The Horizon',
                onTap: () => _scrollToSection(_storiesKey),
              ),
              _NavbarLink(
                label: 'First Class',
                onTap: () => _scrollToSection(_pricingKey),
              ),
              const SizedBox(width: 12),
              OutlinedButton(
                onPressed: widget.onOpenFullMobilePreview,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AviajTheme.midnightNavy,
                  side: const BorderSide(
                    color: AviajTheme.midnightNavy,
                    width: 1.5,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 13,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'App Demo',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 13.5,
                  ),
                ),
              ),
              const SizedBox(width: 10),
            ],
            FilledButton(
              onPressed: () => showMobileAppDownloadModal(context),
              style: FilledButton.styleFrom(
                backgroundColor: AviajTheme.midnightNavy,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                'Download',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 13.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// SECTION 1: Spacious Above-the-Fold Hero — Only 3 clean text elements on the left
  /// and a high-impact lifestyle travel card on the right.
  Widget _buildSpaciousHeroSection(BuildContext context, bool isDesktop) {
    final profiles = widget.state.allProfiles;
    final activeProfile = profiles[_selectedHeroIndex % profiles.length];

    return Container(
      width: double.infinity,
      color: AviajTheme.horizonTeal,
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 72 : 24,
        vertical: isDesktop ? 84 : 48,
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
                      child: _buildMinimalHeroCopy(context),
                    ),
                    const SizedBox(width: 56),
                    Expanded(
                      flex: 5,
                      child: Center(
                        child: _buildCleanHeroVisualCard(
                          context,
                          activeProfile,
                        ),
                      ),
                    ),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildMinimalHeroCopy(context),
                    const SizedBox(height: 44),
                    Center(
                      child: _buildCleanHeroVisualCard(
                        context,
                        activeProfile,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildMinimalHeroCopy(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          decoration: BoxDecoration(
            color: AviajTheme.compassAmber,
            borderRadius: BorderRadius.circular(30),
          ),
          child: const Text(
            'THE TRAVEL DATING & CO-PILOT APP',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: 11.5,
              letterSpacing: 1.0,
            ),
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'Meet your next co-pilot.\nTravel better, together.',
          style: TextStyle(
            color: Colors.white,
            fontSize: 58,
            fontWeight: FontWeight.w900,
            height: 1.05,
            letterSpacing: -1.6,
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'Find vacation romance, a lifelong relationship partner, or a solo travel buddy before you board.',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w500,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 36),
        const AppStoreDownloadBadges(lightOnDark: true),
        const SizedBox(height: 18),
        InkWell(
          onTap: () => showMobileAppDownloadModal(context),
          borderRadius: BorderRadius.circular(30),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(30),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.qr_code_2_rounded, color: Colors.white, size: 20),
                SizedBox(width: 8),
                Flexible(
                  child: Text(
                    'Scan QR code for iOS & Android',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 13,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCleanHeroVisualCard(
    BuildContext context,
    TravellerProfile profile,
  ) {
    return Container(
      width: 390,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(40),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Stack(
              children: [
                AviajNetworkImage(
                  imageUrl: profile.imageUrl,
                  height: 410,
                  width: double.infinity,
                  fallbackLabel: profile.name,
                ),
                Positioned(
                  top: 16,
                  left: 16,
                  child: IntentBadge(
                    intent: profile.primaryIntent,
                    solid: true,
                  ),
                ),
                Positioned(
                  bottom: 16,
                  left: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AviajTheme.midnightNavy.withValues(alpha: 0.92),
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                '${profile.name}, ${profile.age} ${profile.countryFlag}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 19,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const Icon(
                              Icons.verified_rounded,
                              color: AviajTheme.skyAzure,
                              size: 18,
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '✈️ ${profile.nextDestination} • ${profile.nextTripWindow}',
                          style: const TextStyle(
                            color: AviajTheme.compassAmber,
                            fontWeight: FontWeight.w800,
                            fontSize: 12.5,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              IconButton.filledTonal(
                onPressed: () {
                  setState(() {
                    _selectedHeroIndex++;
                  });
                },
                icon: const Icon(Icons.refresh_rounded, size: 18),
                tooltip: 'Next Traveller',
              ),
              const SizedBox(width: 8),
              Expanded(
                child: FilledButton.icon(
                  onPressed: widget.onOpenFullMobilePreview,
                  style: FilledButton.styleFrom(
                    backgroundColor: AviajTheme.sunsetTerracotta,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  icon: const Icon(Icons.smartphone_rounded, size: 17),
                  label: const Text(
                    'Open Interactive App',
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
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
                                    color: AviajTheme.compassAmber,
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
                      color: const Color(0xFF635BFF),
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
                                backgroundColor: const Color(0xFF635BFF),
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
