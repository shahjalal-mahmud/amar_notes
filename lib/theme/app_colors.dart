// AppColors — semantic color tokens for the Amar Notes theme.
//
// We hand-pick every role in both `lightScheme` and `darkScheme` rather than
// using `ColorScheme.fromSeed(...)`. This gives us full control over how the
// app reads in both modes — important for a "production polish" feel.
//
// Every consumer in the app must read colors through `Theme.of(context)
// .colorScheme.*`. Direct access to `AppColors` from widgets is intentionally
// not needed and should be avoided; the ColorScheme *is* the public API.

import 'package:flutter/material.dart';

/// Centralised colour palette.
///
/// Internal-only — widgets should not import this. They should read colors via
/// `Theme.of(context).colorScheme.*` (which is built from these tokens).
final class AppColors {
  const AppColors._();

  // ── Brand seed (a confident indigo-violet) ─────────────────────────
  static const Color brand = Color(0xFF5B5BD6);
  static const Color brandDark = Color(0xFF8B8DEF);

  // ── Neutral greys used for outlines, dividers, surface tints ───────
  static const Color neutral10 = Color(0xFF1A1A1F);
  static const Color neutral20 = Color(0xFF2B2B33);
  static const Color neutral30 = Color(0xFF3D3D47);
  static const Color neutral80 = Color(0xFFD9D9E0);
  static const Color neutral90 = Color(0xFFEFEFF4);
  static const Color neutral95 = Color(0xFFF7F7FB);
  static const Color neutral99 = Color(0xFFFCFCFF);

  // ── Semantic accents ───────────────────────────────────────────────
  static const Color success = Color(0xFF2E7D32);
  static const Color successDark = Color(0xFF81C784);

  // ── Light ColorScheme ──────────────────────────────────────────────
  // Hand-tuned Material 3 roles. Surface tones use a layered approach
  // (`surfaceContainer*`) so cards and elevated surfaces read distinctly.
  static const ColorScheme lightScheme = ColorScheme(
    brightness: Brightness.light,
    primary: brand,
    onPrimary: Colors.white,
    primaryContainer: Color(0xFFE2E2FA),
    onPrimaryContainer: Color(0xFF1A1A55),
    secondary: Color(0xFF5C5D72),
    onSecondary: Colors.white,
    secondaryContainer: Color(0xFFE1E1F9),
    onSecondaryContainer: Color(0xFF191A2C),
    tertiary: Color(0xFF7A536D),
    onTertiary: Colors.white,
    tertiaryContainer: Color(0xFFFFD8EE),
    onTertiaryContainer: Color(0xFF2F1128),
    error: Color(0xFFBA1A1A),
    onError: Colors.white,
    errorContainer: Color(0xFFFFDAD6),
    onErrorContainer: Color(0xFF410002),
    surface: Color(0xFFFCFCFF),
    onSurface: Color(0xFF1A1A1F),
    onSurfaceVariant: Color(0xFF45464F),
    outline: Color(0xFF75767F),
    outlineVariant: Color(0xFFC5C6D0),
    shadow: Colors.black,
    scrim: Colors.black,
    inverseSurface: Color(0xFF2F2F36),
    onInverseSurface: Color(0xFFF1F0F7),
    inversePrimary: Color(0xFFC2C2FA),
    surfaceTint: brand,
    // Surface containers — used for cards, sheets, dialogs. Layered so
    // higher elevations read slightly darker (Material 3 convention).
    surfaceContainerLowest: neutral99,
    surfaceContainerLow: neutral95,
    surfaceContainer: Color(0xFFF1F1F8),
    surfaceContainerHigh: Color(0xFFEBEBF2),
    surfaceContainerHighest: Color(0xFFE5E5EC),
  );

  // ── Dark ColorScheme ───────────────────────────────────────────────
  static const ColorScheme darkScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: brandDark,
    onPrimary: Color(0xFF1F1F66),
    primaryContainer: Color(0xFF3D3D8A),
    onPrimaryContainer: Color(0xFFE2E2FA),
    secondary: Color(0xFFC4C4DD),
    onSecondary: Color(0xFF2D2E42),
    secondaryContainer: Color(0xFF444559),
    onSecondaryContainer: Color(0xFFE1E1F9),
    tertiary: Color(0xFFEBB7D8),
    onTertiary: Color(0xFF48263D),
    tertiaryContainer: Color(0xFF613B55),
    onTertiaryContainer: Color(0xFFFFD8EE),
    error: Color(0xFFFFB4AB),
    onError: Color(0xFF690005),
    errorContainer: Color(0xFF93000A),
    onErrorContainer: Color(0xFFFFDAD6),
    surface: Color(0xFF131318),
    onSurface: Color(0xFFE5E5EC),
    onSurfaceVariant: Color(0xFFC5C6D0),
    outline: Color(0xFF8F9099),
    outlineVariant: Color(0xFF45464F),
    shadow: Colors.black,
    scrim: Colors.black,
    inverseSurface: Color(0xFFE5E5EC),
    onInverseSurface: Color(0xFF2F2F36),
    inversePrimary: brand,
    surfaceTint: brandDark,
    surfaceContainerLowest: Color(0xFF0E0E13),
    surfaceContainerLow: Color(0xFF1B1B22),
    surfaceContainer: Color(0xFF1F1F27),
    surfaceContainerHigh: Color(0xFF2A2A33),
    surfaceContainerHighest: Color(0xFF35353F),
  );
}