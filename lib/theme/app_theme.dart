import 'package:flutter/material.dart';

/// Aviaj Solid-Color Single Love & Relationship Travel Brand Theme
/// Combining the bold romantic energy of Tinder (#FE3C72) and Bumble (#FFC629 / #121216)
/// using strictly SOLID flat brand colors (no gradients).
class AviajTheme {
  // Primary solid brand color: Love Crimson (Tinder-inspired romantic solid red-pink)
  static const Color loveCrimson = Color(0xFFFF2E55);

  // Bumble-inspired solid Honey Gold for "First Move" & 24h timers
  static const Color bumbleHoney = Color(0xFFFFC629);

  // Solid Deep Charcoal / Obsidian for high-contrast typography & cards
  static const Color obsidian = Color(0xFF141418);

  // Solid Warm Cream background
  static const Color warmCream = Color(0xFFFFF8F6);

  // Solid Soft Blush surface for pills & tags
  static const Color softBlush = Color(0xFFFFE4E9);

  // Solid Emerald for verified & match states
  static const Color solidEmerald = Color(0xFF00B87C);

  // Solid Electric Blue for Tinder-style Passport™ Teleport & Super Like
  static const Color passportBlue = Color(0xFF1DA1F2);

  // Backward-compatible aliases so all screens share the solid palette
  static const Color coralPrimary = loveCrimson;
  static const Color sunsetOrange = bumbleHoney;
  static const Color oceanTeal = obsidian;
  static const Color deepNavy = obsidian;
  static const Color roseRomance = loveCrimson;
  static const Color goldPassport = bumbleHoney;
  static const Color sandLight = warmCream;

  static ThemeData lightTheme() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: loveCrimson,
      primary: loveCrimson,
      secondary: obsidian,
      tertiary: bumbleHoney,
      surface: Colors.white,
      brightness: Brightness.light,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: warmCream,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: obsidian,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
          side: const BorderSide(color: Color(0xFFF0E4E6), width: 1.5),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFF7F2F3),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Color(0xFFEAE0E2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: loveCrimson, width: 2),
        ),
      ),
    );
  }

  static ThemeData darkTheme() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: loveCrimson,
      primary: loveCrimson,
      secondary: bumbleHoney,
      tertiary: passportBlue,
      surface: const Color(0xFF1C1C22),
      brightness: Brightness.dark,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: const Color(0xFF101014),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1C1C22),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        color: const Color(0xFF1C1C22),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
          side: const BorderSide(color: Color(0xFF2D2D38), width: 1.5),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF25252E),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Color(0xFF353542)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: loveCrimson, width: 2),
        ),
      ),
    );
  }
}
