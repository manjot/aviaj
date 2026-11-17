import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'screens/aviaj_landing_page.dart';
import 'screens/discover_screen.dart';
import 'screens/expedition_planner_screen.dart';
import 'screens/messages_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/trips_screen.dart';
import 'services/ad_service.dart';
import 'state/aviaj_state.dart';
import 'theme/app_theme.dart';

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
      icon: Icons.terrain_outlined,
      activeIcon: Icons.terrain_rounded,
      label: 'Expeditions',
    ),
    (
      icon: Icons.calculate_outlined,
      activeIcon: Icons.calculate_rounded,
      label: 'Planner',
    ),
    (
      icon: Icons.groups_outlined,
      activeIcon: Icons.groups_rounded,
      label: 'Co-Pilots',
    ),
    (
      icon: Icons.forum_outlined,
      activeIcon: Icons.forum_rounded,
      label: 'Crew Chat',
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
      TripsScreen(state: state),
      ExpeditionPlannerScreen(state: state),
      DiscoverScreen(state: state),
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
                  tooltip: 'Altitude & Expense Planner',
                  onPressed: () => state.setActiveTab(1),
                  icon: const Icon(
                    Icons.calculate_rounded,
                    color: AviajTheme.horizonTeal,
                  ),
                ),
                IconButton(
                  tooltip: 'Community Safety, UGC Policy & EULA',
                  onPressed: () => _showCommunitySafetyDialog(context),
                  icon: const Icon(
                    Icons.verified_user_rounded,
                    color: AviajTheme.loveRed,
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
      body: Column(
        children: [
          Expanded(
            child: IndexedStack(
              index: state.activeTabIndex,
              children: screens,
            ),
          ),
        ],
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

  void _showCommunitySafetyDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.verified_user_rounded, color: AviajTheme.loveRed),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Aviaj Expedition Safety & Community EULA',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
                ),
              ),
            ],
          ),
          content: const SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Zero Tolerance for Objectionable Content or Harassment',
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
                SizedBox(height: 6),
                Text(
                  '• All expedition hosts and co-travellers must adhere to the Aviaj End-User License Agreement (EULA) and Community Guidelines.\n'
                  '• You can immediately Report or Block any user from their Co-Pilot profile or Crew Chat header. Blocked users are permanently removed from your feed and conversations.\n'
                  '• Reported content is reviewed by our Trust & Safety team within 24 hours, and offending accounts are ejected.\n'
                  '• You can delete your account and erase all local data at any time in the Passport tab.',
                  style: TextStyle(fontSize: 13, height: 1.45),
                ),
              ],
            ),
          ),
          actions: [
            FilledButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('I Understand & Agree'),
            ),
          ],
        );
      },
    );
  }
}
