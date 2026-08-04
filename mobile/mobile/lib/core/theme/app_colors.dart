import 'package:flutter/material.dart';

/// Single source of truth for the app colour palette.
/// Always reference these constants in widgets — never hard-code hex values.
final class AppColors {
  // ── Brand ─────────────────────────────────────────────────────
  static const Color primary      = Color(0xFF1565C0); // Blue 800
  static const Color primaryLight = Color(0xFF1E88E5); // Blue 600
  static const Color primaryDark  = Color(0xFF0D47A1); // Blue 900
  static const Color accent       = Color(0xFF00ACC1); // Cyan 600

  // ── Inspection status ─────────────────────────────────────────
  static const Color statusPlanned    = Color(0xFF1565C0);
  static const Color statusInProgress = Color(0xFFF57C00);
  static const Color statusCompleted  = Color(0xFF2E7D32);
  static const Color statusCancelled  = Color(0xFF757575);

  // ── Damage severity ───────────────────────────────────────────
  static const Color severityLow      = Color(0xFF43A047);
  static const Color severityMedium   = Color(0xFFF9A825);
  static const Color severityHigh     = Color(0xFFE64A19);
  static const Color severityCritical = Color(0xFFB71C1C);

  // ── Semantic ──────────────────────────────────────────────────
  static const Color success = Color(0xFF2E7D32);
  static const Color warning = Color(0xFFF57C00);
  static const Color error   = Color(0xFFC62828);

  // ── Surface ───────────────────────────────────────────────────
  static const Color backgroundLight = Color(0xFFF5F5F5);
  static const Color backgroundDark  = Color(0xFF121212);
  static const Color surfaceDark     = Color(0xFF1E1E1E);
  static const Color cardDark        = Color(0xFF2C2C2C);

  // ── Text ──────────────────────────────────────────────────────
  static const Color textPrimary   = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textOnPrimary = Color(0xFFFFFFFF);
}
