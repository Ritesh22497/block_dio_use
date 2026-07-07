// lib/presentation/viewmodels/feed_viewmodel.dart

import 'package:flutter/foundation.dart';
import '../../core/constants/app_constants.dart';
import '../../data/datasources/video_cache_service.dart';
import '../../domain/entities/video_entity.dart';
import '../../domain/usecases/video_usecases.dart';

enum FeedState { initial, loading, loaded, loadingMore, error }

class FeedViewModel extends ChangeNotifier {
  final FetchVideosUseCase _fetchVideosUseCase;
  final ToggleLikeUseCase _toggleLikeUseCase;
  final GetCachedVideoUseCase _getCachedVideoUseCase;

  FeedViewModel({
    required FetchVideosUseCase fetchVideosUseCase,
    required ToggleLikeUseCase toggleLikeUseCase,
    required GetCachedVideoUseCase getCachedVideoUseCase,
  })  : _fetchVideosUseCase = fetchVideosUseCase,
        _toggleLikeUseCase = toggleLikeUseCase,
        _getCachedVideoUseCase = getCachedVideoUseCase {
    fetchInitialVideos();
  }

  // ─── State ────────────────────────────────────────────────
  FeedState _state = FeedState.initial;
  FeedState get state => _state;

  List<VideoEntity> _videos = [];
  List<VideoEntity> get videos => List.unmodifiable(_videos);

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  bool _hasMore = true;
  bool get hasMore => _hasMore;

  bool get isLoading => _state == FeedState.loading;
  bool get isLoadingMore => _state == FeedState.loadingMore;

  // ─── Cached video paths ───────────────────────────────────
  final Map<String, String> _cachedPaths = {};
  Map<String, String> get cachedPaths => Map.unmodifiable(_cachedPaths);

  // ─── Public API ───────────────────────────────────────────

  /// Initial load
  Future<void> fetchInitialVideos() async {
    _setState(FeedState.loading);
    _errorMessage = null;

    final result = await _fetchVideosUseCase();

    result.fold(
      (failure) {
        _errorMessage = failure.message;
        _setState(FeedState.error);
      },
      (videos) {
        _videos = videos;
        _hasMore = videos.length == AppConstants.pageSize;
        _setState(FeedState.loaded);
        _schedulePreload(0);
      },
    );
  }

  /// Load next page (pagination)
  Future<void> fetchMoreVideos() async {
    if (!_hasMore || _state == FeedState.loadingMore) return;
    _setState(FeedState.loadingMore);

    final lastId = _videos.isNotEmpty ? _videos.last.id : null;
    final result = await _fetchVideosUseCase(lastDocumentId: lastId);

    result.fold(
      (failure) {
        _errorMessage = failure.message;
        _setState(FeedState.loaded); // Revert to loaded so user can retry
      },
      (newVideos) {
        _videos = [..._videos, ...newVideos];
        _hasMore = newVideos.length == AppConstants.pageSize;
        _setState(FeedState.loaded);
        _schedulePreload(_currentIndex);
      },
    );
  }

  /// Called when user swipes to a new index
  void onPageChanged(int index) {
    _currentIndex = index;
    notifyListeners();
    _schedulePreload(index);

    // Trigger pagination when approaching end
    if (index >= _videos.length - 3) {
      fetchMoreVideos();
    }
  }

  /// Toggle like with optimistic update
  Future<void> toggleLike(String videoId) async {
    final idx = _videos.indexWhere((v) => v.id == videoId);
    if (idx == -1) return;

    final video = _videos[idx];
    final newIsLiked = !video.isLiked;
    final newLikes = newIsLiked ? video.likesCount + 1 : video.likesCount - 1;

    // Optimistic update
    _videos[idx] = video.copyWith(
      isLiked: newIsLiked,
      likesCount: newLikes.clamp(0, double.maxFinite.toInt()),
    );
    notifyListeners();

    // Sync with backend
    final result = await _toggleLikeUseCase(
      videoId: videoId,
      isLiked: newIsLiked,
    );

    result.fold(
      (_) {
        // Revert on failure
        _videos[idx] = video;
        notifyListeners();
      },
      (updated) {
        _videos[idx] = updated;
        notifyListeners();
      },
    );
  }

  /// Retry after error
  Future<void> retry() => fetchInitialVideos();

  // ─── Private Helpers ─────────────────────────────────────

  void _setState(FeedState newState) {
    _state = newState;
    notifyListeners();
  }
void _schedulePreload(int currentIndex) {
  if (_videos.isEmpty) return;

  final start = (currentIndex - AppConstants.preloadBehind)
      .clamp(0, _videos.length - 1);

  final end = (currentIndex + AppConstants.preloadAhead)
      .clamp(0, _videos.length - 1);

  for (int i = start; i <= end; i++) {
    final video = _videos[i];

    if (!_cachedPaths.containsKey(video.videoUrl)) {
      _preloadVideo(video.videoUrl);
    }
  }
}
  // /// Preloads N videos ahead and behind current index
  // void _schedulePreload(int currentIndex) {
  //   final start = (currentIndex - AppConstants.preloadBehind).clamp(0, _videos.length - 1);
  //   final end = (currentIndex + AppConstants.preloadAhead).clamp(0, _videos.length - 1);

  //   for (int i = start; i <= end; i++) {
  //     final video = _videos[i];
  //     if (!_cachedPaths.containsKey(video.videoUrl)) {
  //       _preloadVideo(video.videoUrl);
  //     }
  //   }
  // }

  Future<void> _preloadVideo(String url) async {
    // Fire-and-forget background preload
    VideoCacheManager.preCache(url).then((_) async {
      final result = await _getCachedVideoUseCase(url);
      result.fold(
        (_) {},
        (path) {
          _cachedPaths[url] = path;
          notifyListeners();
        },
      );
    });
  }

  @override
  void dispose() {
    _cachedPaths.clear();
    super.dispose();
  }
}
