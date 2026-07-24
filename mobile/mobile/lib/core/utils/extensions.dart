import 'package:flutter/material.dart';
import 'package:inspection_app/core/theme/app_colors.dart';

/// String helpers used throughout the presentation layer.
extension StringX on String {
  /// Capitalises the first letter and lower-cases the rest.
  String get capitalised =>
      isEmpty ? this : '${this[0].toUpperCase()}${substring(1).toLowerCase()}';

  /// Converts `IN_PROGRESS` → `In Progress` for display labels.
  String get statusLabel =>
      replaceAll('_', ' ').split(' ').map((w) => w.capitalised).join(' ');
}

/// Maps an [InspectionStatus] string value to its brand colour.
extension InspectionStatusColorX on String {
  Color get statusColor => switch (this) {
    'PLANNED'     => AppColors.statusPlanned,
    'IN_PROGRESS' => AppColors.statusInProgress,
    'COMPLETED'   => AppColors.statusCompleted,
    'CANCELLED'   => AppColors.statusCancelled,
    _             => AppColors.textSecondary,
  };
}

/// Maps a [DamageSeverity] string value to its brand colour.
extension SeverityColorX on String {
  Color get severityColor => switch (this) {
    'LOW'      => AppColors.severityLow,
    'MEDIUM'   => AppColors.severityMedium,
    'HIGH'     => AppColors.severityHigh,
    'CRITICAL' => AppColors.severityCritical,
    _          => AppColors.textSecondary,
  };
}
