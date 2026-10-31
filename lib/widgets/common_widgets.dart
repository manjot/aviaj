import 'package:flutter/material.dart';
import '../models/models.dart';
import '../state/aviaj_state.dart';
import '../theme/app_theme.dart';

class AviajNetworkImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final String fallbackLabel;

  const AviajNetworkImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.fallbackLabel = 'Aviaj',
  });

  @override
  Widget build(BuildContext context) {
    final child = Image.network(
      imageUrl,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          width: width,
          height: height,
          color: AviajTheme.horizonTeal,
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.flight_takeoff_rounded,
                color: Colors.white,
                size: 36,
              ),
              const SizedBox(height: 6),
              Text(
                fallbackLabel,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 13,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );

    if (borderRadius != null) {
      return ClipRRect(
        borderRadius: borderRadius!,
        child: child,
      );
    }
    return child;
  }
}

class IntentBadge extends StatelessWidget {
  final ConnectionIntent intent;
  final bool compact;
  final bool solid;

  const IntentBadge({
    super.key,
    required this.intent,
    this.compact = false,
    this.solid = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = intent.color;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 10 : 13,
        vertical: compact ? 5 : 6,
      ),
      decoration: BoxDecoration(
        color: solid ? color : color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: solid ? color : color.withValues(alpha: 0.45),
          width: 1.2,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            intent.icon,
            size: compact ? 13 : 15,
            color: solid ? Colors.white : color,
          ),
          const SizedBox(width: 5),
          Text(
            intent.label,
            style: TextStyle(
              color: solid ? Colors.white : color,
              fontWeight: FontWeight.w800,
              fontSize: compact ? 11.5 : 12.5,
              letterSpacing: 0.1,
            ),
          ),
        ],
      ),
    );
  }
}

class CompatibilityPill extends StatelessWidget {
  final int score;

