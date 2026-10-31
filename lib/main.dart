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
          title: 'Aviaj — Single Love & Relationship Travel App',
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
      icon: Icons.local_fire_department_outlined,
      activeIcon: Icons.local_fire_department_rounded,
      label: 'Swipe & Date',
    ),
    (
      icon: Icons.luggage_outlined,
      activeIcon: Icons.luggage_rounded,
      label: 'Singles Trips',
    ),
    (
      icon: Icons.favorite_border_rounded,
      activeIcon: Icons.favorite_rounded,
      label: 'Love Match',
    ),
    (
      icon: Icons.chat_bubble_outline_rounded,
      activeIcon: Icons.chat_bubble_rounded,
      label: 'First Moves',
    ),
    (
      icon: Icons.badge_outlined,
      activeIcon: Icons.badge_rounded,
      label: 'Passport',
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
        preferredSize: const Size.fromHeight(70),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1C1C22) : Colors.white,
            border: Border(
              bottom: BorderSide(
                color:
                    isDark ? const Color(0xFF2D2D38) : const Color(0xFFF0E4E6),
                width: 1.5,
              ),
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: Row(
              children: [
                // Solid-Color Single-Love Brand Logo
                Flexible(
                  child: InkWell(
                    onTap: () => state.setActiveTab(0),
                    borderRadius: BorderRadius.circular(14),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: AviajTheme.loveCrimson,
                            borderRadius: BorderRadius.circular(13),
                          ),
                          child: const Icon(
                            Icons.favorite_rounded,
                            color: Colors.white,
                            size: 23,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Flexible(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'aviaj',
                                style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 22,
                                  letterSpacing: -0.5,
                                  color: AviajTheme.loveCrimson,
                                  height: 1.0,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                'Single Love • Travel Dating',
                                style: TextStyle(
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w800,
                                  color: isDark
                                      ? Colors.white70
                                      : AviajTheme.obsidian,
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
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(_navItems.length, (idx) {
                      final item = _navItems[idx];
                      final isSelected = state.activeTabIndex == idx;
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 3),
                        child: TextButton.icon(
                          onPressed: () => state.setActiveTab(idx),
                          style: TextButton.styleFrom(
                            backgroundColor: isSelected
                                ? AviajTheme.loveCrimson
                                : Colors.transparent,
                            foregroundColor: isSelected
                                ? Colors.white
                                : (isDark
                                    ? Colors.white70
                                    : AviajTheme.obsidian),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 13,
                              vertical: 10,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                          ),
                          icon: Icon(
                            isSelected ? item.activeIcon : item.icon,
                            size: 18,
                          ),
                          label: Text(
                            item.label,
                            style: TextStyle(
                              fontWeight: isSelected
                                  ? FontWeight.w900
                                  : FontWeight.w700,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                const Spacer(),
                if (screenWidth >= 680) ...[
                  FilledButton.icon(
                    onPressed: () => showMobileAppDownloadModal(context),
                    style: FilledButton.styleFrom(
                      backgroundColor: AviajTheme.obsidian,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    icon: const Icon(Icons.phone_iphone_rounded, size: 16),
                    label: const Text(
                      'Get the App',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 12.5,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
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
                        color: AviajTheme.loveCrimson,
                      ),
                      label: item.label,
                    ),
                  )
                  .toList(),
            ),
    );
  }
}
