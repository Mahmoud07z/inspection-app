import 'package:flutter/material.dart';

/// Single source of truth for the app colour palette.
/// Always reference these constants in widgets — never hard-code hex values.
final class AppColors {
  // ── Brand ─────────────────────────────────────────────────────
  static const Color primary = Color(0xFF17324D);
  static const Color primaryLight = Color(0xFF287C83);
  static const Color primaryDark = Color(0xFF10263D);
  static const Color accent = Color(0xFF53B8A9);

  // ── Inspection status ─────────────────────────────────────────
  static const Color statusPlanned = Color(0xFF1565C0);
  static const Color statusInProgress = Color(0xFFF57C00);
  static const Color statusCompleted = Color(0xFF2E7D32);
  static const Color statusCancelled = Color(0xFF757575);

  // ── Damage severity ───────────────────────────────────────────
  static const Color severityLow = Color(0xFF43A047);
  static const Color severityMedium = Color(0xFFF9A825);
  static const Color severityHigh = Color(0xFFE64A19);
  static const Color severityCritical = Color(0xFFB71C1C);

  // ── Semantic ──────────────────────────────────────────────────
  static const Color success = Color(0xFF2E7D32);
  static const Color warning = Color(0xFFF57C00);
  static const Color error = Color(0xFFC62828);

  // ── Surface ───────────────────────────────────────────────────
  static const Color backgroundLight = Color(0xFFF3F6F9);
  static const Color backgroundDark = Color(0xFF0F1922);
  static const Color surfaceDark = Color(0xFF15232E);
  static const Color cardDark = Color(0xFF1A2A36);
  static const Color outlineDark = Color(0xFF344753);
  static const Color textPrimaryDark = Color(0xFFE7EEF3);
  static const Color textSecondaryDark = Color(0xFFB0BEC8);

  // ── Text ──────────────────────────────────────────────────────
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textOnPrimary = Color(0xFFFFFFFF);
}
