import 'package:flutter/material.dart';

/// Static typography definitions.
/// Reference these in widgets that need a style without a [BuildContext].
abstract final class AppTextStyles {
  static const TextStyle heading1 = TextStyle(
    fontSize: 28, fontWeight: FontWeight.w700, letterSpacing: -0.5,
  );
  static const TextStyle heading2 = TextStyle(
    fontSize: 22, fontWeight: FontWeight.w600,
  );
  static const TextStyle heading3 = TextStyle(
    fontSize: 18, fontWeight: FontWeight.w600,
  );
  static const TextStyle body = TextStyle(fontSize: 15);
  static const TextStyle bodySmall = TextStyle(fontSize: 13);
  static const TextStyle label = TextStyle(
    fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 0.5,
  );
  /// For displaying codes / barcodes / inspection IDs.
  static const TextStyle code = TextStyle(
    fontFamily: 'monospace', fontSize: 13, fontWeight: FontWeight.w500,
  );
}
