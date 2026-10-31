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
          color: AviajTheme.loveCrimson,
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.favorite_rounded,
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
        color: AviajTheme.loveCrimson,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.favorite_rounded, color: Colors.white, size: 13),
          const SizedBox(width: 5),
          Text(
            '$score% Love Match',
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
    final bgColor = lightOnDark ? AviajTheme.obsidian : Colors.white;
    final fgColor = lightOnDark ? Colors.white : AviajTheme.obsidian;
    final borderColor =
        lightOnDark ? Colors.white24 : AviajTheme.obsidian.withValues(alpha: 0.2);

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
                            color: AviajTheme.loveCrimson,
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
                            color: AviajTheme.obsidian,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'Swipe Destinations. Make the First Move. Fall in Love Abroad.',
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.w900,
                        color: AviajTheme.obsidian,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Selected: $initialStore • Rated 4.9 ★ by 140,000+ single solo & group travellers worldwide.',
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
                        color: AviajTheme.warmCream,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: AviajTheme.softBlush, width: 2),
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
                              color: AviajTheme.obsidian,
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
                                    color: AviajTheme.bumbleHoney,
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
                                  color: AviajTheme.passportBlue,
                                  text:
                                      'Tinder-Style Passport™: Match in Kyoto, Amalfi, or Bali before you fly.',
                                ),
                                SizedBox(height: 8),
                                _AppFeatureBullet(
                                  icon: Icons.bolt_rounded,
                                  color: AviajTheme.obsidian,
                                  text:
                                      'Bumble-Style 24h First Move & Opening Moves for real romantic spark.',
                                ),
                                SizedBox(height: 8),
                                _AppFeatureBullet(
                                  icon: Icons.verified_user_rounded,
                                  color: AviajTheme.solidEmerald,
                                  text:
                                      'Photo + Passport Verified Singles & Solo Group Villa Crews.',
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
                                  backgroundColor: AviajTheme.obsidian,
                                  content: Text(
                                    'Redirecting to Apple App Store: Aviaj — Single Love & Travel Dating (iOS)...',
                                  ),
                                ),
                              );
                            },
                            style: FilledButton.styleFrom(
                              backgroundColor: AviajTheme.obsidian,
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
                                  backgroundColor: AviajTheme.loveCrimson,
                                  content: Text(
                                    'Redirecting to Google Play Store: Aviaj — Single Love & Travel Dating (Android)...',
                                  ),
                                ),
                              );
                            },
                            style: FilledButton.styleFrom(
                              backgroundColor: AviajTheme.loveCrimson,
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
                        color: AviajTheme.obsidian,
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
                            backgroundColor: AviajTheme.bumbleHoney,
                            foregroundColor: AviajTheme.obsidian,
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
              color: AviajTheme.obsidian,
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
        'Passport™ Search: Kyoto, Amalfi, Bali, Paris, or traveller name...',
  });

  static const List<String> _passportCities = [
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
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1C1C22) : Colors.white,
        border: Border(
          bottom: BorderSide(
            color: isDark ? const Color(0xFF2D2D38) : const Color(0xFFF0E4E6),
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  onChanged: state.setSearchQuery,
                  decoration: InputDecoration(
                    hintText: searchHint,
                    prefixIcon: const Icon(
                      Icons.flight_takeoff_rounded,
                      color: AviajTheme.loveCrimson,
                    ),
                    suffixIcon: state.searchQuery.isNotEmpty
                        ? IconButton(
                            onPressed: () => state.setSearchQuery(''),
                            icon: const Icon(Icons.close_rounded, size: 18),
                          )
                        : null,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              // Tinder-style Passport™ Location Switcher
              PopupMenuButton<String>(
                tooltip: 'Teleport Passport™ Location',
                onSelected: (city) {
                  if (city == 'All Destinations') {
                    state.setSearchQuery('');
                  } else {
                    state.setSearchQuery(city);
                  }
                },
                itemBuilder: (ctx) => _passportCities
                    .map(
                      (c) => PopupMenuItem<String>(
                        value: c,
                        child: Row(
                          children: [
                            const Icon(
                              Icons.place_rounded,
                              size: 18,
                              color: AviajTheme.loveCrimson,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              c,
                              style:
                                  const TextStyle(fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 13,
                  ),
                  decoration: BoxDecoration(
                    color: AviajTheme.obsidian,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.public_rounded,
                        color: AviajTheme.bumbleHoney,
                        size: 18,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        state.searchQuery.isEmpty
                            ? 'Passport™ Mode'
                            : state.searchQuery,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 12.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (state.selectedIntentFilter != null ||
                  state.selectedStyleFilter != null ||
                  state.searchQuery.isNotEmpty) ...[
                const SizedBox(width: 8),
                TextButton.icon(
                  onPressed: state.clearFilters,
                  icon: const Icon(Icons.restart_alt_rounded, size: 18),
                  label: const Text('Reset'),
                ),
              ],
            ],
          ),
          const SizedBox(height: 12),
          // Bumble-style Mode Switcher Pills (Solid Colors)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _FilterChipItem(
                  label: 'All Single Love & Travel Modes',
                  icon: Icons.favorite_rounded,
                  isSelected: state.selectedIntentFilter == null,
                  activeColor: AviajTheme.loveCrimson,
                  onTap: () => state.setIntentFilter(null),
                ),
                const SizedBox(width: 8),
                ...ConnectionIntent.values.map(
                  (intent) => Padding(
                    padding: const EdgeInsets.only(right: 8),
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
              : (isDark ? const Color(0xFF25252E) : const Color(0xFFF6F1F2)),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isSelected
                ? activeColor
                : (isDark ? const Color(0xFF353542) : const Color(0xFFE6DCDF)),
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
                  : (isDark ? Colors.white70 : AviajTheme.obsidian),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: isSelected
                    ? Colors.white
                    : (isDark ? Colors.white : AviajTheme.obsidian),
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
                // Solid Bumble/Tinder Match Header Pill
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                  decoration: BoxDecoration(
                    color: isSuperBoardingPass
                        ? AviajTheme.bumbleHoney
                        : AviajTheme.loveCrimson,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isSuperBoardingPass
                            ? Icons.star_rounded
                            : Icons.favorite_rounded,
                        color: isSuperBoardingPass
                            ? AviajTheme.obsidian
                            : Colors.white,
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        isSuperBoardingPass
                            ? 'SUPER BOARDING PASS • FIRST MOVE UNLOCKED!'
                            : 'IT’S A TRAVEL LOVE MATCH!',
                        style: TextStyle(
                          color: isSuperBoardingPass
                              ? AviajTheme.obsidian
                              : Colors.white,
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
                      backgroundColor: AviajTheme.loveCrimson,
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
                          color: AviajTheme.softBlush,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.favorite_rounded,
                          color: AviajTheme.loveCrimson,
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
                  'You & ${profile.name} Matched!',
                  style: const TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.w900,
                    color: AviajTheme.obsidian,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 6),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    color: AviajTheme.bumbleHoney,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    '⏱ 24h Bumble Timer Active: Make the First Move!',
                    style: TextStyle(
                      color: AviajTheme.obsidian,
                      fontWeight: FontWeight.w900,
                      fontSize: 11.5,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Destination Match: ${profile.nextDestination} (${profile.nextTripWindow})',
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
                      color: AviajTheme.warmCream,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AviajTheme.softBlush),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${profile.name.split(' ').first}’s Opening Move:',
                          style: const TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w900,
                            color: AviajTheme.loveCrimson,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          '“${profile.prompts.first.question} — ${profile.prompts.first.answer}”',
                          style: const TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                            color: AviajTheme.obsidian,
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
                        'Reply to ${profile.name.split(' ').first}’s Opening Move...',
                    prefixIcon: const Icon(
                      Icons.send_rounded,
                      size: 18,
                      color: AviajTheme.loveCrimson,
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
                        child: const Text('Keep Swiping'),
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
                          backgroundColor: AviajTheme.loveCrimson,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        icon: const Icon(Icons.chat_bubble_rounded, size: 18),
                        label: const Text('Make First Move'),
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
