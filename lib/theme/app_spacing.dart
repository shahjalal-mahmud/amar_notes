// AppSpacing — design tokens for layout spacing.
//
// Based on a 4-point grid, with explicit breakpoints for responsive layouts:
//   xs   = 4   (icon-to-label gaps, tight inline spacing)
//   sm   = 8   (button-to-button, list-item inner padding)
//   md   = 12  (form field spacing, card inner padding)
//   lg   = 16  (default screen padding, between paragraphs)
//   xl   = 24  (between sections, larger breathing room)
//   xxl  = 32  (top of empty states, hero spacing)
//   huge = 48  (empty-state icon-to-text distance, full-screen dividers)
//
// Widgets must read these via `AppSpacing.lg` etc. — never inline literals
// like `SizedBox(height: 16)`. (Tiny one-off gaps < 4 still use a literal,
// but anything that recurs should be a token.)

import 'package:flutter/material.dart';

/// Breakpoint thresholds for responsive padding.
final class AppBreakpoints {
  const AppBreakpoints._();

  /// Below this width we use compact (phone) spacing.
  static const double compact = 600;

  /// Below this width we use medium (large phone / small tablet) spacing.
  static const double medium = 1024;
}

final class AppSpacing {
  const AppSpacing._();

  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;
  static const double huge = 48;

  /// Returns a horizontal padding that scales with screen width:
  ///   <600dp  → lg   (16)  — phones
  ///   <1024dp → xl   (24)  — large phones / small tablets
  ///   >=1024  → xxl  (32)  — tablets / desktop
  static double horizontal(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width < AppBreakpoints.compact) return lg;
    if (width < AppBreakpoints.medium) return xl;
    return xxl;
  }

  /// Maximum content width for forms/lists on wide screens.
  /// Keeps long lines readable on tablets by capping the layout.
  static const double maxContentWidth = 720;

  /// Wraps [child] in a `Center` + `ConstrainedBox` so it never exceeds
  /// [maxContentWidth]. Apply to list/form bodies on wide screens.
  static Widget constrained(Widget child) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: maxContentWidth),
        child: child,
      ),
    );
  }
}