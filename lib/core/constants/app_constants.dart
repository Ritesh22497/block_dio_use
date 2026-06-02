// lib/core/constants/app_constants.dart

class AppConstants {
  AppConstants._();

  // Firestore
  static const String videosCollection = 'videos';
  static const int pageSize = 10;

  // Preload
  static const int preloadAhead = 3;
  static const int preloadBehind = 1;
  static const int maxCacheSize = 100; // MB

  // UI
  static const double iconSize = 32.0;
  static const double avatarRadius = 22.0;
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration doubleTapDuration = Duration(milliseconds: 400);

  // Cache
  static const String videoCacheKey = 'reels_video_cache';
  static const Duration cacheMaxAge = Duration(days: 7);
  static const int cacheMaxNrOfCacheObjects = 50;
}
