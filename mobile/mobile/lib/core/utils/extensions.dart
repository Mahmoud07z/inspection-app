import 'package:flutter/material.dart';
import 'package:inspection_app/core/theme/app_colors.dart';

extension StringX on String {
  String get capitalised =>
      isEmpty ? this : '${this[0].toUpperCase()}${substring(1).toLowerCase()}';

  /// `IN_PROGRESS` → `In Progress`
  String get statusLabel =>
      replaceAll('_', ' ').split(' ').map((w) => w.capitalised).join(' ');
}

extension StatusColorX on String {
  Color get statusColor => switch (this) {
    'PLANNED'     => AppColors.statusPlanned,
    'IN_PROGRESS' => AppColors.statusInProgress,
    'COMPLETED'   => AppColors.statusCompleted,
    'CANCELLED'   => AppColors.statusCancelled,
    _             => AppColors.textSecondary,
  };
}

extension SeverityColorX on String {
  Color get severityColor => switch (this) {
    'LOW'      => AppColors.severityLow,
    'MEDIUM'   => AppColors.severityMedium,
    'HIGH'     => AppColors.severityHigh,
    'CRITICAL' => AppColors.severityCritical,
    _          => AppColors.textSecondary,
  };
}
