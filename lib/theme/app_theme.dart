import 'package:flutter/material.dart';

/// Aviaj Solid-Color Travel & Romance Dating Brand Theme
/// Original Mediterranean Sunset Terracotta (#D95338), Aegean Horizon Teal (#0D6E6E),
/// Compass Sandstone Amber (#C98A2C), and Deep Midnight Navy (#0F172A).
/// Strictly flat solid colors — zero gradients and zero third-party dating brand colors.
class AviajTheme {
  // Primary solid travel-romance color: Mediterranean Sunset Terracotta
  static const Color sunsetTerracotta = Color(0xFFD95338);

  // Secondary solid travel color: Aegean Horizon Teal
  static const Color horizonTeal = Color(0xFF0D6E6E);

  // Solid Compass Sandstone Amber for First-Class & Priority Boarding badges
  static const Color compassAmber = Color(0xFFC98A2C);

  // Solid Deep Midnight Horizon Navy for high-contrast typography & cards
  static const Color midnightNavy = Color(0xFF0F172A);

  // Solid Warm Travertine Sand background
  static const Color warmSand = Color(0xFFFAF7F2);

  // Solid Soft Terracotta surface for pills & tags
  static const Color softTerracotta = Color(0xFFFCE8E3);

  // Solid Emerald for verified & match states
  static const Color solidEmerald = Color(0xFF059669);

  // Solid Aviation Sky Azure for destination radar & verified badges
  static const Color skyAzure = Color(0xFF0284C7);

  // Semantic aliases used across screens
  static const Color coralPrimary = sunsetTerracotta;
  static const Color loveCrimson = sunsetTerracotta;
  static const Color oceanTeal = horizonTeal;
  static const Color deepNavy = midnightNavy;
  static const Color obsidian = midnightNavy;
  static const Color roseRomance = sunsetTerracotta;
  static const Color goldPassport = compassAmber;
  static const Color sunsetOrange = compassAmber;
  static const Color passportBlue = skyAzure;
  static const Color warmCream = warmSand;
  static const Color sandLight = warmSand;
  static const Color softBlush = softTerracotta;

  static ThemeData lightTheme() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: sunsetTerracotta,
      primary: sunsetTerracotta,
      secondary: horizonTeal,
      tertiary: compassAmber,
      surface: Colors.white,
      brightness: Brightness.light,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: warmSand,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: midnightNavy,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
          side: const BorderSide(color: Color(0xFFE8E2D9), width: 1.5),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFF4EFEA),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Color(0xFFE2DAD0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: sunsetTerracotta, width: 2),
        ),
      ),
    );
  }

  static ThemeData darkTheme() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: sunsetTerracotta,
      primary: sunsetTerracotta,
      secondary: horizonTeal,
      tertiary: compassAmber,
      surface: const Color(0xFF1E293B),
      brightness: Brightness.dark,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: midnightNavy,
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1E293B),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        color: const Color(0xFF1E293B),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
          side: const BorderSide(color: Color(0xFF334155), width: 1.5),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF263349),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Color(0xFF3B4C66)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: sunsetTerracotta, width: 2),
        ),
      ),
    );
  }
}
