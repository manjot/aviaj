import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/ad_service.dart';
import '../services/stripe_service.dart';
import '../state/aviaj_state.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';

/// Original Aviaj Solid-Color Travel & Romance Marketing Landing Page for Web (`aviaj.com`),
/// directing users to download the iOS App Store & Google Play Store mobile apps,
/// with an embedded interactive iPhone mobile app preview.
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
  final GlobalKey _pricingKey = GlobalKey();
  final GlobalKey _downloadKey = GlobalKey();
  int _previewCardIndex = 0;

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
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 960;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(72),
        child: _buildAviajNavbar(context, isDesktop),
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            // 1. SOLID AEGEAN TEAL & TERRACOTTA TRAVEL-DATING HERO SECTION
            _buildHeroSection(context, isDesktop),

            // 2. THREE AVIAJ TRAVEL PILLARS: ROMANCE • CO-PILOT • GROUP CREW
            Container(
              key: _modesKey,
              child: _buildThreeModesSection(context, isDesktop),
            ),

            // 3. HOW IT WORKS ON MOBILE (DESTINATION RADAR + DEPARTURE LOUNGE)
            _buildMobileAppFeaturesBanner(context, isDesktop),

            // 4. AVIAJ BUSINESS CLASS™ & FIRST CLASS™ (POWERED BY STRIPE)
            Container(
              key: _pricingKey,
              child: _buildStripePricingSection(context, isDesktop),
            ),

            // 5. DOWNLOAD MOBILE APP CTA & QR SECTION + FOOTER
            Container(
              key: _downloadKey,
              child: _buildDownloadAndFooterSection(context, isDesktop),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAviajNavbar(BuildContext context, bool isDesktop) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: isDesktop ? 48 : 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Color(0xFFE8E2D9), width: 1.5),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            // Solid Aviaj Aviation & Romance Brand Logo
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AviajTheme.sunsetTerracotta,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.flight_takeoff_rounded,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  'aviaj',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 28,
                    letterSpacing: -1.0,
                    color: AviajTheme.midnightNavy,
                  ),
                ),
              ],
            ),
            const Spacer(),
            if (isDesktop) ...[
              _NavbarLink(
                label: 'Travel Romance',
                onTap: () => _scrollToSection(_modesKey),
              ),
              _NavbarLink(
                label: 'Solo Co-Pilot',
                onTap: () => _scrollToSection(_modesKey),
              ),
              _NavbarLink(
                label: 'Group Departures',
                onTap: () => _scrollToSection(_modesKey),
              ),
              _NavbarLink(
                label: 'First Class™',
                onTap: () => _scrollToSection(_pricingKey),
              ),
              _NavbarLink(
                label: 'Mobile App Demo',
                onTap: widget.onOpenFullMobilePreview,
              ),
              const SizedBox(width: 16),
            ],
            FilledButton.icon(
              onPressed: () => showMobileAppDownloadModal(context),
              style: FilledButton.styleFrom(
                backgroundColor: AviajTheme.midnightNavy,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              icon: const Icon(Icons.phone_iphone_rounded, size: 17),
              label: const Text(
                'Download App',
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

  Widget _buildHeroSection(BuildContext context, bool isDesktop) {
    final profiles = widget.state.allProfiles;
    final activeProfile = profiles[_previewCardIndex % profiles.length];

    return Container(
      width: double.infinity,
      color: AviajTheme.horizonTeal, // Solid Aegean Horizon Teal
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 64 : 24,
        vertical: isDesktop ? 56 : 36,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1240),
          child: isDesktop
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 6,
                      child: _buildHeroCopy(context),
                    ),
                    const SizedBox(width: 48),
                    Expanded(
                      flex: 5,
                      child: Center(
                        child: _buildInteractivePhoneMockup(
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
                    _buildHeroCopy(context),
                    const SizedBox(height: 36),
                    Center(
                      child: _buildInteractivePhoneMockup(
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

  Widget _buildHeroCopy(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Solid Compass Sandstone Amber Pill
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: AviajTheme.compassAmber,
            borderRadius: BorderRadius.circular(30),
          ),
          child: const Text(
            'SOLO & GROUP TRAVEL BUDDY • SHORT & LONG-TERM TRAVEL DATING APP',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: 11.5,
              letterSpacing: 0.8,
            ),
          ),
        ),
        const SizedBox(height: 22),
        const Text(
          'Meet your next co-pilot.\nTravel together. Fall in love abroad.',
          style: TextStyle(
            color: Colors.white,
            fontSize: 50,
            fontWeight: FontWeight.w900,
            height: 1.08,
            letterSpacing: -1.4,
          ),
        ),
        const SizedBox(height: 18),
        const Text(
          'Connect with verified solo and group travellers heading to the same destination. Whether you want a spontaneous vacation romance, a lifelong relationship partner, or a trusted travel buddy to split a coastal villa, your journey starts on the Aviaj mobile app.',
          style: TextStyle(
            color: Colors.white,
            fontSize: 17.5,
            fontWeight: FontWeight.w500,
            height: 1.45,
          ),
        ),
        const SizedBox(height: 28),
        // Official App Store & Google Play Store Download Buttons
        const AppStoreDownloadBadges(lightOnDark: true),
        const SizedBox(height: 22),
        // Compact QR Code + Mobile App Preview Trigger
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
          ),
          child: Wrap(
            spacing: 16,
            runSpacing: 12,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AviajTheme.midnightNavy,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.qr_code_2_rounded,
                  color: Colors.white,
                  size: 38,
                ),
              ),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Get the Aviaj App on iOS & Android',
                    style: TextStyle(
                      color: AviajTheme.midnightNavy,
                      fontWeight: FontWeight.w900,
                      fontSize: 14.5,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Scan with your phone camera to download from App Store or Google Play.',
                    style: TextStyle(
                      color: Color(0xFF555560),
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        // Travel & Relationship Intent Pills
        Wrap(
          spacing: 8,
          runSpacing: 6,
          children: ConnectionIntent.values
              .map(
                (i) => Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    i.label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 11.5,
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  /// Interactive iPhone 16 Pro Frame showcasing the Aviaj Mobile App right inside the Hero!
  Widget _buildInteractivePhoneMockup(
    BuildContext context,
    TravellerProfile profile,
  ) {
    return Container(
      width: 340,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AviajTheme.midnightNavy,
        borderRadius: BorderRadius.circular(46),
        border: Border.all(color: Colors.white24, width: 3),
      ),
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(36),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Phone Status Bar + Dynamic Island
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '9:41',
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 12,
                      color: AviajTheme.midnightNavy,
                    ),
                  ),
                  Container(
                    width: 76,
                    height: 18,
                    decoration: BoxDecoration(
                      color: AviajTheme.midnightNavy,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  const Row(
                    children: [
                      Icon(Icons.wifi_rounded, size: 13),
                      SizedBox(width: 4),
                      Icon(Icons.battery_full_rounded, size: 14),
                    ],
                  ),
                ],
              ),
            ),
            // Mini Mobile App Top Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'aviaj',
                    style: TextStyle(
                      color: AviajTheme.sunsetTerracotta,
                      fontWeight: FontWeight.w900,
                      fontSize: 20,
                      letterSpacing: -0.5,
                    ),
                  ),
                  Flexible(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AviajTheme.horizonTeal,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'Destination Radar',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 10,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Mobile Traveller Card inside the Phone Frame
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Stack(
                  children: [
                    AviajNetworkImage(
                      imageUrl: profile.imageUrl,
                      height: 310,
                      width: double.infinity,
                      fallbackLabel: profile.name,
                    ),
                    Positioned(
                      top: 10,
                      left: 10,
                      child: IntentBadge(
                        intent: profile.primaryIntent,
                        compact: true,
                        solid: true,
                      ),
                    ),
                    Positioned(
                      bottom: 10,
                      left: 10,
                      right: 10,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AviajTheme.midnightNavy.withValues(alpha: 0.92),
                          borderRadius: BorderRadius.circular(16),
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
                                      fontSize: 17,
                                    ),
                                  ),
                                ),
                                const Icon(
                                  Icons.verified_rounded,
                                  color: AviajTheme.skyAzure,
                                  size: 16,
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '✈️ ${profile.nextDestination} (${profile.nextTripWindow})',
                              style: const TextStyle(
                                color: AviajTheme.compassAmber,
                                fontWeight: FontWeight.w800,
                                fontSize: 11.5,
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
            // Mobile Co-Pilot Action Buttons inside the Phone Frame
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _MiniPhoneCircleBtn(
                    icon: Icons.close_rounded,
                    bgColor: const Color(0xFFF3F4F6),
                    fgColor: AviajTheme.midnightNavy,
                    onTap: () {
                      setState(() {
                        _previewCardIndex++;
                      });
                    },
                  ),
                  _MiniPhoneCircleBtn(
                    icon: Icons.airplane_ticket_rounded,
                    bgColor: AviajTheme.compassAmber,
                    fgColor: Colors.white,
                    onTap: () => showMobileAppDownloadModal(context),
                  ),
                  _MiniPhoneCircleBtn(
                    icon: Icons.favorite_rounded,
                    bgColor: AviajTheme.sunsetTerracotta,
                    fgColor: Colors.white,
                    onTap: () {
                      setState(() {
                        _previewCardIndex++;
                      });
                      showMobileAppDownloadModal(context);
                    },
                  ),
                ],
              ),
            ),
            // Launch Interactive Mobile Simulator Bar
            InkWell(
              onTap: widget.onOpenFullMobilePreview,
              child: Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 11),
                color: AviajTheme.sunsetTerracotta,
                alignment: Alignment.center,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.smartphone_rounded,
                      size: 15,
                      color: Colors.white,
                    ),
                    SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        'Open Mobile App Demo →',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 11.5,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Section 2: Three Original Aviaj Travel Pillars (Romance, Co-Pilot, Crew)
  Widget _buildThreeModesSection(BuildContext context, bool isDesktop) {
    final modes = [
      (
        badge: 'AVIAJ ROMANCE',
        title: 'Short-Term Vacation Chemistry & Long-Term Partners',
        description:
            'Connect with verified single travellers heading to the same destination. Share Departure Prompts and propose sunset rooftop dates before your flight lands.',
        bgColor: AviajTheme.sunsetTerracotta,
        textColor: Colors.white,
        btnColor: AviajTheme.midnightNavy,
        btnTextColor: Colors.white,
        imageUrl:
            'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?auto=format&fit=crop&w=800&q=80',
      ),
      (
        badge: 'AVIAJ CO-PILOT',
        title: 'Platonic Travel Buddies & Shared Roadtrips',
        description:
            'Looking for a trusted co-explorer to split a 4x4 in Patagonia, an oceanfront villa in Madeira, or sunrise treks without paying single supplements?',
        bgColor: AviajTheme.horizonTeal,
        textColor: Colors.white,
        btnColor: AviajTheme.compassAmber,
        btnTextColor: Colors.white,
        imageUrl:
            'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=800&q=80',
      ),
      (
        badge: 'AVIAJ CREW',
        title: 'Curated Solo Group Trips & Sunset Villas',
        description:
            'Reserve a verified spot on 4-to-8 person solo group departures in Amalfi, Kyoto, and Bali directly inside the Aviaj mobile app.',
        bgColor: AviajTheme.midnightNavy,
        textColor: Colors.white,
        btnColor: AviajTheme.sunsetTerracotta,
        btnTextColor: Colors.white,
        imageUrl:
            'https://images.unsplash.com/photo-1533105079780-92b9be482077?auto=format&fit=crop&w=800&q=80',
      ),
    ];

    return Container(
      width: double.infinity,
      color: AviajTheme.warmSand,
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 64 : 24,
        vertical: 64,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1240),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'ONE TRAVEL DATING APP. THREE WAYS TO EXPLORE TOGETHER.',
                style: TextStyle(
                  color: AviajTheme.sunsetTerracotta,
                  fontWeight: FontWeight.w900,
                  fontSize: 12.5,
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Designed for Romantic Co-Pilots, Solo Travel Buddies & Group Crews.',
                style: TextStyle(
                  color: AviajTheme.midnightNavy,
                  fontSize: 36,
                  fontWeight: FontWeight.w900,
                  height: 1.15,
                  letterSpacing: -0.8,
                ),
              ),
              const SizedBox(height: 32),
              Wrap(
                spacing: 24,
                runSpacing: 24,
                children: modes.map((m) {
                  return SizedBox(
                    width: isDesktop ? 380 : double.infinity,
                    child: Container(
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        color: m.bgColor,
                        borderRadius: BorderRadius.circular(32),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AviajNetworkImage(
                            imageUrl: m.imageUrl,
                            height: 220,
                            width: double.infinity,
                            fallbackLabel: m.badge,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(26),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: m.btnColor,
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: Text(
                                    m.badge,
                                    style: TextStyle(
                                      color: m.btnTextColor,
                                      fontWeight: FontWeight.w900,
                                      fontSize: 11,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  m.title,
                                  style: TextStyle(
                                    color: m.textColor,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w900,
                                    height: 1.2,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  m.description,
                                  style: TextStyle(
                                    color: m.textColor.withValues(alpha: 0.88),
                                    fontSize: 14,
                                    height: 1.45,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                FilledButton.icon(
                                  onPressed: () =>
                                      showMobileAppDownloadModal(context),
                                  style: FilledButton.styleFrom(
                                    backgroundColor: m.btnColor,
                                    foregroundColor: m.btnTextColor,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 18,
                                      vertical: 13,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                  ),
                                  icon: const Icon(
                                    Icons.download_rounded,
                                    size: 17,
                                  ),
                                  label: const Text(
                                    'Get on iOS & Android',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w900,
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

  /// Section 3: Solid Sunset Terracotta Banner highlighting Mobile-Only Features
  Widget _buildMobileAppFeaturesBanner(BuildContext context, bool isDesktop) {
    return Container(
      width: double.infinity,
      color: AviajTheme.sunsetTerracotta,
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 64 : 24,
        vertical: 56,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1240),
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
                      'EXCLUSIVELY IN THE AVIAJ MOBILE APP',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 12,
                        letterSpacing: 1.0,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Destination Radar Meets Verified Departure Lounge Dating.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 34,
                        fontWeight: FontWeight.w900,
                        height: 1.15,
                        letterSpacing: -0.8,
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Download the Aviaj mobile app on the App Store or Google Play to set your upcoming travel dates, send Priority Boarding Passes, and unlock free radar boosts with Rewarded Ads.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AppStoreDownloadBadges(lightOnDark: true),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      OutlinedButton.icon(
                        onPressed: () => showAdMobUnityConsoleModal(context),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(
                            color: Colors.white,
                            width: 1.8,
                          ),
                        ),
                        icon: const Icon(
                          Icons.monetization_on_rounded,
                          size: 17,
                        ),
                        label: const Text(
                          'AdMob & Unity Ads SDK',
                          style: TextStyle(fontWeight: FontWeight.w900),
                        ),
                      ),
                      const SizedBox(width: 10),
                      FilledButton.icon(
                        onPressed: widget.onOpenFullMobilePreview,
                        style: FilledButton.styleFrom(
                          backgroundColor: AviajTheme.midnightNavy,
                          foregroundColor: Colors.white,
                        ),
                        icon: const Icon(Icons.phone_iphone_rounded, size: 17),
                        label: const Text(
                          'Launch App Preview',
                          style: TextStyle(fontWeight: FontWeight.w900),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Section 4: Stripe Payment Gateway (`acct_1TNTVyJD1U0jWVOT`) Membership Tiers
  Widget _buildStripePricingSection(BuildContext context, bool isDesktop) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 64 : 24,
        vertical: 64,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1240),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(
                      color: const Color(0xFF635BFF),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'POWERED BY STRIPE • acct_1TNTVyJD1U0jWVOT',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Text(
                'Upgrade Your Travel Boarding Pass with Business & First Class™',
                style: TextStyle(
                  color: AviajTheme.midnightNavy,
                  fontSize: 34,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.8,
                ),
              ),
              const SizedBox(height: 28),
              Wrap(
                spacing: 24,
                runSpacing: 24,
                children: AviajStripeService.plans.map((plan) {
                  return SizedBox(
                    width: isDesktop ? 380 : double.infinity,
                    child: Container(
                      padding: const EdgeInsets.all(26),
                      decoration: BoxDecoration(
                        color: AviajTheme.warmSand,
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(
                          color: plan.badgeColor,
                          width: 2,
                        ),
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
                              borderRadius: BorderRadius.circular(14),
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
                          const SizedBox(height: 14),
                          Text(
                            plan.name,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              color: AviajTheme.midnightNavy,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            plan.interval == 'month'
                                ? '\$${plan.amountUsd.toStringAsFixed(2)} / month'
                                : '\$${plan.amountUsd.toStringAsFixed(2)} one-time',
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w900,
                              color: AviajTheme.sunsetTerracotta,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ...plan.perks.map(
                            (p) => Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(
                                    Icons.check_circle_rounded,
                                    color: AviajTheme.solidEmerald,
                                    size: 17,
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
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 18),
                          SizedBox(
                            width: double.infinity,
                            child: FilledButton.icon(
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
                                  borderRadius: BorderRadius.circular(18),
                                ),
                              ),
                              icon: const Icon(
                                Icons.credit_card_rounded,
                                size: 18,
                              ),
                              label: const Text(
                                'Subscribe via Stripe',
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

  /// Section 5: Solid Midnight Navy Footer with App Store & Google Play Store Download CTAs
  Widget _buildDownloadAndFooterSection(BuildContext context, bool isDesktop) {
    return Container(
      width: double.infinity,
      color: AviajTheme.midnightNavy,
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 64 : 24,
        vertical: 56,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1240),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 32,
                runSpacing: 24,
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 620),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'aviaj',
                          style: TextStyle(
                            color: AviajTheme.sunsetTerracotta,
                            fontSize: 36,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -1.0,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Download the Aviaj Mobile App on the App Store & Google Play.',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          'All co-pilot matching, destination radar, solo-group trip booking, and Departure Lounge chat functionality is built into the Aviaj iOS and Android apps.',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const AppStoreDownloadBadges(lightOnDark: false),
                ],
              ),
              const Divider(height: 48, color: Colors.white12),
              Wrap(
                spacing: 20,
                runSpacing: 10,
                alignment: WrapAlignment.spaceBetween,
                children: [
                  const Text(
                    '© 2026 Aviaj Inc. • Travel Buddy, Short-Term & Long-Term Travel Dating App',
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
      padding: const EdgeInsets.symmetric(horizontal: 6),
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

class _MiniPhoneCircleBtn extends StatelessWidget {
  final IconData icon;
  final Color bgColor;
  final Color fgColor;
  final VoidCallback onTap;

  const _MiniPhoneCircleBtn({
    required this.icon,
    required this.bgColor,
    required this.fgColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: Container(
        width: 46,
        height: 46,
        decoration: BoxDecoration(
          color: bgColor,
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: Icon(icon, color: fgColor, size: 22),
      ),
    );
  }
}

