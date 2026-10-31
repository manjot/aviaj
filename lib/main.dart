import 'package:flutter/material.dart';
import 'screens/discover_screen.dart';
import 'screens/matchmaker_screen.dart';
import 'screens/messages_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/trips_screen.dart';
import 'state/aviaj_state.dart';
import 'theme/app_theme.dart';
import 'widgets/common_widgets.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const AviajApp());
}

class AviajApp extends StatefulWidget {
  const AviajApp({super.key});

  @override
  State<AviajApp> createState() => _AviajAppState();
}

class _AviajAppState extends State<AviajApp> {
  late final AviajState _state;

  @override
  void initState() {
    super.initState();
    _state = AviajState();
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
          title: 'Aviaj — Solo & Group Travel Buddy & Dating App',
          debugShowCheckedModeBanner: false,
          theme: AviajTheme.lightTheme(),
          darkTheme: AviajTheme.darkTheme(),
          themeMode: _state.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          home: AviajHomeShell(state: _state),
        );
      },
    );
  }
}

class AviajHomeShell extends StatelessWidget {
  final AviajState state;

  const AviajHomeShell({super.key, required this.state});

  static const _navItems = [
    (
      icon: Icons.explore_outlined,
      activeIcon: Icons.explore_rounded,
      label: 'Discover & Date',
    ),
    (
      icon: Icons.luggage_outlined,
      activeIcon: Icons.luggage_rounded,
      label: 'Solo & Group Trips',
    ),
    (
      icon: Icons.compass_calibration_outlined,
      activeIcon: Icons.compass_calibration_rounded,
      label: 'Compass Match',
    ),
    (
      icon: Icons.forum_outlined,
      activeIcon: Icons.forum_rounded,
      label: 'Lounge Chat',
    ),
    (
      icon: Icons.badge_outlined,
      activeIcon: Icons.badge_rounded,
      label: 'My Passport',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktopWeb = screenWidth >= 900;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final screens = [
      DiscoverScreen(state: state),
      TripsScreen(state: state),
      MatchmakerScreen(state: state),
      MessagesScreen(state: state),
      ProfileScreen(state: state),
    ];

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(68),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF151F32) : Colors.white,
            border: Border(
              bottom: BorderSide(
                color: isDark ? const Color(0xFF26334D) : Colors.grey.shade200,
              ),
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: Row(
              children: [
                // Brand Logo
                Flexible(
                  child: InkWell(
                    onTap: () => state.setActiveTab(0),
                    borderRadius: BorderRadius.circular(14),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                AviajTheme.coralPrimary,
                                AviajTheme.sunsetOrange,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.flight_takeoff_rounded,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Flexible(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'AVIAJ',
                                style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 19,
                                  letterSpacing: 1.2,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                'Travel Buddy • Dating',
                                style: TextStyle(
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey.shade500,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                if (isDesktopWeb)
                  Flexible(
                    flex: 3,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(_navItems.length, (idx) {
                          final item = _navItems[idx];
                          final isSelected = state.activeTabIndex == idx;
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: TextButton.icon(
                              onPressed: () => state.setActiveTab(idx),
                              style: TextButton.styleFrom(
                                backgroundColor: isSelected
                                    ? AviajTheme.coralPrimary
                                        .withValues(alpha: 0.12)
                                    : Colors.transparent,
                                foregroundColor: isSelected
                                    ? AviajTheme.coralPrimary
                                    : (isDark
                                        ? Colors.white70
                                        : Colors.grey.shade800),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 10,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              icon: Icon(
                                isSelected ? item.activeIcon : item.icon,
                                size: 19,
                              ),
                              label: Text(
                                item.label,
                                style: TextStyle(
                                  fontWeight: isSelected
                                      ? FontWeight.w800
                                      : FontWeight.w600,
                                  fontSize: 13.5,
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                const Spacer(),
                if (screenWidth >= 680) ...[
                  IntentBadge(
                    intent: state.currentUser.primaryIntent,
                    compact: true,
                  ),
                  const SizedBox(width: 10),
                ],
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
      bottomNavigationBar: isDesktopWeb
          ? null
          : NavigationBar(
              selectedIndex: state.activeTabIndex,
              onDestinationSelected: state.setActiveTab,
              destinations: _navItems
                  .map(
                    (item) => NavigationDestination(
                      icon: Icon(item.icon),
                      selectedIcon: Icon(
                        item.activeIcon,
                        color: AviajTheme.coralPrimary,
                      ),
                      label: item.label,
                    ),
                  )
                  .toList(),
            ),
    );
  }
}