  const CompatibilityPill({super.key, required this.score});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
      decoration: BoxDecoration(
        color: AviajTheme.sunsetTerracotta,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.favorite_rounded, color: Colors.white, size: 13),
          const SizedBox(width: 5),
          Text(
            '$score% Co-Pilot Match',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

/// Official-style solid App Store & Google Play Store download buttons.
class AppStoreDownloadBadges extends StatelessWidget {
  final bool lightOnDark;
  final bool compact;

  const AppStoreDownloadBadges({
    super.key,
    this.lightOnDark = true,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 10,
      children: [
        _StoreButton(
          icon: Icons.apple_rounded,
          topLabel: 'Download on the',
          storeName: 'App Store',
          lightOnDark: lightOnDark,
          compact: compact,
          onTap: () => showMobileAppDownloadModal(
            context,
            initialStore: 'Apple App Store (iOS)',
          ),
        ),
        _StoreButton(
          icon: Icons.play_arrow_rounded,
          topLabel: 'GET IT ON',
          storeName: 'Google Play',
          lightOnDark: lightOnDark,
          compact: compact,
          onTap: () => showMobileAppDownloadModal(
            context,
            initialStore: 'Google Play Store (Android)',
          ),
        ),
      ],
    );
  }
}

class _StoreButton extends StatelessWidget {
  final IconData icon;
  final String topLabel;
  final String storeName;
  final bool lightOnDark;
  final bool compact;
  final VoidCallback onTap;

  const _StoreButton({
    required this.icon,
    required this.topLabel,
    required this.storeName,
    required this.lightOnDark,
    required this.compact,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = lightOnDark ? AviajTheme.midnightNavy : Colors.white;
    final fgColor = lightOnDark ? Colors.white : AviajTheme.midnightNavy;
    final borderColor = lightOnDark
        ? Colors.white24
        : AviajTheme.midnightNavy.withValues(alpha: 0.2);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: compact ? 14 : 18,
          vertical: compact ? 8 : 11,
        ),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor, width: 1.5),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: fgColor, size: compact ? 24 : 30),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  topLabel,
                  style: TextStyle(
                    color: fgColor.withValues(alpha: 0.8),
                    fontSize: compact ? 9.5 : 10.5,
                    fontWeight: FontWeight.w600,
                    height: 1.1,
                  ),
                ),
                Text(
                  storeName,
                  style: TextStyle(
                    color: fgColor,
                    fontSize: compact ? 14 : 16.5,
                    fontWeight: FontWeight.w900,
                    height: 1.15,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Modal allowing users to download the Aviaj iOS & Android app via App Store, Google Play, QR code, or SMS link.
Future<void> showMobileAppDownloadModal(
  BuildContext context, {
  String initialStore = 'Apple App Store & Google Play',
}) async {
  final phoneCtrl = TextEditingController();
  bool linkSent = false;

  await showDialog<void>(
    context: context,
    builder: (ctx) {
      return StatefulBuilder(
        builder: (context, setModalState) {
          return Dialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32),
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 540),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Solid brand top pill
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AviajTheme.horizonTeal,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.phone_iphone_rounded,
                                color: Colors.white,
                                size: 15,
                              ),
                              SizedBox(width: 6),
                              Text(
                                'AVIAJ MOBILE APP • iOS & ANDROID',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 11,
                                  letterSpacing: 0.7,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () => Navigator.of(ctx).pop(),
                          icon: const Icon(
                            Icons.close_rounded,
                            color: AviajTheme.midnightNavy,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'Meet Your Next Co-Pilot. Travel Together. Fall in Love Abroad.',
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.w900,
                        color: AviajTheme.midnightNavy,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Selected: $initialStore • Rated 4.9 ★ by 140,000+ solo & group travellers worldwide.',
                      style: const TextStyle(
                        fontSize: 13.5,
                        color: Color(0xFF555560),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // QR code + App Features Row
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: AviajTheme.warmSand,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: AviajTheme.softTerracotta,
                          width: 2,
                        ),
                      ),
                      child: Wrap(
                        spacing: 20,
                        runSpacing: 16,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Container(
                            width: 116,
                            height: 116,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AviajTheme.midnightNavy,
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.qr_code_2_rounded,
                                  color: Colors.white,
                                  size: 68,
                                ),
                                Text(
                                  'SCAN TO GET APP',
                                  style: TextStyle(
                                    color: AviajTheme.compassAmber,
                                    fontSize: 8.5,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 310),
                            child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _AppFeatureBullet(
                                  icon: Icons.public_rounded,
                                  color: AviajTheme.horizonTeal,
                                  text:
                                      'Aviaj Destination Radar: Connect in Kyoto, Amalfi, or Bali before your flight departs.',
                                ),
                                SizedBox(height: 8),
                                _AppFeatureBullet(
                                  icon: Icons.airplane_ticket_rounded,
                                  color: AviajTheme.sunsetTerracotta,
                                  text:
                                      'Departure Prompts & Boarding Date Invites for real romantic travel chemistry.',
                                ),
                                SizedBox(height: 8),
                                _AppFeatureBullet(
                                  icon: Icons.verified_user_rounded,
                                  color: AviajTheme.solidEmerald,
                                  text:
                                      'Photo + Passport Verified Solo Travellers & Curated Villa Crews.',
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    // Direct Store Download Buttons
                    Row(
                      children: [
                        Expanded(
                          child: FilledButton.icon(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  backgroundColor: AviajTheme.midnightNavy,
                                  content: Text(
                                    'Apple App Store Production Listing: com.aviaj.aviaj (iOS v1.0.0+1)',
                                  ),
                                ),
                              );
                            },
                            style: FilledButton.styleFrom(
                              backgroundColor: AviajTheme.midnightNavy,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            icon: const Icon(Icons.apple_rounded, size: 22),
                            label: const Text(
                              'App Store (iOS)',
                              style: TextStyle(fontWeight: FontWeight.w800),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: FilledButton.icon(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  backgroundColor: AviajTheme.sunsetTerracotta,
                                  content: Text(
                                    'Google Play Production Release: com.aviaj.aviaj (aviaj.com/downloads/aviaj-release.apk)',
                                  ),
                                ),
                              );
                            },
                            style: FilledButton.styleFrom(
                              backgroundColor: AviajTheme.sunsetTerracotta,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            icon:
                                const Icon(Icons.play_arrow_rounded, size: 22),
                            label: const Text(
                              'Google Play (APK)',
                              style: TextStyle(fontWeight: FontWeight.w800),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      'Or text/email yourself the direct download link:',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 13,
                        color: AviajTheme.midnightNavy,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: phoneCtrl,
                            decoration: const InputDecoration(
                              hintText: '+1 (555) 019-2834 or you@email.com',
                              prefixIcon: Icon(Icons.sms_outlined, size: 18),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        FilledButton(
                          onPressed: () {
                            setModalState(() {
                              linkSent = true;
                            });
                          },
                          style: FilledButton.styleFrom(
                            backgroundColor: AviajTheme.compassAmber,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Text(
                            linkSent ? 'Link Sent ✓' : 'Send Link',
                            style: const TextStyle(fontWeight: FontWeight.w900),
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

class _AppFeatureBullet extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String text;

  const _AppFeatureBullet({
    required this.icon,
    required this.color,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
              color: AviajTheme.midnightNavy,
              height: 1.3,
            ),
          ),
        ),
      ],
    );
  }
}

class GlobalIntentFilterBar extends StatelessWidget {
  final AviajState state;
  final String searchHint;

  const GlobalIntentFilterBar({
    super.key,
    required this.state,
    this.searchHint =
        'Destination Radar: Kyoto, Amalfi, Bali, Paris, or traveller name...',
  });

  static const List<String> _radarCities = [
    'All Destinations',
    'Amalfi',
    'Kyoto',
    'Bali',
    'Patagonia',
    'Madeira',
    'Mendoza',
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        border: Border(
          bottom: BorderSide(
            color: isDark ? const Color(0xFF334155) : const Color(0xFFE8E2D9),
          ),
        ),
      ),
      child: Row(
        children: [
          // Compact Search Input
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 260),
            child: SizedBox(
              height: 38,
              child: TextField(
                onChanged: state.setSearchQuery,
                style: const TextStyle(fontSize: 13),
                decoration: InputDecoration(
                  hintText: 'Search city or name...',
                  hintStyle: const TextStyle(fontSize: 12.5),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                  prefixIcon: const Icon(
                    Icons.search_rounded,
                    color: AviajTheme.horizonTeal,
                    size: 18,
                  ),
                  suffixIcon: state.searchQuery.isNotEmpty
                      ? IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: () => state.setSearchQuery(''),
                          icon: const Icon(Icons.close_rounded, size: 15),
                        )
                      : null,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Inline Single-Row Intent Pills
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _FilterChipItem(
                    label: 'All Modes',
                    icon: Icons.explore_rounded,
                    isSelected: state.selectedIntentFilter == null,
                    activeColor: AviajTheme.horizonTeal,
                    onTap: () => state.setIntentFilter(null),
                  ),
                  const SizedBox(width: 6),
                  ...ConnectionIntent.values.map(
                    (intent) => Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: _FilterChipItem(
                        label: intent.label,
                        icon: intent.icon,
                        isSelected: state.selectedIntentFilter == intent,
                        activeColor: intent.color,
                        onTap: () => state.setIntentFilter(
                          state.selectedIntentFilter == intent ? null : intent,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Compact Destination Radar City Switcher
          PopupMenuButton<String>(
            tooltip: 'Switch Destination Radar City',
            onSelected: (city) {
              if (city == 'All Destinations') {
                state.setSearchQuery('');
              } else {
                state.setSearchQuery(city);
              }
            },
            itemBuilder: (ctx) => _radarCities
                .map(
                  (c) => PopupMenuItem<String>(
                    value: c,
                    child: Row(
                      children: [
                        const Icon(
                          Icons.place_rounded,
                          size: 17,
                          color: AviajTheme.sunsetTerracotta,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          c,
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AviajTheme.midnightNavy,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.flight_takeoff_rounded,
                    color: AviajTheme.compassAmber,
                    size: 15,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    state.searchQuery.isEmpty ? 'Radar' : state.searchQuery,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChipItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final Color activeColor;
  final VoidCallback onTap;

  const _FilterChipItem({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.activeColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? activeColor
              : (isDark ? const Color(0xFF263349) : const Color(0xFFF4EFEA)),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isSelected
                ? activeColor
                : (isDark ? const Color(0xFF3B4C66) : const Color(0xFFE2DAD0)),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected
                  ? Colors.white
                  : (isDark ? Colors.white70 : AviajTheme.midnightNavy),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: isSelected
                    ? Colors.white
                    : (isDark ? Colors.white : AviajTheme.midnightNavy),
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w700,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> showBoardingMatchModal({
  required BuildContext context,
  required TravellerProfile profile,
  required bool isSuperBoardingPass,
  required AviajState state,
}) async {
  final noteController = TextEditingController();
  await showDialog<void>(
    context: context,
    builder: (ctx) {
      return Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 460),
          child: Padding(
            padding: const EdgeInsets.all(26),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Solid Aviaj Boarding Match Header Pill
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                  decoration: BoxDecoration(
                    color: isSuperBoardingPass
                        ? AviajTheme.compassAmber
                        : AviajTheme.horizonTeal,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isSuperBoardingPass
                            ? Icons.airplane_ticket_rounded
                            : Icons.favorite_rounded,
                        color: Colors.white,
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        isSuperBoardingPass
                            ? 'PRIORITY BOARDING PASS • INSTANT MATCH!'
                            : 'CO-PILOT & TRAVEL ROMANCE MATCH!',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 11.5,
                          letterSpacing: 0.6,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 42,
                      backgroundColor: AviajTheme.horizonTeal,
                      child: ClipOval(
                        child: AviajNetworkImage(
                          imageUrl: state.currentUser.imageUrl,
                          width: 80,
                          height: 80,
                          fallbackLabel: state.currentUser.name,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                          color: AviajTheme.softTerracotta,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.flight_takeoff_rounded,
                          color: AviajTheme.sunsetTerracotta,
                          size: 24,
                        ),
                      ),
                    ),
                    CircleAvatar(
                      radius: 42,
                      backgroundColor: profile.primaryIntent.color,
                      child: ClipOval(
                        child: AviajNetworkImage(
                          imageUrl: profile.imageUrl,
                          width: 80,
                          height: 80,
                          fallbackLabel: profile.name,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'You & ${profile.name} Are Co-Pilots!',
                  style: const TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.w900,
                    color: AviajTheme.midnightNavy,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 6),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    color: AviajTheme.compassAmber,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    '✈️ Departure Lounge Unlocked: Plan Your Trip Together!',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 11.5,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Shared Destination: ${profile.nextDestination} (${profile.nextTripWindow})',
                  style: const TextStyle(
                    color: Color(0xFF555560),
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 14),
                if (profile.prompts.isNotEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AviajTheme.warmSand,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AviajTheme.softTerracotta),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${profile.name.split(' ').first}’s Travel Icebreaker:',
                          style: const TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w900,
                            color: AviajTheme.sunsetTerracotta,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          '“${profile.prompts.first.question} — ${profile.prompts.first.answer}”',
                          style: const TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                            color: AviajTheme.midnightNavy,
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 14),
                TextField(
                  controller: noteController,
                  decoration: InputDecoration(
                    hintText:
                        'Send a travel note to ${profile.name.split(' ').first}...',
                    prefixIcon: const Icon(
                      Icons.send_rounded,
                      size: 18,
                      color: AviajTheme.sunsetTerracotta,
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(ctx).pop(),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text('Keep Exploring'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: () {
                          if (noteController.text.trim().isNotEmpty) {
                            state.sendMessage(
                              profile.id,
                              noteController.text.trim(),
                            );
                          }
                          state.selectConversation(profile.id);
                          Navigator.of(ctx).pop();
                          state.setActiveTab(3);
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: AviajTheme.sunsetTerracotta,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        icon: const Icon(Icons.chat_bubble_rounded, size: 18),
                        label: const Text('Open Lounge Chat'),
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
}
