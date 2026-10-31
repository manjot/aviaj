import 'package:flutter/material.dart';

/// Aviaj Red Love Single-Color Brand Theme
/// Strictly monochromatic Red Love (#E11D3F / #B91532) paired with Pure White (#FFFFFF),
/// Soft Rose Blush (#FFF2F4), and Deep Charcoal (#161215). Zero gradients.
class AviajTheme {
  // Primary Red Love brand color
  static const Color loveRed = Color(0xFFE11D3F);

  // Deep Red Love shade for badges & secondary contrast within the single-color theme
  static const Color deepLoveRed = Color(0xFFB91532);

  // Soft Rose Blush background tint
  static const Color softLoveBlush = Color(0xFFFFF2F4);

  // Soft Rose border & chip fill
  static const Color roseTint = Color(0xFFFFE0E6);

  // High-contrast Deep Charcoal for readable typography & dark surfaces
  static const Color charcoal = Color(0xFF161215);

  // All semantic aliases unified under the Red Love single-color theme
  static const Color sunsetTerracotta = loveRed;
  static const Color horizonTeal = loveRed;
  static const Color compassAmber = deepLoveRed;
  static const Color midnightNavy = charcoal;
  static const Color warmSand = softLoveBlush;
  static const Color softTerracotta = roseTint;
  static const Color solidEmerald = loveRed;
  static const Color skyAzure = loveRed;

  static const Color coralPrimary = loveRed;
  static const Color loveCrimson = loveRed;
  static const Color oceanTeal = loveRed;
  static const Color deepNavy = charcoal;
  static const Color obsidian = charcoal;
  static const Color roseRomance = loveRed;
  static const Color goldPassport = deepLoveRed;
  static const Color sunsetOrange = loveRed;
  static const Color passportBlue = loveRed;
  static const Color warmCream = softLoveBlush;
  static const Color sandLight = softLoveBlush;
  static const Color softBlush = roseTint;

  static ThemeData lightTheme() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: loveRed,
      primary: loveRed,
      secondary: deepLoveRed,
      tertiary: loveRed,
      surface: Colors.white,
      brightness: Brightness.light,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: softLoveBlush,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: charcoal,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
          side: const BorderSide(color: Color(0xFFF5D0D8), width: 1.5),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFFFF5F7),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Color(0xFFF5D0D8)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: loveRed, width: 2),
        ),
      ),
    );
  }

  static ThemeData darkTheme() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: loveRed,
      primary: loveRed,
      secondary: deepLoveRed,
      tertiary: loveRed,
      surface: const Color(0xFF22181C),
      brightness: Brightness.dark,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: charcoal,
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF22181C),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        color: const Color(0xFF22181C),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
          side: const BorderSide(color: Color(0xFF3D2830), width: 1.5),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF2D1F25),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Color(0xFF4A3039)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: loveRed, width: 2),
        ),
      ),
    );
  }
}
