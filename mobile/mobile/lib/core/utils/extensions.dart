import 'package:flutter/material.dart';
import 'package:inspection_app/core/theme/app_colors.dart';

<<<<<<< HEAD
extension StringX on String {
  String get capitalised =>
      isEmpty ? this : '${this[0].toUpperCase()}${substring(1).toLowerCase()}';

  /// `IN_PROGRESS` → `In Progress`
=======
/// String helpers used throughout the presentation layer.
extension StringX on String {
  /// Capitalises the first letter and lower-cases the rest.
  String get capitalised =>
      isEmpty ? this : '${this[0].toUpperCase()}${substring(1).toLowerCase()}';

  /// Converts `IN_PROGRESS` → `In Progress` for display labels.
>>>>>>> 38d35ecc504df7aefda47e8dab5325df5dc5f1a1
  String get statusLabel =>
      replaceAll('_', ' ').split(' ').map((w) => w.capitalised).join(' ');
}

<<<<<<< HEAD
extension StatusColorX on String {
=======
/// Maps an [InspectionStatus] string value to its brand colour.
extension InspectionStatusColorX on String {
>>>>>>> 38d35ecc504df7aefda47e8dab5325df5dc5f1a1
  Color get statusColor => switch (this) {
    'PLANNED'     => AppColors.statusPlanned,
    'IN_PROGRESS' => AppColors.statusInProgress,
    'COMPLETED'   => AppColors.statusCompleted,
    'CANCELLED'   => AppColors.statusCancelled,
    _             => AppColors.textSecondary,
  };
}

<<<<<<< HEAD
=======
/// Maps a [DamageSeverity] string value to its brand colour.
>>>>>>> 38d35ecc504df7aefda47e8dab5325df5dc5f1a1
extension SeverityColorX on String {
  Color get severityColor => switch (this) {
    'LOW'      => AppColors.severityLow,
    'MEDIUM'   => AppColors.severityMedium,
    'HIGH'     => AppColors.severityHigh,
    'CRITICAL' => AppColors.severityCritical,
    _          => AppColors.textSecondary,
  };
}
