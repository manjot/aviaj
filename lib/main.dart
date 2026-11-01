import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'screens/aviaj_landing_page.dart';
import 'screens/discover_screen.dart';
import 'screens/matchmaker_screen.dart';
import 'screens/messages_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/trips_screen.dart';
import 'services/ad_service.dart';
import 'services/stripe_service.dart';
import 'state/aviaj_state.dart';
import 'theme/app_theme.dart';
import 'widgets/common_widgets.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  AviajAdService.instance.initializeAll();
  runApp(const AviajApp());
}

class AviajApp extends StatefulWidget {
  /// Optional override for testing mobile mode vs landing page mode.
  final bool? forceMobileAppMode;

  const AviajApp({super.key, this.forceMobileAppMode});

  @override
  State<AviajApp> createState() => _AviajAppState();
}

class _AviajAppState extends State<AviajApp> {
  late final AviajState _state;
  late bool _showMobileAppExperience;

  @override
  void initState() {
    super.initState();
    _state = AviajState();
    // On Web (aviaj.com), default to the Aviaj travel-dating marketing landing page.
    // On native iOS & Android (!kIsWeb), boot directly into the full mobile app functionality.
    _showMobileAppExperience = widget.forceMobileAppMode ?? (!kIsWeb);
  }

  @override
  void dispose() {
    _state.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _state,
      builder: (context, _) {
        return MaterialApp(
          title: 'Aviaj — Solo & Group Travel Buddy & Romance Dating App',
          debugShowCheckedModeBanner: false,
          theme: AviajTheme.lightTheme(),
          darkTheme: AviajTheme.darkTheme(),
          themeMode: _state.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          home: _showMobileAppExperience
              ? AviajMobileAppShell(
                  state: _state,
                  onBackToLandingPage: null,
                )
              : AviajLandingPage(
                  state: _state,
                  onOpenFullMobilePreview: () {},
                ),
        );
      },
    );
  }
}

/// Full Mobile App Experience for iOS & Android (and Interactive Mobile Simulator on Web).
class AviajMobileAppShell extends StatelessWidget {
  final AviajState state;
  final VoidCallback? onBackToLandingPage;

  const AviajMobileAppShell({
    super.key,
    required this.state,
    this.onBackToLandingPage,
  });

  static const _navItems = [
    (
      icon: Icons.explore_outlined,
      activeIcon: Icons.explore_rounded,
      label: 'Discover',
    ),
    (
      icon: Icons.luggage_outlined,
      activeIcon: Icons.luggage_rounded,
      label: 'Trips',
    ),
    (
      icon: Icons.favorite_border_rounded,
      activeIcon: Icons.favorite_rounded,
      label: 'Co-Pilot',
    ),
    (
      icon: Icons.chat_bubble_outline_rounded,
      activeIcon: Icons.chat_bubble_rounded,
      label: 'Lounge',
    ),
    (
      icon: Icons.badge_outlined,
      activeIcon: Icons.badge_rounded,
      label: 'Passport',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final screens = [
      DiscoverScreen(state: state),
      TripsScreen(state: state),
      MatchmakerScreen(state: state),
      MessagesScreen(state: state),
      ProfileScreen(state: state),
    ];

    final mobileScaffold = Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(58),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : Colors.white,
            border: Border(
              bottom: BorderSide(
                color:
                    isDark ? const Color(0xFF334155) : const Color(0xFFE8E2D9),
                width: 1.5,
              ),
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: Row(
              children: [
                if (onBackToLandingPage != null) ...[
                  TextButton.icon(
                    onPressed: onBackToLandingPage,
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: AviajTheme.horizonTeal,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                    icon: const Icon(Icons.arrow_back_rounded, size: 16),
                    label: const Text(
                      'Web Landing',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                ],
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: AviajTheme.sunsetTerracotta,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.favorite_rounded,
                    color: Colors.white,
                    size: 19,
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'aviaj',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 21,
                    letterSpacing: -0.5,
                    color: AviajTheme.loveRed,
                  ),
                ),
                const Spacer(),
                IconButton(
                  tooltip: 'Business Class™ • Stripe Checkout',
                  onPressed: () => showStripeStorefrontModal(context),
                  icon: const Icon(
                    Icons.workspace_premium_rounded,
                    color: AviajTheme.loveRed,
                  ),
                ),
                IconButton(
                  tooltip: 'AdMob & Unity Ads Rewards',
                  onPressed: () => showAdMobUnityConsoleModal(context),
                  icon: const Icon(
                    Icons.monetization_on_rounded,
                    color: AviajTheme.compassAmber,
                  ),
                ),
                IconButton(
                  tooltip: 'Download on App Store & Google Play',
                  onPressed: () => showMobileAppDownloadModal(context),
                  icon: const Icon(
                    Icons.phone_iphone_rounded,
                    color: AviajTheme.horizonTeal,
                  ),
                ),
                IconButton(
                  tooltip: state.isDarkMode ? 'Light Mode' : 'Dark Mode',
                  onPressed: state.toggleDarkMode,
                  icon: Icon(
                    state.isDarkMode
                        ? Icons.light_mode_rounded
                        : Icons.dark_mode_rounded,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: IndexedStack(
        index: state.activeTabIndex,
        children: screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: state.activeTabIndex,
        onDestinationSelected: state.setActiveTab,
        destinations: _navItems
            .map(
              (item) => NavigationDestination(
                icon: Icon(item.icon),
                selectedIcon: Icon(
                  item.activeIcon,
                  color: AviajTheme.sunsetTerracotta,
                ),
                label: item.label,
              ),
            )
            .toList(),
      ),
    );

    return mobileScaffold;
  }
}
