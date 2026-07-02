// AppTextTheme — Material 3 TextTheme for both light and dark modes.
//
// Each role follows the official M3 type scale (display / headline / title /
// body / label), but with explicit weights and heights tuned for clarity on
// both phone and tablet form factors.
//
// Widgets must read text via `Theme.of(context).textTheme.*` — never with
// `TextStyle(fontSize: …)` literals.

import 'package:flutter/material.dart';

import 'app_colors.dart';

final class AppTextTheme {
  const AppTextTheme._();

  // ── Base text style — uses the system font (no external dependency) ──
  // The Material 3 default family is "Roboto" on Android, ".SF Pro Text" on
  // iOS, etc. — picked automatically by `Typography`. The family is a
  // platform-dependent runtime value, so it can't be `const` — we resolve
  // it lazily the first time either theme is built.
  static String? _cachedFamily;
  static String get _family {
    return _cachedFamily ??= Typography.material2021(
      platform: TargetPlatform.android,
    ).black.displayLarge!.fontFamily!;
  }

  // Weights we use across the scale.
  static const FontWeight _w400 = FontWeight.w400;
  static const FontWeight _w500 = FontWeight.w500;
  static const FontWeight _w600 = FontWeight.w600;

  // ── Light TextTheme ────────────────────────────────────────────────
  static TextTheme get light {
    final base = Typography.material2021(platform: TargetPlatform.android)
        .black;
    return _build(
      base: base,
      color: AppColors.lightScheme.onSurface,
      surfaceVariant: AppColors.lightScheme.onSurfaceVariant,
    );
  }

  // ── Dark TextTheme ─────────────────────────────────────────────────
  static TextTheme get dark {
    final base = Typography.material2021(platform: TargetPlatform.android)
        .white;
    return _build(
      base: base,
      color: AppColors.darkScheme.onSurface,
      surfaceVariant: AppColors.darkScheme.onSurfaceVariant,
    );
  }

  // ── Shared builder ─────────────────────────────────────────────────
  static TextTheme _build({
    required TextTheme base,
    required Color color,
    required Color surfaceVariant,
  }) {
    // Apply our colour + a few overrides for the most-used roles.
    // We don't override every size — the M3 default scale is already good.
    return base.copyWith(
      displayLarge: base.displayLarge?.copyWith(
        fontFamily: _family,
        fontWeight: _w400,
        color: color,
      ),
      displayMedium: base.displayMedium?.copyWith(
        fontFamily: _family,
        fontWeight: _w400,
        color: color,
      ),
      displaySmall: base.displaySmall?.copyWith(
        fontFamily: _family,
        fontWeight: _w400,
        color: color,
      ),
      headlineLarge: base.headlineLarge?.copyWith(
        fontFamily: _family,
        fontWeight: _w600,
        color: color,
      ),
      headlineMedium: base.headlineMedium?.copyWith(
        fontFamily: _family,
        fontWeight: _w600,
        color: color,
      ),
      headlineSmall: base.headlineSmall?.copyWith(
        fontFamily: _family,
        fontWeight: _w600,
        color: color,
      ),
      titleLarge: base.titleLarge?.copyWith(
        fontFamily: _family,
        fontWeight: _w600,
        color: color,
      ),
      titleMedium: base.titleMedium?.copyWith(
        fontFamily: _family,
        fontWeight: _w600,
        color: color,
      ),
      titleSmall: base.titleSmall?.copyWith(
        fontFamily: _family,
        fontWeight: _w500,
        color: color,
      ),
      bodyLarge: base.bodyLarge?.copyWith(
        fontFamily: _family,
        fontWeight: _w400,
        color: color,
      ),
      bodyMedium: base.bodyMedium?.copyWith(
        fontFamily: _family,
        fontWeight: _w400,
        color: surfaceVariant,
      ),
      bodySmall: base.bodySmall?.copyWith(
        fontFamily: _family,
        fontWeight: _w400,
        color: surfaceVariant,
      ),
      labelLarge: base.labelLarge?.copyWith(
        fontFamily: _family,
        fontWeight: _w500,
        color: color,
      ),
      labelMedium: base.labelMedium?.copyWith(
        fontFamily: _family,
        fontWeight: _w500,
        color: surfaceVariant,
      ),
      labelSmall: base.labelSmall?.copyWith(
        fontFamily: _family,
        fontWeight: _w500,
        color: surfaceVariant,
      ),
    );
  }
}