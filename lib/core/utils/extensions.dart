// lib/core/utils/extensions.dart

extension IntExtension on int {
  /// Formats large numbers: 1200 → "1.2K", 1500000 → "1.5M"
  String toCompactString() {
    if (this >= 1000000) {
      return '${(this / 1000000).toStringAsFixed(1)}M';
    } else if (this >= 1000) {
      return '${(this / 1000).toStringAsFixed(1)}K';
    }
    return toString();
  }
}

extension StringExtension on String {
  String get truncated =>
      length > 100 ? '${substring(0, 100)}...' : this;
}
