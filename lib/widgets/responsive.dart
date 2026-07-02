// Responsive padding helper.
//
// `horizontalScreenPadding(context)` returns an `EdgeInsets` whose horizontal
// value scales with screen width. Use as the `padding` of a list/column body.

import 'package:flutter/widgets.dart';

import '../theme/app_spacing.dart';

/// Horizontal padding that scales with screen width:
///   <600dp  → 16  (phones)
///   <1024dp → 24  (large phones / small tablets)
///   >=1024  → 32  (tablets)
EdgeInsets horizontalScreenPadding(BuildContext context) {
  return EdgeInsets.symmetric(
    horizontal: AppSpacing.horizontal(context),
    vertical: AppSpacing.lg,
  );
}