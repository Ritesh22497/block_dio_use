// lib/core/utils/extensions.dart

extension IntExt on int {
  String toCompact() {
    if (this >= 1000000) return '${(this / 1000000).toStringAsFixed(1)}M';
    if (this >= 1000) return '${(this / 1000).toStringAsFixed(1)}K';
    return toString();
  }
}

extension StringExt on String {
  String get initials {
    final parts = trim().split('_');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return isNotEmpty ? this[0].toUpperCase() : '?';
  }
}
