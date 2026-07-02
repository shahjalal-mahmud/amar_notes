// AppRadius — corner radius tokens.
//
//   sm   = 8   — chips, small surfaces
//   md   = 12  — buttons, text fields, dialogs
//   lg   = 16  — cards, bottom sheets
//   xl   = 20  — large cards, hero surfaces
//   pill = 999 — fully rounded (used by floating action button, snackbars)
//
// Centralising radius lets us tune the entire visual language (more
// rounded vs. more rectangular) by changing one file.

import 'package:flutter/material.dart';

final class AppRadius {
  const AppRadius._();

  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double pill = 999;

  // ── Pre-built BorderRadius instances for quick reuse ───────────────
  static const BorderRadius brSm = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius brMd = BorderRadius.all(Radius.circular(md));
  static const BorderRadius brLg = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius brXl = BorderRadius.all(Radius.circular(xl));
  static const BorderRadius brPill = BorderRadius.all(Radius.circular(pill));

  // ── ShapeBorder factories for widgets that take a shape ────────────
  static RoundedRectangleBorder cardShape() =>
      RoundedRectangleBorder(borderRadius: brLg);

  static RoundedRectangleBorder dialogShape() =>
      RoundedRectangleBorder(borderRadius: brLg);

  static RoundedRectangleBorder inputShape() =>
      RoundedRectangleBorder(borderRadius: brMd);

  static RoundedRectangleBorder buttonShape() =>
      RoundedRectangleBorder(borderRadius: brPill);
}