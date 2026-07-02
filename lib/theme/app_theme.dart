// AppTheme — single import point for theme + design tokens.
//
// Screens import this file and use:
//   - `AppTheme.lightTheme` / `AppTheme.darkTheme` for the MaterialApp
//   - `AppSpacing.*` for layout dimensions
//   - `AppRadius.*` for corner radii
//   - `AppColors.brand` (rarely — prefer `colorScheme.primary` instead)
//
// Internal-only files (`app_colors`, `app_text_theme`, `light_theme`,
// `dark_theme`) should not be imported by widgets directly.

import 'app_colors.dart';
import 'app_radius.dart';
import 'app_spacing.dart';
import 'dark_theme.dart';
import 'light_theme.dart';

/// Public façade for the theme system.
final class AppTheme {
  const AppTheme._();

  static final lightTheme = AppLightTheme.theme;
  static final darkTheme = AppDarkTheme.theme;

  // Re-export design tokens so screens only need one import.
  static const spacing = AppSpacing;
  static const radius = AppRadius;
  static const colors = AppColors;
}