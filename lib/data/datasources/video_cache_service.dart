// lib/data/datasources/video_cache_service.dart

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import '../../core/constants/app_constants.dart';

/// Singleton custom cache manager for videos
class VideoCacheManager {
  static const key = AppConstants.videoCacheKey;

  static final CacheManager instance = CacheManager(
    Config(
      key,
      stalePeriod: AppConstants.cacheMaxAge,
      maxNrOfCacheObjects: AppConstants.cacheMaxNrOfCacheObjects,
      repo: JsonCacheInfoRepository(databaseName: key),
      fileService: HttpFileService(),
    ),
  );

  VideoCacheManager._();

  /// Pre-cache a video URL silently in the background
  static Future<void> preCache(String url) async {
    try {
      await instance.downloadFile(url);
    } catch (_) {
      // Silent fail for preload
    }
  }

  /// Returns cached file path or downloads if not cached
  static Future<String> getCachedPath(String url) async {
    final file = await instance.getSingleFile(url);
    return file.path;
  }

  /// Check if a URL is already cached
  static Future<bool> isCached(String url) async {
    final info = await instance.getFileFromCache(url);
    return info != null;
  }

  /// Remove a specific URL from cache
  static Future<void> removeFromCache(String url) async {
    await instance.removeFile(url);
  }

  /// Clear all video cache
  static Future<void> clearCache() async {
    await instance.emptyCache();
  }
}
